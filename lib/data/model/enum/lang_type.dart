import 'dart:ui';

import '../../../gen/colors.gen.dart';

enum LangType {
  UZ,
  EN,
  RU;

  static LangType getObj(String key) {
    if (key == "en") {
      return LangType.EN;
    } else if (key == "ru") {
      return LangType.RU;
    } else {
      return LangType.UZ;
    }
  }

  String getKey() {
    switch (this) {
      case LangType.RU:
        return "ru";
      case LangType.EN:
        return "en";
      case LangType.UZ:
        return "uz";
    }
  }
}
