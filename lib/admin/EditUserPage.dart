import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:libraryapp/models/reader.dart';
import 'package:libraryapp/services/offline_enabled_supabase_manager.dart';
import 'package:libraryapp/services/supabase_manager.dart';

class EditUserPage extends StatefulWidget {
  final Reader user;

  const EditUserPage({super.key, required this.user});

  @override
  _EditUserPageState createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
  final OfflineEnabledSupabaseManager _offlineEnabledManager = OfflineEnabledSupabaseManager();

  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _barcodeController;
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    // Use Reader model properties
    _firstNameController = TextEditingController(text: widget.user.firstname);
    _lastNameController = TextEditingController(text: widget.user.lastname);
    _barcodeController = TextEditingController(text: widget.user.barcode);
    log('User details initialized: ${widget.user}');
  }

  Future<void> _updateDetails() async {
    if (!_validateInputs()) return;

    setState(() => _isLoading = true);

    try {
      await _offlineEnabledManager.updateReader(
        readerId: widget.user.id,
        firstname: _firstNameController.text,
        lastname: _lastNameController.text,
        barcode: _barcodeController.text,
      );

      if (mounted) {
        _showSuccessMessage('User details updated successfully!');
        Navigator.of(context).pop(); // Return to previous screen
      }
    } catch (error) {
      setState(() => _error = error.toString());
      _showErrorMessage('Error updating user: $error');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  bool _validateInputs() {
    if (_firstNameController.text.isEmpty ||
        _lastNameController.text.isEmpty ||
        _barcodeController.text.isEmpty) {
      _showErrorMessage('Please fill in all the fields');
      return false;
    }
    return true;
  }

  Future<void> _scanBarcode() async {
    try {
      final barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        '#615793', // Purple color for scan line
        'Cancel',
        true,
        ScanMode.BARCODE,
      );

      if (!mounted) return;

      if (barcodeScanRes != '-1') {
        setState(() => _barcodeController.text = barcodeScanRes);
        _showSuccessMessage('Barcode scanned: $barcodeScanRes');
      }
    } catch (e) {
      if (!mounted) return;
      _showErrorMessage('Failed to scan barcode: ${e.toString()}');
    }
  }

  Future<void> _deleteUser() async {
    // Show confirmation dialog
    final bool? shouldDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF32324D),
          title: Text(
            'Confirm Delete',
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            'Are you sure you want to delete this user? This action cannot be undone.',
            style: TextStyle(color: Colors.white70),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.white70),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(
                backgroundColor: Color(0xFF935757),
              ),
              child: Text(
                'Delete',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );

    // If user cancels, return early
    if (shouldDelete != true) return;

    // Show loading state
    setState(() => _isLoading = true);

    try {
      // Call delete API
      await _offlineEnabledManager.deleteReader(widget.user.id);

      if (mounted) {
        // Show success message
        _showSuccessMessage('User deleted successfully');
        // Pop twice to go back to the user list
        Navigator.of(context)
          ..pop() // Pop the current page
          ..pop(); // Pop the previous page to refresh the list
      }
    } catch (error) {
      if (mounted) {
        setState(() => _error = error.toString());
        _showErrorMessage('Error deleting user: $error');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF32324D),
      appBar: AppBar(
        leading: BackButton(color: Colors.white),
        title: Text('Edit User Details', style: TextStyle(color: Colors.white)),
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
              'Editing UserID: ${widget.user.id}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.left,
            ),
            SizedBox(height: 24),
            _buildTextField(
              label: 'First Name',
              controller: _firstNameController,
            ),
            SizedBox(height: 16),
            _buildTextField(
              label: 'Last Name',
              controller: _lastNameController,
            ),
            SizedBox(height: 16),
            _buildTextField(
              label: 'User Barcode',
              controller: _barcodeController,
              isPassword: false,
            ),
            SizedBox(height: 24),
            GestureDetector(
              onTap: _scanBarcode,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 15.0),
                decoration: BoxDecoration(
                  color: Colors.white12,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  children: [
                    Icon(Icons.camera_alt, color: Colors.white54),
                    SizedBox(height: 10),
                    Text(
                      'Update barcode',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF615793),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onPressed: _updateDetails,
              child: Text('Update Details'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF935757),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onPressed: _isLoading ? null : _deleteUser,
              child: _isLoading
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 2,
                      ),
                    )
                  : Text('Delete User'),
            ),
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
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.orange, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.orange, width: 2.0),
        ),
        suffixIcon: isPassword
            ? const Icon(Icons.visibility_off, color: Colors.white70)
            : null,
      ),
      style: TextStyle(color: Colors.white70),
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _barcodeController.dispose();
    super.dispose();
  }
}
