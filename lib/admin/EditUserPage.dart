import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:libraryapp/models/user_dto.dart';
import 'package:libraryapp/services/offline_enabled_supabase_manager.dart';
import 'package:libraryapp/services/supabase_manager.dart';

class EditUserPage extends StatefulWidget {
  final UserDTO user;
  final bool isLibrarian;
  final bool isSelf;

  const EditUserPage(
      {super.key,
      required this.user,
      this.isLibrarian = false,
      this.isSelf = false});

  @override
  _EditUserPageState createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
  final OfflineEnabledSupabaseManager _offlineEnabledManager =
      OfflineEnabledSupabaseManager();

  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _barcodeController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;
  bool _isLoading = false;
  String? _error;
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    // Use User model properties
    _firstNameController = TextEditingController(text: widget.user.firstname);
    _lastNameController = TextEditingController(text: widget.user.lastname);
    _barcodeController = TextEditingController(text: widget.user.barcode);
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    log('User details initialized: ${widget.user}');
  }

  Future<void> _updateUserDetails() async {
    if (!_validateInputs()) return;

    setState(() => _isLoading = true);

    try {
      await _offlineEnabledManager.updateUser(
        userId: widget.user.id,
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

  Future<void> _updatePassword() async {
    if (!_validatePasswordInputs()) return;

    setState(() => _isLoading = true);

    try {
      await _offlineEnabledManager.setUserPassword(
        userId: widget.user.id,
        userPassword: _passwordController.text,
      );

      if (mounted) {
        _showSuccessMessage('Password updated successfully!');
        Navigator.of(context).pop(); // Return to previous screen
      }
    } catch (error) {
      setState(() => _error = error.toString());
      _showErrorMessage('Error updating password: $error');
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
      _showErrorMessage('Please fill in all the required fields');
      return false;
    }

    return true;
  }

  bool _validatePasswordInputs() {
    if (_passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      _showErrorMessage('Please fill in all the required fields');
      return false;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      _showErrorMessage('Passwords do not match');
      return false;
    }

    if (_passwordController.text.length < 6) {
      _showErrorMessage('Password must be at least 6 characters long');
      return false;
    }

    return true;
  }

  Future<void> _resetLibrarianPassword() async {
    // Show confirmation dialog
    final bool? shouldReset = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF32324D),
          title: Text(
            'Reset Password',
            style: TextStyle(color: Colors.white),
          ),
          content: RichText(
            text: TextSpan(
              style: TextStyle(color: Colors.white70),
              children: [
                TextSpan(
                  text: 'The password will be reset to: ',
                ),
                TextSpan(
                  text: 'password',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Cancel', style: TextStyle(color: Colors.white70)),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(
                backgroundColor: Color(0xFF615793),
              ),
              child: Text('Reset', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );

    if (shouldReset != true) return;

    setState(() => _isLoading = true);

    try {
      await _offlineEnabledManager.setUserPassword(
        userId: widget.user.id,
        userPassword: 'password',
      );

      if (mounted) {
        _showSuccessMessage('Password reset successfully');
      }
    } catch (error) {
      setState(() => _error = error.toString());
      _showErrorMessage('Error resetting password: $error');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
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
          children: <Widget>[
            SizedBox(height: 20),
            Text(
              'Editing ${widget.isLibrarian ? "Librarian" : "Reader"} ID: ${widget.user.id}',
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
            ),
            SizedBox(height: 16),
            ..._passwordTextField(),
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
            _updateDetailsButton(),
            ..._updatePasswordButton(),
            ..._resetPasswordButton(),
            ..._deleteUserButton(),
          ],
        ),
      ),
    );
  }

  List<Widget> _passwordTextField() {
    if (widget.isLibrarian && widget.isSelf) {
      return [
        _buildTextField(
          label: 'New Password',
          controller: _passwordController,
          isPassword: true,
        ),
        SizedBox(height: 16),
        _buildTextField(
          label: 'Confirm Password',
          controller: _confirmPasswordController,
          isPassword: true,
        ),
        SizedBox(height: 24),
      ];
    }
    return [];
  }

  ElevatedButton _updateDetailsButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF615793),
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      onPressed: _isLoading ? null : _updateUserDetails,
      child: _isLoading
          ? SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                strokeWidth: 2,
              ),
            )
          : Text('Update Details'),
    );
  }

  List<Widget> _updatePasswordButton() {
    if (widget.isLibrarian && widget.isSelf) {
      return [
        SizedBox(height: 16),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF935793),
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          onPressed: _isLoading ? null : _updatePassword,
          child: Text('Update Password'),
        ),
      ];
    } else {
      return [];
    }
  }

  List<Widget> _resetPasswordButton() {
    if (widget.isLibrarian && !widget.isSelf) {
      return [
        SizedBox(height: 16),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF935793),
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          onPressed: _isLoading ? null : _resetLibrarianPassword,
          child: Text('Reset Password to Default'),
        ),
      ];
    }
    return [];
  }

  List<Widget> _deleteUserButton() {
    if (!widget.isSelf) {
      return [
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
          child: Text('Delete User'),
        ),
      ];
    }
    return [];
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    bool isPassword = false,
    bool isPasswordVisible = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword && !isPasswordVisible,
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
            ? IconButton(
                icon: Icon(
                  _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.white70,
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              )
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
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
