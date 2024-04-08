// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class Responsive extends StatelessWidget {
  Responsive({
    super.key,
    required this.mobile,
    required this.tablet,
  });
  Widget? desktop;
  Widget? largeMobile;
  final Widget mobile;
  final Widget tablet;
  Widget? extraLargeScreen;

  static bool isMobile(BuildContext context) {
    return MediaQuery.sizeOf(context).width <= 380;
  }

  static bool isMediumMobile(BuildContext context) {
    return (MediaQuery.sizeOf(context).width > 381 &&
        MediaQuery.sizeOf(context).width <= 413);
  }

  static bool isLargeMobile(BuildContext context) {
    return (MediaQuery.sizeOf(context).width > 414 &&
        MediaQuery.sizeOf(context).width <= 799);
  }

  static bool isTablet(BuildContext context) {
    return (MediaQuery.sizeOf(context).width >= 800 &&
        MediaQuery.sizeOf(context).width <= 1280); //~ 1080
  }

  // static bool isDesktop(BuildContext context) {
  //   return MediaQuery.sizeOf(context).width > 1024;
  // }

  static bool isExtraLargeScreen(BuildContext context) {
    return (MediaQuery.sizeOf(context).width > 1281 &&
        MediaQuery.sizeOf(context).width <= 1400);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      // If our width is more than 1100 then we consider it a desktop
      builder: (context, constraints) {
        // if (constraints.maxWidth >= 1100) {
        //   return desktop!;
        // }
        // If width it less then 1100 and more then 650 we consider it as tablet
        // else
        if (constraints.maxWidth >= 650) {
          return tablet;
        }
        // Or less then that we called it mobile
        else {
          return mobile;
        }
      },
    );
    // final Size size = MediaQuery.of(context).size;
    // if (size.width > 1400 && extraLargeScreen != null) {
    //   return extraLargeScreen!;
    // } else if (size.width >= 1080) {
    //   return desktop!;
    // } else if (size.width >= 700 && tablet != null) {
    //   return tablet!;
    // } else if (size.width >= 500 && largeMobile != null) {
    //   return largeMobile!;
    // } else {
    //   return mobile!  ;
    // }
  }
}
