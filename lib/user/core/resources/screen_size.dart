import 'package:flutter/material.dart';

class ScreenSize {
  static double width(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return width;
  }

  static double height(BuildContext context) {
    var height = MediaQuery.of(context).size.height;

    return height;
  }
}
