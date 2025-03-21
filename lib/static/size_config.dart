import 'package:flutter/material.dart';

class SizeConfig {
  static MediaQueryData _mediaQueryData = const MediaQueryData();
  static double screenWidth = 0;
  static double screenHeight = 0;
  static Orientation orientation = Orientation.portrait;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    orientation = _mediaQueryData.orientation;
  }
}

double getPropScreenWidth(double size) {
  double screenWidth = SizeConfig.screenWidth;
  return (size / 375.0) * screenWidth;
}

double getPropScreenHeight(double size) {
  double screenHeight = SizeConfig.screenHeight;
  return (size / 812.0) * screenHeight;
}

