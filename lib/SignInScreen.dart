import 'package:flutter/material.dart';
import 'admin/AdminHomePage.dart';
import 'user/UserHomePage.dart';
import 'BarcodeScannerScreen.dart'; // Make sure to create this screen for barcode scanning functionality.

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SignInScreen(),
    );
  }
}

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _attemptSignIn() {
    final String username = _usernameController.text;
    final String password = _passwordController.text;
    if (username == 'Admin' && password == 'AdminPassword') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AdminHomePage()),
      );
    } else if (username == 'User' && password == 'UserPassword') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => UserHomePage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Incorrect username or password')),
      );
    }
  }

  void _signInWithBarcode() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BarcodeScannerScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF32324D),
      appBar: AppBar(
        title: const Text('Sign In Screen'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
              maxWidth: 600), // limits the width on larger screens
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Spacer(flex: 2),
                Text(
                  "Let's Get Started",
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
                Spacer(),
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    hintText: 'Username',
                    hintStyle: TextStyle(color: Colors.white70),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange, width: 1.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange, width: 2.0),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    hintStyle: TextStyle(color: Colors.white70),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange, width: 1.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange, width: 2.0),
                    ),
                    suffixIcon:
                        const Icon(Icons.visibility_off, color: Colors.white70),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                Spacer(),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF615793),
                    onPrimary: Colors.white,
                  ),
                  onPressed: _attemptSignIn,
                  child: const Text('Sign In'),
                ),
                Spacer(),
                Divider(color: Colors.white54),
                Spacer(),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF615793),
                    onPrimary: Colors.white,
                  ),
                  onPressed: _signInWithBarcode,
                  child: const Text('Sign In with Barcode'),
                ),
                Spacer(flex: 2),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

// BarcodeScannerScreen is a placeholder. Replace with actual barcode scanner implementation.
class BarcodeScannerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Barcode Scanner')),
      body: Center(
        child: Text('Barcode Scanner Implementation'),
      ),
    );
  }
}
