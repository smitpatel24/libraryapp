import 'package:flutter/material.dart';
import 'EditBookPage.dart';

class BookDetailsPage extends StatefulWidget {
  @override
  _BookDetailsPageState createState() => _BookDetailsPageState();
}

class _BookDetailsPageState extends State<BookDetailsPage> {
  List<Map<String, String>> books = [
    {
      'title': "Aurora's Awakening",
      'author': 'Luna Evergreen',
      'bookId': 'PR8923W6'
    },
    {
      'title': "The Great Gatsby",
      'author': 'F. Scott Fitzgerald',
      'bookId': 'BK001'
    },
    {
      'title': "To Kill a Mockingbird",
      'author': 'Harper Lee',
      'bookId': 'BK002'
    },
    {'title': "1984", 'author': 'George Orwell', 'bookId': 'BK003'},
    {
      'title': "Pride and Prejudice",
      'author': 'Jane Austen',
      'bookId': 'BK004'
    },
    {
      'title': "The Catcher in the Rye",
      'author': 'J.D. Salinger',
      'bookId': 'BK005'
    }
    // Add more books as needed
  ];

  List<Map<String, String>> foundBooks = [];
  int currentPage = 0;
  final int itemsPerPage = 3; // Show 3 cards at once

  @override
  void initState() {
    super.initState();
    foundBooks = books;
  }

  void _runFilter(String enteredKeyword) {
    List<Map<String, String>> results = [];
    if (enteredKeyword.isEmpty) {
      results = books;
    } else {
      results = books.where((book) {
        return book['title']!
                .toLowerCase()
                .contains(enteredKeyword.toLowerCase()) ||
            book['author']!
                .toLowerCase()
                .contains(enteredKeyword.toLowerCase()) ||
            book['bookId']!.contains(enteredKeyword);
      }).toList();
    }

    setState(() {
      foundBooks = results;
    });
  }

  List<Map<String, String>> getCurrentPageBooks() {
    final int startIndex = currentPage * itemsPerPage;
    final int endIndex = startIndex + itemsPerPage;
    return foundBooks.sublist(startIndex, endIndex.clamp(0, foundBooks.length));
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> currentPageBooks = getCurrentPageBooks();

    return Scaffold(
      backgroundColor: Color(0xFF32324D),
      appBar: AppBar(
        title: Text(
          'Book Details',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Container(
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
                onChanged: _runFilter,
                style: TextStyle(color: Colors.black.withOpacity(0.7)),
                decoration: InputDecoration(
                  hintText: 'Search',
                  hintStyle: TextStyle(color: Colors.black.withOpacity(0.7)),
                  prefixIcon:
                      Icon(Icons.search, color: Colors.black.withOpacity(0.7)),
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: currentPageBooks.length,
                itemBuilder: (context, index) => Card(
                  key: ValueKey(currentPageBooks[index]["bookId"]),
                  color: Color(0xFF4C4C6D),
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  elevation: 4,
                  child: ListTile(
                    title: Text(
                      currentPageBooks[index]['title']!,
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          currentPageBooks[index]['author']!,
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Library ID: ${currentPageBooks[index]['libraryId']}',
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Book ID: ${currentPageBooks[index]['bookId']}',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.edit, color: Colors.white),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditBookPage(
                                bookDetails: currentPageBooks[index]),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            buildPagination(),
          ],
        ),
      ),
    );
  }

  Widget buildPagination() {
    final int totalPages = (foundBooks.length / itemsPerPage).ceil();
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
