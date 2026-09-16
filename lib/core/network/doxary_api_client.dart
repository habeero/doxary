import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/doxary_api_config.dart';
import '../errors/app_error.dart';

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
    try {
      return await _client.send(request).timeout(timeout);
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
    final body = await response.stream.bytesToString();
    if (body.isEmpty) return const {};
    try {
      final decoded = jsonDecode(body);
      if (decoded is! Map<String, dynamic>) {
        throw const MalformedRemoteResponseError(
          'The server response was invalid.',
        );
      }
      return decoded;
    } on FormatException catch (error) {
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
