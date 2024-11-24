
class UserRequest {
  final String fullname;

  UserRequest(this.fullname);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["fullname"] = fullname;
    return data;
  }
}
