import 'app_error.dart';

sealed class Result<T> {
  const Result();
  R when<R>({
    required R Function(T) success,
    required R Function(AppError) failure,
  });
}

final class Success<T> extends Result<T> {
  const Success(this.value);
  final T value;
  @override
  R when<R>({
    required R Function(T) success,
    required R Function(AppError) failure,
  }) => success(value);
}

final class Failure<T> extends Result<T> {
  const Failure(this.error);
  final AppError error;
  @override
  R when<R>({
    required R Function(T) success,
    required R Function(AppError) failure,
  }) => failure(error);
}
