import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:libraryapp/models/book.dart';
import 'package:libraryapp/services/offline_enabled_supabase_manager.dart';
import 'package:libraryapp/services/supabase_manager.dart';
import 'package:libraryapp/widgets/step_indicator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ReturnBookPage extends StatefulWidget {
  const ReturnBookPage({super.key});

  @override
  _ReturnBookPageState createState() => _ReturnBookPageState();
}

class _ReturnBookPageState extends State<ReturnBookPage> {
  // final OfflineEnabledSupabaseManager _offlineEnabledManager =
  //     OfflineEnabledSupabaseManager();
  final SupabaseManager _offlineEnabledManager = SupabaseManager.instance;
  final TextEditingController _barcodeController = TextEditingController();
  String _selectedCondition = 'Good';
  Book? _bookDetails;
  int _currentStep = 1;

  Future<void> _scanBarcode() async {
    try {
      final barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        '#615793',
        'Cancel',
        true,
        ScanMode.BARCODE,
      );

      if (!mounted) return;

      if (barcodeScanRes != '-1') {
        setState(() {
          _barcodeController.text = barcodeScanRes;
        });
      }
    } catch (e) {
      _showErrorMessage('Failed to scan barcode: ${e.toString()}');
    }
  }

  Future<void> _fetchBookDetails() async {
    if (_barcodeController.text.isEmpty) {
      _showErrorMessage('Please enter or scan a barcode');
      return;
    }

    await _offlineEnabledManager
        .getCheckeoutBookByBarcode(_barcodeController.text);

    final book = {
      'title': 'The Great Gatsby',
      'author': 'F. Scott Fitzgerald',
    };
    if (book != null) {
      setState(() {
        _bookDetails = Book(
          bookId: 1,
          copyId: 1,
          title: 'The Great Gatsby',
          authorName: 'F. Scott Fitzgerald',
          authorId: 1,
          barcode: _barcodeController.text,
        );
        _currentStep = 2; // Move to the confirmation step
      });
    } else {
      _showErrorMessage('Book not found.');
    }
  }

  void _confirmReturn() async {
    if (_barcodeController.text.isEmpty) {
      _showErrorMessage('Please enter or scan a barcode');
      return;
    }

    try {
      // await _offlineEnabledManager.updateBookStatus(
      //   barcode: _barcodeController.text,
      //   status: 'Available',
      //   condition: _selectedCondition,
      // );
      await Future.delayed(Duration(seconds: 2)); // Simulate network delay
      setState(() {
        _currentStep = 3; // Move to the success step
      });
    } catch (error) {
      _showErrorMessage('Error returning book: $error');
    }
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF32324D),
      appBar: AppBar(
        leading: BackButton(color: Colors.white),
        title: Text('Return Book', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(height: 20),
          StepIndicator(
            totalSteps: 3,
            currentStep: _currentStep,
            titles: ['Barcode', 'Confirm', 'Success'],
          ),
          SizedBox(height: 30),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: _currentStep == 1
                  ? _buildBarcodeEntryStep()
                  : _currentStep == 2
                      ? _buildConfirmationStep()
                      : _buildSuccessScreen(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBarcodeEntryStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GestureDetector(
          onTap: _scanBarcode,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 15.0),
            decoration: BoxDecoration(
              color: Colors.white12,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.camera_alt,
                  color: Colors.white54,
                ),
                const SizedBox(height: 10),
                Text(
                  'Tap to scan barcode',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 16),
        TextField(
          controller: _barcodeController,
          decoration: InputDecoration(
            labelText: 'Enter Barcode Manually',
            labelStyle: TextStyle(color: Colors.white70),
            filled: true,
            fillColor: Colors.white12,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: Colors.orange, width: 1.5),
            ),
          ),
          style: TextStyle(color: Colors.white),
        ),
        SizedBox(height: 24),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF615793),
            padding: EdgeInsets.symmetric(vertical: 16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          onPressed: _fetchBookDetails,
          child: Text(
            'Submit Barcode',
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildConfirmationStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildBookDetails(),
        SizedBox(height: 16),
        _buildConditionSelector(),
        SizedBox(height: 24),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey,
            padding: EdgeInsets.symmetric(vertical: 16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          onPressed: () {
            setState(() {
              _currentStep = 1;
              _barcodeController.clear();
              _bookDetails = null;
            });
          },
          child: Text(
            'Go Back',
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
        SizedBox(height: 16),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF615793),
            padding: EdgeInsets.symmetric(vertical: 16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          onPressed: _confirmReturn,
          child: Text(
            'Confirm Return',
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildSuccessScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Spacer(),
          Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 80,
          ),
          SizedBox(height: 16),
          Text(
            'Book returned successfully!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          Spacer(),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF615793),
                padding: EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onPressed: () {
                setState(() {
                  _currentStep = 1;
                  _barcodeController.clear();
                  _bookDetails = null;
                });
              },
              child: Text(
                'Return Another Book',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
          SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildBookDetails() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white12,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Book Details',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Title: ${_bookDetails?.title ?? 'Unknown'}',
            style: TextStyle(color: Colors.white70),
          ),
          Text(
            'Author: ${_bookDetails?.authorName ?? 'Unknown'}',
            style: TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildConditionSelector() {
    return DropdownButtonFormField<String>(
      value: _selectedCondition,
      dropdownColor: Color(0xFF32324D),
      decoration: InputDecoration(
        labelText: 'Condition',
        labelStyle: TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.white24,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.orange, width: 1.5),
        ),
      ),
      items: ['Good', 'Damaged', 'Missing Pages']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value, style: TextStyle(color: Colors.white70)),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          _selectedCondition = newValue!;
        });
      },
    );
  }
}
