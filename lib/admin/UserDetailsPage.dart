import 'package:flutter/material.dart';
import 'package:libraryapp/models/user_dto.dart';
import 'package:libraryapp/services/supabase_manager.dart';
import 'package:libraryapp/services/user_type_service.dart';
import 'EditUserPage.dart';
import 'AddUserPage.dart';

class UserDetailsPage extends StatefulWidget {
  const UserDetailsPage({super.key});

  @override
  _UserDetailsPageState createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  final SupabaseManager _supabaseManager = SupabaseManager.instance;
  List<UserDTO> readers = [];
  List<UserDTO> librarians = [];
  bool isReadersLoading = true;
  String? readersLoadingError;

  bool isLibrariansLoading = true;
  String? librariansLoadingError;

  UserRole _selectedRole = UserRole.reader;
  bool _isAdmin = false;

  int _currentUserId = -1;

  @override
  void initState() {
    super.initState();
    _checkUserType();
    loadData();
  }

  Future<void> _checkUserType() async {
    bool isAdmin = await UserTypeService.isAdmin();
    int userId = await UserTypeService.getUserId();
    setState(() {
      _isAdmin = isAdmin;
      _currentUserId = userId;
    });
  }

  Future<void> loadData() async {
    await loadReaders();
    await loadLibrarians();
  }

  Future<void> loadReaders() async {
    try {
      setState(() {
        isReadersLoading = true;
        readersLoadingError = null;
      });

      final fetchedReaders = await _supabaseManager.fetchAllReaders();

      setState(() {
        readers = fetchedReaders;
        isReadersLoading = false;
      });
    } catch (e) {
      setState(() {
        readersLoadingError = 'Failed to load readers: ${e.toString()}';
        isReadersLoading = false;
      });
    }
  }

  Future<void> loadLibrarians() async {
    try {
      setState(() {
        isLibrariansLoading = true;
        librariansLoadingError = null;
      });

      final fetchedLibrarians = await _supabaseManager.fetchAllLibrarians();

      setState(() {
        librarians = fetchedLibrarians;
        isLibrariansLoading = false;
      });
    } catch (e) {
      setState(() {
        librariansLoadingError = 'Failed to load librarians: ${e.toString()}';
        isLibrariansLoading = false;
      });
    }
  }

  void navigateToEditUserPage(BuildContext context, UserDTO user,
      [bool? isLibrarian, bool? isSelf]) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditUserPage(
          user: user,
          isLibrarian: isLibrarian ?? false,
          isSelf: isSelf ?? false,
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildRoleSelector(),
            SizedBox(height: 10),
            Expanded(
              child: _selectedRole == UserRole.reader
                  ? _buildReadersList()
                  : _buildLibrarianList(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: navigateToAddUserPage,
        backgroundColor: Color(0xFF615793),
        tooltip: 'Add New User',
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildRoleSelector() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: SegmentedButton<UserRole>(
        segments: [
          ButtonSegment<UserRole>(
            value: UserRole.reader,
            label: Text('Reader'),
            icon: Icon(Icons.person_outline),
          ),
          ButtonSegment<UserRole>(
            value: UserRole.librarian,
            label: Text('Librarian'),
            icon: Icon(Icons.admin_panel_settings),
          ),
        ],
        selected: {_selectedRole},
        onSelectionChanged: (Set<UserRole> newSelection) {
          setState(() {
            _selectedRole = newSelection.first;
          });
        },
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith<Color>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.selected)) {
                return Colors.green;
              }
              return Colors.white24;
            },
          ),
        ),
      ),
    );
  }

  Widget _buildReadersList() {
    if (isReadersLoading) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    }

    if (readersLoadingError != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              readersLoadingError!,
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
            contentPadding:
                EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
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

  Widget _buildLibrarianList() {
    if (isLibrariansLoading) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    }

    if (librariansLoadingError != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              librariansLoadingError!,
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

    if (librarians.isEmpty) {
      return Center(
        child: Text(
          'No users available. Add users by clicking the "+" button above.',
          style: TextStyle(color: Colors.white60, fontSize: 18),
          textAlign: TextAlign.center,
        ),
      );
    }

    return ListView.builder(
      itemCount: librarians.length,
      itemBuilder: (BuildContext context, int index) {
        final librarian = librarians[index];
        return Card(
          color: Color(0xFF4A4A6A),
          margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 0.0),
          child: ListTile(
            contentPadding:
                EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            title: Text(
              '${librarian.firstname} ${librarian.lastname}',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            subtitle: Text(
              'Barcode: ${librarian.barcode}',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            trailing: IconButton(
              icon: Icon(Icons.edit, color: Colors.white),
              onPressed: () => navigateToEditUserPage(
                  context, librarian, true, librarian.id == _currentUserId),
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
