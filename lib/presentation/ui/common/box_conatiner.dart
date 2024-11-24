import 'package:flutter/material.dart';

import '../../../gen/colors.gen.dart';

class BoxContainer extends StatelessWidget {
  Widget child;
  bool withShadow = false;
  BorderRadius? borderRadius;
  EdgeInsets? padding;
  double? height;
  double? width;
  Color color;
  bool? haveBackground;
  BoxBorder? border;
  BoxConstraints? constraints;
  BoxContainer(
      {required this.child,
      super.key,
      this.color = Colors.white,
      this.withShadow = false,
      this.borderRadius,
      this.padding,
      this.height,
      this.width,
      this.haveBackground, this.border, this.constraints});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: width,
        height: height,
        constraints: constraints,
        decoration: BoxDecoration(
            boxShadow: withShadow
                ? [
                    BoxShadow(
                      color: ColorName.shadow.withOpacity(0.08),
                      spreadRadius: 1,
                      blurRadius: 12,
                      offset: Offset(1, 1), // changes position of shadow
                    ),
                  ]
                : [],
            color: color,
            borderRadius: borderRadius,
            border: border,
            image: haveBackground == true
                ? const DecorationImage(
                    image: AssetImage(
                      "assets/images/background.png",
                    ),
                    fit: BoxFit.cover)
                : null),
        padding: padding,
        child: child);
  }
}
