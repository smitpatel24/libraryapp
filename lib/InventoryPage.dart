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
  final List<Map<String, dynamic>> allItems = [
    {
      'title': "Aurora's Awakening",
      'author': 'Luna Evergreen',
      'libraryId': 'LB7834',
      'bookId': 'PR8923W6',
      'availability': 5
    },
    {
      'title': "The Great Gatsby",
      'author': 'F. Scott Fitzgerald',
      'libraryId': 'LB001',
      'bookId': 'BK001',
      'availability': 3
    },
    {
      'title': "To Kill a Mockingbird",
      'author': 'Harper Lee',
      'libraryId': 'LB002',
      'bookId': 'BK002',
      'availability': 2
    },
    {
      'title': "1984",
      'author': 'George Orwell',
      'libraryId': 'LB003',
      'bookId': 'BK003',
      'availability': 4
    },
    {
      'title': "Pride and Prejudice",
      'author': 'Jane Austen',
      'libraryId': 'LB004',
      'bookId': 'BK004',
      'availability': 1
    },
    {
      'title': "The Catcher in the Rye",
      'author': 'J.D. Salinger',
      'libraryId': 'LB005',
      'bookId': 'BK005',
      'availability': 8
    },
    {
      'title': "Moby Dick",
      'author': 'Herman Melville',
      'libraryId': 'LB006',
      'bookId': 'BK006',
      'availability': 4
    },
    {
      'title': "The House of Dragons",
      'author': 'G.R.R Martin',
      'libraryId': 'LB007',
      'bookId': 'BK007',
      'availability': 6
    },
    {
      'title': "Game of Thrones",
      'author': 'Martin',
      'libraryId': 'LB007',
      'bookId': 'BK007',
      'availability': 2
    },
    {
      'title': "Rich Dad Poor Dad",
      'author': 'Robert Kiyosaki',
      'libraryId': 'LB007',
      'bookId': 'BK007',
      'availability': 10
    }
  ];

  List<Map<String, dynamic>> itemsToShow = [];
  int currentPage = 0;
  final int itemsPerPage = 4;  // Now set to 4 items per page
  String searchText = '';
  String filterAuthor = '';
  String filterTitle = '';
  String sortBy = 'title';  // Default sorting by title
  bool isAscending = true;  // Default sorting direction

  @override
  void initState() {
    super.initState();
    itemsToShow = List.from(allItems)..sort(_sortList);
  }

  void _searchItems(String text) {
    setState(() {
      searchText = text;
      _filterItems();
    });
  }

  void _filterItems() {
    setState(() {
      itemsToShow = allItems.where((item) {
        return (filterTitle.isEmpty || item['title'].toLowerCase().contains(filterTitle.toLowerCase())) &&
            (filterAuthor.isEmpty || item['author'].toLowerCase().contains(filterAuthor.toLowerCase())) &&
            (searchText.isEmpty || item['title'].toLowerCase().contains(searchText.toLowerCase()) || item['author'].toLowerCase().contains(searchText.toLowerCase()));
      }).toList();
      itemsToShow.sort(_sortList);
      currentPage = 0;
    });
  }

  int _sortList(Map<String, dynamic> a, Map<String, dynamic> b) {
    int orderModifier = isAscending ? 1 : -1;
    switch (sortBy) {
      case 'title':
        return a['title'].compareTo(b['title']) * orderModifier;
      case 'author':
        return a['author'].compareTo(b['author']) * orderModifier;
      case 'availability':
        return b['availability'].compareTo(a['availability']) * orderModifier;
      default:
        return 0;
    }
  }

  void _showFilterDialog() {
    TextEditingController authorController = TextEditingController(text: filterAuthor);
    TextEditingController titleController = TextEditingController(text: filterTitle);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text("Filter"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(
                      controller: authorController,
                      decoration: InputDecoration(
                        labelText: "Filter by Author",
                        hintText: "Enter author name",
                      ),
                    ),
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        labelText: "Filter by Title",
                        hintText: "Enter book title",
                      ),
                    ),
                    SizedBox(height: 20),
                    Text("Sort by:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ListTile(
                      title: const Text('Title'),
                      leading: Radio<String>(
                        value: 'title',
                        groupValue: sortBy,
                        onChanged: (value) {
                          setState(() {
                            sortBy = value!;
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: const Text('Author'),
                      leading: Radio<String>(
                        value: 'author',
                        groupValue: sortBy,
                        onChanged: (value) {
                          setState(() {
                            sortBy = value!;
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: const Text('Availability'),
                      leading: Radio<String>(
                        value: 'availability',
                        groupValue: sortBy,
                        onChanged: (value) {
                          setState(() {
                            sortBy = value!;
                          });
                        },
                      ),
                    ),
                    SwitchListTile(
                      title: Text('Ascending Order'),
                      value: isAscending,
                      onChanged: (bool value) {
                        setState(() {
                          isAscending = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Apply'),
                  onPressed: () {
                    setState(() {
                      filterAuthor = authorController.text;
                      filterTitle = titleController.text;
                      _filterItems();
                      Navigator.of(context).pop();
                    });
                  },
                ),
                TextButton(
                  child: Text('Reset'),
                  onPressed: () {
                    setState(() {
                      filterAuthor = '';
                      filterTitle = '';
                      sortBy = 'title';
                      isAscending = true;
                      _filterItems();
                      Navigator.of(context).pop();
                    });
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    int totalPages = (itemsToShow.length / itemsPerPage).ceil();
    List<Map<String, dynamic>> pageItems = itemsToShow
        .skip(currentPage * itemsPerPage)
        .take(itemsPerPage)
        .toList();

    return Scaffold(
      backgroundColor: Color(0xFF32324D),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Inventory',
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
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 4,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        onChanged: _searchItems,
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(
          hintText: "Search by title or author",
          hintStyle: TextStyle(color: Colors.black.withOpacity(0.5)),
          prefixIcon: Icon(Icons.search, color: Colors.black),
          suffixIcon: IconButton(
            icon: Icon(Icons.filter_list, color: Colors.black),
            onPressed: _showFilterDialog,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget buildItem(Map<String, dynamic> item) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: Color(0xFF4C4C6D),
      margin: EdgeInsets.only(bottom: 16),
      elevation: 8,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              item['title'],
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(color: Colors.white),
            ),
            SizedBox(height: 4),
            Text(
              item['author'],
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
            SizedBox(height: 4),
            Text(
              'Availability: ${item['availability']} units',
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
                      ? Colors.blue : Colors.white24,
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
                color: currentPage < totalPages - 1 ? Colors.white : Colors.grey),
            onPressed: currentPage < totalPages - 1
                ? () => setState(() => currentPage++)
                : null,
          ),
        ],
      ),
    );
  }
}
