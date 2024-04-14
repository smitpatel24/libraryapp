import 'package:flutter/material.dart';
import 'readers_model.dart';
import 'package:provider/provider.dart';
import 'reader.dart';

class EditReaderScreen extends StatefulWidget {
  // You might want to pass the reader's initial data here if it's being edited
  final String initialFirstName;
  final String initialLastName;
  final String initialReaderID;

  EditReaderScreen({
    Key? key,
    this.initialFirstName = "",
    this.initialLastName = "",
    this.initialReaderID = "",
  }) : super(key: key);

  @override
  _EditReaderScreenState createState() => _EditReaderScreenState();
}

class _EditReaderScreenState extends State<EditReaderScreen> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _readerIdController;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.initialFirstName);
    _lastNameController = TextEditingController(text: widget.initialLastName);
    _readerIdController = TextEditingController(text: widget.initialReaderID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF2A2A72), // AppBar background color
        elevation: 0, // Removes the shadow under the AppBar
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Edit Reader Screen',
          style: TextStyle(color: Colors.white, fontSize: 22),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.menu, color: Colors.white),
            onPressed: () {
              // Menu button action
            },
          ),
        ],
      ),
      backgroundColor: Color(0xFF2A2A72),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: _firstNameController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'First Name',
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.orange, width: 2.0),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.orange, width: 2.0),
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _lastNameController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Last Name',
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.orange, width: 2.0),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.orange, width: 2.0),
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _readerIdController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Reader ID',
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.orange, width: 2.0),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.orange, width: 2.0),
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            SizedBox(height: 24),
            // Barcode section, assuming it's just an image placeholder for now
            Center(
              child: Image.asset('assets/barcode.png'), // Your barcode asset
            ),
            SizedBox(height: 24),
            TextButton(
              onPressed: () {
                // Logic to update barcode
              },
              child: Text(
                'Update Barcode',
                style: TextStyle(color: Colors.white),
              ),
              style: TextButton.styleFrom(backgroundColor: Colors.grey),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // Create an updated reader object
                Reader updatedReader = Reader(
                  _firstNameController.text.trim(),
                  _lastNameController.text.trim(),
                  _readerIdController.text.trim(),
                );

                // Update the reader in the model
                Provider.of<ReadersModel>(context, listen: false)
                    .updateReaderById(widget.initialReaderID, updatedReader);

                // Optionally show a confirmation message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text('Reader details updated successfully')),
                );

                // Pop the current screen
                Navigator.of(context).pop();
              },
              child: Text('Update Details'),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Colors.deepPurpleAccent, // Button background color
                foregroundColor: Colors.white, // Button text color
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Confirm dialog before deletion
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Confirm'),
                      content: const Text(
                          'Are you sure you want to delete this reader?'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () =>
                              Navigator.of(context).pop(), // Dismiss dialog
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            // Get the readers model
                            final readersModel = Provider.of<ReadersModel>(
                                context,
                                listen: false);

                            // Find the reader by ID and remove it
                            readersModel
                                .removeReaderById(widget.initialReaderID);

                            // Dismiss the dialog
                            Navigator.of(context).pop();

                            // Navigate back to the reader list screen
                            Navigator.of(context).pop();
                          },
                          child: const Text('Delete'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text('Delete Reader'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,

                foregroundColor: Colors.white, // Button text color
              ),
            ),
          ],
        ),
      ),
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
