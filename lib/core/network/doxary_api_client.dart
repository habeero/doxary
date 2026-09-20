import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/doxary_api_config.dart';
import '../errors/app_error.dart';
import '../logging/debug_log.dart';

/// Small injectable HTTP boundary for Doxary's product API.
/// It intentionally exposes no provider or backend implementation detail.
class DoxaryApiClient {
  DoxaryApiClient(
    this._config, {
    http.Client? client,
    this.timeout = const Duration(seconds: 30),
  }) : _client = client ?? http.Client();

  final DoxaryApiConfig _config;
  final http.Client _client;
  final Duration timeout;

  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final stopwatch = Stopwatch()..start();
    analysisDebugLog(
      'http',
      'send_start method=${request.method} uri=${request.url} '
          'timeout_ms=${timeout.inMilliseconds} '
          'content_length=${request.contentLength ?? 'unknown'}',
    );
    try {
      final response = await _client.send(request).timeout(timeout);
      analysisDebugLog(
        'http',
        'send_response status=${response.statusCode} '
            'elapsed_ms=${stopwatch.elapsedMilliseconds}',
      );
      return response;
    } on TimeoutException catch (error) {
      analysisDebugLog(
        'http',
        'send_timeout stage=send_or_response_headers '
            'elapsed_ms=${stopwatch.elapsedMilliseconds} '
            'type=${error.runtimeType} uri=${request.url}',
      );
      throw RemoteUnavailableError('The connection timed out.', cause: error);
    } on http.ClientException catch (error) {
      analysisDebugLog(
        'http',
        'send_client_exception stage=connect_or_send '
            'elapsed_ms=${stopwatch.elapsedMilliseconds} '
            'type=${error.runtimeType} uri=${request.url} '
            'message=${error.message}',
      );
      throw RemoteUnavailableError(
        'No connection to Doxary is available.',
        cause: error,
      );
    } catch (error) {
      analysisDebugLog(
        'http',
        'send_exception stage=send_or_response_headers '
            'elapsed_ms=${stopwatch.elapsedMilliseconds} '
            'type=${error.runtimeType} uri=${request.url}',
      );
      rethrow;
    }
  }

  Uri endpoint(String path) => _config.resolve(path);

  Future<Map<String, dynamic>> readJson(http.StreamedResponse response) async {
    analysisDebugLog('json_decode', 'entered status=${response.statusCode}');
    final body = await response.stream.bytesToString();
    if (body.isEmpty) return const {};
    try {
      final decoded = jsonDecode(body);
      if (decoded is! Map<String, dynamic>) {
        analysisDebugLog(
          'response_parsing',
          'failed status=${response.statusCode} type=unexpected_json_shape',
        );
        throw const MalformedRemoteResponseError(
          'The server response was invalid.',
        );
      }
      analysisDebugLog('json_decode', 'succeeded');
      return decoded;
    } on FormatException catch (error) {
      analysisDebugLog(
        'response_parsing',
        'failed status=${response.statusCode} type=${error.runtimeType}',
      );
      throw MalformedRemoteResponseError(
        'The server response was invalid.',
        cause: error,
      );
    }
  }

  void close() => _client.close();
}

RemoteApiError toRemoteApiError(int statusCode, Map<String, dynamic> body) {
  final error = body['error'];
  if (error is Map<String, dynamic>) {
    final code = error['code'];
    final retryable = error['retryable'];
    analysisDebugLog(
      'error_parsing',
      'status=$statusCode code=${code is String ? code : 'unknown'} retryable=${retryable == true}',
    );
    return RemoteApiError(
      retryable == true
          ? 'The service is temporarily unavailable.'
          : 'The analysis request could not be completed.',
      statusCode: statusCode,
      code: code is String ? code : 'unknown_error',
      retryable: retryable == true,
    );
  }
  return RemoteApiError(
    'The analysis request could not be completed.',
    statusCode: statusCode,
    code: 'http_$statusCode',
    retryable: statusCode >= 500,
  );
}
