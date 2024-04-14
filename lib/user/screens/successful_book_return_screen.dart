import 'package:flutter/material.dart';
import '../core/resources/app_text_size.dart';
import '../core/resources/colors.dart';
import '../core/responsive/responsive_size.dart';
import '../core/widgets/app_bar.dart';
import '../core/widgets/bg_gradient_container.dart';

class SuccessfulBookReturnScreen extends StatelessWidget {
  const SuccessfulBookReturnScreen({super.key});

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
                              ? 150
                              : 250,
                        ),
                        TextWidget2(
                          alignnment: TextAlign.center,
                          tittle: "RETURN SUCCESSFUL!",
                          maxTextlines: 3,
                          textSize: Responsive.isMobile(context) ? 35 : 40,
                          tittleColor: AppColor.successMsgTextColor,
                          textWeight: FontWeight.w700,
                        ),
                      ],
                    ),
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
