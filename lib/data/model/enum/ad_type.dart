import 'dart:ui';

import '../../../gen/colors.gen.dart';

enum OrderStatus {
  PAID_WAITING,
  SENDED,
  CLIENT_CANCELED,
  OPERATOR_CANCELED,
  COMPLETED,
  NONE;

  static OrderStatus getObj(String key) {
    if (key == "paid_waiting") {
      return OrderStatus.PAID_WAITING;
    } else if (key == "sended") {
      return OrderStatus.SENDED;
    } else if (key == "client_canceled") {
      return OrderStatus.CLIENT_CANCELED;
    } else if (key == "operator_canceled") {
      return OrderStatus.OPERATOR_CANCELED;
    } else if (key == "completed") {
      return OrderStatus.COMPLETED;
    } else {
      return OrderStatus.NONE;
    }
  }

  String getTitle() {
    switch (this) {
      case OrderStatus.PAID_WAITING:
        return "To'lov kutilmoqda";
      case OrderStatus.SENDED:
        return "Yetkazib berilmoqda";
      case OrderStatus.CLIENT_CANCELED:
        return "Mijoz bekor qildi";
      case OrderStatus.OPERATOR_CANCELED:
        return "Operator bekor qildi";
      case OrderStatus.COMPLETED:
        return "Tugatilgan";
      case OrderStatus.NONE:
        return "";
    }
  }

  Color getColor() {
    switch (this) {
      case OrderStatus.PAID_WAITING:
        return ColorName.alertWarning300;
      case OrderStatus.SENDED:
        return ColorName.info300;
      case OrderStatus.CLIENT_CANCELED:
        return ColorName.alertError300;
      case OrderStatus.OPERATOR_CANCELED:
        return ColorName.alertError300;
      case OrderStatus.COMPLETED:
        return ColorName.mainPrimary500Base;
      case OrderStatus.NONE:
        return ColorName.alertWarning300;
    }
  }
}
