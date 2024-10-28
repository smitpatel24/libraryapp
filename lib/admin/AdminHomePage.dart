import 'package:flutter/material.dart';
import 'AddUserPage.dart';
import 'UserDetailsPage.dart';
import 'AddBookPage.dart';
import 'package:libraryapp/InventoryPage.dart';
import 'package:libraryapp/OverduePage.dart';
import 'BookDetailsPage.dart';
import '../services/supabase_manager.dart';
import '../SignInScreen.dart';

class AdminHomePage extends StatelessWidget {
  final SupabaseManager _supabaseManager = SupabaseManager();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF32324D),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Library Name', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              await _supabaseManager.logout();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => SignInScreen()),
                    (route) => false,
              );
            },
          ),
        ],
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
            label: 'Add User',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddUserPage()),
              );
            },
          ),
          _buildGridButton(
            context,
            icon: Icons.supervised_user_circle_sharp,
            label: 'User Details',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserDetailsPage()),
              );
            },
          ),
          _buildGridButton(
            context,
            icon: Icons.access_time,
            label: 'Overdue',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => OverduePage()),
              );
            },
          ),
          _buildGridButton(
            context,
            icon: Icons.inventory,
            label: 'Inventory',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => InventoryPage()),
              );
            },
          ),
          _buildGridButton(
            context,
            icon: Icons.library_add,
            label: 'Add Book',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddBookPage()),
              );
            },
          ),
          _buildGridButton(
            context,
            icon: Icons.book,
            label: 'Book Details',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BookDetailsPage()),
              );
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
          color: Color(0xAA4A4A6A),
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
