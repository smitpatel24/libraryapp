import 'package:flutter/material.dart';
import 'admin/AdminHomePage.dart';
import 'user/UserHomePage.dart';
import 'BarcodeScannerScreen.dart'; // Make sure to create this screen for barcode scanning functionality.

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        // This will prevent overflow when the keyboard is displayed
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 600, // This limits the width on larger screens
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 80), // Provides spacing at the top
                Text(
                  "Let's Get Started",
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
                SizedBox(height: 40),
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
                  style: TextStyle(color: Colors.white),
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
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 40),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Color(0xFF615793), // The background color of the button
                    foregroundColor: Colors
                        .white, // The color of the text (foreground color)
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          10), // The rounded corners of the button
                      // side: BorderSide(
                      //     color: Color(0xFFD6A642)), // Border color and width
                    ),
                  ),
                  onPressed: _attemptSignIn,
                  child: Text(
                    'Sign In',
                    style: TextStyle(
                      fontSize: 18, // The font size
                      fontWeight: FontWeight.bold, // The font weight
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Divider(color: Colors.white54),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Color(0xFF615793), // The background color of the button
                    foregroundColor: Colors
                        .white, // The color of the text (foreground color)
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          10), // The rounded corners of the button
                      // side: BorderSide(
                      //     color: Color(0xFFD6A642)), // Border color and width
                    ),
                  ),
                  onPressed: _signInWithBarcode,
                  child: const Text('Scan Barcode'),
                ),
                SizedBox(height: 80), // Provides spacing at the bottom
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

// The BarcodeScannerScreen is assumed to be a placeholder.
// Replace with your actual barcode scanner screen implementation.
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
