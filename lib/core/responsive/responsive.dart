import 'package:flutter/widgets.dart';

class Responsive {
  // Screen size breakpoints
  static const double mobileBreakpoint = 850;
  static const double tabletBreakpoint = 900;
  static const double desktopBreakpoint = 1000;

  static const double spacingHz = 20.0;
  static const double spacingVt = 15.0;
  static const double betweenSpace = 15.0;

  static const double kHZPadding = 40;
  static const double kVRTPadding = 20;
  static const double kHZRowPadding = 25;
  static const double kVRTRowPadding = 18;

  static const double kHZRowPaddingTB = 20;
  static const double kVRTPaddingTB = 20;

  static const double spacingHzTB = 10.0;
  static const double spacingVtTB = 15.0;

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 768;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width < desktopBreakpoint &&
      MediaQuery.of(context).size.width >= mobileBreakpoint;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= desktopBreakpoint;

  // Get screen width percentage
  static double widthPercent(BuildContext context, double percent) =>
      MediaQuery.of(context).size.width * (percent / 100);

  // Get screen height percentage
  static double heightPercent(BuildContext context, double percent) =>
      MediaQuery.of(context).size.height * (percent / 100);

  // Helper method to get correct padding based on screen size
  static double getHorizontalPadding(BuildContext context) {
    if (isDesktop(context)) return 120.0;
    if (isDesktop(context)) return 80.0;
    if (isTablet(context)) return 40.0;
    return 20.0;
  }
}
