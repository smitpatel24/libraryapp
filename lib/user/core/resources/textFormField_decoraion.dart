// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_text_size.dart';

InputDecoration formFieldDeocration({
  required String hintText,
}) {
  return InputDecoration(
      fillColor: Colors.transparent,
      hintText: hintText,
      hintStyle: GoogleFonts.mulish(
        fontSize: AppTextSize.body1TextSize,
        fontWeight: FontWeight.w600,
        // color: AppColor.hintTextColor,
        color: Colors.white,
      ),
      border: InputBorder.none);
}
