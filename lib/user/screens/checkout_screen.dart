import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:libraryapp/user/UserHomePage.dart';
import 'package:libraryapp/user/screens/review_screen.dart';
import '../core/resources/app_text_size.dart';
import '../core/resources/colors.dart';
import '../core/resources/dimensions.dart';
import '../core/resources/screen_size.dart';
import '../core/resources/textFormField_decoraion.dart';
import '../core/widgets/app_bar.dart';
import '../core/widgets/bg_gradient_container.dart';
import '../core/widgets/submit_btn.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

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
                          tittle: "Scan Reader",
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
                    SizedBox(
                      // height: 400,
                      width: ScreenSize.width(context),
                      child: Column(
                        children: [
                          //^ Enter Book id
                          Container(
                            width: ScreenSize.width(context),
                            // height: 54.h,
                            decoration: BoxDecoration(
                              color: AppColor.txtFldFillColor,
                              borderRadius: BorderRadius.circular(
                                  Dimensions.submitButonRadius),
                              border: Border.all(
                                color: Colors.transparent,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15.0, vertical: 5),
                              child: TextFormField(
                                decoration: formFieldDeocration(
                                    hintText: "Enter Book ID"),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 1,
                                  color: Colors.white,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 2,
                                  horizontal: 10,
                                ),
                                child: TextWidget2(
                                  tittle: "Or",
                                  textSize: AppTextSize.h2Textsize,
                                  textWeight: FontWeight.w400,
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  height: 1,
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                          //^ Enter Book id
                          Container(
                            width: ScreenSize.width(context),
                            // height: 54.h,
                            decoration: BoxDecoration(
                              color: AppColor.txtFldFillColor2,
                              borderRadius: BorderRadius.circular(
                                  Dimensions.submitButonRadius),
                              border: Border.all(
                                color: Colors.transparent,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15.0, vertical: 5),
                              child: TextFormField(
                                decoration: formFieldDeocration(
                                    hintText: "Scan Barcode"),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),

                    //! submit button
                    SubmitButton(
                        onTap: () => Get.to(const ReviewScreen(),
                            transition: Transition.leftToRight),
                        tittle: "Continue")
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
