import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:libraryapp/user/UserHomePage.dart';
import '../core/resources/app_text_size.dart';
import '../core/resources/colors.dart';
import '../core/resources/dimensions.dart';
import '../core/resources/screen_size.dart';
import '../core/responsive/responsive_size.dart';
import '../core/widgets/app_bar.dart';
import '../core/widgets/bg_gradient_container.dart';
import 'checkout_screen.dart';

class CheckoutSuccessScreen extends StatelessWidget {
  const CheckoutSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primaryColor,
      body: SingleChildScrollView(
        child: BgGradientContainer(
          context: context,
          child: Column(
            children: [
              //^ Header (Appbar)   widget
              const SizedBox(
                height: 30,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        CustmAppBarWidget(),
                        SizedBox(
                          height: Responsive.isMediumMobile(context) ||
                                  Responsive.isMobile(context)
                              ? 100
                              : 130,
                        ),
                        TextWidget2(
                          alignnment: TextAlign.center,
                          tittle: "CHECKOUT SUCCESSFUL!",
                          maxTextlines: 3,
                          textSize: Responsive.isMobile(context) ? 35 : 40,
                          tittleColor: AppColor.successMsgTextColor,
                          textWeight: FontWeight.w700,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Image.asset(
                          "assets/icons/check.png",
                          height: Responsive.isMobile(context) ? 130 : 150,
                          width: Responsive.isMobile(context) ? 130 : 200,
                          fit: BoxFit.fitWidth,
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    //! submit button
                    GestureDetector(
                      onTap: () {
                        Get.to(UserHomePage());
                      },
                      child: Container(
                        height: 54.h,
                        width: ScreenSize.width(context) / 2,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColor.txtFldFillColor2,
                          borderRadius: BorderRadius.circular(
                              Dimensions.submitButonRadius),
                          border: Border.all(
                            color: Colors.transparent,
                          ),

                          // gradient: btnGradient
                        ),
                        child: TextWidget2(
                            tittle: "New Checkout",
                            tittleColor: Colors.white,
                            textWeight: FontWeight.w400,
                            textSize: AppTextSize.h2Textsize),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
