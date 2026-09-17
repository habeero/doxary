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
    analysisDebugLog('http', '${request.method} ${request.url.path}');
    try {
      final response = await _client.send(request).timeout(timeout);
      analysisDebugLog('http', 'status=${response.statusCode}');
      return response;
    } on TimeoutException catch (error) {
      throw RemoteUnavailableError('The connection timed out.', cause: error);
    } on http.ClientException catch (error) {
      throw RemoteUnavailableError(
        'No connection to Doxary is available.',
        cause: error,
      );
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
