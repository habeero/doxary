import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import '../../../core/errors/app_error.dart';
import '../../../core/network/doxary_api_client.dart';
import '../domain/analysis_submission.dart';
import '../../documents/domain/entities/domain_entities.dart';
import 'analysis_result_mapper.dart';

class DoxaryDocumentAnalysisRemoteDataSource
    implements DocumentAnalysisRemoteDataSource {
  DoxaryDocumentAnalysisRemoteDataSource(
    this._api, {
    DateTime Function()? clock,
  }) : _clock = clock ?? DateTime.now;
  final DoxaryApiClient _api;
  final DateTime Function() _clock;

  @override
  Future<AcceptedAnalysisOperation> submit(
    AnalysisSubmission submission,
  ) async {
    if (submission.files.isEmpty) {
      throw const ValidationError('A document needs at least one file.');
    }
    final request =
        _RepeatedFieldMultipartRequest(
            'POST',
            _api.endpoint('document-analyses'),
          )
          ..headers['Idempotency-Key'] = submission.idempotencyKey
          ..fields.addAll([
            ('client_document_id', submission.clientDocumentId),
            (
              'output_language',
              submission.language == ExplanationLanguage.arabic ? 'ar' : 'de',
            ),
            ('output_style', submission.style.name),
            ('input_kind', submission.isPdf ? 'pdf' : 'images'),
          ]);
    final ordered = [...submission.files]
      ..sort((a, b) => a.pageOrder.compareTo(b.pageOrder));
    for (final file in ordered) {
      if (!submission.isPdf) {
        request.fields.add(('page_indexes', '${file.pageOrder}'));
      }
      final path = file.localUri.toFilePath();
      if (!await File(path).exists()) {
        throw const ValidationError('The local document file is unavailable.');
      }
      request.files.add(
        await http.MultipartFile.fromPath(
          'files',
          path,
          contentType: _contentType(file.mediaType),
          filename: file.originalFilename,
        ),
      );
    }
    final response = await _api.send(request);
    final body = await _api.readJson(response);
    if (response.statusCode != 202) {
      throw toRemoteApiError(response.statusCode, body);
    }
    final operationId = body['operation_id'];
    final requestId = body['request_id'];
    if (operationId is! String ||
        requestId is! String ||
        body['status'] != 'accepted') {
      throw const MalformedRemoteResponseError(
        'The analysis acceptance response was invalid.',
      );
    }
    return AcceptedAnalysisOperation(
      operationId: operationId,
      requestId: requestId,
    );
  }

  @override
  Future<BackendOperation> getOperation(String operationId) async {
    final response = await _api.send(
      http.Request('GET', _api.endpoint('operations/$operationId')),
    );
    final body = await _api.readJson(response);
    if (response.statusCode == 410) {
      throw const RemoteApiError(
        'The temporary analysis result has expired.',
        statusCode: 410,
        code: 'operation_expired',
        retryable: false,
      );
    }
    if (response.statusCode != 200) {
      throw toRemoteApiError(response.statusCode, body);
    }
    final statusText = body['status'];
    final responseOperationId = body['operation_id'];
    final requestId = body['request_id'];
    if (statusText is! String ||
        responseOperationId is! String ||
        requestId is! String) {
      throw const MalformedRemoteResponseError(
        'The operation response was invalid.',
      );
    }
    final status = BackendOperationStatus.values.byName(statusText);
    final result = body['result'];
    if (status == BackendOperationStatus.succeeded &&
        result is! Map<String, dynamic>) {
      throw const MalformedRemoteResponseError(
        'The completed operation had no valid result.',
      );
    }
    return BackendOperation(
      operationId: responseOperationId,
      status: status,
      requestId: requestId,
      result: result is Map<String, dynamic>
          ? mapAnalysisResult(result, id: operationId, createdAt: _clock())
          : null,
      failureCode:
          (body['failure'] as Map<String, dynamic>?)?['code'] as String?,
    );
  }
}

MediaType? _contentType(String value) {
  final parts = value.split('/');
  return parts.length == 2 ? MediaType(parts.first, parts.last) : null;
}

/// `http.MultipartRequest.fields` is a map, while the backend correctly
/// requires repeated `page_indexes`; this focused request preserves ordering.
class _RepeatedFieldMultipartRequest extends http.BaseRequest {
  _RepeatedFieldMultipartRequest(super.method, super.url)
    : _boundary = 'doxary-${DateTime.now().microsecondsSinceEpoch}' {
    headers['content-type'] = 'multipart/form-data; boundary=$_boundary';
  }

  final String _boundary;
  final List<(String, String)> fields = [];
  final List<http.MultipartFile> files = [];

  @override
  http.ByteStream finalize() {
    super.finalize();
    return http.ByteStream(Stream.fromFuture(_buildBody()));
  }

  Future<List<int>> _buildBody() async {
    final bytes = BytesBuilder(copy: false);
    void text(String value) => bytes.add(utf8.encode(value));
    for (final field in fields) {
      text(
        '--$_boundary\r\nContent-Disposition: form-data; name="${field.$1}"\r\n\r\n${field.$2}\r\n',
      );
    }
    for (final file in files) {
      text(
        '--$_boundary\r\nContent-Disposition: form-data; name="${file.field}"; filename="${file.filename ?? ''}"\r\n',
      );
      text('Content-Type: ${file.contentType}\r\n');
      text('\r\n');
      await for (final chunk in file.finalize()) {
        bytes.add(chunk);
      }
      text('\r\n');
    }
    text('--$_boundary--\r\n');
    return bytes.takeBytes();
  }
}
