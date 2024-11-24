import 'dart:async';

import 'package:jibox_reels/data/model/ad_filter_model.dart';

import '../model/ad_model.dart';
import '../model/response/base_response.dart';
import '../network/api_service.dart';

class AdRepository {
  final ApiService apiService;

  AdRepository(this.apiService);

  Future<BaseResponse> loadAdList(AdFilterModel filter) async {
    try {
      final response =
          await apiService.dio.post("ad/list", data: filter.toJson());
      final data = apiService.wrapResponse(response);
      if (data.success) {
        data.data =
            (data.data as List<dynamic>).map((json) => AdModel.fromJson(json)).toList();
        return data;
      } else {
        return data;
      }
    } catch (e) {
      return BaseResponse(false, apiService.wrapError(e), -1, null);
    }
  }
}
