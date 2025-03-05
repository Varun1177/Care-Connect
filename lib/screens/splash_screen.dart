import 'package:care__connect/screens/NGO/ngo_registration_screen.dart';
import 'package:care__connect/screens/User/signup_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {

  const SplashScreen({super.key});
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignupScreen()),
                );
              },
              child: Column(
                children: [
                  Image.asset("lib/assets/add-user.png", height: 100),
                  const Text(
                    'User Registration',
                    style: TextStyle(
                        color: Color(0xFF00A86B), fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 50),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NGORegistrationScreen()),
                );
              },
              child: Column(
                children: [
                  Image.asset("lib/assets/add-NGO.png", height: 100),
                  const Text(
                    'NGO Registration',
                    style: TextStyle(
                        color: Color(0xFF00A86B), fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
