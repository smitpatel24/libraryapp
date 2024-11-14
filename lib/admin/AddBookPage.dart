import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import '../services/supabase_manager.dart';

class AddBookPage extends StatefulWidget {
  @override
  _AddBookPageState createState() => _AddBookPageState();
}

class _AddBookPageState extends State<AddBookPage> {
  final TextEditingController _bookNameController = TextEditingController();
  final TextEditingController _authorNameController = TextEditingController();
  final TextEditingController _bookIdController = TextEditingController();
  final TextEditingController _barcodeIdController = TextEditingController();

  @override
  void dispose() {
    _bookNameController.dispose();
    _authorNameController.dispose();
    _bookIdController.dispose();
    _barcodeIdController.dispose();
    super.dispose();
  }

  String normalizeAuthorName(String authorName) {
    String normalized = authorName.toLowerCase();
    normalized = normalized.replaceAll(RegExp(r'[^\w\s]'), '');
    normalized = normalized.trim();
    return normalized;
  }

  void _addBook() async {
    // Validate required fields first
    if (_bookIdController.text.isEmpty ||
        _bookNameController.text.isEmpty ||
        _barcodeIdController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Book ID, Book Title, and Barcode are required fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    print("Attempting to add a book");
    try {
      String normalized_aname = normalizeAuthorName(_authorNameController.text);
      int? authorId = await SupabaseManager().ensureAuthorExists(normalized_aname, int.parse(_bookIdController.text));
      
      if (authorId == -1) {
        // Book already exists, so let's add a copy instead
        try {
          await SupabaseManager().addBookCopy(
            _bookIdController.text,  
            _barcodeIdController.text
          );
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('New copy added successfully!'))
            );
            _bookIdController.clear();
            _bookNameController.clear();
            _authorNameController.clear();
            _barcodeIdController.clear();
          }
        } catch (copyError) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed to add book copy'))
            );
          }
        }
        return;
      }

      if (authorId == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Author could not be verified or added.'))
          );
        }
        return;
      }

      // Add new book and its first copy
      await SupabaseManager().addBook(
          _bookIdController.text,
          _bookNameController.text,
          authorId,
          _barcodeIdController.text
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Book added successfully!'))
        );
        _bookIdController.clear();
        _bookNameController.clear();
        _authorNameController.clear();
        _barcodeIdController.clear();
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to add book: $error'))
        );
      }
    }
  }

  Future<void> _scanBarcode() async {
    String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        "#ff6666",
        "Cancel",
        true,
        ScanMode.BARCODE
    );
    if (barcodeScanRes != "-1" && mounted) {
      setState(() {
        _barcodeIdController.text = barcodeScanRes;
      });
    }
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
            const SizedBox(height: 20),
            _buildTextField(label: 'Barcode ID', controller: _barcodeIdController),
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF615793),
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onPressed: _scanBarcode,
              child: const Text('Scan Barcode',
                  style: TextStyle(fontSize: 18, color: Colors.white)),
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
}