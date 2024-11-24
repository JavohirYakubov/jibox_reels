class BaseResponse {
  final bool success;
  final String message;
  final int? errorCode;
  dynamic data;

  BaseResponse(this.success, this.message, this.errorCode, this.data);

  factory BaseResponse.fromJson(Map<String, dynamic> json) => BaseResponse(
      json["success"], json["message"], json["error_code"] as int?, json["data"]);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["success"] = success;
    data["message"] = message;
    data["error_code"] = errorCode;
    data["data"] = data;
    return data;
  }
}
