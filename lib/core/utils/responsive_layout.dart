import 'package:flutter/material.dart';

abstract final class ResponsiveLayout {
  static Size sizeOf(BuildContext context) => MediaQuery.sizeOf(context);

  static bool isLandscape(BuildContext context) =>
      MediaQuery.orientationOf(context) == Orientation.landscape;

  static bool isTablet(BuildContext context) =>
      sizeOf(context).shortestSide >= 600;

  static bool isLandscapeTablet(BuildContext context) =>
      isLandscape(context) && isTablet(context);

  static double contentMaxWidth(BuildContext context) {
    if (isLandscapeTablet(context)) return 1200;
    if (isTablet(context)) return 720;
    return double.infinity;
  }

  static double horizontalPadding(BuildContext context) {
    if (isLandscapeTablet(context)) return 48;
    if (isTablet(context)) return 32;
    return 20;
  }

  static double value(
    BuildContext context, {
    required double mobile,
    double? tablet,
    double? landscapeTablet,
  }) {
    if (isLandscapeTablet(context)) {
      return landscapeTablet ?? tablet ?? mobile;
    }
    if (isTablet(context)) {
      return tablet ?? mobile;
    }
    return mobile;
  }
}
