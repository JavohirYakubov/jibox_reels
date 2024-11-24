import 'dart:async';

import '../model/response/base_response.dart';
import '../model/response/user_response.dart';
import '../network/api_service.dart';

class AuthRepository {
  final ApiService apiService;

  AuthRepository(this.apiService);

  Future<BaseResponse> login(String phone) async {
    try {
      final response = await apiService.dio.post("auth/login", data: {
        "phone": phone,
      });
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

  Future<BaseResponse> loginConfirm(String phone, String otp) async {
    try {
      final response = await apiService.dio.post("auth/confirm", data: {
        "phone": phone,
        "sms_code": otp,
      });
      final data = apiService.wrapResponse(response);
      if (data.success) {
        data.data = data.data["token"];
        return data;
      } else {
        return data;
      }
    } catch (e) {
      return BaseResponse(false, apiService.wrapError(e), -1, null);
    }
  }

  Future<BaseResponse> updateFullname(String fullname) async {
    try {
      final response = await apiService.dio.post("auth/update_fullname", data: {
        "fullname": fullname,
      });
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

  Future<BaseResponse> getUserInfo() async {
    try {
      final response = await apiService.dio.get("auth/get/user");
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

  Future<BaseResponse> deleteAccount() async {
    try {
      final response = await apiService.dio.get("auth/remove/user");
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
