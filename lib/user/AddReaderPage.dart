import 'package:flutter/material.dart';

class AddReaderPage extends StatefulWidget {
  @override
  _AddReaderPageState createState() => _AddReaderPageState();
}

class _AddReaderPageState extends State<AddReaderPage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _readerIDController = TextEditingController();

  void _addReader() {
    // Add reader logic will go here
  }

  void _scanBarcode() {
    // Barcode scanning logic will go here
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
            SizedBox(height: 10),
            Text(
              'Add New Reader Details',
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
            _buildTextField(
                label: 'Reader ID', controller: _readerIDController),
            SizedBox(height: 30),
            GestureDetector(
              onTap: _scanBarcode,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                decoration: BoxDecoration(
                  color: Colors.white12,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  children: [
                    Icon(Icons.camera_alt, color: Colors.white54),
                    SizedBox(height: 8),
                    Text('Scan barcode below:',
                        style: TextStyle(color: Colors.white70)),
                  ],
                ),
              ),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF615793),
                padding: EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onPressed: _addReader,
              child: Text('Add Reader', style: TextStyle(fontSize: 18)),
            ),
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
    _readerIDController.dispose();
    super.dispose();
  }
}

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Add New Reader',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AddReaderPage(),
    );
  }
}
