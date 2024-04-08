// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../resources/screen_size.dart';
import 'back_button.dart';

class CustmAppBarWidget extends StatelessWidget {
  CustmAppBarWidget({super.key, this.onTapMenu, this.onTapBackButton});
  void Function()? onTapMenu;
  void Function()? onTapBackButton;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: ScreenSize.width(context),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // const BackButtonWidget(),
          GestureDetector(
            onTap: () => onTapBackButton ?? Get.back(),
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
          ),
          GestureDetector(
            onTap: onTapMenu,
            child: SvgPicture.asset("assets/icons/menu.svg"),
          )
        ],
      ),
    );
  }
}
