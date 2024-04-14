import 'package:flutter/material.dart';
import 'dart:math'; // Import math package to use pi, cos, and sin
import 'login_page.dart'; // Make sure to import LoginPage

class SankofaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Define a top margin for the logo.
    final topMargin = MediaQuery.of(context).size.height * 0.2;

    return Scaffold(
      backgroundColor: Color(0xFF2A2A72),
      body: Container(
        // Dark blue background color
        child: CustomPaint(
          painter: BackgroundCircleLinesPainter(
              topMargin: topMargin + 80), // Adjust the position of the circle
          child: Column(
            children: <Widget>[
              SizedBox(
                  height: topMargin - 40), // Adjust the height to move logo up
              CircleAvatar(
                backgroundColor: Color(0xFFFFD700),
                radius: 120,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Image.asset('assets/image.png', fit: BoxFit.contain),
                ),
              ),
              SizedBox(
                  height:
                      86), // Adjust this to move the 'Sankofa' text up or down
              Text(
                'Sankofa',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                ),
              ),
              SizedBox(height: 16), // Adjust this as well
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  'Transform literacy in Burkina Faso with efficient library management app.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 18,
                  ),
                ),
              ),
              SizedBox(height: 35),
              ElevatedButton(
                onPressed: () {
                  // Handle the button press
                  // When the button is pressed, navigate to the LoginPage
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF4A4A8E),
                  padding: EdgeInsets.symmetric(horizontal: 36, vertical: 12),
                ),
                child: Text('Get Started'),
              ),
              SizedBox(
                  height: MediaQuery.of(context).size.height *
                      0.1), // Adjust the space at the bottom
            ],
          ),
        ),
      ),
    );
  }
}

class BackgroundCircleLinesPainter extends CustomPainter {
  final double topMargin;

  BackgroundCircleLinesPainter({required this.topMargin});

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, topMargin);
    final double firstCircleRadius = 140;
    final double secondCircleRadius = 190;
    final paint = Paint()
      ..color = Colors.white
          .withOpacity(0.2) // Semi-transparent white for the circles
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Draw only two circle lines
    canvas.drawCircle(center, firstCircleRadius, paint);
    canvas.drawCircle(center, secondCircleRadius, paint);

    // Paint for the dots
    final dotPaint = Paint()
      ..color = Colors.white // Solid white for the dots
      ..style = PaintingStyle.fill;

    // Dots for the first circle at 0 and 180 degrees
    List<double> anglesFirstCircle = [0, pi]; // 0 and 180 degrees
    for (var angle in anglesFirstCircle) {
      Offset dotPosition = center +
          Offset(
              cos(angle) * firstCircleRadius, sin(angle) * firstCircleRadius);
      canvas.drawCircle(dotPosition, 4, dotPaint); // Dot size is 4
    }

    // Dots for the second circle at 90 and 270 degrees
    List<double> anglesSecondCircle = [
      pi / 2,
      3 * pi / 2
    ]; // 90 and 270 degrees
    for (var angle in anglesSecondCircle) {
      Offset dotPosition = center +
          Offset(
              cos(angle) * secondCircleRadius, sin(angle) * secondCircleRadius);
      canvas.drawCircle(dotPosition, 4, dotPaint); // Dot size is 4
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
