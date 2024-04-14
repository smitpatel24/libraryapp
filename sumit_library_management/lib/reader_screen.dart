

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'readers_model.dart'; // Path to your ReadersModel class
import 'edit_reader_screen.dart'; // Path to your EditReaderScreen class

class ReaderScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final readersModel = Provider.of<ReadersModel>(context);

    return Scaffold(
      backgroundColor: Color(0xFF2A2A72),
      appBar: AppBar(
        backgroundColor: Color(0xFF2A2A72),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Readers Screen',
          style: TextStyle(color: Colors.white, fontSize: 22),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: readersModel.readers.length,
              itemBuilder: (context, index) {
                final reader = readersModel.readers[index];
                // Ensure that 'reader.firstName' and 'reader.lastName' are the actual fields used in your Reader model.
                // Concatenate them to form the full name.
                String fullName = '${reader.firstName} ${reader.lastName}';
                return Card(
                  color: Color(0xFF3A3A55),
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  child: ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    title: Text(
                      fullName, // Using the full name
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      reader
                          .readerID, // Assuming 'readerID' is the field you want to display
                      style: TextStyle(color: Colors.white70),
                    ),
                    trailing: Icon(Icons.edit, color: Colors.white),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditReaderScreen(
                            initialFirstName: reader.firstName,
                            initialLastName: reader.lastName,
                            initialReaderID: reader.readerID,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
