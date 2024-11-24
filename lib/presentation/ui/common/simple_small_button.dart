import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jibox_reels/gen/colors.gen.dart';


enum SimpleSmallButtonStyle {
  PRIMARY,
  SECONDARY,
  OUTLINED;

  Color fillColor() {
    return switch (this) {
      PRIMARY => ColorName.mainPrimary500Base,
      SECONDARY => ColorName.mainPrimary300,
      OUTLINED => Colors.white,
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

class SimpleSmallButton extends StatefulWidget {
  String text;
  Function onClick;
  bool active;
  bool progress;
  SimpleSmallButtonStyle type;
  String? icon;

  SimpleSmallButton(this.text, this.onClick,
      {this.active = true,
      this.progress = false,
      this.type = SimpleSmallButtonStyle.PRIMARY,
      this.icon});

  @override
  State<StatefulWidget> createState() {
    return SimpleSmallButtonState();
  }
}

class SimpleSmallButtonState extends State<SimpleSmallButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (widget.active && !widget.progress) widget.onClick();
      },
      child: Container(
        padding: EdgeInsets.all(8.h),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.w),
            border: widget.type == SimpleSmallButtonStyle.OUTLINED
                ? Border.all(color: ColorName.gray500Base)
                : null,
            color: widget.active
                ? widget.type.fillColor()
                : ColorName.gray500Base),
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
                            width: 16.w,
                            height: 16.w,
                            color: widget.type.textColor(),
                          ),
                          SizedBox(width: 4.w,),
                          Text(
                            widget.text,
                            style: TextStyle(
                              color: widget.type.textColor(),
                              fontSize: 14.sp,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      )
                    : Text(
                        widget.text,
                        style: TextStyle(
                          color: widget.type.textColor(),
                          fontSize: 14.sp,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )
                : SizedBox(
                    width: 16.w,
                    height: 16.w,
                    child: CircularProgressIndicator(
                      color: widget.type.progressColor(),
                    ))),
      ),
    );
  }
}
