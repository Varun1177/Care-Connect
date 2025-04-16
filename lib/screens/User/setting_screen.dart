import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';
import 'package:care__connect/screens/login_screen.dart';
import 'package:care__connect/services/auth_service.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

      void _signOut(BuildContext context) async {
        await AuthService().signOut();
        Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: const Icon(Icons.brightness_6, color: Colors.orange),
              title: const Text("Dark Mode"),
              trailing: Switch(
                value: themeProvider.isDarkMode,
                onChanged: (value) {
                  themeProvider.toggleTheme();
                },
              ),
            ),
            const Divider(),

            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text("Logout"),
              onTap: () => _signOut(context),
            ),
          ],
        ),
      ),
    );
  }
}
