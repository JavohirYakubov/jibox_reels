import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jibox_reels/presentation/ui/common/text_view.dart';

import '../../../gen/assets.gen.dart';
import '../../../gen/colors.gen.dart';

class RegularAppBar extends AppBar {
  RegularAppBar(BuildContext context, String titleText,
      {bool? canBack = true, super.key, super.actions})
      : super(
          title: TextView(
            titleText,
            textStyle: TextViewStyle.SEMIBOLD,
            fontSize: 16,
          ),
          elevation: 0.3,
          centerTitle: true,
          leadingWidth: 56.w,
          leading: canBack == true
              ? GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: 24.w, right: 8.w, top: 8.h, bottom: 8.h),
                    child: Center(
                        child: Assets.icons.arrowLeft.svg(
                      width: 24.w,
                      height: 24.h,
                      colorFilter: ColorFilter.mode(
                          ColorName.textPrimary, BlendMode.srcIn),
                    )),
                  ),
                )
              : null,
        );
}
