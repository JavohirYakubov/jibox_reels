import 'package:flutter/cupertino.dart';

import 'box_conatiner.dart';

class ClipRoundedView extends StatelessWidget {
  final double? width;
  final double? height;
  final Widget child;
  final BorderRadius borderRadius;
  final Color color;

  const ClipRoundedView(
      {super.key,
      required this.child,
      required this.borderRadius,
      required this.color,
      this.width,
      this.height});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: BoxContainer(
        borderRadius: borderRadius,
        color: color,
        width: width,
        height: height,
        child: child,
      ),
    );
  }
}
