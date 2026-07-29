import 'package:flutter/material.dart';
import 'breakpoints.dart';

extension ContextResponsiveExt on BuildContext {
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
  Orientation get orientation => MediaQuery.of(this).orientation;

  bool get isTablet => screenWidth >= Breakpoints.mobileMax;
  bool get isPhone => screenWidth < Breakpoints.mobileMax;

  int get gridColumns {
    if (screenWidth >= 900) return 4;
    if (screenWidth >= 600) return 3;
    return 2;
  }
}
