import 'package:flutter/material.dart';
import '../services/supabase_manager.dart';

class EditBookPage extends StatefulWidget {
  final Map<String, String> bookDetails;

  EditBookPage({Key? key, required this.bookDetails}) : super(key: key);

  @override
  _EditBookPageState createState() => _EditBookPageState();
}

class _EditBookPageState extends State<EditBookPage> {
  late final TextEditingController _bookNameController;
  late final TextEditingController _authorNameController;
  late final TextEditingController _bookIdController;

  @override
  void initState() {
    super.initState();
    _bookNameController =
        TextEditingController(text: widget.bookDetails['title']);
    _authorNameController =
        TextEditingController(text: widget.bookDetails['author']);
    _bookIdController =
        TextEditingController(text: widget.bookDetails['bookId']);
  }

  void _updateBookDetails() async {
    String bookId = _bookIdController.text;
    String bookName = _bookNameController.text;
    String authorName = _authorNameController.text;

    SupabaseManager supabaseManager = SupabaseManager();
    await supabaseManager.updateBookDetails(bookId, bookName, authorName);

    // Show a success message and navigate back
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Book details updated successfully')),
    );
    Navigator.of(context).pop();
  }

  void _updateBarcode() {
    // Logic to scan and update the barcode goes here
  }

  void _deleteBook() {
    // Logic to delete the book goes here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF32324D),
      appBar: AppBar(
        leading: BackButton(color: Colors.white),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Edit Book', style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _buildTextField(
              label: 'Book Name',
              controller: _bookNameController,
              isPassword: false,
            ),
            SizedBox(height: 20),
            _buildTextField(
              label: 'Author Name',
              controller: _authorNameController,
              isPassword: false,
            ),
            SizedBox(height: 20),
            _buildTextField(
              label: 'Book ID',
              controller: _bookIdController,
              isPassword: false,
              readOnly: true, // Make the book ID field read-only
            ),
            SizedBox(height: 30),
            InkWell(
              onTap: _updateBarcode,
              child: Container(
                padding: EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  color: Colors.white12,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  children: [
                    Icon(Icons.camera_alt, color: Colors.white54),
                    Text('Update barcode',
                        style: TextStyle(color: Colors.white70)),
                    Text('315468951018784',
                        style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF615793),
                padding: EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                foregroundColor: Colors.white,
              ),
              onPressed: _updateBookDetails,
              child: Text('Update Book', style: TextStyle(fontSize: 18)),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF935757),
                padding: EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                foregroundColor: Colors.white,
              ),
              onPressed: _deleteBook,
              child: Text('Delete Book', style: TextStyle(fontSize: 18)),
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
    bool readOnly = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      readOnly: readOnly,
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
            ? Icon(Icons.visibility_off, color: Colors.white70)
            : null,
      ),
      style: TextStyle(color: Colors.white70),
    );
  }

  @override
  void dispose() {
    _bookNameController.dispose();
    _authorNameController.dispose();
    _bookIdController.dispose();
    super.dispose();
  }
}

void main() => runApp(MaterialApp(
  home: EditBookPage(bookDetails: {
    'title': 'Sample Book',
    'author': 'Author Name',
    'bookId': '123456',
  }),
));
