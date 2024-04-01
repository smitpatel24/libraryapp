import 'package:flutter/material.dart';
import 'EditReaderPage.dart'; // Assume this file exists for editing reader details

class ReaderDetailsPage extends StatefulWidget {
  @override
  _ReaderDetailsPageState createState() => _ReaderDetailsPageState();
}

class _ReaderDetailsPageState extends State<ReaderDetailsPage> {
  List<Map<String, String>> readers = [
    {'name': 'Ariel Meadows', 'details': '502804(CODE_071)'},
    {'name': 'Wayne Solomon', 'details': '332094(CODE_805)'},
    {'name': 'Mylah Martin', 'details': '263602(CODE_541)'},
    {'name': 'Mateo Crane', 'details': '634421(CODE_025)'},
  ];

  void navigateToEditReaderPage(
      BuildContext context, Map<String, String> readerDetails) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => EditReaderPage(readerDetails: readerDetails)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF32324D),
        elevation: 0,
        leading: BackButton(color: Colors.white),
      ),
      backgroundColor: Color(0xFF32324D),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(13.0),
            child: Text(
              'Reader Details',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 14),
          Expanded(
            child: ListView.builder(
              itemCount: readers.length,
              itemBuilder: (BuildContext context, int index) {
                Map<String, String> reader = readers[index];
                return Card(
                  color: Color(0xFF4A4A6A),
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: ListTile(
                    title: Text(
                      reader['name']!,
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    subtitle: Text(
                      reader['details']!,
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.edit, color: Colors.white),
                      onPressed: () =>
                          navigateToEditReaderPage(context, reader),
                    ),
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

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reader Details',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ReaderDetailsPage(),
    );
  }
}
