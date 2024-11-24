import 'dart:async';

import '../model/response/base_response.dart';
import '../model/response/user_response.dart';
import '../network/api_service.dart';

class UserRepository {
  final ApiService apiService;

  UserRepository(this.apiService);

  Future<BaseResponse> getUser(String fcmToken) async {
    try {
      final response =
          await apiService.dio.post("v1/user/info", data: {"fcm": fcmToken});
      final data = apiService.wrapResponse(response);
      if (data.success) {
        data.data = UserResponse.fromJson(data.data);
        return data;
      } else {
        return data;
      }
    } catch (e) {
      return BaseResponse(false, apiService.wrapError(e), -1, null);
    }
  }

  Future<BaseResponse> toggleLike(int id) async {
    try {
      final response =
          await apiService.dio.get("ad/$id/set/like");
      final data = apiService.wrapResponse(response);
      if (data.success) {
        return data;
      } else {
        return data;
      }
    } catch (e) {
      return BaseResponse(false, apiService.wrapError(e), -1, null);
    }
  }
}
