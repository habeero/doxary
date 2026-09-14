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

final class RemoteError extends AppError {
  const RemoteError(super.message, {super.cause});
}

final class UnexpectedAppError extends AppError {
  const UnexpectedAppError(super.message, {super.cause});
}
