sealed class AppError implements Exception {
  const AppError(this.message, {this.cause});
  final String message;
  final Object? cause;
}

final class ValidationError extends AppError {
  const ValidationError(super.message);
}

final class StorageError extends AppError {
  const StorageError(super.message, {super.cause});
}

final class UnsupportedFileError extends AppError {
  const UnsupportedFileError(super.message);
}

final class CapabilityUnavailableError extends AppError {
  const CapabilityUnavailableError(super.message);
}

final class ImportCancelledError extends AppError {
  const ImportCancelledError() : super('Import was cancelled.');
}

final class ImportPickerError extends AppError {
  const ImportPickerError(super.message, {super.cause});
}

final class RemoteError extends AppError {
  const RemoteError(super.message, {super.cause});
}

final class RemoteUnavailableError extends RemoteError {
  const RemoteUnavailableError(super.message, {super.cause});
}

final class MalformedRemoteResponseError extends RemoteError {
  const MalformedRemoteResponseError(super.message, {super.cause});
}

final class RemoteApiError extends RemoteError {
  const RemoteApiError(
    super.message, {
    required this.statusCode,
    required this.code,
    required this.retryable,
    this.isTerminalOperationFailure = false,
  });
  final int statusCode;
  final String code;
  final bool retryable;
  final bool isTerminalOperationFailure;
}

final class UnexpectedAppError extends AppError {
  const UnexpectedAppError(super.message, {super.cause});
}
