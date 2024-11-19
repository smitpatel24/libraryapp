import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import '../core/resources/app_text_size.dart';
import '../core/resources/colors.dart';
import '../core/resources/dimensions.dart';
import '../core/resources/screen_size.dart';
import '../core/resources/textFormField_decoraion.dart';
import '../core/widgets/app_bar.dart';
import '../core/widgets/bg_gradient_container.dart';
import '../../services/supabase_manager.dart';
import 'checkout_error_screen.dart';
import 'successful_book_return_screen.dart';

class ReturnScreen extends StatefulWidget {
  const ReturnScreen({super.key});

  @override
  State<ReturnScreen> createState() => _ReturnScreenState();
}

class _ReturnScreenState extends State<ReturnScreen> {
  final TextEditingController _bookIdController = TextEditingController();

  // Custom Snackbar method to show messages
  void showCustomSnackbar(BuildContext context, String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  Future<void> _scanBarcode() async {
    String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
      "#ff6666",
      "Cancel",
      true,
      ScanMode.BARCODE,
    );
    if (barcodeScanRes != "-1" && mounted) {
      setState(() {
        _bookIdController.text = barcodeScanRes;
      });
    }
  }

  Future<void> _handleReturn() async {
    String bookId = _bookIdController.text;
        
    if (bookId.isEmpty) {
      showCustomSnackbar(context, 'Please enter a book ID or scan barcode', isError: true);
      return;
    }

    try {
      await SupabaseManager().returnBook(bookId);
      _bookIdController.clear(); // Clear the text field after successful return
      Get.to(const SuccessfulBookReturnScreen(),
          transition: Transition.leftToRight);
    } catch (e) {
      showCustomSnackbar(context, 'Error returning book: ${e.toString()}', isError: true);
    }
  }

  @override
  void dispose() {
    _bookIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primaryColor,
      body: SingleChildScrollView(
        child: BgGradientContainer(
          context: context,
          child: Column(
            children: [
              //^ Header (Appbar) widget
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
                          tittle: "Return",
                          textSize: AppTextSize.h1Textsize,
                          textWeight: FontWeight.w400,
                        ),
                      ],
                    ),
                    //! form
                    SizedBox(
                      width: ScreenSize.width(context),
                      child: Column(
                        children: [
                          //^ Enter Book id
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
                            child: Container(
                              width: ScreenSize.width(context), // Ensuring it takes full width
                              decoration: BoxDecoration(
                                color: AppColor.txtFldFillColor,
                                borderRadius: BorderRadius.circular(Dimensions.submitButonRadius),
                                border: Border.all(
                                  color: Colors.transparent,
                                ),
                              ),
                              child: TextFormField(
                                controller: _bookIdController,
                                decoration: buildInputDecoration("Enter Book Barcode"),
                                style: const TextStyle(color: Colors.white70),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          // Divider line with OR text
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 1,
                                  color: Colors.grey,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  "OR",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  height: 1,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          //^ Scan Barcode Button
                          GestureDetector(
                            onTap: _scanBarcode,
                            child: Container(
                              width: ScreenSize.width(context),
                              height: 54.h,
                              decoration: BoxDecoration(
                                color: AppColor.txtFldFillColor2,
                                borderRadius: BorderRadius.circular(Dimensions.submitButonRadius),
                                border: Border.all(
                                  color: Colors.transparent,
                                ),
                              ),
                              child: Center(
                                child: TextWidget2(
                                  tittle: "Scan Barcode",
                                  textSize: AppTextSize.h2Textsize,
                                  textWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    //! submit button
                    GestureDetector(
                      onTap: _handleReturn,
                      child: Container(
                        height: 54.h,
                        width: ScreenSize.width(context) / 2,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColor.txtFldFillColor2,
                          borderRadius: BorderRadius.circular(Dimensions.submitButonRadius),
                          border: Border.all(
                            color: Colors.transparent,
                          ),
                        ),
                        child: TextWidget2(
                          tittle: "Return",
                          tittleColor: Colors.white,
                          textWeight: FontWeight.w400,
                          textSize: AppTextSize.h2Textsize,
                        ),
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

  // TextField Decoration copied from CheckoutScreen
  InputDecoration buildInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      filled: true,
      fillColor: Colors.white24,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(color: Colors.orange, width: 1.5),
      ),
    );
  }
}
