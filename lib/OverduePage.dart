import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Overdue',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: OverduePage(),
    );
  }
}

class OverduePage extends StatefulWidget {
  @override
  _OverduePageState createState() => _OverduePageState();
}

class _OverduePageState extends State<OverduePage> {
  final List<Map<String, String>> allItems = [
    {
      'title': "The Great Gatsby",
      'author': 'F. Scott Fitzgerald',
      'libraryId': 'LB001',
      'bookId': 'BK001',
      'issuedBy': 'John Doe',
      'dueDate': '2023-03-15'
    },
    {
      'title': "To Kill a Mockingbird",
      'author': 'Harper Lee',
      'libraryId': 'LB002',
      'bookId': 'BK002',
      'issuedBy': 'Jane Smith',
      'dueDate': '2023-03-20'
    },
    {
      'title': "1984",
      'author': 'George Orwell',
      'libraryId': 'LB003',
      'bookId': 'BK003',
      'issuedBy': 'Emily Johnson',
      'dueDate': '2023-03-25'
    },
    {
      'title': "Pride and Prejudice",
      'author': 'Jane Austen',
      'libraryId': 'LB004',
      'bookId': 'BK004',
      'issuedBy': 'Mike Brown',
      'dueDate': '2023-03-30'
    },
    {
      'title': "The Catcher in the Rye",
      'author': 'J.D. Salinger',
      'libraryId': 'LB005',
      'bookId': 'BK005',
      'issuedBy': 'Laura Wilson',
      'dueDate': '2023-04-04'
    },
  ];

  List<Map<String, String>> itemsToShow = [];
  int currentPage = 0;
  final int itemsPerPage = 4;
  String searchText = '';
  String filterIssuer = '';
  String sortBy = 'dueDate';  // Default sorting by due date
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
        return (searchText.isEmpty || item['title']!.toLowerCase().contains(searchText.toLowerCase()) ||
            item['author']!.toLowerCase().contains(searchText.toLowerCase()) ||
            item['issuedBy']!.toLowerCase().contains(searchText.toLowerCase())) &&
            (filterIssuer.isEmpty || item['issuedBy']!.toLowerCase().contains(filterIssuer.toLowerCase()));
      }).toList();
      itemsToShow.sort(_sortList);
      currentPage = 0;
    });
  }

  int _sortList(Map<String, String> a, Map<String, String> b) {
    int orderModifier = isAscending ? 1 : -1;
    switch (sortBy) {
      case 'dueDate':
        return a['dueDate']!.compareTo(b['dueDate']!) * orderModifier;
      case 'title':
        return a['title']!.compareTo(b['title']!) * orderModifier;
      default:
        return 0;
    }
  }

  void _showFilterDialog() {
    TextEditingController issuerController = TextEditingController(text: filterIssuer);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text("Filter and Sort"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(
                      controller: issuerController,
                      decoration: InputDecoration(
                        labelText: "Filter by Issuer",
                        hintText: "Enter issuer name",
                      ),
                    ),
                    SizedBox(height: 20),
                    Text("Sort by:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ListTile(
                      title: const Text('Due Date'),
                      leading: Radio<String>(
                        value: 'dueDate',
                        groupValue: sortBy,
                        onChanged: (value) {
                          setState(() {
                            sortBy = value!;
                          });
                        },
                      ),
                    ),
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
                      filterIssuer = issuerController.text;
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
    List<Map<String, String>> pageItems = itemsToShow
        .skip(currentPage * itemsPerPage)
        .take(itemsPerPage)
        .toList();

    return Scaffold(
      backgroundColor: Color(0xFF32324D),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Overdue',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: BackButton(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_alt),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: 20),
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
        color: Colors.white.withOpacity(1),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: Colors.black.withOpacity(0.7)),
          SizedBox(width: 8),
          Expanded(
            child: TextField(
              onChanged: _searchItems,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                hintText: "Search by book name, author, or issuer",
                hintStyle: TextStyle(color: Colors.black.withOpacity(0.7)),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildItem(Map<String, String> item) {
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
            SizedBox(height: 8),
            Text(
              'Library ID: ${item['libraryId']}',
              style: TextStyle(color: Colors.white70),
            ),
            Text(
              'Book ID: ${item['bookId']}',
              style: TextStyle(color: Colors.white70),
            ),
            Text(
              'Issued By: ${item['issuedBy']}',
              style: TextStyle(color: Colors.white70),
            ),
            Text(
              'Due Date: ${item['dueDate']}',
              style: TextStyle(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPagination(int totalPages) {
    return Container(
      alignment: Alignment.center,
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
                  color: currentPage == index ? Colors.blue : Colors.white24,
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
