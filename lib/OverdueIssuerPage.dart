import 'package:flutter/material.dart';

class OverdueIssuerPage extends StatefulWidget {
  final String issuer;

  const OverdueIssuerPage({Key? key, required this.issuer}) : super(key: key);

  @override
  _OverdueIssuerPageState createState() => _OverdueIssuerPageState();
}

class _OverdueIssuerPageState extends State<OverdueIssuerPage> {
  List<Map<String, String>> overdueBooks = [];
  int currentPage = 0;
  final int itemsPerPage = 3;

  @override
  void initState() {
    super.initState();
    overdueBooks = [
      {'title': "Book 1", 'author': 'Author 1', 'dueDate': '2023-03-15'},
      {'title': "Book 2", 'author': 'Author 2', 'dueDate': '2023-03-20'},
    ];
  }

  @override
  Widget build(BuildContext context) {
    int totalPages = (overdueBooks.length / itemsPerPage).ceil();
    List<Map<String, String>> pageItems = overdueBooks
        .skip(currentPage * itemsPerPage)
        .take(itemsPerPage)
        .toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Issued by ${widget.issuer}',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: BackButton(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: 20),
            Text(
              '${widget.issuer}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 24),
            for (var book in pageItems) buildBookCard(book),
            if (totalPages > 1) buildPagination(totalPages),
          ],
        ),
      ),
      backgroundColor: Color(0xFF32324D),
    );
  }

  Widget buildBookCard(Map<String, String> book) {
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
              'Title: ${book['title']}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Author: ${book['author']}',
              style: TextStyle(color: Colors.white70),
            ),
            SizedBox(height: 8),
            Text(
              'Due Date: ${book['dueDate']}',
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
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
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
