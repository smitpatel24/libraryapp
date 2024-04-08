import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/resources/app_text_size.dart';
import '../core/resources/colors.dart';
import '../core/resources/dimensions.dart';
import '../core/resources/screen_size.dart';
import '../core/resources/textFormField_decoraion.dart';
import '../core/responsive/responsive_size.dart';
import '../core/widgets/app_bar.dart';
import '../core/widgets/bg_gradient_container.dart';
import '../core/widgets/submit_btn.dart';
import 'checkout_error_screen2.dart';
import 'checkout_scannedBook_screen.dart';

class ChkoutScanBookScreen extends StatelessWidget {
  const ChkoutScanBookScreen({super.key});

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
                          height: Responsive.isMobile(context) ? 15 : 20,
                        ),
                        TextWidget1(
                          tittle: "Checkout",
                          textSize: AppTextSize.h1Textsize,
                          textWeight: FontWeight.w400,
                        ),
                        SizedBox(
                            height: Responsive.isMobile(context) ? 15 : 20),
                        TextWidget2(
                          tittle: "Scan Book",
                          textSize: AppTextSize.h2Textsize,
                          textWeight: FontWeight.w700,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextWidget2(
                          tittle: "Ariel Meadows",
                          textSize: AppTextSize.body1TextSize,
                          textWeight: FontWeight.w600,
                        ),
                        SizedBox(
                          height: Responsive.isMobile(context) ? 10 : 20,
                        ),
                        TextWidget2(
                          tittle: "502804(CODE_071)",
                          textSize: AppTextSize.body2TextSize,
                          textWeight: FontWeight.w600,
                          tittleColor: const Color(0xFFC0C0CF),
                        ),
                        SizedBox(
                          height: Responsive.isMobile(context) ? 15 : 25,
                        ),
                        TextWidget2(
                          tittle: "(Step 2 of 2)",
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
                        onTap: () => Get.to(const ChkoutScannedBookScreen(),
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
