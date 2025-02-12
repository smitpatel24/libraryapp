import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import '../services/offline_enabled_supabase_manager.dart';

class AddBookPage extends StatefulWidget {
  @override
  _AddBookPageState createState() => _AddBookPageState();
}

enum BookAddType { newBook, existingBook }

class _AddBookPageState extends State<AddBookPage> {
  final _offlineEnabledManager = OfflineEnabledSupabaseManager();
  final TextEditingController _bookNameController = TextEditingController();
  final TextEditingController _authorNameController = TextEditingController();
  final TextEditingController _existingBookBarcodeController = TextEditingController();
  final TextEditingController _barcodeIdController = TextEditingController();
  BookAddType _selectedType = BookAddType.newBook;

  @override
  void dispose() {
    _bookNameController.dispose();
    _authorNameController.dispose();
    _existingBookBarcodeController.dispose();
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
    if (_barcodeIdController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Barcode is a required field'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_selectedType == BookAddType.existingBook && _existingBookBarcodeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Existing Book Barcode is required'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_selectedType == BookAddType.newBook && _bookNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Book Title is required for new books'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    print("Attempting to ${_selectedType == BookAddType.newBook ? 'add a new book' : 'add a copy'}");
    try {
      if (_selectedType == BookAddType.existingBook) {
        // Add a copy of existing book
        await _offlineEnabledManager.addBookCopy(
          _existingBookBarcodeController.text,  
          _barcodeIdController.text
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('New copy added successfully!'))
          );
          _clearForm();
        }
        return;
      }

      // Adding a new book
      String normalized_aname = normalizeAuthorName(_authorNameController.text);
      
      // Add new book and its first copy
      await _offlineEnabledManager.addBook(
          _bookNameController.text,
          normalized_aname,
          _barcodeIdController.text
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Book added successfully!'))
        );
        _clearForm();
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to add book: $error'))
        );
      }
    }
  }

  void _clearForm() {
    _existingBookBarcodeController.clear();
    _bookNameController.clear();
    _authorNameController.clear();
    _barcodeIdController.clear();
  }

  Future<void> _scanBarcode(TextEditingController controller) async {
    String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        "#ff6666",
        "Cancel",
        true,
        ScanMode.BARCODE
    );
    if (barcodeScanRes != "-1" && mounted) {
      setState(() {
        controller.text = barcodeScanRes;
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
              'Add Book',
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 25),
            _buildTypeSelector(),
            const SizedBox(height: 25),
            if (_selectedType == BookAddType.newBook) ...[
              _buildTextField(
                  label: 'Book Name', 
                  controller: _bookNameController,
                  isScannable: false),
              const SizedBox(height: 20),
              _buildTextField(
                  label: 'Author Name', 
                  controller: _authorNameController,
                  isScannable: false),
              const SizedBox(height: 20),
            ],
            if (_selectedType == BookAddType.existingBook)
              _buildTextField(
                  label: 'Existing Book Barcode',
                  controller: _existingBookBarcodeController,
                  isScannable: true),
            if (_selectedType == BookAddType.existingBook)
              const SizedBox(height: 20),
            _buildTextField(
                label: 'New Copy Barcode', 
                controller: _barcodeIdController,
                isScannable: true),
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
              child: Text(
                _selectedType == BookAddType.newBook ? 'Add New Book' : 'Add Copy',
                style: const TextStyle(fontSize: 18, color: Colors.white)
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SegmentedButton<BookAddType>(
        segments: const [
          ButtonSegment<BookAddType>(
            value: BookAddType.newBook,
            label: Text('New Book'),
            icon: Icon(Icons.add_box),
          ),
          ButtonSegment<BookAddType>(
            value: BookAddType.existingBook,
            label: Text('Add Copy'),
            icon: Icon(Icons.copy),
          ),
        ],
        selected: {_selectedType},
        onSelectionChanged: (Set<BookAddType> newSelection) {
          setState(() {
            _selectedType = newSelection.first;
            _clearForm();
          });
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.selected)) {
                return Colors.green;
              }
              return Colors.white24;
            },
          ),
          foregroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              return Colors.white;
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    bool isScannable = false,
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
        suffixIcon: isScannable
            ? IconButton(
                icon: const Icon(Icons.qr_code_scanner, color: Colors.white70),
                onPressed: () => _scanBarcode(controller),
              )
            : null,
      ),
      style: const TextStyle(color: Colors.white70),
    );
  }
}