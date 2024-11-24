import 'dart:ui';

import '../../../gen/colors.gen.dart';

enum AdType {
  FLAT,
  HOME,
  COMMERCIAL,
  NONE;

  static AdType getObj(String key) {
    if (key == "flat") {
      return AdType.FLAT;
    } else if (key == "home") {
      return AdType.HOME;
    } else if (key == "commercial") {
      return AdType.COMMERCIAL;
    } else {
      return AdType.NONE;
    }
  }

  String getTitle() {
    switch (this) {
      case AdType.FLAT:
        return "Kvartira";
      case AdType.HOME:
        return "Hovli uy";
      case AdType.COMMERCIAL:
        return "Biznes";
      case AdType.NONE:
        return "";
    }
  }

  String getKey() {
    switch (this) {
      case AdType.FLAT:
        return "flat";
      case AdType.HOME:
        return "home";
      case AdType.COMMERCIAL:
        return "commercial";
      case AdType.NONE:
        return "";
    }
  }
}
