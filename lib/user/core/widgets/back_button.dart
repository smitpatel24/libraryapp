import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class BackButtonWidget extends StatelessWidget {
  const BackButtonWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.back(),
      child: Container(
        height: 40, // 44
        width: 40, //44
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xFF4A4A6A),
          borderRadius: BorderRadius.circular(12),
        ),
        child: SvgPicture.asset("assets/icons/back.svg"),
      ),
    );
  }
}
