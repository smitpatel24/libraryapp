import 'package:flutter/material.dart';
import '../services/supabase_manager.dart';
import 'EditBookPage.dart';

class BookDetailsPage extends StatefulWidget {
  @override
  _BookDetailsPageState createState() => _BookDetailsPageState();
}

class _BookDetailsPageState extends State<BookDetailsPage> {
  List<Map<String, dynamic>> books = [];
  List<Map<String, dynamic>> foundBooks = [];
  int currentPage = 0;
  final int itemsPerPage = 3; // Show 3 cards at once
  bool isSearching = false;
  TextEditingController _searchController = TextEditingController();

  void _runFilter(String enteredKeyword) async {
    if (enteredKeyword.isEmpty) {
      setState(() {
        foundBooks = [];
        isSearching = false;
      });
      return;
    }

    SupabaseManager supabaseManager = SupabaseManager();
    List<Map<String, dynamic>> results = await supabaseManager.searchBooks(enteredKeyword);

    setState(() {
      foundBooks = results;
      isSearching = true;
    });
  }

  List<Map<String, dynamic>> getCurrentPageBooks() {
    final int startIndex = currentPage * itemsPerPage;
    final int endIndex = startIndex + itemsPerPage;
    return foundBooks.sublist(startIndex, endIndex.clamp(0, foundBooks.length));
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> currentPageBooks = getCurrentPageBooks();

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
                controller: _searchController,
                onSubmitted: _runFilter,
                style: TextStyle(color: Colors.black.withOpacity(0.7)),
                decoration: InputDecoration(
                  hintText: 'Search',
                  hintStyle: TextStyle(color: Colors.black.withOpacity(0.7)),
                  prefixIcon: Icon(Icons.search, color: Colors.black.withOpacity(0.7)),
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: isSearching && foundBooks.isEmpty
                  ? Center(
                child: Text(
                  'No results found',
                  style: TextStyle(color: Colors.white),
                ),
              )
                  : foundBooks.isEmpty
                  ? Center(
                child: Text(
                  'Please search for a book',
                  style: TextStyle(color: Colors.white),
                ),
              )
                  : ListView.builder(
                itemCount: currentPageBooks.length,
                itemBuilder: (context, index) => Card(
                  key: ValueKey(currentPageBooks[index]["bookid"]),
                  color: Color(0xFF4C4C6D),
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  elevation: 4,
                  child: ListTile(
                    title: Text(
                      currentPageBooks[index]['bookname']?.toString() ?? '',
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          currentPageBooks[index]['authorname']?.toString() ?? '',
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Book ID: ${currentPageBooks[index]['bookid']?.toString() ?? ''}',
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
                              bookDetails: {
                                'title': currentPageBooks[index]['bookname']?.toString() ?? '',
                                'author': currentPageBooks[index]['authorname']?.toString() ?? '',
                                'bookId': currentPageBooks[index]['bookid']?.toString() ?? '',
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            if (foundBooks.isNotEmpty) buildPagination(),
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
            icon: Icon(Icons.chevron_left, color: currentPage > 0 ? Colors.white : Colors.grey),
            onPressed: currentPage > 0 ? () => setState(() => currentPage--) : null,
          ),
          ...List.generate(totalPages, (index) {
            return GestureDetector(
              onTap: () => setState(() => currentPage = index),
              child: Container(
                padding: EdgeInsets.all(8),
                margin: EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: currentPage == index ? Colors.black.withOpacity(0.5) : Colors.white24,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '${index + 1}',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            );
          }),
          IconButton(
            icon: Icon(Icons.chevron_right, color: currentPage < totalPages - 1 ? Colors.white : Colors.grey),
            onPressed: currentPage < totalPages - 1 ? () => setState(() => currentPage++) : null,
          ),
        ],
      ),
    );
  }
}
