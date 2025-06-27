/// Abstract base class for all use cases
///
/// Use cases represent the business logic of the application
/// and orchestrate the flow of data to and from the entities
abstract class UseCase<Type, Params> {
  /// Execute the use case with given parameters
  Future<Type> call(Params params);
}

/// Base class for use cases that don't require parameters
abstract class NoParamsUseCase<Type> {
  /// Execute the use case without parameters
  Future<Type> call();
}

/// Base class for synchronous use cases
abstract class SyncUseCase<Type, Params> {
  /// Execute the use case synchronously with given parameters
  Type call(Params params);
}

/// Base class for synchronous use cases that don't require parameters
abstract class NoParamsSyncUseCase<Type> {
  /// Execute the use case synchronously without parameters
  Type call();
}

/// Represents no parameters for use cases
class NoParams {
  const NoParams();
}

/// Represents a success result
class Success<T> {
  final T data;
  const Success(this.data);
}

/// Represents a failure result
class Failure {
  final String message;
  final Exception? exception;

  const Failure(this.message, [this.exception]);

  @override
  String toString() => 'Failure(message: $message, exception: $exception)';
}

/// Result type for use cases that can succeed or fail
sealed class Result<T> {
  const Result();
}

/// Success result containing data
class SuccessResult<T> extends Result<T> {
  final T data;
  const SuccessResult(this.data);
}

/// Failure result containing error information
class FailureResult<T> extends Result<T> {
  final String message;
  final Exception? exception;

  const FailureResult(this.message, [this.exception]);

  @override
  String toString() =>
      'FailureResult(message: $message, exception: $exception)';
}

/// Extensions for working with Result
extension ResultExtensions<T> on Result<T> {
  /// Check if result is successful
  bool get isSuccess => this is SuccessResult<T>;

  /// Check if result is a failure
  bool get isFailure => this is FailureResult<T>;

  /// Get data if successful, null otherwise
  T? get dataOrNull {
    if (this is SuccessResult<T>) {
      return (this as SuccessResult<T>).data;
    }
    return null;
  }

  /// Get error message if failure, null otherwise
  String? get errorOrNull {
    if (this is FailureResult<T>) {
      return (this as FailureResult<T>).message;
    }
    return null;
  }

  /// Fold the result into a single value
  R fold<R>(R Function(T data) onSuccess, R Function(String error) onFailure) {
    switch (this) {
      case SuccessResult<T> success:
        return onSuccess(success.data);
      case FailureResult<T> failure:
        return onFailure(failure.message);
    }
  }
}
