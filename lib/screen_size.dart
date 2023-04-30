import 'package:flutter/cupertino.dart';

class ScreenSize {
  static MediaQueryData? _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static late double safeAreaHorizontal;
  static late double safeAreaVertical;
  static late double padding10;
  static late double padding30;
  static late double padding8;
  static late double padding20;

  static void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData!.size.width;
    screenHeight = _mediaQueryData!.size.height;

    final safeArea = _mediaQueryData!.padding;
    safeAreaHorizontal = safeArea.left + safeArea.right;
    safeAreaVertical = safeArea.top + safeArea.bottom;

    padding10 = screenWidth * 0.025;
    padding30 = screenWidth * 0.075;
    padding8 = screenWidth * 0.016;
    padding20 = screenWidth * 0.05;
  }
}
