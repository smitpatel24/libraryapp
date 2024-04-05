// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:responsive/responsive_size.dart';
// import 'package:scan_reader/screens/review_screen.dart';
// import '../../core/resources/app_text_size.dart';
// import '../../core/resources/colors.dart';
// import '../../core/widgets/app_bar.dart';
// import '../../core/widgets/bg_gradient_container.dart';
// import '../../core/widgets/submit_btn.dart';

// class CheckoutErrorScreen extends StatelessWidget {
//   const CheckoutErrorScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColor.primaryColor,
//       body: SingleChildScrollView(
//         child: BgGradientContainer(
//           context: context,
//           child: Column(
//             children: [
//               //^ Header (Appbar)   widget
//               const SizedBox(
//                 height: 30,
//               ),
//               Expanded(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Column(
//                       children: [
//                         CustmAppBarWidget(),
//                         const SizedBox(
//                           height: 20,
//                         ),
//                         TextWidget1(
//                           tittle: "Checkout",
//                           textSize: AppTextSize.h1Textsize,
//                           textWeight: FontWeight.w400,
//                         ),
//                         const SizedBox(
//                           height: 20,
//                         ),
//                         TextWidget2(
//                           tittle: "Oops",
//                           textSize: 50,
//                           tittleColor: AppColor.secondaryColor,
//                           textWeight: FontWeight.w600,
//                         ),
//                         SizedBox(
//                           height: Responsive.isMobile(context) ? 30 : 50,
//                         ),
//                         TextWidget2(
//                           alignnment: TextAlign.center,
//                           tittle:
//                               "Something went wrong! \n\n Please scan again or enter Reader ID",
//                           maxTextlines: 5,
//                           textSize: Responsive.isMobile(context) ? 23 : 32,
//                           tittleColor: Colors.white,
//                           textWeight: FontWeight.w600,
//                         ),
//                       ],
//                     ),

//                     //! submit button
//                     SubmitButton(
//                         onTap: () => Get.to(const ReviewScreen(),
//                             transition: Transition.leftToRight),
//                         tittle: "Try again")
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
