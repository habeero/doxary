import 'dart:convert';
import 'dart:io';

import 'package:drift/native.dart';
import 'package:doxary/core/config/doxary_api_config.dart';
import 'package:doxary/core/database/app_database.dart' hide DocumentFile;
import 'package:doxary/core/errors/app_error.dart';
import 'package:doxary/core/network/doxary_api_client.dart';
import 'package:doxary/features/document_analysis/application/analysis_workflow.dart';
import 'package:doxary/features/document_analysis/data/analysis_result_mapper.dart';
import 'package:doxary/features/document_analysis/data/doxary_document_analysis_remote_data_source.dart';
import 'package:doxary/features/document_analysis/data/local_analysis_repository.dart';
import 'package:doxary/features/document_analysis/domain/analysis_submission.dart';
import 'package:doxary/features/documents/domain/entities/domain_entities.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

void main() {
  test('API config normalizes bare host and preserves versioned base path', () {
    expect(
      DoxaryApiConfig(baseUri: Uri.parse('https://dox-api.habeero.de'))
          .resolve('document-analyses')
          .toString(),
      'https://dox-api.habeero.de/api/v1/document-analyses',
    );
    expect(
      DoxaryApiConfig(baseUri: Uri.parse('https://example.test/api/v1/'))
          .resolve('operations/op-1')
          .toString(),
      'https://example.test/api/v1/operations/op-1',
    );
  });

  test(
    'maps a complete Arabic result with typed facts and quality outcomes',
    () {
      final result = mapAnalysisResult(
        _result(),
        id: 'analysis-1',
        createdAt: DateTime(2026),
      );
      expect(result.targetLanguage, 'ar');
      expect(result.analysisStatus, AnalysisStatus.partial);
      expect(result.classification?.organizationName, 'Jobcenter');
      expect(result.deadlines.single.dateOrRange, '2026-10-01');
      expect(result.amounts.single.direction, AmountDirection.pay);
      expect(result.qualityReasons, [DocumentQualityReason.blurryImage]);
    },
  );

  test('multipart submission preserves files, language, idempotency, and repeated page indexes', () async {
    final directory = await Directory.systemTemp.createTemp(
      'doxary-analysis-test',
    );
    addTearDown(() => directory.delete(recursive: true));
    final first = File('${directory.path}/first.jpg')
      ..writeAsBytesSync([0xff, 0xd8, 0xff]);
    final second = File('${directory.path}/second.png')
      ..writeAsBytesSync([0x89, 0x50, 0x4e, 0x47]);
    final transport = _RecordingClient(
      _jsonResponse({
        'operation_id': 'op-1',
        'status': 'accepted',
        'request_id': 'request-1',
      }, 202),
    );
    final source = DoxaryDocumentAnalysisRemoteDataSource(
      DoxaryApiClient(
        DoxaryApiConfig(baseUri: Uri.parse('http://example.test/api/v1/')),
        client: transport,
      ),
    );
    await source.submit(
      AnalysisSubmission(
        clientDocumentId: 'document-1',
        language: ExplanationLanguage.german,
        style: ExplanationStyle.simple,
        idempotencyKey: 'idempotency-1',
        files: [
          _file('file-2', second, 'image/png', 1),
          _file('file-1', first, 'image/jpeg', 0),
        ],
      ),
    );
    expect(transport.request!.headers['Idempotency-Key'], 'idempotency-1');
    expect(transport.body, contains('name="output_language"\r\n\r\nde'));
    expect(transport.body, contains('name="output_style"\r\n\r\nsimple'));
    expect(_allIndexes(transport.body), ['0', '1']);
  });

  test('polling persists a new completed analysis version without changing document identity', () async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final now = DateTime(2026);
    await database
        .into(database.documents)
        .insert(
          DocumentsCompanion.insert(
            clientDocumentId: 'document-1',
            classificationState: 'confirmed',
            status: 'imported',
            createdAt: now,
            updatedAt: now,
          ),
        );
    final local = LocalAnalysisRepository(database);
    final remote = _FakeRemote([
      const BackendOperation(
        operationId: 'op-1',
        status: BackendOperationStatus.processing,
        requestId: 'r-1',
      ),
      BackendOperation(
        operationId: 'op-1',
        status: BackendOperationStatus.succeeded,
        requestId: 'r-2',
        result: mapAnalysisResult(_result(), id: 'version-2', createdAt: now),
      ),
    ]);
    final workflow = AnalysisWorkflow(
      remote,
      local,
      maxPolls: 3,
      wait: (_) async {},
    );
    final terminal = await workflow.poll('op-1', 'document-1');
    expect(terminal.status, BackendOperationStatus.succeeded);
    expect(await database.select(database.analyses).get(), hasLength(1));
    expect(
      (await database.select(database.documents).get()).single.clientDocumentId,
      'document-1',
    );
    expect(await database.select(database.analysisOperations).get(), isEmpty);
  });

  test(
    'expired results are explicit and failed operations stay distinct',
    () async {
      final source = DoxaryDocumentAnalysisRemoteDataSource(
        DoxaryApiClient(
          DoxaryApiConfig(baseUri: Uri.parse('http://example.test/api/v1/')),
          client: _RecordingClient(
            _jsonResponse({
              'error': {
                'code': 'operation_expired',
                'message': 'expired',
                'retryable': false,
              },
              'request_id': 'r',
            }, 410),
          ),
        ),
      );
      await expectLater(
        source.getOperation('op'),
        throwsA(
          isA<RemoteApiError>().having(
            (error) => error.code,
            'code',
            'operation_expired',
          ),
        ),
      );
    },
  );

  test('unknown operation status is a safe malformed-response error', () async {
    final source = DoxaryDocumentAnalysisRemoteDataSource(
      DoxaryApiClient(
        DoxaryApiConfig(baseUri: Uri.parse('http://example.test')),
        client: _RecordingClient(
          _jsonResponse({
            'operation_id': 'op',
            'status': 'mystery',
            'request_id': 'r',
          }, 200),
        ),
      ),
    );
    await expectLater(
      source.getOperation('op'),
      throwsA(isA<MalformedRemoteResponseError>()),
    );
  });
}

DocumentFile _file(String id, File file, String mediaType, int pageOrder) =>
    DocumentFile(
      id: id,
      clientDocumentId: 'document-1',
      localUri: file.uri,
      mediaType: mediaType,
      originalFilename: file.uri.pathSegments.last,
      pageOrder: pageOrder,
      importedAt: DateTime(2026),
    );

List<String> _allIndexes(String value) =>
    RegExp(r'name="page_indexes"\r\n\r\n(\d+)')
        .allMatches(value)
        .map((match) => match.group(1)!)
        .toList();
http.StreamedResponse _jsonResponse(Map<String, dynamic> body, int status) =>
    http.StreamedResponse(
      Stream.value(utf8.encode(jsonEncode(body))),
      status,
      headers: const {'content-type': 'application/json'},
    );

class _RecordingClient extends http.BaseClient {
  _RecordingClient(this.response);
  final http.StreamedResponse response;
  http.BaseRequest? request;
  String body = '';
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    this.request = request;
    body = utf8.decode(
      await request.finalize().toBytes(),
      allowMalformed: true,
    );
    return response;
  }
}

class _FakeRemote implements DocumentAnalysisRemoteDataSource {
  _FakeRemote(this._responses);
  final List<BackendOperation> _responses;
  @override
  Future<BackendOperation> getOperation(String operationId) async =>
      _responses.removeAt(0);
  @override
  Future<AcceptedAnalysisOperation> submit(
    AnalysisSubmission submission,
  ) async =>
      const AcceptedAnalysisOperation(operationId: 'op-1', requestId: 'r-1');
}

Map<String, dynamic> _result() => {
  'schema_version': 'analysis_result.v1',
  'analysis_status': 'partial',
  'client_document_id': 'document-1',
  'detected_language': 'de',
  'action_required': 'yes',
  'urgency': 'high',
  'practical_states': ['action_required', 'payment'],
  'classification': {
    'sender_organization': 'Jobcenter',
    'document_type': 'notice',
    'evidence_reference_ids': [],
    'uncertainties': [],
  },
  'explanation': {
    'language': 'ar',
    'style': 'standard',
    'summary': 'Summary',
    'body': 'Body',
    'next_actions': ['Do this'],
  },
  'source_references': [
    {'reference_id': 'e-1', 'page_number': 1, 'provenance': 'analysis'},
  ],
  'uncertainties': [
    {
      'code': 'wording_unclear',
      'message': 'Verify this',
      'evidence_reference_ids': [],
    },
  ],
  'quality_issues': [
    {'reason': 'blurry_image', 'message': 'Blur', 'evidence_reference_ids': []},
  ],
  'extracted_facts': {
    'deadlines': [
      {
        'description': 'Reply',
        'value': '2026-10-01',
        'evidence_reference_ids': [],
        'uncertainties': [],
      },
    ],
    'appointments': [],
    'amounts': [
      {
        'value': '12.50',
        'currency': 'EUR',
        'purpose': 'Fee',
        'direction': 'pay',
        'evidence_reference_ids': [],
        'uncertainties': [],
      },
    ],
    'required_documents': [],
    'suggested_tasks': [],
  },
};
