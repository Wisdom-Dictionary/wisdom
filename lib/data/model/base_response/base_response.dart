class BaseResponse<T> {
  T? data;
  int? code;
  String? message;
  bool? status;

  BaseResponse({
    this.data,
    this.code,
    this.message,
    this.status,
  });
}
