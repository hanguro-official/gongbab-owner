sealed class Result<T> {
  const Result();

  factory Result.success(T value) => Success(value);
  factory Result.failure(String success, Map<String, dynamic>? data) => Failure(success, data);
  factory Result.error(String error) => Error(error);

  R when<R>({
    required R Function(T value) success,
    required R Function(String success, Map<String, dynamic>? data) failure,
    required R Function(String error) error,
  }) {
    if (this is Success) {
      return success((this as Success).value);
    } else if (this is Failure) {
      return failure((this as Failure).success, (this as Failure).data);
    } else if (this is Error) {
      return error((this as Error).error);
    }
    throw Exception('Unknown Result');
  }
}

final class Success<T> extends Result<T> {
  const Success(this.value);

  final T value;
}

final class Failure<T> extends Result<T> {
  const Failure(this.success, this.data);

  final String success;
  final Map<String, dynamic>? data;
}

final class Error<T> extends Result<T> {
  const Error(this.error);

  final String error;
}