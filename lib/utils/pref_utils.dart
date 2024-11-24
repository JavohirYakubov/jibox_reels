import 'dart:convert';

import 'package:jibox_reels/data/model/app_settings_model.dart';
import 'package:jibox_reels/data/model/response/user_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/model/enum/lang_type.dart';

class PrefUtils {
  late SharedPreferences _shared;

  static const PREF_FCM_TOKEN = "fcm_token";
  static const PREF_USER = "user";
  static const PREF_TOKEN = "token";
  static const SHOWED_LANGUAGE_PAGE = "showed_language_page";
  static const PREF_CURRENT_LANG = "current_lang";
  static const PREF_REGIONS = "regions";
  static const PREF_ACTIVE_REGION = "active_region_";
  static const PREF_BASKET = "shop_cart";
  static const APP_SETTINGS = "app_settings";

  Future<bool> init() async {
    _shared = await SharedPreferences.getInstance();
    return true;
  }

  String getFCMToken() {
    return _shared.getString(PREF_FCM_TOKEN) ?? "";
  }

  Future<bool> setFCMToken(String value) async {
    return _shared.setString(PREF_FCM_TOKEN, value);
  }

  String getToken() {
    return _shared.getString(PREF_TOKEN) ?? "";
  }

  Future<bool> setToken(String value) async {
    return _shared.setString(PREF_TOKEN, value);
  }

  bool showedLanguagePage() {
    return _shared.getBool(PrefUtils.SHOWED_LANGUAGE_PAGE) ?? false;
  }

  Future<bool> setShowedLanguagePage(bool value) async {
    return _shared.setBool(SHOWED_LANGUAGE_PAGE, value);
  }

  LangType getCurrentLang() {
    return LangType.getObj(_shared.getString(PREF_CURRENT_LANG) ?? "uz");
  }

  Future<bool> setCurrentLang(LangType value) async {
    return _shared.setString(PREF_CURRENT_LANG, value.getKey());
  }

  AppSettingsModel? getAppSettings() {
    try {
      return _shared.getString(APP_SETTINGS) != null
          ? AppSettingsModel.fromJson(jsonDecode(_shared.getString(APP_SETTINGS) ?? "{}"))
          : null;
    } catch (e) {
      return null;
    }
  }

  Future<bool> setAppSettings(AppSettingsModel? value) async {
    return value != null
        ? _shared.setString(APP_SETTINGS, jsonEncode(value.toJson()))
        : _shared.remove(APP_SETTINGS);
  }

  UserResponse? getUserInfo() {
    try {
      return _shared.getString(PREF_USER) != null
          ? UserResponse.fromJson(jsonDecode(_shared.getString(PREF_USER) ?? "{}"))
          : null;
    } catch (e) {
      return null;
    }
  }

  Future<bool> setUserInfo(UserResponse? value) async {
    return value != null
        ? _shared.setString(PREF_USER, jsonEncode(value.toJson()))
        : _shared.remove(PREF_USER);
  }

  Future<void> clearAll() async {
    final pref = await SharedPreferences.getInstance();
    await pref.clear();
    return;
  }
}
