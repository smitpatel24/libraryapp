import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'SignInScreen.dart';
import 'admin/AdminHomePage.dart';
import 'user/UserHomePage.dart';
import '../services/supabase_manager.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      child: GetMaterialApp(
        title: 'Sankofa Library App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          fontFamily: 'Mulish', // Ensure this font is in your pubspec.yaml
        ),
        home: const InitialScreen(),
      ),
    );
  }
}

class InitialScreen extends StatefulWidget {
  const InitialScreen({super.key});

  @override
  _InitialScreenState createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  final SupabaseManager _supabaseManager = SupabaseManager();

  @override
  void initState() {
    super.initState();
    _checkLoginState();
  }

  Future<void> _checkLoginState() async {
    bool isLoggedIn = await _supabaseManager.isLoggedIn();
    if (isLoggedIn) {
      int? userType = await _supabaseManager.getUserType();
      if (userType == 2) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminHomePage()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => UserHomePage()),
        );
      }
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const StartScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF32324D),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              child: CustomPaint(
                painter: BackgroundPainter(),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Spacer(flex: 2),
                // Adjust logo size as necessary
                Image.asset('assets/images/logo_favl.jpg',
                    width: 163, height: 217),
                SizedBox(height: 24),
                Spacer(flex: 2),
                Text(
                  'Sankofa',
                  style: TextStyle(
                    fontFamily: 'DM Sans', // Ensure this font is in your pubspec.yaml
                    fontSize: 26,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 48.0),
                  child: Text(
                    'Transform literacy in Burkina Faso with efficient library management app.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFFEAEAEF),
                    ),
                  ),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size.fromHeight(50),
                      backgroundColor: Color(0xFF615793),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignInScreen()),
                      );
                    },
                    child: const Text(
                      'Get Started',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                Spacer(flex: 2),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class BackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    // Set up paint for the larger ellipses
    paint.color = Color(0xFFD6A642).withOpacity(0.5);
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 2;

    // Larger ellipse in the center
    canvas.drawCircle(
        Offset(size.width / 2, size.height * 0.25), size.width * 0.3, paint);

    // Larger ellipse in the center
    canvas.drawCircle(
        Offset(size.width / 2, size.height * 0.25), size.width * 0.35, paint);

    // Small filled ellipse in the center
    paint.color = Color(0xFFD6A642);
    paint.style = PaintingStyle.fill;
    canvas.drawCircle(
        Offset(size.width / 2, size.height * 0.25), size.width * 0.25, paint);

    // Dots
    paint.color = Color(0xFFD6A642);
    canvas.drawCircle(Offset(size.width * 0.255, size.height * 0.1), 4, paint);
    canvas.drawCircle(Offset(size.width * 0.255, size.height * 0.4), 6, paint);

    paint.color = Color(0xFFFFC861);
    canvas.drawCircle(Offset(size.width * 0.745, size.height * 0.1), 5, paint);

    paint.color = Color(0xFFFFE7BB);
    canvas.drawCircle(Offset(size.width * 0.745, size.height * 0.4), 3, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
