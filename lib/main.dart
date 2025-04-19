import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import 'screens/login_screen.dart';
import 'screens/Admin/admin_dashboard.dart';
import 'screens/User/main_screen.dart';
import 'screens/NGO/widgets/approved_ngo_view.dart';
import 'screens/NGO/widgets/pending_approval_view.dart';
import 'services/auth_service.dart';
import 'screens/User/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Care Connect',
      theme: themeProvider.isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Schedule our async startup logic right after the first frame:
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startUpLogic();
    });
  }

  Future<void> _startUpLogic() async {
    final user = FirebaseAuth.instance.currentUser;
    Widget destination;

    if (user == null) {
      // Not signed in at all
      destination = const LoginScreen();
    } else {
      // Signed in → fetch their 'role'
      final role = await AuthService().getUserRole(user.uid);

      switch (role) {
        case 'admin':
          destination = const AdminDashboard();
          break;

        case 'user':
          destination = const MainScreen();
          break;

        case 'ngo':
          // Check the 'ngos' collection for this email:
          final snap = await FirebaseFirestore.instance
              .collection('ngos')
              .where('email', isEqualTo: user.email)
              .limit(1)
              .get();

          if (snap.docs.isEmpty) {
            // No NGO doc ⇒ ask them to register
            destination = const LoginScreen();
          } else {
            final doc = snap.docs.first;
            final approved = (doc.data()['approved'] ?? false) as bool;
            if (approved) {
              destination = ApprovedNGOView(ngoData: doc);
            } else {
              destination = PendingApprovalView(pendingData: doc);
            }
          }
          break;

        default:
          destination = const LoginScreen();
      }
    }

    // Finally, perform the one and only navigation:
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => destination),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Just show a spinner until _startUpLogic() decides where to go:
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
