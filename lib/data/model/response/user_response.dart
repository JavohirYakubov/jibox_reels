

class UserResponse {
  final int id;
  final String? fullname;
  final String phone;

  UserResponse(
    this.id,
    this.fullname,
    this.phone,
  );

  factory UserResponse.fromJson(Map<String, dynamic> json) => UserResponse(
        json["id"],
        json["fullname"],
        json["phone"],
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["fullname"] = fullname;
    data["phone"] = phone;
    return data;
  }
}
