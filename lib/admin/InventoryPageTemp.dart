import 'package:flutter/material.dart';
import '../services/supabase_manager.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Overdue Inventory',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: InventoryPage(),
    );
  }
}

class InventoryPage extends StatelessWidget {
  final List<Map<String, String>> items = [
    {
      'title': "Aurora's Awakening",
      'author': 'By Luna Evergreen',
      'libraryId': 'LB7834',
      'bookId': 'PR8923W6'
    },{
      'title': "Aurora's Awakening",
      'author': 'By Luna Evergreen',
      'libraryId': 'LB7834',
      'bookId': 'PR8923W6'
    },{
      'title': "Aurora's Awakening",
      'author': 'By Luna Evergreen',
      'libraryId': 'LB7834',
      'bookId': 'PR8923W6'
    },{
      'title': "Aurora's Awakening",
      'author': 'By Luna Evergreen',
      'libraryId': 'LB7834',
      'bookId': 'PR8923W6'
    }
    // ... Other items
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF32324D),
      appBar: AppBar(
        leading: BackButton(color: Colors.white),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          buildScrollView(context),
          buildPagination(),
        ],
      ),
    );
  }

  Widget buildScrollView(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(left: 24.0, right: 24.0, bottom: 80.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(height: 10),
          buildTitle(),
          SizedBox(height: 20),
          buildSearchBar(),
          SizedBox(height: 24),
          buildItemList(),
        ],
      ),
    );
  }

  Widget buildTitle() {
    return Text(
      'Inventory',
      style: TextStyle(
        fontSize: 24,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget buildSearchBar() {
    return Row(
      children: <Widget>[
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 10.0),
              hintText: "Search",
              hintStyle: TextStyle(color: Colors.grey),
              prefixIcon: Icon(Icons.search, color: Colors.grey),
              fillColor: Color(0xFFFFFFFF),
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            style: TextStyle(color: Colors.black),
          ),
        ),
        SizedBox(width: 10),
        Icon(Icons.filter_list, color: Colors.white),
      ],
    );
  }

  Widget buildItemList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: items.map((item) => buildItem(item)).toList(),
    );
  }

  Widget buildItem(Map<String, String> item) {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Color(0xFF4C4C6D),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            item['title']!,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 8),
          Text(
            item['author']!,
            style: TextStyle(color: Colors.white70),
          ),
          SizedBox(height: 16),
          Text(
            'Library ID: ${item['libraryId']}',
            style: TextStyle(color: Colors.white70),
          ),
          SizedBox(height: 4),
          Text(
            'Book ID: ${item['bookId']}',
            style: TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget buildPagination() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 16,
      child: Center(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 36),
          // decoration: BoxDecoration(
          //   color: Color(0xFF4C4C6D),
          //   borderRadius: BorderRadius.circular(20),
          // ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              PaginationButton(iconData: Icons.chevron_left, isSelected: false),
              PaginationButton(text: '1', isSelected: true),
              PaginationButton(text: '2', isSelected: false),
              Text('...', style: TextStyle(color: Colors.white54)),
              PaginationButton(text: '9', isSelected: false),
              PaginationButton(text: '10', isSelected: false),
              PaginationButton(iconData: Icons.chevron_right, isSelected: false),
            ],
          ),
        ),
      ),
    );
  }
}

class PaginationButton extends StatelessWidget {
  final String? text;
  final IconData? iconData;
  final bool isSelected;

  const PaginationButton({
    Key? key,
    this.text,
    this.iconData,
    this.isSelected = false,
  })  : assert(text != null || iconData != null, 'Either text or iconData must be provided'),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      margin: EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: isSelected ? Colors.white : Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: Colors.white54,
        ),
      ),
      child: Center(
        child: text != null
            ? Text(
          text!,
          style: TextStyle(
            color: isSelected ? Colors.blue : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        )
            : Icon(iconData, color: Colors.black),
      ),
    );
  }
}
