// lib/core/dio/api_state.dart
enum ApiStatus { idle, loading, success, error }

class ApiState<T> {
  final ApiStatus status;
  final T? data;
  final String? message; // 필요하면
  final Object? error;

  const ApiState({
    this.status = ApiStatus.idle,
    this.data,
    this.message,
    this.error,
  });

  const ApiState.idle() : this(status: ApiStatus.idle);
  const ApiState.loading() : this(status: ApiStatus.loading);
  const ApiState.success(T data) : this(status: ApiStatus.success, data: data);
  const ApiState.error(Object error, {String? message})
    : this(status: ApiStatus.error, error: error, message: message);

  ApiState<T> copyWith({
    ApiStatus? status,
    T? data,
    String? message,
    Object? error,
  }) {
    return ApiState<T>(
      status: status ?? this.status,
      data: data ?? this.data,
      message: message ?? this.message,
      error: error ?? this.error,
    );
  }

  bool get isLoading => status == ApiStatus.loading;
  bool get isSuccess => status == ApiStatus.success;
  bool get isError => status == ApiStatus.error;
}
