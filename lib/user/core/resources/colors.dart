import 'package:flutter/material.dart';

class AppColor {
//* App Colors
  static const lightGrayColor = Color(0xFF7A9496);
  static const deepGrayColor = Color(0xFF3F494B);

//* primary  Color

  //& Light theme
  static const LinearGradient backgroundColorGradient = LinearGradient(colors: [
    Color(0xFF32324D),
    Color(0xFF32324D),
    Color(0xFF2C2C45),
    Color(0xFF32324D),
    Color(0xFF32324D),
  ]);

  static const Color primaryColor = Color(0xFF32324D);
  static const Color lightPrimaryColor = Color(0xFF615793);
  static const Color secondaryColor = Color(0xff935757);

  static const Color mainTitleTextColor = Colors.white;

  static const Color bodytitleTextColorWhite = Color(0xffFFFFFF);

  static const Color bodysubTitleTextColor = Color(0xffC0C0CF);

  static const Color successMsgTextColor = Color(0xff7AD08A);

//* Buttn text color

  static const Color submitBtnTextWhite = Colors.white;

  static const Color backButtonColor = Color(0xFF4A4A6A);
  static const Color backButtonBorderColor = Colors.transparent;


//* Buttn border color

  static const Color submitBtnBgColor = AppColor.secondaryColor;
  static const Color submitBtnBorderColor = Color(0xff19A7CE);

//* Text Field Color

  static final Color txtFldFillColor = const Color(0xFFEBC7AF).withOpacity(0.3);
  static const Color txtFldFillColor2 = Color(0xFF615793);

  static const Color txtFldContentColor = Colors.white;

  static const Color hintTextColor = Color(0xff597173);

  static const Color textFiledBorderColor = Colors.transparent;

  static const Color textFiledErrorBorderColor = Color(0xFFE64646);

//* icon color
  static const Color appIconColor = Colors.white;
}
