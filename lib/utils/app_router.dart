import 'package:flutter/material.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static push(Widget screen, [Function(dynamic r)? callback]) async {
    var r = await navigatorKey.currentState
        ?.push(MaterialPageRoute(builder: (_) => screen,

    ));
    if (callback != null) {
      callback(r);
    }
  }

  static pushReplace(Widget screen, [Function(dynamic r)? callback]) async {
    var r = await navigatorKey.currentState
        ?.pushReplacement(MaterialPageRoute(builder: (_) => screen,

    ));
    if (callback != null) {
      callback(r);
    }
  }

  static pushAndClear(Widget screen) async {
    navigatorKey.currentState?.pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => screen), (route) => false);
  }

  static pop([dynamic result]) async {
    navigatorKey.currentState?.pop(result);
  }
}
