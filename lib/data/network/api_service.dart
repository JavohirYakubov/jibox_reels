import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../di/locator.dart';
import '../../main.dart';
import '../../presentation/screens/splash/splash_page.dart';
import '../../utils/app_router.dart';
import '../../utils/constants.dart';
import '../../utils/pref_utils.dart';
import '../model/response/base_response.dart';

class CustomInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers.addAll({
      'token': getIt.get<PrefUtils>().getToken(),
    });
    super.onRequest(options, handler);
  }
}

class ApiService {
  final dio = Dio();

  ApiService() {
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient dioClient) {
      dioClient.badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
      return dioClient;
    };
  }

  Future<void> addHeaders() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    dio.interceptors.add(alice.getDioInterceptor());
    dio.interceptors.add(CustomInterceptor());
    dio.options.baseUrl = BASE_URL;
    dio.options.headers.addAll({
      'os-type': Platform.operatingSystem,
      'os-version': Platform.operatingSystemVersion,
      'app-version-code': packageInfo.buildNumber,
      'app-lang': getIt.get<PrefUtils>().getCurrentLang(),
      'device': Platform.localeName,
    });
    return;
  }

  BaseResponse wrapResponse(Response response) {
    if (kDebugMode) {
      printLog(response);
    }

    if (response.statusCode == 200) {
      final data = BaseResponse.fromJson(response.data);
      if (data.success) {
        return data;
      } else if (data.errorCode == 401) {
        getIt.get<PrefUtils>().setToken("");
        AppRouter.pushAndClear(SplashPage());
        return BaseResponse(false, "Token expired", -1, null);
      }
      return data;
    } else if (response.statusCode == 401) {
      getIt.get<PrefUtils>().setToken("");
      AppRouter.pushAndClear(SplashPage());
      return BaseResponse(false, "Token expired", -1, null);
    } else {
      return BaseResponse(
          false,
          response.statusMessage ?? "Unknown error ${response.statusCode}",
          -1,
          null);
    }
  }

  void printLog(Response response) {
    debugPrint("");
    debugPrint("");
    debugPrint("");
    debugPrint(
        "🚀🚀🚀🚀🚀 LOG API ${(response.requestOptions.path).toUpperCase()} 🚀🚀🚀🚀🚀");
    debugPrint("🟢🟢🟢🟢🟢🟢🟢🟢🟢");
    debugPrint(
        "REQUEST ${response.requestOptions.method} | ${response.requestOptions.path} ");
    debugPrint("REQUEST HEADERS ${response.requestOptions.headers}");
    debugPrint("REQUEST BODY");
    try {
      debugPrint(getPrettyJSONString(response.requestOptions.data));
    } catch (e) {
      debugPrint(response.requestOptions.data.toString());
    }
    debugPrint(
        "RESPONSE STATUS ${response.statusCode} | ${response.statusMessage} ");
    debugPrint("RESPONSE BODY");
    try {
      final s = getPrettyJSONString(response.data);
      debugPrint(s.length > 3000
          ? getPrettyJSONString(response.data).substring(0, 3000)
          : s);
    } catch (e) {
      debugPrint(response.data);
    }
    debugPrint("🔴🔴🔴🔴🔴🔴🔴🔴🔴️");
  }

  String getPrettyJSONString(jsonObject) {
    var encoder = JsonEncoder.withIndent("     ");
    return encoder.convert(jsonObject);
  }

  String wrapError(dynamic error) {
    // if (kDebugMode) {
    //   return error.toString();
    // }
    if (error is! DioException) {
      return wrapErrorString(error.toString());
    }
    if (error.response?.statusCode == 401) {
      getIt.get<PrefUtils>().setToken("");
      AppRouter.pushAndClear(SplashPage());
      return "Token expired";
    }
    if (error.error is SocketException) {
      return "Network not connection!";
    }
    return "Unknown error! ${error.response?.statusCode ?? ""}";
  }

  String wrapErrorString(String error) {
    if (error.contains("subtype of type")) {
      return "Failed to cast!";
    }
    return "Unknown error!";
  }
}
