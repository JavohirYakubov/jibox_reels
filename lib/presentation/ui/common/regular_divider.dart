import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../gen/colors.gen.dart';

class RegularDivider extends StatelessWidget {
  const RegularDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1.h,
      decoration: BoxDecoration(
        border: Border.all(color: ColorName.gray100, width: 1.w),
      ),
    );
  }
}
