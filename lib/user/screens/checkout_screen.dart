import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import '../../services/supabase_manager.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'checkout_success_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final TextEditingController _bookBarcodeController = TextEditingController();
  final TextEditingController _userBarcodeController = TextEditingController();
  final TextEditingController _dueDateController = TextEditingController();

  @override
  void dispose() {
    _bookBarcodeController.dispose();
    _userBarcodeController.dispose();
    _dueDateController.dispose();
    super.dispose();
  }

  Future<void> _scanBarcode(TextEditingController controller) async {
    String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
      "#ff6666",
      "Cancel",
      true,
      ScanMode.BARCODE,
    );
    if (barcodeScanRes != "-1" && mounted) {
      setState(() {
        controller.text = barcodeScanRes;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 14)), // Default to 2 weeks from now
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF615793),
              onPrimary: Colors.white,
              surface: Color(0xFF32324D),
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: const Color(0xFF32324D),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null && mounted) {
      setState(() {
        _dueDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _showReviewModal(BuildContext context) async {
    if (_bookBarcodeController.text.isEmpty || _userBarcodeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter both book and user barcodes"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final data = await SupabaseManager().fetchCheckoutDetails(
        _bookBarcodeController.text,
        _userBarcodeController.text,
      );

      if (!mounted) return;

      if (data == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("No checkout details found for the provided barcodes"),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Successfully fetched checkout details"),
          backgroundColor: Colors.green,
        ),
      );

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: const Color(0xFF32324D),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Checkout Details",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    "Book Title: ${data['bookTitle']}",
                    style: const TextStyle(fontSize: 18, color: Colors.white70),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Author: ${data['author']}",
                    style: const TextStyle(fontSize: 18, color: Colors.white70),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Reader Name: ${data['readerFirstName']} ${data['readerLastName']}",
                    style: const TextStyle(fontSize: 18, color: Colors.white70),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Due Date: ${_dueDateController.text}",
                    style: const TextStyle(fontSize: 18, color: Colors.white70),
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      onPressed: () async {
                        try {
                          await SupabaseManager().checkoutBook(
                            _bookBarcodeController.text,
                            _userBarcodeController.text,
                            _dueDateController.text,
                          );
                          if (mounted) {
                            Navigator.pop(context);
                            _bookBarcodeController.clear();
                            _userBarcodeController.clear();
                            _dueDateController.clear();
                            Get.to(const CheckoutSuccessScreen());
                          }
                        } catch (error) {
                          if (mounted) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Checkout failed: $error"),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      },
                      child: const Text(
                        "Confirm Checkout",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    } catch (error) {
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to fetch checkout details: $error"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF32324D),
      appBar: AppBar(
        leading: const BackButton(color: Colors.white),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const SizedBox(height: 20),
            const Text(
              'Checkout Book',
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 25),
            _buildTextField(
                label: 'Book Barcode',
                controller: _bookBarcodeController,
                isScannable: true),
            const SizedBox(height: 20),
            _buildTextField(
                label: 'User Barcode',
                controller: _userBarcodeController,
                isScannable: true),
            const SizedBox(height: 20),
            _buildTextField(
                label: 'Due Date',
                controller: _dueDateController,
                onTap: () => _selectDate(context),
                readOnly: true),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF615793),
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onPressed: () => _showReviewModal(context),
              child: const Text(
                'Review Checkout',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    bool isScannable = false,
    VoidCallback? onTap,
    bool readOnly = false,
  }) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      decoration: InputDecoration(
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
        suffixIcon: isScannable
            ? IconButton(
                icon: const Icon(Icons.qr_code_scanner, color: Colors.white70),
                onPressed: () => _scanBarcode(controller),
              )
            : readOnly
                ? const Icon(Icons.calendar_today, color: Colors.white70)
                : null,
      ),
      style: const TextStyle(color: Colors.white70),
    );
  }
}
