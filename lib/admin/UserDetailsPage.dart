import 'package:flutter/material.dart';
import 'EditUserPage.dart';
import 'AddUserPage.dart';

class UserDetailsPage extends StatefulWidget {
  @override
  _UserDetailsPageState createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  List<Map<String, String>> users = [
    {'name': 'Ariel Meadows', 'details': '502804(CODE_071)'},
    {'name': 'Wayne Solomon', 'details': '332094(CODE_805)'},
    {'name': 'Mylah Martin', 'details': '263602(CODE_541)'},
    {'name': 'Mateo Crane', 'details': '634421(CODE_025)'},
  ];

  void navigateToEditUserPage(
      BuildContext context, Map<String, String> userDetails) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => EditUserPage(userDetails: userDetails)),
    );
  }

  void navigateToAddUserPage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddUserPage()),
    );

    if (result != null) {
      setState(() {
        users.add(result);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF32324D),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: Colors.white),
            onPressed: navigateToAddUserPage,
          ),
        ],
      ),
      backgroundColor: Color(0xFF32324D),
      body: Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'User Details',
                style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: users.length,
                itemBuilder: (BuildContext context, int index) {
                  Map<String, String> user = users[index];
                  return Card(
                    color: Color(0xFF4A4A6A),
                    margin:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child: ListTile(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      title: Text(
                        user['name']!,
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      subtitle: Text(
                        user['details']!,
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.edit, color: Colors.white),
                        onPressed: () => navigateToEditUserPage(context, user),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
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
