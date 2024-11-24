import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:petitparser/expression.dart';
import 'package:petitparser/parser.dart';

extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}

extension CustomDateTime on DateTime {
  get formattedDate {
    return DateFormat('dd.MM.yyyy').format(this);
  }

  get formattedDateTime {
    return DateFormat('dd.MM.yyyy HH:mm:ss').format(this);
  }

  get formattedTime {
    return DateFormat('HH:mm').format(this);
  }

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inMinutes < 5) {
      return "Hozirgina";
    } else if (difference.inMinutes < 60) {
      return "${difference.inMinutes} minut oldin";
    } else if (difference.inHours < 24) {
      return "${difference.inHours} soat oldin";
    } else if (difference.inDays < 7) {
      return "${difference.inDays} kun oldin";
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return "$weeks hafta oldin";
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return "$months oy oldin";
    } else {
      final years = (difference.inDays / 365).floor();
      return "$years yil oldin";
    }
  }
}

extension CustomTime on TimeOfDay {
  get formattedTime {
    return "${this.hour.toString().padLeft(2, '0')}:${this.minute.toString().padLeft(2, '0')}";
  }
}

extension CustomString on String {
  get formattedDateTime {
    var date = DateTime.tryParse(this);
    return date != null
        ? DateFormat('dd.MM.yyyy hh:mm').format(date)
        : formattedDateTime;
  }

  get dateTime {
    try {
      return DateFormat('dd.MM.yyyy').parse(this);
    } catch (e) {
      return DateTime.now();
    }
  }

  String get removeFloatPoint {
    return split(".").first;
  }

  get removeLastCharacter {
    if (isNotEmpty) {
      return this.substring(0, length - 1);
    }

    return this;
  }

  Parser buildParser() {
    final builder = ExpressionBuilder();
    builder.group()
      ..primitive((pattern('+-').optional() &
              digit().plus() &
              (char('.') & digit().plus()).optional() &
              (pattern('eE') & pattern('+-').optional() & digit().plus())
                  .optional())
          .flatten('number expected')
          .trim()
          .map(num.tryParse))
      ..wrapper(
          char('(').trim(), char(')').trim(), (left, value, right) => value);
    builder.group().prefix(char('-').trim(), (op, a) => -a);
    builder.group().right(char('^').trim(), (a, op, b) => pow(a, b));
    builder.group()
      ..left(char('*').trim(), (a, op, b) => a * b)
      ..left(char('/').trim(), (a, op, b) => a / b);
    builder.group()
      ..left(char('+').trim(), (a, op, b) => a + b)
      ..left(char('-').trim(), (a, op, b) => a - b);
    return builder.build().end();
  }

  bool hasMathAction() {
    var actions = [
      this.lastIndexOf("+"),
      this.lastIndexOf("-"),
      this.lastIndexOf("*"),
      this.lastIndexOf("/"),
    ];
    return actions.where((element) => element == (length - 1)).isNotEmpty;
  }

  double calcString() {
    var actions = [
      this.lastIndexOf("+"),
      this.lastIndexOf("-"),
      this.lastIndexOf("*"),
      this.lastIndexOf("/"),
    ];

    var value = this;

    if (actions.where((element) => element == length - 1).isNotEmpty) {
      value = value.removeLastCharacter;
    }
    final parser = buildParser();
    final input = value;
    final result = parser.parse(input);
    if (result.isSuccess) {
      return result.value.toDouble();
    } else {
      return double.tryParse(value) ?? 0.0;
    }
  }
}

extension CustomDouble on double {
  String formattedAmountString({String currency = "UZS"}) {
    return NumberFormat.currency(locale: "uz")
        .format(this)
        .replaceAll(",00", "")
        .replaceAll("UZS", currency);
  }
}

extension SizedBoxExtensions on num {
  SizedBox get height => SizedBox(height: toDouble().h);

  SizedBox get width => SizedBox(width: toDouble().w);

  SizedBox get box => SizedBox(width: toDouble().w, height: toDouble().w);
}
