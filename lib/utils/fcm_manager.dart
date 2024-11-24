import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:jibox_reels/utils/constants.dart';
import 'package:jibox_reels/utils/pref_utils.dart';

import '../di/locator.dart';
import '../presentation/screens/splash/splash_page.dart';
import 'app_router.dart';

class FCMManager {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initAll() async {
    await initFCM();
    await initLocalNotification();
    initHandlers();
  }

  static const FirebaseOptions androidOptions = FirebaseOptions(
    apiKey: 'AIzaSyA1w0LIqt4tITJlAZR9-Yy-FXhnliZMlo4',
    appId: '1:339899656023:android:175b80776f63ca82384012',
    messagingSenderId: '339899656023',
    projectId: 'merojmart',
  );

  static const FirebaseOptions iosOpstions = FirebaseOptions(
    apiKey: 'AIzaSyDs4B7AQDCQHrVIPCqMVuosxtDD9jqKiw4',
    appId: '1:339899656023:ios:5d45f180f1385cee384012',
    messagingSenderId: '339899656023',
    projectId: 'merojmart',
    storageBucket: 'merojmart.appspot.com',
    iosBundleId: 'uz.devapp.merojmart.merojMart',
    iosClientId: '339899656023.apps.googleusercontent.com',
  );

  static Future<void> initFCM() async {
    try {
      if (Platform.isAndroid) {
        // var app = await Firebase.initializeApp(options: androidOptions);
      } else if (Platform.isIOS) {
        // await Firebase.initializeApp(name: "merojmart", options: iosOpstions);
      }
    } catch (e) {
      print(e);
    }
  }

  static void initHandlers() async {
    try {
      FirebaseMessaging.onBackgroundMessage((RemoteMessage message) async {
        await initFCM();
        await initLocalNotification();
        if (message.notification != null) {
          displayNotification(
              title: message.notification?.title ?? "",
              body: message.notification?.body ?? "");
        }
      });

      FirebaseMessaging.onMessageOpenedApp
          .listen((RemoteMessage message) async {
        AppRouter.push(SplashPage());
      });

      await FirebaseMessaging.instance.requestPermission();
      await FirebaseMessaging.instance.getInitialMessage();
      await FirebaseMessaging.instance.setAutoInitEnabled(true);


      FirebaseMessaging.instance.getToken().then((v) {
        debugPrint("FCM: $v");
        getIt.get<PrefUtils>().setFCMToken(v ?? "");
      });
    } catch (e) {
      print(e);
    }
  }

  static Future<void> initLocalNotification() async {
    try {
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      final DarwinInitializationSettings initializationSettingsIOS =
          DarwinInitializationSettings(
              requestAlertPermission: true,
              requestBadgePermission: false,
              requestSoundPermission: true,
              onDidReceiveLocalNotification:
                  (int id, String? title, String? body, String? payload) async {
                // Handle the notification tapped logic here
              });

      final InitializationSettings initializationSettings =
          InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
      );

      flutterLocalNotificationsPlugin.initialize(initializationSettings);
      flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    } catch (e) {
      print(e);
    }
  }

  static Future<void> subscribeTopics() async {}

  static Future<void> unSubscribeTopics() async {}

  void onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    // display a dialog with the notification details, tap ok to go to another page
  }

  static displayNotification(
      {required String title, required String body}) async {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
        PROJECT_NAME, PROJECT_TITLE,
        icon: "@mipmap/launcher_icon",
        importance: Importance.max,
        priority: Priority.high,
        ongoing: false,
        styleInformation: BigTextStyleInformation(''));
    var iOSPlatformChannelSpecifics = const DarwinNotificationDetails(

    );
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    debugPrint("FCM onDisplay: ${title}");
    await flutterLocalNotificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      platformChannelSpecifics,
      payload: 'Default_Sound',
    );
  }
}
