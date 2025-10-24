class ApiResponse<T> {
  final T? data;
  final String? error;
  final bool success;
  final String? message;

  ApiResponse({this.data, this.error, this.message, required this.success});

  factory ApiResponse.success(T data, {String? message}) {
    return ApiResponse<T>(data: data, success: true, message: message);
  }

  factory ApiResponse.error(String error, {String? message}) {
    return ApiResponse<T>(error: error, success: false, message: message);
  }
}
