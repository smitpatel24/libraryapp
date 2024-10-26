import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:libraryapp/services/supabase_manager.dart';

class AddUserPage extends StatefulWidget {
  @override
  _AddUserPageState createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _scannedBarcode; // Store the scanned barcode

  void _createAccount() async {
    // 1. Validate input fields
    if (_firstNameController.text.isEmpty ||
        _lastNameController.text.isEmpty ||
        _usernameController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill in all the fields')),
        );
      }
      return;
    }

    // 2. Check if a barcode has been scanned
    if (_scannedBarcode == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please scan a barcode first')),
        );
      }
      return;
    }

    // Show a loading indicator while the user is being created
    if (mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );
    }

    try {
      // Call the SupabaseManager to create a user
      await SupabaseManager().createUserAsAReader(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        username: _usernameController.text,
        password: _passwordController.text,
        barcode: _scannedBarcode!,
      );

      // On success, close the loading indicator
      if (mounted) {
        Navigator.of(context).pop(); // Close the loading dialog

        // Clear the form
        _firstNameController.clear();
        _lastNameController.clear();
        _usernameController.clear();
        _passwordController.clear();
        setState(() {
          _scannedBarcode = null;
        });

        // Show success message using SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text('User created successfully! Form cleared for new entry.'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (error) {
      if (mounted) {
        Navigator.of(context).pop(); // Close the loading dialog

        // Show error message using SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error creating user: $error'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _scanBarcode() async {
    try {
      final barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        '#615793', // Using the same purple color as your theme
        'Cancel',
        true,
        ScanMode.BARCODE,
      );
      if (!mounted) return;
      // Only update if a barcode was successfully scanned
      if (barcodeScanRes != '-1') {
        setState(() {
          _scannedBarcode = barcodeScanRes;
        });

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Barcode scanned: $_scannedBarcode'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      // Check if widget is still mounted before using BuildContext
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to scan barcode: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF32324D),
      appBar: AppBar(
        leading: BackButton(color: Colors.white),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        // Ensures the input form is scrollable
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 20),
            Text(
              'Add New User Details',
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24),
            _buildTextField(
                label: 'First Name', controller: _firstNameController),
            SizedBox(height: 16),
            _buildTextField(
                label: 'Last Name', controller: _lastNameController),
            SizedBox(height: 16),
            _buildTextField(label: 'Username', controller: _usernameController),
            SizedBox(height: 16),
            _buildTextField(
                label: 'Password',
                controller: _passwordController,
                isPassword: true),
            SizedBox(height: 24),
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
                      _scannedBarcode != null
                          ? Icons.check_circle
                          : Icons.camera_alt,
                      color: _scannedBarcode != null
                          ? Colors.green
                          : Colors.white54,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _scannedBarcode != null
                          ? 'Barcode: $_scannedBarcode'
                          : 'Scan barcode',
                      style: TextStyle(
                        color: _scannedBarcode != null
                            ? Colors.green
                            : Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
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
              onPressed: _createAccount,
              child: Text('Create Account',
                  style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
            SizedBox(height: 80), // Adjust spacing as needed
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
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
        suffixIcon: isPassword
            ? Icon(Icons.visibility_off, color: Colors.white70)
            : null,
      ),
      style: TextStyle(color: Colors.white70),
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _scannedBarcode = null;
    super.dispose();
  }
}
