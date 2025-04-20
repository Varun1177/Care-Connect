// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'theme_provider.dart';
// import 'package:care__connect/screens/login_screen.dart';
// import 'package:care__connect/services/auth_service.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class SettingsScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final themeProvider = Provider.of<ThemeProvider>(context);

//       void _signOut(BuildContext context) async {

//         final user = FirebaseAuth.instance.currentUser;
//   final token = await FirebaseMessaging.instance.getToken();

//   if (user != null && token != null) {
//     final role = await AuthService().getUserRole(user.uid);

//     if (role == 'user') {
//       await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
//         'fcmToken': FieldValue.delete(),
//       });
//     } else if (role == 'ngo') {
//       final ngoSnap = await FirebaseFirestore.instance
//           .collection('ngos')
//           .where('email', isEqualTo: user.email)
//           .limit(1)
//           .get();

//       if (ngoSnap.docs.isNotEmpty) {
//         await ngoSnap.docs.first.reference.update({
//           'fcmToken': FieldValue.delete(),
//         });
//       }
//     }
//   }
//         await AuthService().signOut();
//         Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => LoginScreen()),
//     );
//   }

//     return Scaffold(
//       appBar: AppBar(title: const Text("Settings")),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             ListTile(
//               leading: const Icon(Icons.brightness_6, color: Colors.orange),
//               title: const Text("Dark Mode"),
//               trailing: Switch(
//                 value: themeProvider.isDarkMode,
//                 onChanged: (value) {
//                   themeProvider.toggleTheme();
//                 },
//               ),
//             ),
//             const Divider(),

//             ListTile(
//               leading: const Icon(Icons.logout, color: Colors.red),
//               title: const Text("Logout"),
//               onTap: () => _signOut(context),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';
import 'package:care__connect/screens/login_screen.dart';
import 'package:care__connect/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    void _signOut(BuildContext context) async {
      final user = FirebaseAuth.instance.currentUser;

      // Step 1: Sign out the user
      
      await AuthService().signOut();

      // Step 2: Navigate to LoginScreen immediately
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );

      // Step 3: Delete FCM token in the background
      Future.microtask(() async {
        try {
          if (user != null) {
            final role = await AuthService().getUserRole(user.uid);

            if (role == 'user') {
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .update({
                'fcmToken': FieldValue.delete(),
              });
              debugPrint('🧹 Deleted FCM token for user');
            } else if (role == 'ngo') {
              final ngoSnap = await FirebaseFirestore.instance
                  .collection('ngos')
                  .where('email', isEqualTo: user.email)
                  .limit(1)
                  .get();

              if (ngoSnap.docs.isNotEmpty) {
                await ngoSnap.docs.first.reference.update({
                  'fcmToken': FieldValue.delete(),
                });
                debugPrint('🧹 Deleted FCM token for NGO');
              }
            }
          }
        } catch (e) {
          debugPrint('❌ Error deleting FCM token: $e');
        }
      });
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
