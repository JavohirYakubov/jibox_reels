import 'package:flutter/cupertino.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get_it/get_it.dart';
import 'package:jibox_reels/data/repository/ad_repository.dart';
import 'package:jibox_reels/utils/custom_cache_manager.dart';

import '../data/network/api_service.dart';
import '../data/repository/auth_repository.dart';
import '../data/repository/user_repository.dart';
import '../utils/pref_utils.dart';

final getIt = GetIt.instance;

class LocatorDI {
  static Future<void> provideAll() async {
    await clear();
    await providePrefUtils();
    await provideApiService();
    await provideRepositories();
    await provideManagers();
  }

  //
  static Future<void> providePrefUtils() async {
    final pref = PrefUtils();
    await pref.init();
    getIt.registerSingleton(pref);
  }

  static Future<void> provideApiService() async {
    try {
      await getIt.unregister<ApiService>();
    } catch (e) {
      debugPrint(e.toString());
    }
    final apiService = ApiService();
    await apiService.addHeaders();
    getIt.registerSingleton(apiService);
  }

  static Future<void> provideRepositories() async {
    getIt.registerLazySingleton(() => AuthRepository(getIt.get<ApiService>()));
    getIt.registerLazySingleton(() => AdRepository(getIt.get<ApiService>()));
    getIt.registerLazySingleton(() => UserRepository(getIt.get<ApiService>()));
  }

  static Future<void> provideManagers() async {
    getIt.registerLazySingleton(() => Config(
      "jibox_reels_cache",
      stalePeriod: const Duration(days: 7),
      maxNrOfCacheObjects: 500,
      repo: JsonCacheInfoRepository(databaseName: "jibox_reels_cache"),
      fileSystem: IOFileSystem("jibox_reels_cache"),
      fileService: HttpFileService(),
    ));
  }

  static Future<void> clear() async {
    await getIt.reset();
  }
}
