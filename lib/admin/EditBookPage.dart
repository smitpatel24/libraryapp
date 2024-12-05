import 'package:flutter/material.dart';
import '../services/supabase_manager.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

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
  List<Map<String, dynamic>> bookCopies = [];
  int currentPage = 0;
  final int itemsPerPage = 5;

  @override
  void initState() {
    super.initState();
    _bookNameController =
        TextEditingController(text: widget.bookDetails['title']);
    _authorNameController =
        TextEditingController(text: widget.bookDetails['author']);
    _bookIdController =
        TextEditingController(text: widget.bookDetails['bookId']);
    _loadBookCopies();
  }

  Future<void> _loadBookCopies() async {
    try {
      SupabaseManager supabaseManager = SupabaseManager();
      final copies = await supabaseManager.fetchBookCopies(int.parse(widget.bookDetails['bookId']!));
      setState(() {
        bookCopies = copies;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load book copies: ${e.toString()}')),
      );
    }
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

  Future<void> _scanBarcode(TextEditingController barcodeController) async {
    try {
      String barcode = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancel',
        true,
        ScanMode.BARCODE,
      );
      if (barcode != '-1') {
        barcodeController.text = barcode;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to scan barcode: ${e.toString()}')),
      );
    }
  }

  void _showEditCopyDialog(Map<String, dynamic> copy) {
    final TextEditingController barcodeController = TextEditingController(text: copy['barcode']);
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF32324D),
          title: Text('Edit Copy', style: TextStyle(color: Colors.white)),
          content: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  enabled: false,
                  decoration: InputDecoration(
                    labelText: 'Copy ID',
                    labelStyle: TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: Colors.white24,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange, width: 1.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange, width: 2.0),
                    ),
                  ),
                  controller: TextEditingController(text: copy['copyid'].toString()),
                  style: TextStyle(color: Colors.white70),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: barcodeController,
                  decoration: InputDecoration(
                    labelText: 'Barcode',
                    labelStyle: TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: Colors.white24,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange, width: 1.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange, width: 2.0),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.qr_code_scanner, color: Colors.white),
                      onPressed: () => _scanBarcode(barcodeController),
                    ),
                  ),
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Delete', style: TextStyle(color: Colors.red)),
              onPressed: () async {
                final bool confirm = await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: Color(0xFF32324D),
                      title: Text('Confirm Delete', style: TextStyle(color: Colors.white)),
                      content: Text('Are you sure you want to delete this copy?', 
                        style: TextStyle(color: Colors.white)),
                      actions: [
                        TextButton(
                          child: Text('Cancel'),
                          onPressed: () => Navigator.of(context).pop(false),
                        ),
                        TextButton(
                          child: Text('Delete', style: TextStyle(color: Colors.red)),
                          onPressed: () => Navigator.of(context).pop(true),
                        ),
                      ],
                    );
                  },
                ) ?? false;

                if (confirm) {
                  try {
                    SupabaseManager supabaseManager = SupabaseManager();
                    await supabaseManager.deleteBookCopy(copy['copyid']);
                    Navigator.of(context).pop();
                    _loadBookCopies();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Copy deleted successfully')),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to delete copy: ${e.toString()}')),
                    );
                  }
                }
              },
            ),
            TextButton(
              child: Text('Update'),
              onPressed: () async {
                try {
                  SupabaseManager supabaseManager = SupabaseManager();
                  await supabaseManager.updateBookCopyBarcode(
                    copy['copyid'],
                    barcodeController.text,
                  );
                  Navigator.of(context).pop();
                  _loadBookCopies();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Copy updated successfully')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to update copy: ${e.toString()}')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  List<Map<String, dynamic>> getCurrentPageCopies() {
    final startIndex = currentPage * itemsPerPage;
    final endIndex = startIndex + itemsPerPage;
    return bookCopies.sublist(startIndex, endIndex.clamp(0, bookCopies.length));
  }

  Widget buildPagination() {
    final totalPages = (bookCopies.length / itemsPerPage).ceil();
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(Icons.chevron_left, color: currentPage > 0 ? Colors.white : Colors.grey),
            onPressed: currentPage > 0 ? () => setState(() => currentPage--) : null,
          ),
          Text(
            '${currentPage + 1} / $totalPages',
            style: TextStyle(color: Colors.white),
          ),
          IconButton(
            icon: Icon(Icons.chevron_right, color: currentPage < totalPages - 1 ? Colors.white : Colors.grey),
            onPressed: currentPage < totalPages - 1 ? () => setState(() => currentPage++) : null,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentPageCopies = getCurrentPageCopies();
    
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
              readOnly: true,
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
            SizedBox(height: 30),
            Text(
              'Book Copies',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold
              ),
            ),
            SizedBox(height: 16),
            ...currentPageCopies.map((copy) => Card(
              margin: EdgeInsets.only(bottom: 8),
              color: Colors.white24,
              child: ListTile(
                title: Text(
                  'Copy ID: ${copy['copyid']}',
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Barcode: ${copy['barcode'] ?? 'N/A'}',
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      'Status: ${copy['available'] ? 'Available' : 'Checked Out'}',
                      style: TextStyle(
                        color: copy['available'] ? Colors.green : Colors.red
                      ),
                    ),
                  ],
                ),
                trailing: IconButton(
                  icon: Icon(Icons.edit, color: Colors.white),
                  onPressed: () => _showEditCopyDialog(copy),
                ),
              ),
            )).toList(),
            if (bookCopies.isNotEmpty) buildPagination(),
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
