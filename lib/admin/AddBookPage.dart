// ignore_for_file: file_names

import 'package:flutter/material.dart';
import '../services/supabase_manager.dart';  // Ensure this import points to your SupabaseManager class correctly

class AddBookPage extends StatefulWidget {
  @override
  _AddBookPageState createState() => _AddBookPageState();
}

class _AddBookPageState extends State<AddBookPage> {
  final TextEditingController _bookNameController = TextEditingController();
  final TextEditingController _authorNameController = TextEditingController();
  final TextEditingController _bookIdController = TextEditingController();

  // Begin - Logic to add a book with author handling

  String normalizeAuthorName(String authorName) {
    // Convert to lower case
    String normalized = authorName.toLowerCase();

    // Remove all non-alphanumeric characters except spaces
    normalized = normalized.replaceAll(RegExp(r'[^\w\s]'), '');

    // Trim leading and trailing spaces
    normalized = normalized.trim();

    return normalized;
  }

  void _addBook() async {
    print("Attempting to add a book");
    try {
      String normalized_aname = normalizeAuthorName(_authorNameController.text);
      int? authorId = await SupabaseManager().ensureAuthorExists(normalized_aname, int.parse(_bookIdController.text));
      if (authorId == -1) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Book ID already exists. Please try again.'))
        );
        return;
      }
      if (authorId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Author could not be verified or added.'))
        );
        return;
      }
      await SupabaseManager().addBook(
          _bookIdController.text,
          _bookNameController.text,
          authorId
      );
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Book added successfully!'))
      );
      _bookIdController.clear();
      _bookNameController.clear();
      _authorNameController.clear();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add book: $error'))
      );
    }
  }
  // End - Logic to add a book with author handling

  void _scanBarcode() {
    // Logic to scan a barcode goes here
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
              'Add New Book',
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 25),
            _buildTextField(
                label: 'Book Name', controller: _bookNameController),
            const SizedBox(height: 20),
            _buildTextField(
                label: 'Author Name', controller: _authorNameController),
            const SizedBox(height: 20),
            _buildTextField(label: 'Book ID', controller: _bookIdController),
            const SizedBox(height: 30),
            InkWell(
              onTap: _scanBarcode,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                decoration: BoxDecoration(
                  color: Colors.white12,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.camera_alt, color: Colors.white54),
                    Text('Scan barcode below:',
                        style: TextStyle(color: Colors.white70)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF615793),
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onPressed: _addBook,
              child: const Text('Add Book',
                  style: TextStyle(fontSize: 18, color: Colors.white)),
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
      ),
      style: const TextStyle(color: Colors.white70),
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

void main() => runApp(MaterialApp(home: AddBookPage()));
