// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

//* Text Sizes
class AppTextSize {
  static double h1Textsize = 24.0.sp; //26
  static double h2Textsize = 20.0.sp; //22
  static double h3TextSize = 17.0.sp; //18
  static double body1TextSize = 16.0.sp;
  static double body2TextSize = 14.0.sp;
}

//* APP Custom TextWidgets

//^  TextWidget1

class TextWidget1 extends StatelessWidget {
  TextWidget1(
      {super.key,
      required this.tittle,
      this.alignnment,
      this.maxTextlines,
      this.tittleColor,
      this.textWeight,
      this.textOverflow,
      this.textSize});

  String tittle;
  Color? tittleColor;
  int? maxTextlines;
  TextAlign? alignnment;
  double? textSize;
  FontWeight? textWeight;
  TextOverflow? textOverflow;

  @override
  Widget build(BuildContext context) {
    return Text(
      tittle,
      maxLines: maxTextlines,
      textAlign: alignnment ?? TextAlign.start,
      overflow: textOverflow ?? TextOverflow.ellipsis,
      style: GoogleFonts.dmSans(
        fontSize: textSize ?? AppTextSize.h1Textsize - 3,
        fontWeight: textWeight ?? FontWeight.w600,
        color: tittleColor ?? Colors.white,
      ),
    );
  }
}
//^  TextWidget2

class TextWidget2 extends StatelessWidget {
  TextWidget2(
      {super.key,
      required this.tittle,
      this.alignnment,
      this.maxTextlines,
      this.tittleColor,
      this.textWeight,
      this.textOverflow,
      this.textSize});

  String tittle;
  Color? tittleColor;
  int? maxTextlines;
  TextAlign? alignnment;
  double? textSize;
  FontWeight? textWeight;
  TextOverflow? textOverflow;

  @override
  Widget build(BuildContext context) {
    return Text(
      tittle,
      maxLines: maxTextlines,
      textAlign: alignnment ?? TextAlign.start,
      overflow: textOverflow ?? TextOverflow.ellipsis,
      style: GoogleFonts.mulish(
        fontSize: textSize ?? AppTextSize.h2Textsize,
        fontWeight: textWeight ?? FontWeight.w600,
        color: tittleColor ?? Colors.white,
      ),
    );
  }
}
