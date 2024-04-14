import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'readers_model.dart';
import 'sankofa_page.dart'; 
import 'package:sumit_library_management/add_new_reader_details.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ReadersModel(),
      child: MaterialApp(
        title: 'Readers App',
        // home: SankofaPage(),
        home: AddNewReaderDetailsPage(),
      ),
    );
  }
}
