import 'package:flutter/material.dart';

class AdaptiveScreen {
  static const double maxSmallScreenWidth = 900.0;

  static bool isSmallScreen(BuildContext context) {
    return MediaQuery.of(context).size.width < maxSmallScreenWidth;
  }

  static bool isBigScreen(BuildContext context) => !isSmallScreen(context);
}
