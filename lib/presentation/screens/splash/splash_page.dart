import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:jibox_reels/gen/assets.gen.dart';
import 'package:jibox_reels/presentation/screens/main/main_page.dart';
import 'package:jibox_reels/presentation/ui/common/text_view.dart';
import 'package:jibox_reels/utils/app_router.dart';
import 'package:jibox_reels/utils/common.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../di/locator.dart';
import '../../../main.dart';
import 'splash_bloc.dart';
import 'splash_event.dart';

class SplashPage extends StatefulWidget {
  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    checkPermissionAndGetLocation();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>
          SplashBloc(getIt.get())..add(InitEvent()),
      child: Builder(builder: (context) => _buildPage(context)),
    );
  }

  Widget _buildPage(BuildContext context) {
    final bloc = BlocProvider.of<SplashBloc>(context);
    return Scaffold(
      body: Column(
        children: [
          Expanded(
              child: Center(child: Assets.images.logo.image(width: 200.w))),
          Padding(
            padding:  EdgeInsets.only(left: 16.w, right: 16.w, bottom: safePadding(context).bottom + 16.h),
            child: TextView(
              "Reels orqali soting!",
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }

  Future<void> checkPermissionAndGetLocation() async {
    // MyApp.currentLocation = Position(
    //     longitude: 41.328075,
    //     latitude: 69.226492,
    //     timestamp: DateTime.now(),
    //     accuracy: 12,
    //     altitude: 1,
    //     altitudeAccuracy: 1,
    //     heading: 1,
    //     headingAccuracy: 1,
    //     speed: 1,
    //     speedAccuracy: 1);
    // navigateToHome();
    // return;
    var status = await Permission.locationWhenInUse.status;
    if (status.isGranted) {
      // Permission granted after request, get the current location
      MyApp.currentLocation = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      // Navigate to the next screen
      navigateToHome();
    } else if (status.isDenied || status.isPermanentlyDenied) {
      final r = await Permission.locationWhenInUse.request();
      // Request permission
      if (r.isGranted) {
        // Permission granted after request, get the current location
        MyApp.currentLocation = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        // Navigate to the next screen
        navigateToHome();
      } else {
        // Permission denied, handle accordingly
        showPermissionDeniedDialog();
      }
    }
  }

  void navigateToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MainPage()),
    );
  }

  void showPermissionDeniedDialog() async {
    await showConfirmDialog(context,
        title: "not_allowed_location".tr,
        comment: "please_allow_location".tr,
        positiveTitle: "open_settings".tr,
        negativeTitle: "exit".tr, onAllow: () async {
          await AppSettings.openAppSettings(type: AppSettingsType.location);
          checkPermissionAndGetLocation();
        }, onCancel: () {
          Navigator.pop(context);
        });
  }
}
