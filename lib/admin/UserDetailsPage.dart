import 'package:flutter/material.dart';
import 'package:libraryapp/models/reader.dart';
import 'package:libraryapp/services/supabase_manager.dart';
import 'EditUserPage.dart';
import 'AddUserPage.dart';

class UserDetailsPage extends StatefulWidget {
  const UserDetailsPage({super.key});

  @override
  _UserDetailsPageState createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  final SupabaseManager _supabaseManager = SupabaseManager();
  List<Reader> readers = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    loadReaders();
  }

  Future<void> loadReaders() async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });

      final fetchedReaders = await _supabaseManager.fetchAllReaders();
      
      setState(() {
        readers = fetchedReaders;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = 'Failed to load readers: ${e.toString()}';
        isLoading = false;
      });
    }
  }

  void navigateToEditUserPage(BuildContext context, Reader reader) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditUserPage(
          userDetails: {
            'firstname': reader.firstname,
            'lastname': reader.lastname,
            'barcode': reader.barcode,
          },
        ),
      ),
    );
  }

  void navigateToAddUserPage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddUserPage()),
    );

    if (result != null) {
      // Refresh the list after adding a new user
      loadReaders();

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User added successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF32324D),
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'User Details',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white),
            onPressed: loadReaders,
            tooltip: 'Refresh',
          ),
        ],
      ),
      backgroundColor: Color(0xFF32324D),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Expanded(
              child: _buildContent(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: navigateToAddUserPage,
        backgroundColor: Color(0xFF615793),
        child: Icon(Icons.add),
        tooltip: 'Add New User',
      ),
    );
  }

  Widget _buildContent() {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    }

    if (error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              error!,
              style: TextStyle(color: Colors.red[300], fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: loadReaders,
              child: Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (readers.isEmpty) {
      return Center(
        child: Text(
          'No users available. Add users by clicking the "+" button above.',
          style: TextStyle(color: Colors.white60, fontSize: 18),
          textAlign: TextAlign.center,
        ),
      );
    }

    return ListView.builder(
      itemCount: readers.length,
      itemBuilder: (BuildContext context, int index) {
        final reader = readers[index];
        return Card(
          color: Color(0xFF4A4A6A),
          margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 0.0),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            title: Text(
              '${reader.firstname} ${reader.lastname}',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            subtitle: Text(
              'Barcode: ${reader.barcode}',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            trailing: IconButton(
              icon: Icon(Icons.edit, color: Colors.white),
              onPressed: () => navigateToEditUserPage(context, reader),
              tooltip: 'Edit User',
            ),
          ),
        );
      },
    );
  }
}

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User Details',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: UserDetailsPage(),
    );
  }
}