import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:libraryapp/services/supabase_manager.dart';

class AddUserPage extends StatefulWidget {
  @override
  _AddUserPageState createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  // Use singleton instance
  final SupabaseManager _supabaseManager = SupabaseManager.instance;
  
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _scannedBarcode;
  bool _isPasswordVisible = false;  // Add state for password visibility

  void _createAccount() async {
    if (!_validateInputs()) return;

    if (mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );
    }

    try {
      log('Calling createUserAsAReader...');
      await _supabaseManager.createUserAsAReader(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        username: _usernameController.text,
        password: _passwordController.text,
        barcode: _scannedBarcode!,
      );

      if (mounted) {
        Navigator.of(context).pop(); // Close loading dialog
        _clearForm();
        _showSuccessMessage('User created successfully! Form cleared for new entry.');
      }
    } catch (error) {
      if (mounted) {
        Navigator.of(context).pop(); // Close loading dialog
        _showErrorMessage('Error creating user: $error');
      }
    }
  }

  bool _validateInputs() {
    if (_firstNameController.text.isEmpty ||
        _lastNameController.text.isEmpty ||
        _usernameController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      _showErrorMessage('Please fill in all the fields');
      return false;
    }

    if (_scannedBarcode == null) {
      _showErrorMessage('Please scan a barcode first');
      return false;
    }

    return true;
  }

  void _clearForm() {
    _firstNameController.clear();
    _lastNameController.clear();
    _usernameController.clear();
    _passwordController.clear();
    setState(() {
      _scannedBarcode = null;
    });
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

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
        setState(() => _scannedBarcode = barcodeScanRes);
        _showSuccessMessage('Barcode scanned: $barcodeScanRes');
      }
    } catch (e) {
      if (!mounted) return;
      _showErrorMessage('Failed to scan barcode: ${e.toString()}');
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
            _buildTextField(label: 'First Name', controller: _firstNameController),
            SizedBox(height: 16),
            _buildTextField(label: 'Last Name', controller: _lastNameController),
            SizedBox(height: 16),
            _buildTextField(label: 'Username', controller: _usernameController),
            SizedBox(height: 16),
            _buildPasswordField(),
            SizedBox(height: 24),
            _buildBarcodeScanner(),
            SizedBox(height: 24),
            _buildCreateAccountButton(),
            SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextField(
      controller: _passwordController,
      obscureText: !_isPasswordVisible,
      decoration: InputDecoration(
        labelText: 'Password',
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
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: Colors.white70,
          ),
          onPressed: () {
            setState(() => _isPasswordVisible = !_isPasswordVisible);
          },
        ),
      ),
      style: TextStyle(color: Colors.white70),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
  }) {
    return TextField(
      controller: controller,
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
      ),
      style: TextStyle(color: Colors.white70),
    );
  }

  Widget _buildBarcodeScanner() {
    return GestureDetector(
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
              _scannedBarcode != null ? Icons.check_circle : Icons.camera_alt,
              color: _scannedBarcode != null ? Colors.green : Colors.white54,
            ),
            const SizedBox(height: 10),
            Text(
              _scannedBarcode != null ? 'Barcode: $_scannedBarcode' : 'Scan barcode',
              style: TextStyle(
                color: _scannedBarcode != null ? Colors.green : Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreateAccountButton() {
    return ElevatedButton(
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
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}