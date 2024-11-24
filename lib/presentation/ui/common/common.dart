import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../gen/colors.gen.dart';

void showCustomBottomSheetDialog({
  required BuildContext context,
  required Widget child,
  EdgeInsetsGeometry? padding,
  BoxConstraints? constraints,
  Color? backgroundColor,
  double? radius,
  bool request = false,
  bool? isDismissible,
}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: backgroundColor ?? ColorName.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(radius ?? 24.w),
          topRight: Radius.circular(radius ?? 24.w)),
    ),
    constraints: constraints,
    isDismissible: isDismissible ?? true,
    enableDrag: true,
    isScrollControlled: true,
    builder: (context) {
      return AnimatedPadding(
        padding: MediaQuery.of(context).viewInsets,
        duration: const Duration(milliseconds: 100),
        curve: Curves.decelerate,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 32.w,
                height: 4.h,
                margin: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    100.w,
                  ),
                  color: ColorName.gray100,
                ),
              ),
            ),
            SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              padding: padding,
              child: child,
            ),
          ],
        ),
      );
    },
  );
}

Future<dynamic> showNewBottomSheetDialog(
    {required BuildContext context,
    required Widget child,
    double initHeight = 0.55}) {
  return showFlexibleBottomSheet(
    minHeight: 0,
    initHeight: initHeight,
    maxHeight: 1,
    context: context,
    bottomSheetColor: Colors.white,
    bottomSheetBorderRadius: BorderRadius.only(
        topLeft: Radius.circular(20.w), topRight: Radius.circular(20.w)),
    builder: (context, scrollController, offset) => ListView(
      controller: scrollController,
      shrinkWrap: true,
      children: [
        SizedBox(
          height: 8.h,
        ),
        Center(
          child: Container(
            width: 32.w,
            height: 4.h,
            margin: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                100.w,
              ),
              color: ColorName.gray100,
            ),
          ),
        ),
        child,
      ],
    ),
    anchors: [0, 0.5, 1],
    isSafeArea: true,
  );
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
