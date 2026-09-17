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
import 'package:flutter/foundation.dart';
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

  test('maps the complete staging-shaped result including document date and evidence metadata', () {
    final payload = _result()
      ..['analysis_status'] = 'complete'
      ..['quality_issues'] = []
      ..['extracted_facts'] = {
        'document_date': {'value': '2026-09-01', 'source_text': '01.09.2026'},
        'deadlines': [],
        'appointments': [],
        'amounts': [],
        'required_documents': [],
        'suggested_tasks': [],
      };
    final result = mapAnalysisResult(
      payload,
      id: 'analysis-complete',
      createdAt: DateTime(2026),
    );
    expect(result.analysisStatus, AnalysisStatus.complete);
    expect(result.documentDate, '2026-09-01');
    expect(result.sourceReferences.single.pageIndex, isNull);
    expect(result.sourceReferences.single.fileId, isNull);
  });

  test('incompatible result payload fails safely', () {
    expect(
      () => mapAnalysisResult(
        {'schema_version': 'analysis_result.v1'},
        id: 'a',
        createdAt: DateTime(2026),
      ),
      throwsA(isA<FormatException>()),
    );
  });

  test('submission retry preserves key and client document while new submission differs', () {
    final first = AnalysisSubmission(
      clientDocumentId: 'document-1',
      files: const [],
      language: ExplanationLanguage.german,
      style: ExplanationStyle.simple,
      idempotencyKey: 'key-1',
    );
    final retry = first.copyWith();
    final second = AnalysisSubmission(
      clientDocumentId: 'document-2',
      files: const [],
      language: ExplanationLanguage.german,
      style: ExplanationStyle.simple,
      idempotencyKey: 'key-2',
    );
    expect(retry.idempotencyKey, first.idempotencyKey);
    expect(retry.clientDocumentId, first.clientDocumentId);
    expect(second.idempotencyKey, isNot(first.idempotencyKey));
    expect(second.clientDocumentId, isNot(first.clientDocumentId));
  });

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
    expect(remote.submitCalls, 0);
  });

  test(
    'accepted operation transitions to terminal failure without another POST',
    () async {
      final database = AppDatabase(NativeDatabase.memory());
      addTearDown(database.close);
      final local = LocalAnalysisRepository(database);
      await _insertDocument(database, 'document-failed');
      await local.saveOperation(
        operationId: 'op-failed',
        clientDocumentId: 'document-failed',
        state: AnalysisLifecycleState.accepted,
      );
      final remote = _FakeRemote([
        const BackendOperation(
          operationId: 'op-failed',
          status: BackendOperationStatus.failed,
          requestId: null,
          failureCode: 'processing_failed',
          failureRetryable: false,
        ),
      ]);
      final workflow = AnalysisWorkflow(remote, local, wait: (_) async {});

      await expectLater(
        workflow.poll('op-failed', 'document-failed'),
        throwsA(
          isA<RemoteApiError>()
              .having((error) => error.code, 'code', 'processing_failed')
              .having(
                (error) => error.isTerminalOperationFailure,
                'isTerminalOperationFailure',
                true,
              )
              .having((error) => error.retryable, 'retryable', false),
        ),
      );

      final operations = await database
          .select(database.analysisOperations)
          .get();
      final documents = await database.select(database.documents).get();
      expect(remote.getCalls, 1);
      expect(remote.submitCalls, 0);
      expect(operations.single.state, AnalysisLifecycleState.failed.name);
      expect(operations.single.lastFailureCode, 'processing_failed');
      expect(documents.single.status, DocumentStatus.needsReview.name);
      expect(await local.watchPending().first, isEmpty);
    },
  );

  test('processing operation stops polling when it reaches failed', () async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final local = LocalAnalysisRepository(database);
    await _insertDocument(database, 'document-processing-failed');
    final remote = _FakeRemote([
      const BackendOperation(
        operationId: 'op-processing-failed',
        status: BackendOperationStatus.processing,
        requestId: null,
      ),
      const BackendOperation(
        operationId: 'op-processing-failed',
        status: BackendOperationStatus.failed,
        requestId: null,
        failureCode: 'analysis_unavailable',
        failureRetryable: true,
      ),
    ]);
    final workflow = AnalysisWorkflow(
      remote,
      local,
      maxPolls: 3,
      wait: (_) async {},
    );

    await expectLater(
      workflow.poll('op-processing-failed', 'document-processing-failed'),
      throwsA(
        isA<RemoteApiError>()
            .having((error) => error.code, 'code', 'analysis_unavailable')
            .having((error) => error.retryable, 'retryable', true),
      ),
    );

    final operations = await database.select(database.analysisOperations).get();
    expect(remote.getCalls, 2);
    expect(remote.submitCalls, 0);
    expect(operations.single.state, AnalysisLifecycleState.failed.name);
    expect(await local.watchPending().first, isEmpty);
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

  test(
    'failed operation parses safe code and retryability without its message',
    () async {
      final source = DoxaryDocumentAnalysisRemoteDataSource(
        DoxaryApiClient(
          DoxaryApiConfig(baseUri: Uri.parse('http://example.test')),
          client: _RecordingClient(
            _jsonResponse({
              'failure': {
                'code': 'analysis_unavailable',
                'message': 'This must never reach Flutter logs or UI.',
                'retryable': true,
              },
              'operation_id': 'op-failed',
              'status': 'failed',
            }, 200),
          ),
        ),
      );

      final operation = await source.getOperation('op-failed');
      expect(operation.status, BackendOperationStatus.failed);
      expect(operation.failureCode, 'analysis_unavailable');
      expect(operation.failureRetryable, true);
    },
  );

  test('succeeded operation envelope without request_id maps through production DTO path', () async {
    final payload = _result()
      ..['analysis_status'] = 'complete'
      ..['quality_issues'] = [];
    final source = DoxaryDocumentAnalysisRemoteDataSource(
      DoxaryApiClient(
        DoxaryApiConfig(baseUri: Uri.parse('http://example.test')),
        client: _RecordingClient(
          _jsonResponse({
            'failure': null,
            'operation_id': 'op-succeeded',
            'result': payload,
            'status': 'succeeded',
          }, 200),
        ),
      ),
    );
    final operation = await source.getOperation('op-succeeded');
    expect(operation.status, BackendOperationStatus.succeeded);
    expect(operation.requestId, isNull);
    expect(operation.result?.analysisStatus, AnalysisStatus.complete);
  });

  test('invalid enum mapping reports only path and token category', () async {
    final payload = _result()
      ..['extracted_facts'] = {
        'deadlines': [],
        'appointments': [],
        'amounts': [
          {
            'value': '12.50',
            'currency': 'EUR',
            'purpose': 'Fee',
            'direction': 'invalid',
            'evidence_reference_ids': [],
          },
        ],
        'required_documents': [],
        'suggested_tasks': [],
      };
    final logs = <String>[];
    final previous = debugPrint;
    debugPrint = (message, {wrapWidth}) {
      if (message is String) logs.add(message);
    };
    addTearDown(() => debugPrint = previous);
    final source = DoxaryDocumentAnalysisRemoteDataSource(
      DoxaryApiClient(
        DoxaryApiConfig(baseUri: Uri.parse('http://example.test')),
        client: _RecordingClient(
          _jsonResponse({
            'failure': null,
            'operation_id': 'op-invalid-enum',
            'result': payload,
            'status': 'succeeded',
          }, 200),
        ),
      ),
    );
    await expectLater(
      source.getOperation('op-invalid-enum'),
      throwsA(isA<MalformedRemoteResponseError>()),
    );
    expect(
      logs,
      contains(
        '[DoxaryAnalysis][domain_mapping] failed path=amounts[0].direction type=ArgumentError token_category=unknown_enum_token',
      ),
    );
  });

  test('uppercase enum variant remains invalid and is classified without its value', () async {
    final payload = _result()
      ..['extracted_facts'] = {
        'deadlines': [],
        'appointments': [],
        'amounts': [
          {
            'value': '12.50',
            'currency': 'EUR',
            'purpose': 'Fee',
            'direction': 'PAY',
            'evidence_reference_ids': [],
          },
        ],
        'required_documents': [],
        'suggested_tasks': [],
      };
    final logs = <String>[];
    final previous = debugPrint;
    debugPrint = (message, {wrapWidth}) {
      if (message is String) logs.add(message);
    };
    addTearDown(() => debugPrint = previous);

    expect(
      () =>
          mapAnalysisResult(payload, id: 'analysis', createdAt: DateTime(2026)),
      throwsA(isA<ArgumentError>()),
    );
    expect(
      logs,
      contains(
        '[DoxaryAnalysis][domain_mapping] failed path=amounts[0].direction type=ArgumentError token_category=uppercase_variant',
      ),
    );
  });
}

Future<void> _insertDocument(
  AppDatabase database,
  String clientDocumentId,
) async {
  final now = DateTime(2026);
  await database
      .into(database.documents)
      .insert(
        DocumentsCompanion.insert(
          clientDocumentId: clientDocumentId,
          classificationState: 'unclassified',
          status: 'imported',
          createdAt: now,
          updatedAt: now,
        ),
      );
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
  int submitCalls = 0;
  int getCalls = 0;
  @override
  Future<BackendOperation> getOperation(String operationId) async {
    getCalls++;
    return _responses.removeAt(0);
  }

  @override
  Future<AcceptedAnalysisOperation> submit(
    AnalysisSubmission submission,
  ) async {
    submitCalls++;
    return const AcceptedAnalysisOperation(
      operationId: 'op-1',
      requestId: 'r-1',
    );
  }
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
