import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jibox_reels/gen/colors.gen.dart';
import 'package:jibox_reels/presentation/ui/common/text_view.dart';

enum SimpleButtonStyle {
  PRIMARY,
  SECONDARY,
  OUTLINED;

  Color fillColor() {
    return switch (this) {
      PRIMARY => ColorName.mainPrimary500Base,
      SECONDARY => ColorName.mainSecondary500Base,
      OUTLINED => Colors.transparent,
    };
  }

  Color textColor() {
    return switch (this) {
      PRIMARY => Colors.white,
      SECONDARY => ColorName.black,
      OUTLINED => ColorName.black,
    };
  }

  Color progressColor() {
    return switch (this) {
      PRIMARY => Colors.white,
      SECONDARY => ColorName.gray500Base,
      OUTLINED => ColorName.gray500Base,
    };
  }
}

class SimpleButton extends StatefulWidget {
  String text;
  Function onClick;
  bool active;
  bool progress;
  SimpleButtonStyle type;
  String? icon;
  Color? fillColor;

  SimpleButton(this.text, this.onClick,
      {this.active = true,
      this.progress = false,
      this.type = SimpleButtonStyle.PRIMARY,
      this.icon,
      this.fillColor});

  @override
  State<StatefulWidget> createState() {
    return SimpleButtonState();
  }
}

class SimpleButtonState extends State<SimpleButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (widget.active && !widget.progress) widget.onClick();
      },
      child: Container(
        padding: EdgeInsets.all(12.h),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: widget.type == SimpleButtonStyle.OUTLINED
                ? Border.all(color: ColorName.gray500Base)
                : null,
            color: widget.active
                ? widget.fillColor ?? widget.type.fillColor()
                : ColorName.gray300),
        child: Center(
            child: !widget.progress
                ? widget.icon != null
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            widget.icon!,
                            width: 18.w,
                            height: 18.w,
                            color: widget.type.textColor(),
                          ),
                          SizedBox(
                            width: 4.w,
                          ),
                          Flexible(
                            child: TextView(
                              widget.text,
                              textColor: widget.type.textColor(),
                              fontSize: 16.sp,
                              maxLines: 1,
                              textStyle: TextViewStyle.MEDIUM,
                            ),
                          ),
                        ],
                      )
                    : TextView(
                        widget.text,
                        textColor: widget.type.textColor(),
                        fontSize: 16.sp,
                        maxLines: 1,
                        textStyle: TextViewStyle.MEDIUM,
                      )
                : SizedBox(
                    width: 16.w,
                    height: 16.w,
                    child: CupertinoActivityIndicator(
                      color: widget.type.progressColor(),
                    ))),
      ),
    );
  }
}
