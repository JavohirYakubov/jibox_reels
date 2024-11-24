import 'package:flutter/material.dart';

import '../../../gen/assets.gen.dart';

class BottomNavigationBarModel{
  final String title;
  final SvgGenImage icon;
  final SvgGenImage activeIcon;
  final Widget page;
  BottomNavigationBarModel(this.title, this.icon, this.activeIcon, this.page);
}