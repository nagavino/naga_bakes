import '../error/failure.dart';

abstract class Result<T> {
  const Result();

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is ErrorResult<T>;

  T get data => (this as Success<T>).value;
  Failure get failure => (this as ErrorResult<T>).error;

  R when<R>({
    required R Function(T data) success,
    required R Function(Failure failure) error,
  }) {
    if (this is Success<T>) {
      return success((this as Success<T>).value);
    } else {
      return error((this as ErrorResult<T>).error);
    }
  }
}

class Success<T> extends Result<T> {
  final T value;
  const Success(this.value);
}

class ErrorResult<T> extends Result<T> {
  final Failure error;
  const ErrorResult(this.error);
}
