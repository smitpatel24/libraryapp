import 'package:flutter/material.dart';

class EditReaderPage extends StatefulWidget {
  final Map<String, String> readerDetails;

  EditReaderPage({Key? key, required this.readerDetails}) : super(key: key);

  @override
  _EditReaderPageState createState() => _EditReaderPageState();
}

class _EditReaderPageState extends State<EditReaderPage> {
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _readerIdController;

  @override
  void initState() {
    super.initState();
    _firstNameController =
        TextEditingController(text: widget.readerDetails['firstName']);
    _lastNameController =
        TextEditingController(text: widget.readerDetails['lastName']);
    _readerIdController =
        TextEditingController(text: widget.readerDetails['readerID']);
  }

  void _updateDetails() {
    // Logic to update reader details goes here
  }

  void _updateBarcode() {
    // Logic to scan and update the barcode goes here
  }

  void _deleteReader() {
    // Logic to delete reader goes here
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
        padding: EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Edit Reader Details',
              style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24),
            _buildTextField(
                label: 'First Name', controller: _firstNameController),
            SizedBox(height: 16),
            _buildTextField(
                label: 'Last Name', controller: _lastNameController),
            SizedBox(height: 16),
            _buildTextField(
                label: 'Reader ID', controller: _readerIdController),
            SizedBox(height: 24),
            _buildBarcodeContainer(),
            SizedBox(height: 24),
            _buildUpdateButton('Update Details', _updateDetails),
            SizedBox(height: 16),
            _buildUpdateButton(
                'Delete Reader', _deleteReader, Color(0xAA935757)),
            SizedBox(height: 80),
          ],
        ),
      ),
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
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white24),
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.orange, width: 2),
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      style: TextStyle(color: Colors.white70),
    );
  }

  Widget _buildBarcodeContainer() {
    return InkWell(
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
            Text('Update barcode', style: TextStyle(color: Colors.white70)),
            // Placeholder barcode
            Text('315468951018784', style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }

  Widget _buildUpdateButton(String text, VoidCallback onPressed,
      [Color? color]) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: color ?? Color(0xFF615793),
        padding: EdgeInsets.symmetric(vertical: 16.0),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
      onPressed: onPressed,
      child: Text(text, style: TextStyle(fontSize: 18)),
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _readerIdController.dispose();
    super.dispose();
  }
}
