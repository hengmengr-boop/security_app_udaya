import 'package:flutter/material.dart';

/// Breakpoints shared by every page so one codebase fits phone, tablet and laptop.
///
/// * mobile  : < 600   (phones)
/// * tablet  : 600-899 (tablets, phone landscape)
/// * wide    : >= 900  (laptop / desktop / large tablet landscape)
extension ResponsiveUtils on BuildContext {
  double get screenWidth => MediaQuery.sizeOf(this).width;

  double get screenHeight => MediaQuery.sizeOf(this).height;

  bool get isMobile => screenWidth < 600;

  bool get isTablet => screenWidth >= 600 && screenWidth < 900;

  bool get isWide => screenWidth >= 900;
}
