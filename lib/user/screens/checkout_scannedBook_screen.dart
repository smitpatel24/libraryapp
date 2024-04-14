import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:libraryapp/user/UserHomePage.dart';
import 'package:libraryapp/user/screens/checkout_error_screen2.dart';
import '../core/resources/app_text_size.dart';
import '../core/resources/colors.dart';
import '../core/responsive/responsive_size.dart';
import '../core/widgets/app_bar.dart';
import '../core/widgets/bg_gradient_container.dart';
import '../core/widgets/submit_btn.dart';
import 'checkout_error_screen.dart';
import 'checkout_success_screen.dart';

class ChkoutScannedBookScreen extends StatelessWidget {
  const ChkoutScannedBookScreen({super.key});

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
                          height: Responsive.isMobile(context) ? 20 : 30,
                        ),
                        TextWidget1(
                          tittle: "Checkout",
                          textSize: AppTextSize.h1Textsize,
                          textWeight: FontWeight.w400,
                        ),
                        SizedBox(
                          height: Responsive.isMobile(context) ? 15 : 25,
                        ),
                        TextWidget2(
                          tittle: "Scanned Book",
                          textSize: AppTextSize.h1Textsize,
                          textWeight: FontWeight.w500,
                        ),
                        SizedBox(
                          height: Responsive.isMobile(context) ? 15 : 15,
                        ),
                        TextWidget2(
                          tittle: "Aurora's Awakening",
                          textSize: AppTextSize.body1TextSize - 2,
                          textWeight: FontWeight.w400,
                        ),
                        SizedBox(
                          height: Responsive.isMobile(context) ? 15 : 15,
                        ),
                        TextWidget2(
                          tittle: "- By Luna Evergreen",
                          textSize: AppTextSize.body1TextSize - 2,
                          textWeight: FontWeight.w400,
                        ),
                        SizedBox(
                          height: Responsive.isMobile(context) ? 15 : 15,
                        ),
                        TextWidget2(
                          tittle: "(Book_ID) ",
                          textSize: AppTextSize.body1TextSize - 2,
                          textWeight: FontWeight.w400,
                        ),
                      ],
                    ),

                    //! submit button
                    SubmitButton(
                        onTap: () => Get.to(const CheckoutSuccessScreen(),
                            transition: Transition.leftToRight),
                        tittle: "Confirm")
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
//! Error Button

              TextButton(
                onPressed: () {
                  Get.to(const CheckoutErrorScreen());
                },
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.red)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextWidget2(
                    tittle: "Error  Screen",
                    textSize: AppTextSize.body1TextSize - 2,
                    textWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
