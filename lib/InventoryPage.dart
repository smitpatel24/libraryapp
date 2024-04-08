import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Inventory',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: InventoryPage(),
    );
  }
}

class InventoryPage extends StatefulWidget {
  @override
  _InventoryPageState createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  final List<Map<String, String>> allItems = [
    {
      'title': "Aurora's Awakening",
      'author': 'Luna Evergreen',
      'libraryId': 'LB7834',
      'bookId': 'PR8923W6'
    },
    {
      'title': "The Great Gatsby",
      'author': 'F. Scott Fitzgerald',
      'libraryId': 'LB001',
      'bookId': 'BK001'
    },
    {
      'title': "To Kill a Mockingbird",
      'author': 'Harper Lee',
      'libraryId': 'LB002',
      'bookId': 'BK002'
    },
    {
      'title': "1984",
      'author': 'George Orwell',
      'libraryId': 'LB003',
      'bookId': 'BK003'
    },
    {
      'title': "Pride and Prejudice",
      'author': 'Jane Austen',
      'libraryId': 'LB004',
      'bookId': 'BK004'
    },
    {
      'title': "The Catcher in the Rye",
      'author': 'J.D. Salinger',
      'libraryId': 'LB005',
      'bookId': 'BK005'
    }
    // Add more books here
  ];

  List<Map<String, String>> itemsToShow = [];
  int currentPage = 0;
  final int itemsPerPage = 3; // Adjust as needed
  String searchText = '';

  @override
  void initState() {
    super.initState();
    itemsToShow = allItems;
  }

  void _searchItems(String text) {
    setState(() {
      searchText = text;
      if (text.isEmpty) {
        itemsToShow = allItems;
      } else {
        itemsToShow = allItems.where((item) {
          return item['title']!.toLowerCase().contains(text.toLowerCase()) ||
              item['author']!.toLowerCase().contains(text.toLowerCase());
        }).toList();
      }
      currentPage = 0; // Reset to the first page
    });
  }

  @override
  Widget build(BuildContext context) {
    int totalPages = (itemsToShow.length / itemsPerPage).ceil();
    List<Map<String, String>> pageItems = itemsToShow
        .skip(currentPage * itemsPerPage)
        .take(itemsPerPage)
        .toList();

    return Scaffold(
      backgroundColor: Color(0xFF32324D),
      appBar: AppBar(
        centerTitle: true, // Center the title
        title: Text(
          'Inventory', // Move the title to the app bar
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: BackButton(color: Colors.white),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(left: 24.0, right: 24.0, bottom: 80.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: 10),
            buildSearchBar(),
            SizedBox(height: 24),
            for (var item in pageItems) buildItem(item),
            if (totalPages > 1) buildPagination(totalPages),
          ],
        ),
      ),
    );
  }

  Widget buildSearchBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(1), // Adjust the opacity as needed
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 4,
            offset: Offset(0, 4), // changes position of shadow
          ),
        ],
      ),
      child: TextField(
        onChanged: _searchItems,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: "Search",
          hintStyle: TextStyle(color: Colors.black.withOpacity(0.7)),
          prefixIcon: Icon(Icons.search, color: Colors.black.withOpacity(0.7)),
          suffixIcon: IconButton(
            icon: Icon(Icons.filter_list, color: Colors.black.withOpacity(0.7)),
            onPressed: () {
              // TODO: Implement filter logic
            },
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget buildItem(Map<String, String> item) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: Color(0xFF4C4C6D), // Background color of the card
      margin: EdgeInsets.only(bottom: 16),
      elevation: 8,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              item['title']!,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(color: Colors.white),
            ),
            SizedBox(height: 4),
            Text(
              item['author']!,
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 16),
            Text(
              'Library ID: ${item['libraryId']}',
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 4),
            Text(
              'Book ID: ${item['bookId']}',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPagination(int totalPages) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(top: 20),
      child: Wrap(
        children: [
          IconButton(
            icon: Icon(Icons.chevron_left,
                color: currentPage > 0 ? Colors.white : Colors.grey),
            onPressed:
                currentPage > 0 ? () => setState(() => currentPage--) : null,
          ),
          ...List.generate(totalPages, (index) {
            return GestureDetector(
              onTap: () => setState(() => currentPage = index),
              child: Container(
                padding: EdgeInsets.all(8),
                margin: EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: currentPage == index
                      ? Colors.black.withOpacity(0.5)
                      : Colors.white24,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '${index + 1}',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            );
          }),
          IconButton(
            icon: Icon(Icons.chevron_right,
                color:
                    currentPage < totalPages - 1 ? Colors.white : Colors.grey),
            onPressed: currentPage < totalPages - 1
                ? () => setState(() => currentPage++)
                : null,
          ),
        ],
      ),
    );
  }
}
