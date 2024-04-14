import 'system_status_header.dart';
import 'reader_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'reader.dart';
import 'readers_model.dart';

class AddNewReaderDetailsPage extends StatefulWidget {
  @override
  _AddNewReaderDetailsPageState createState() =>
      _AddNewReaderDetailsPageState();
}

class _AddNewReaderDetailsPageState extends State<AddNewReaderDetailsPage> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController readerIdController = TextEditingController();
  OutlineInputBorder _outlineInputBorder() {
    return OutlineInputBorder(
      borderSide: BorderSide(color: Colors.orange, width: 2),
      borderRadius: BorderRadius.circular(20),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2A2A72),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SystemStatusHeader(), // This will show the header with time, network, and battery
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              Text(
                "Add New Reader Details",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 28),
              TextField(
                controller: firstNameController,
                style: TextStyle(color: Colors.white),
                cursorColor: Colors.orange,
                decoration: InputDecoration(
                  labelText: 'First Name',
                  labelStyle: TextStyle(color: Colors.white54),
                  enabledBorder: _outlineInputBorder(),
                  focusedBorder: _outlineInputBorder(),
                ),
              ),
              SizedBox(height: 24),
              TextField(
                controller: lastNameController,
                style: TextStyle(color: Colors.white),
                cursorColor: Colors.orange,
                decoration: InputDecoration(
                  labelText: 'Last Name',
                  labelStyle: TextStyle(color: Colors.white54),
                  enabledBorder: _outlineInputBorder(),
                  focusedBorder: _outlineInputBorder(),
                ),
              ),
              SizedBox(height: 24),
              TextField(
                controller: readerIdController,
                style: TextStyle(color: Colors.white),
                cursorColor: Colors.orange,
                decoration: InputDecoration(
                  labelText: 'Reader ID',
                  labelStyle: TextStyle(color: Colors.white54),
                  enabledBorder: _outlineInputBorder(),
                  focusedBorder: _outlineInputBorder(),
                ),
              ),
              SizedBox(height: 32),
              // Add the barcode scanner and button here, following a similar style to the 'LoginPage'
              Text(
                'Scan barcode below:',
                style: TextStyle(color: Colors.white, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              Image.asset('assets/barcode.png',
                  height: 100), // Make sure this asset exists in your project
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  final String firstName = firstNameController.text.trim();
                  final String lastName = lastNameController.text.trim();
                  final String readerId = readerIdController.text.trim();
                  // Debug the input
                  // print('First Name: $firstName');
                  // print('Last Name: $lastName');
                  // print('Reader ID: $readerId');
                  // if (firstName.isEmpty ||
                  //     lastName.isEmpty ||
                  //     readerId.isEmpty) {
                  //   ScaffoldMessenger.of(context).showSnackBar(
                  //     SnackBar(content: Text('Please fill in all fields')),
                  //   );
                  // }
                  if (firstName.isNotEmpty &&
                      lastName.isNotEmpty &&
                      readerId.isNotEmpty) {
                    // Create a new Reader object
                    final newReader = Reader(firstName, lastName, readerId);
                    // final newReader = Reader("$firstName $lastName", readerId);

                    // Add the reader to the ReadersModel
                    Provider.of<ReadersModel>(context, listen: false)
                        .addReader(newReader);

                    // Navigate to ReaderScreen
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ReaderScreen()),
                    );
                  } else {
                    // Optionally show a message if the input fields are empty
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please fill in all fields')),
                    );
                  }
                },
                child: Text('Add Reader'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent,
                  foregroundColor: Colors.white, // Button text color
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Dispose controllers when the widget is removed from the widget tree
    firstNameController.dispose();
    lastNameController.dispose();
    readerIdController.dispose();
    super.dispose();
  }
}
