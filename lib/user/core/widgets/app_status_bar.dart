import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppStatusBar {
  static splashStatusBarColor() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
  }
}
