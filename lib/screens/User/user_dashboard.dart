import 'package:flutter/material.dart';
import 'package:care__connect/services/auth_service.dart';
import 'package:care__connect/screens/login_screen.dart';

class UserDashboardScreen extends StatelessWidget {

  const UserDashboardScreen({super.key});

  void _signOut(BuildContext context) async {
    await AuthService().signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _signOut(context),
          ),
        ],
      ),
      body: const Center(
        child: Text('Welcome to the User Dashboard!'),
      ),
    );
  }
}
