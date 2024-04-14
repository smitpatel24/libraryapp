// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../resources/app_text_size.dart';
import '../resources/colors.dart';
import '../resources/dimensions.dart';
import '../resources/screen_size.dart';

class SubmitButton extends StatelessWidget {
  final String tittle;
  final Color? textColor;
  final String? activeText;
  final IconData? activeIcon;
  final VoidCallback onTap;
  final double? tittleTextSize;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? activeColor;
  final EdgeInsets margin;
  double? height;
  double? width;

  SubmitButton(
      {super.key,
      required this.tittle,
      this.height,
      this.width,
      this.activeText,
      this.activeIcon,
      this.textColor,
      this.tittleTextSize,
      required this.onTap,
      this.borderColor,
      this.activeColor,
      this.margin = const EdgeInsets.symmetric(vertical: 7.5),
      this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width ?? ScreenSize.width(context),
        height: height ?? 54.h,
        decoration: BoxDecoration(
          color: backgroundColor ?? AppColor.secondaryColor,
          borderRadius: BorderRadius.circular(Dimensions.submitButonRadius),
          border: Border.all(
            color: borderColor ?? Colors.transparent,
          ),

          // gradient: btnGradient
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextWidget2(
                  tittle: tittle,
                  tittleColor: textColor ?? Colors.white,
                  textWeight: FontWeight.w400,
                  textSize: tittleTextSize ?? AppTextSize.h2Textsize),
              SvgPicture.asset(
                "assets/icons/arrow_right.svg",
                height: 20,
                width: 20,
              )
            ],
          ),
        ),
      ),
    );
  }
}
