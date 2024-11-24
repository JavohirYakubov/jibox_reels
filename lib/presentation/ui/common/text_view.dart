import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../gen/colors.gen.dart';

enum TextViewStyle {
  BOLD,
  SEMIBOLD,
  MEDIUM,
  REGULAR;

  FontWeight getFontWeight() {
    switch (this) {
      case TextViewStyle.BOLD:
        return FontWeight.w700;
      case TextViewStyle.SEMIBOLD:
        return FontWeight.w600;
      case TextViewStyle.MEDIUM:
        return FontWeight.w500;
      case TextViewStyle.REGULAR:
        return FontWeight.w400;
    }
  }
}

class TextView extends StatelessWidget {
  final String body;
  final TextViewStyle textStyle;
  final Color textColor;
  final double fontSize;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextStyle? style;

  TextView(this.body,
      {super.key,
      this.textStyle = TextViewStyle.REGULAR,
      this.textColor = ColorName.textPrimary,
      this.fontSize = 15,
      this.textAlign,
      this.maxLines, this.style});

  @override
  Widget build(BuildContext context) {
    return Text(
      body,
      maxLines: maxLines,
      overflow: maxLines != null ? TextOverflow.ellipsis : null,
      style: style ?? TextStyle(
        color: textColor,
        fontSize: fontSize.sp,
        fontWeight: textStyle.getFontWeight(),
      ),
      textAlign: textAlign,
    );
  }
}
