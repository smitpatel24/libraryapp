import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/resources/app_text_size.dart';
import '../core/resources/colors.dart';
import '../core/responsive/responsive_size.dart';
import '../core/widgets/app_bar.dart';
import '../core/widgets/bg_gradient_container.dart';
import '../core/widgets/submit_btn.dart';
import 'checkout_scanBook_screen.dart';
import 'successful_book_return_screen.dart';

class ReviewScreen extends StatelessWidget {
  const ReviewScreen({super.key});

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
                        const SizedBox(
                          height: 20,
                        ),
                        TextWidget1(
                          tittle: "Checkout",
                          textSize: AppTextSize.h1Textsize,
                          textWeight: FontWeight.w400,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextWidget2(
                          tittle: "Review",
                          textSize: AppTextSize.h2Textsize,
                          textWeight: FontWeight.w700,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextWidget2(
                          tittle: "(Step 1 of 2)",
                          textSize: AppTextSize.h3TextSize,
                          textWeight: FontWeight.w500,
                        ),
                      ],
                    ),
                    //! form
                    Column(
                      children: [
                        informationWidget(tittle: "First Name", desc: "John"),
                        const SizedBox(
                          height: 05,
                        ),
                        informationWidget(tittle: "Last Name", desc: "Doe"),
                        const SizedBox(
                          height: 05,
                        ),
                        informationWidget(tittle: "Library ID", desc: "LBR456"),
                        const SizedBox(
                          height: 05,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: Responsive.isMobile(context) ? 30 : 40,
                    ),

                    //! submit button
                    SubmitButton(
                        onTap: () => Get.to(const ChkoutScanBookScreen(),
                            transition: Transition.leftToRight),
                        tittle: "Confirm")
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row informationWidget({required String tittle, required String desc}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextWidget2(
          tittle: "$tittle : ",
          textSize: AppTextSize.body1TextSize,
          textWeight: FontWeight.bold,
        ),
        TextWidget2(
            tittle: desc,
            textSize: AppTextSize.body1TextSize,
            textWeight: FontWeight.w400),
      ],
    );
  }
}
