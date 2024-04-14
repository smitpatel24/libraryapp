import 'package:flutter/material.dart';
import 'system_status_header.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isPasswordVisible = false;

  OutlineInputBorder _outlineInputBorder() {
    return OutlineInputBorder(
      borderSide: BorderSide(color: Colors.orange, width: 2),
      borderRadius: BorderRadius.circular(20),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2A2A72),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SystemStatusHeader(), // This will show the header with time, network, and battery
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),
              Text(
                "Let's Get Started",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 28),
              // Username TextField
              TextField(
                style: TextStyle(color: Colors.white),
                cursorColor: Colors.orange, // Set the cursor color to orange
                decoration: InputDecoration(
                  labelText: 'Username',
                  labelStyle: TextStyle(color: Colors.white54),
                  prefixIcon: Icon(Icons.person, color: Colors.white54),
                  enabledBorder: _outlineInputBorder(),
                  focusedBorder: _outlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
              ),
              SizedBox(height: 24),
              // Password TextField
              TextField(
                style: TextStyle(color: Colors.white),
                cursorColor: Colors.orange, // Set the cursor color to orange
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(color: Colors.white54),
                  prefixIcon: Icon(Icons.lock, color: Colors.white54),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.white54,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                  enabledBorder: _outlineInputBorder(),
                  focusedBorder: _outlineInputBorder(),
                ),
              ),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  // TODO: Implement sign-in logic
                },
                child: Text('Sign In'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent,
                  foregroundColor: Colors.white, // Button text color
                ),
              ),
              // Other UI elements...
              // Include the divider with 'Or' text and barcode section here
              // Divider with 'Or' text in the center
              SizedBox(height: 30),
              Row(
                children: <Widget>[
                  Expanded(child: Divider(color: Colors.white54, thickness: 1)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text('OR', style: TextStyle(color: Colors.white)),
                  ),
                  Expanded(child: Divider(color: Colors.white54, thickness: 1)),
                ],
              ),
              SizedBox(height: 20),
// Barcode Image from assets
              Image.asset('assets/barcode.png', height: 100),
              SizedBox(height: 30),
// 'Scan Barcode' Button
              ElevatedButton(
                onPressed: () {
                  // Implement barcode scan logic
                },
                child: Text('Scan Barcode'),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.deepPurpleAccent, // Button background color
                  foregroundColor: Colors.white, // Button text color
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
