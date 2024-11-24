import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jibox_reels/gen/colors.gen.dart';
import 'package:jibox_reels/presentation/ui/common/text_view.dart';

class ExpandedView extends StatefulWidget {
  final String title;
  final Widget expandView;

  ExpandedView({super.key, required this.title, required this.expandView});

  @override
  State<ExpandedView> createState() => _ExpandedViewState();
}

class _ExpandedViewState extends State<ExpandedView> {
  bool isExpand = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isExpand = !isExpand;
        });
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: TextView(
                  widget.title,
                  textStyle: TextViewStyle.SEMIBOLD,
                ),
              ),
              SizedBox(
                width: 8.w,
              ),
              AnimatedSwitcher(
                duration: Duration(milliseconds: 300),
                child: Icon(
                  !isExpand
                      ? Icons.keyboard_arrow_down_rounded
                      : Icons.keyboard_arrow_up_rounded,
                  color: ColorName.iconTertiary,
                  size: 24.w,
                ),
              )
            ],
          ),
          AnimatedSwitcher(
            duration: Duration(milliseconds: 300),
            child: isExpand ? Padding(
              padding: EdgeInsets.only(top: 8.h),
              child: widget.expandView,
            ) : SizedBox(),
          )
        ],
      ),
    );
  }
}
