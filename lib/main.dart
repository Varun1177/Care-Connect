// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:provider/provider.dart';

// import 'screens/login_screen.dart';
// import 'screens/Admin/admin_dashboard.dart';
// import 'screens/User/main_screen.dart';
// import 'screens/NGO/widgets/approved_ngo_view.dart';
// import 'screens/NGO/widgets/pending_approval_view.dart';
// import 'services/auth_service.dart';
// import 'screens/User/theme_provider.dart';
// import 'package:firebase_messaging/firebase_messaging.dart'; // Add this import


// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(
//     ChangeNotifierProvider(
//       create: (_) => ThemeProvider(),
//       child: const MyApp(),
//     ),
//   );
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//   @override
//   Widget build(BuildContext context) {
//     final themeProvider = Provider.of<ThemeProvider>(context);
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Care Connect',
//       theme: themeProvider.isDarkMode ? ThemeData.dark() : ThemeData.light(),
//       home: const SplashScreen(),
//     );
//   }
// }

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});
//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//     // Schedule our async startup logic right after the first frame:
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _startUpLogic();
//     });
//   }

//   Future<void> _startUpLogic() async {
//     final user = FirebaseAuth.instance.currentUser;
//     Widget destination;

//     if (user == null) {
//       // Not signed in at all
//       destination = const LoginScreen();
//     } else {
//       // Signed in → fetch their 'role'
//       final role = await AuthService().getUserRole(user.uid);

//       switch (role) {
//         case 'admin':
//           destination = const AdminDashboard();
//           break;

//         case 'user':
//           destination = const MainScreen();
//           break;

//         case 'ngo':
//           // Check the 'ngos' collection for this email:
//           final snap = await FirebaseFirestore.instance
//               .collection('ngos')
//               .where('email', isEqualTo: user.email)
//               .limit(1)
//               .get();

//           if (snap.docs.isEmpty) {
//             // No NGO doc ⇒ ask them to register
//             destination = const LoginScreen();
//           } else {
//             final doc = snap.docs.first;
//             final approved = (doc.data()['approved'] ?? false) as bool;
//             if (approved) {
//               destination = ApprovedNGOView(ngoData: doc);
//             } else {
//               destination = PendingApprovalView(pendingData: doc);
//             }
//           }
//           break;

//         default:
//           destination = const LoginScreen();
//       }
//     }

//     // Finally, perform the one and only navigation:
//     if (mounted) {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => destination),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Just show a spinner until _startUpLogic() decides where to go:
//     return const Scaffold(
//       body: Center(child: CircularProgressIndicator()),
//     );
//   }
// }


// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:provider/provider.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';

// import 'screens/login_screen.dart';
// import 'screens/Admin/admin_dashboard.dart';
// import 'screens/User/main_screen.dart';
// import 'screens/NGO/widgets/approved_ngo_view.dart';
// import 'screens/NGO/widgets/pending_approval_view.dart';
// import 'services/auth_service.dart';
// import 'screens/User/theme_provider.dart';

// // Handle background messages
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   print("📩 Background message: ${message.messageId}");
// }

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

//   runApp(
//     ChangeNotifierProvider(
//       create: (_) => ThemeProvider(),
//       child: const MyApp(),
//     ),
//   );
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//   @override
//   Widget build(BuildContext context) {
//     final themeProvider = Provider.of<ThemeProvider>(context);
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Care Connect',
//       theme: themeProvider.isDarkMode ? ThemeData.dark() : ThemeData.light(),
//       home: const SplashScreen(),
//     );
//   }
// }

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});
//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();

//     _setupFCM(); // 🔔 Set up Firebase Messaging

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _startUpLogic();
//     });
//   }

//   void _setupFCM() async {
//     FirebaseMessaging messaging = FirebaseMessaging.instance;

//     // 🔒 Request permissions (iOS especially)
//     await messaging.requestPermission();

//     // 🎯 Get FCM token
//     String? token = await messaging.getToken();
//     print("✅ FCM Token: $token");

//     // Save token to Firestore if user is signed in
//     final user = FirebaseAuth.instance.currentUser;
//     if (user != null && token != null) {
//       await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
//         'fcmToken': token,
//       });
//     }

//     // 📲 Foreground listener
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       print("📲 Foreground message: ${message.notification?.title}");
//       if (message.notification != null) {
//         final snackBar = SnackBar(
//           content: Text("${message.notification!.title}: ${message.notification!.body}"),
//         );
//         ScaffoldMessenger.of(context).showSnackBar(snackBar);
//       }
//     });

//     // 📥 When app is opened from a terminated state via a notification
//     FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
//       if (message != null) {
//         print("📥 App opened via notification: ${message.notification?.title}");
//         // You can add navigation logic here if needed
//       }
//     });

//     // 📤 When app is in background but opened via notification
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       print("📤 Notification tapped while in background: ${message.notification?.title}");
//       // Handle the action or navigate here
//     });
//   }

//   void _setupFCM() async {
//   FirebaseMessaging messaging = FirebaseMessaging.instance;

//   // 🔒 Request permissions (especially for iOS)
//   await messaging.requestPermission();

//   // 🎯 Get FCM token
//   String? token = await messaging.getToken();
//   print("✅ FCM Token: $token");

//   // Save token to Firestore if user is signed in
//   final user = FirebaseAuth.instance.currentUser;

//   if (user != null && token != null) {
//     // Determine user role
//     final role = await AuthService().getUserRole(user.uid);

//     try {
//       if (role == 'user') {
//         await FirebaseFirestore.instance
//             .collection('users')
//             .doc(user.uid)
//             .set({'fcmToken': token}, SetOptions(merge: true));
//         print("📝 Token saved to users collection");
//       } else if (role == 'ngo') {
//         final ngoSnap = await FirebaseFirestore.instance
//             .collection('ngos')
//             .where('email', isEqualTo: user.email)
//             .limit(1)
//             .get();

//         if (ngoSnap.docs.isNotEmpty) {
//           await ngoSnap.docs.first.reference.set({'fcmToken': token}, SetOptions(merge: true));
//           print("📝 Token saved to ngos collection");
//         }
//       }
//     } catch (e) {
//       print("❌ Error saving FCM token: $e");
//     }
//   }

//   // 📲 Foreground listener
//   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//     print("📲 Foreground message: ${message.notification?.title}");
//     if (message.notification != null && context.mounted) {
//       final snackBar = SnackBar(
//         content: Text("${message.notification!.title}: ${message.notification!.body}"),
//       );
//       ScaffoldMessenger.of(context).showSnackBar(snackBar);
//     }
//   });

//   // 📥 App opened from terminated state
//   FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
//     if (message != null) {
//       print("📥 App opened via notification: ${message.notification?.title}");
//       // Optional: Navigate or perform action based on data
//     }
//   });

//   // 📤 App opened from background (tapped notification)
//   FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//     print("📤 Notification tapped while in background: ${message.notification?.title}");
//     // Optional: Navigate based on message data
//   });
// }


//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(
//       body: Center(child: CircularProgressIndicator()),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'screens/login_screen.dart';
import 'screens/Admin/admin_dashboard.dart';
import 'screens/User/main_screen.dart';
import 'screens/NGO/widgets/approved_ngo_view.dart';
import 'screens/NGO/widgets/pending_approval_view.dart';
import 'services/auth_service.dart';
import 'screens/User/theme_provider.dart';

// Handle background messages
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("📩 Background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

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
    _setupFCM();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startUpLogic();
    });
  }

  void _setupFCM() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    await messaging.requestPermission();
    String? token = await messaging.getToken();
    print("✅ FCM Token: $token");

    final user = FirebaseAuth.instance.currentUser;
    if (user != null && token != null) {
      final role = await AuthService().getUserRole(user.uid);

      try {
        if (role == 'user') {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .set({'fcmToken': token}, SetOptions(merge: true));
          print("📝 Token saved to users collection");
        } else if (role == 'ngo') {
          final ngoSnap = await FirebaseFirestore.instance
              .collection('ngos')
              .where('email', isEqualTo: user.email)
              .limit(1)
              .get();

          if (ngoSnap.docs.isNotEmpty) {
            await ngoSnap.docs.first.reference.set({'fcmToken': token}, SetOptions(merge: true));
            print("📝 Token saved to ngos collection");
          }
        }
      } catch (e) {
        print("❌ Error saving FCM token: $e");
      }
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("📲 Foreground message: ${message.notification?.title}");
      if (message.notification != null && context.mounted) {
        final snackBar = SnackBar(
          content: Text("${message.notification!.title}: ${message.notification!.body}"),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    });

    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        print("📥 App opened via notification: ${message.notification?.title}");
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("📤 Notification tapped while in background: ${message.notification?.title}");
    });
  }

  Future<void> _startUpLogic() async {
    final user = FirebaseAuth.instance.currentUser;
    Widget destination;

    if (user == null) {
      destination = const LoginScreen();
    } else {
      final role = await AuthService().getUserRole(user.uid);

      switch (role) {
        case 'admin':
          destination = const AdminDashboard();
          break;
        case 'user':
          destination = const MainScreen();
          break;
        case 'ngo':
          final snap = await FirebaseFirestore.instance
              .collection('ngos')
              .where('email', isEqualTo: user.email)
              .limit(1)
              .get();

          if (snap.docs.isEmpty) {
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

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => destination),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
