import 'package:flutter/material.dart';
import '../widgets/responsive_layout.dart';

class ResponsiveUtils {
  ResponsiveUtils._();

  static bool isLandscape(BuildContext context) {
    return MediaQuery.orientationOf(context) == Orientation.landscape;
  }

  static double scaledFontSize(BuildContext context, double baseSize) {
    final screenSize = ResponsiveLayout.getScreenSize(context);
    return switch (screenSize) {
      ScreenSize.mobile => baseSize,
      ScreenSize.tablet => baseSize * 1.1,
      ScreenSize.desktop => baseSize * 1.15,
    };
  }

  static double verticalPadding(BuildContext context, double baseValue) {
    if (isLandscape(context) && ResponsiveLayout.isMobile(context)) {
      return baseValue * 0.6;
    }
    return baseValue;
  }
}
