import 'package:alice/alice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jibox_reels/utils/app_router.dart';
import 'package:jibox_reels/presentation/screens/splash/splash_page.dart';
import 'package:jibox_reels/utils/common.dart';
import 'package:jibox_reels/utils/fcm_manager.dart';
import 'package:jibox_reels/utils/languages.dart';
import 'package:jibox_reels/utils/pref_utils.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'data/bloc/cubit/user_cubit.dart';
import 'di/locator.dart';
import 'gen/colors.gen.dart';

Alice alice = Alice(showNotification: false);
late AssetMapBitmap circleMarkerIcon;
void main() async {
  alice.setNavigatorKey(AppRouter.navigatorKey);
  WidgetsFlutterBinding.ensureInitialized();
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  circleMarkerIcon = await BitmapDescriptor.asset(
    const ImageConfiguration(size: Size(14, 14)), // Adjust size as needed
    'assets/images/circle_icon.png', // Path to the custom marker asset
  );
  await LocatorDI.provideAll();
  FCMManager.initAll();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  static Position? currentLocation;
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Offset _offset = const Offset(32, 48);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(428, 926),
        builder: (context, child) {
          return MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => UserCubit()),
            ],
            child: GetMaterialApp(
                title: "Estate Reels",
                navigatorKey: AppRouter.navigatorKey,
                translations: Languages(),
                locale:
                    Locale(getIt.get<PrefUtils>().getCurrentLang().getKey()),
                debugShowCheckedModeBanner: false,
                theme: ThemeData(
                    useMaterial3: false,
                    fontFamily: "Inter",
                    pageTransitionsTheme: PageTransitionsTheme(
                      builders: {
                        TargetPlatform.android: CustomPageTransitionsBuilder(),
                        // Android custom transition
                        TargetPlatform.iOS: CustomPageTransitionsBuilder(),
                        // iOS custom transition
                      },
                    ),
                    colorScheme: ColorScheme.fromSeed(
                        seedColor: ColorName.mainPrimary500Base),
                    // fontFamily: "Google Sans",
                    scaffoldBackgroundColor: ColorName.backgroundColor,
                    appBarTheme: AppBarTheme(
                        color: Colors.white,
                        iconTheme:
                            const IconThemeData(color: ColorName.iconPrimary),
                        titleTextStyle: TextStyle(
                            color: ColorName.mainPrimary500Base,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.sp)),
                    dialogBackgroundColor: Colors.white),
                home: Builder(builder: (context) {
                  if (true) {
                    WidgetsBinding.instance.addPostFrameCallback(
                        (_) => _addFloatingButton(context));
                  }
                  return SplashPage();
                })),
          );
        });
  }

  void _addFloatingButton(BuildContext context) {
    return Overlay.of(context).insert(
      OverlayEntry(builder: (context) {
        return Positioned(
            top: _offset.dy,
            left: _offset.dx,
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() =>
                    _offset += Offset(details.delta.dx, details.delta.dy));
              },
              onTap: () {
                alice.showInspector();
              },
              child: Container(
                padding: EdgeInsets.all(8.w),
                decoration: const BoxDecoration(
                    color: Colors.blue, shape: BoxShape.circle),
                child: const Icon(
                  Icons.cloudy_snowing,
                  color: Colors.white,
                ),
              ),
            ));
      }),
    );
  }
}
