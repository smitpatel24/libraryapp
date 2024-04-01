import 'package:flutter/material.dart';

class EditUserPage extends StatefulWidget {
  final Map<String, String> userDetails;

  EditUserPage({Key? key, required this.userDetails}) : super(key: key);

  @override
  _EditUserPageState createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _detailsController;

  @override
  void initState() {
    super.initState();
    _firstNameController =
        TextEditingController(text: widget.userDetails['firstName']);
    _lastNameController =
        TextEditingController(text: widget.userDetails['lastName']);
    _detailsController =
        TextEditingController(text: widget.userDetails['details']);
  }

  void _updateDetails() {
    // Logic to update user details goes here
  }

  void _updateBarcode() {
    // Logic to scan and update the barcode goes here
  }

  void _deleteUser() {
    // Logic to delete user goes here
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
              'Edit User Details',
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
            _buildTextField(label: 'User ID', controller: _detailsController),
            SizedBox(height: 24),
            GestureDetector(
              onTap: _updateBarcode,
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
                    Text('Update barcode',
                        style: TextStyle(color: Colors.white70)),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF615793),
                padding: EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onPressed: _updateDetails,
              child: Text('Update Details', style: TextStyle(fontSize: 18)),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Color(0xAA935757),
                padding: EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onPressed: _deleteUser,
              child: Text('Delete User', style: TextStyle(fontSize: 18)),
            ),
            SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      {required String label, required TextEditingController controller}) {
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

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _detailsController.dispose();
    super.dispose();
  }
}
