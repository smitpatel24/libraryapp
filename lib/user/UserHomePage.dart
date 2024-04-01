import 'package:flutter/material.dart';
import 'package:libraryapp/user/ReaderDetailsPage.dart';
import 'AddReaderPage.dart';
import 'ReaderDetailsPage.dart';

class UserHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF32324D),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Library Name', style: TextStyle(color: Colors.white)),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 1.0,
        padding: const EdgeInsets.all(16.0),
        mainAxisSpacing: 16.0,
        crossAxisSpacing: 16.0,
        children: <Widget>[
          _buildGridButton(
            context,
            icon: Icons.person_add,
            label: 'Add Reader',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddReaderPage()),
              );
            },
          ),
          _buildGridButton(
            context,
            icon: Icons.details,
            label: 'Reader Details',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ReaderDetailsPage()),
              );
            },
          ),
          _buildGridButton(
            context,
            icon: Icons.access_time,
            label: 'Overdue',
            onTap: () {
              // Navigate to Overdue screen or handle the button tap
            },
          ),
          _buildGridButton(
            context,
            icon: Icons.inventory,
            label: 'Inventory',
            onTap: () {
              // Navigate to Inventory screen or handle the button tap
            },
          ),
          _buildGridButton(
            context,
            icon: Icons.shopping_basket,
            label: 'Checkout',
            onTap: () {
              // Navigate to Checkout screen or handle the button tap
            },
          ),
          _buildGridButton(
            context,
            icon: Icons.refresh,
            label: 'Return',
            onTap: () {
              // Navigate to Return screen or handle the button tap
            },
          ),
        ],
      ),
    );
  }

  Widget _buildGridButton(BuildContext context,
      {required IconData icon,
      required String label,
      required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFF4A4A6A),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon, size: 50.0, color: Colors.white),
            SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
