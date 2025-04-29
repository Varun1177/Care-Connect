// // import 'package:care__connect/screens/User/DonationTypeScreen.dart';
// // import 'package:care__connect/screens/User/donate_screen.dart';
// // import 'package:care__connect/screens/User/report_screen.dart';
// // import 'package:care__connect/screens/User/setting_screen.dart';
// // import 'package:flutter/material.dart';
// // import 'home_screen.dart';
// // import 'profile_screen.dart';


// // class MainScreen extends StatefulWidget {
// //   @override
// //   _MainScreenState createState() => _MainScreenState();
// // }

// // class _MainScreenState extends State<MainScreen> {
// //   int _selectedIndex = 0;

// //   // List of Screens
// //   final List<Widget> _screens = [
// //     HomeScreen(),
// //     DonationTypeScreen(),
// //     ProfileScreen(), 
// //     SettingsScreen(), 
// //   ];

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       body: IndexedStack(
// //         index: _selectedIndex,
// //         children: _screens,
// //       ),
// //       bottomNavigationBar: BottomNavigationBar(
// //         currentIndex: _selectedIndex,
// //         onTap: (index) {
// //           setState(() {
// //             _selectedIndex = index;
// //           });
// //         },
// //         type: BottomNavigationBarType.fixed,
// //         selectedItemColor: Colors.orange,
// //         unselectedItemColor: Colors.grey,
// //         items: const [
// //           BottomNavigationBarItem(
// //             icon: Icon(Icons.home),
// //             label: 'Home',
// //           ),
// //           BottomNavigationBarItem(
// //             icon: Icon(Icons.volunteer_activism),
// //             label: 'Donate',
// //           ),
// //           BottomNavigationBarItem(
// //             icon: Icon(Icons.person),
// //             label: 'Profile',
// //           ),
// //           BottomNavigationBarItem(
// //             icon: Icon(Icons.settings),
// //             label: 'Settings',
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }


// import 'package:care__connect/screens/User/DonationTypeScreen.dart';
// import 'package:care__connect/screens/User/report_screen.dart';
// import 'package:care__connect/screens/User/setting_screen.dart';
// import 'package:care__connect/screens/User/user_ngo_list_screen.dart';
// import 'package:flutter/material.dart';
// import 'home_screen.dart';
// import 'profile_screen.dart';

// class MainScreen extends StatefulWidget {
//   const MainScreen({Key? key}) : super(key: key);

//   @override
//   _MainScreenState createState() => _MainScreenState();
// }

// class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin {
//   int _selectedIndex = 0;
//   late AnimationController _animationController;
//   late Animation<double> _fadeAnimation;

//   // List of Screens
//   final List<Widget> _screens = [
//     HomeScreen(),
//     UserNGOListScreen(),
//     DonationTypeScreen(),
//     ProfileScreen(),
//     SettingsScreen(),
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 800),
//     );
//     _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(
//         parent: _animationController,
//         curve: Curves.easeIn,
//       ),
//     );
//     _animationController.forward();
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: FadeTransition(
//         opacity: _fadeAnimation,
//         child: IndexedStack(
//           index: _selectedIndex,
//           children: _screens,
//         ),
//       ),
//       bottomNavigationBar: Container(
//         decoration: BoxDecoration(
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.1),
//               blurRadius: 10,
//               spreadRadius: 0,
//             ),
//           ],
//         ),
//         child: ClipRRect(
//           borderRadius: const BorderRadius.only(
//             topLeft: Radius.circular(20),
//             topRight: Radius.circular(20),
//           ),
//           child: BottomNavigationBar(
//             currentIndex: _selectedIndex,
//             onTap: (index) {
//               setState(() {
//                 _selectedIndex = index;
//               });
//             },
//             type: BottomNavigationBarType.fixed,
//             backgroundColor: Colors.white,
//             selectedItemColor: const Color(0xFF00A86B),
//             unselectedItemColor: Colors.grey.shade500,
//             selectedLabelStyle: const TextStyle(
//               fontWeight: FontWeight.w600,
//               fontSize: 12,
//             ),
//             unselectedLabelStyle: const TextStyle(
//               fontWeight: FontWeight.normal,
//               fontSize: 11,
//             ),
//             elevation: 0,
//             items: [
//               bottomNavItem(Icons.home_outlined, Icons.home, 'Home'),
//               bottomNavItem(Icons.join_inner_outlined, Icons.join_inner, 'Join'),
//               bottomNavItem(Icons.volunteer_activism_outlined, Icons.volunteer_activism, 'Donate'),
//               bottomNavItem(Icons.person_outline, Icons.person, 'Profile'),
//               bottomNavItem(Icons.settings_outlined, Icons.settings, 'Settings'),
//             ],
//           ),
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.push(
//             context, 
//             MaterialPageRoute(builder: (context) => ReportScreen())
//           );
//         },
//         backgroundColor: const Color(0xFF00A86B),
//         child: const Icon(Icons.add_alert, color: Colors.white),
//         elevation: 8,
//       ),
//     );
//   }

//   BottomNavigationBarItem bottomNavItem(IconData unselectedIcon, IconData selectedIcon, String label) {
//     return BottomNavigationBarItem(
//       icon: Padding(
//         padding: const EdgeInsets.only(bottom: 4),
//         child: Icon(_selectedIndex == getIndexFromLabel(label) ? selectedIcon : unselectedIcon),
//       ),
//       label: label,
//     );
//   }

//   int getIndexFromLabel(String label) {
//     switch (label) {
//       case 'Home': return 0;
//       case 'Join': return 1;
//       case 'Donate': return 2;
//       case 'Profile': return 3;
//       case 'Settings': return 4;
//       default: return 0;
//     }
//   }
// }


// import 'package:care__connect/screens/User/DonationTypeScreen.dart';
// import 'package:care__connect/screens/User/report_screen.dart';
// import 'package:care__connect/screens/User/setting_screen.dart';
// import 'package:care__connect/screens/User/user_ngo_list_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:care__connect/screens/User/widgets/custom_drawer.dart';// Import the custom drawer
// import 'home_screen.dart';
// import 'profile_screen.dart';

// class MainScreen extends StatefulWidget {
//   const MainScreen({Key? key}) : super(key: key);

//   @override
//   _MainScreenState createState() => _MainScreenState();
// }

// class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin {
//   int _selectedIndex = 0;
//   late AnimationController _animationController;
//   late Animation<double> _fadeAnimation;
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

//   // List of Screens
//   final List<Widget> _screens = [
//     HomeScreen(),
//     UserNGOListScreen(),
//     DonationTypeScreen(),
//     ProfileScreen(),
//     SettingsScreen(),
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 800),
//     );
//     _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(
//         parent: _animationController,
//         curve: Curves.easeIn,
//       ),
//     );
//     _animationController.forward();
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }

//   // Navigation from drawer
//   void navigateFromDrawer(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: _scaffoldKey,
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF00A86B),
//         elevation: 0,
//         title: const Text('Care Connect', style: TextStyle(color: Colors.white)),
//         leading: IconButton(
//           icon: const Icon(Icons.menu, color: Colors.white),
//           onPressed: () {
//             _scaffoldKey.currentState?.openDrawer();
//           },
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.notifications_outlined, color: Colors.white),
//             onPressed: () {
//               // Handle notifications
//             },
//           ),
//         ],
//       ),
//       drawer: CustomDrawer(
//         onNavigate: navigateFromDrawer,
//         currentIndex: _selectedIndex,
//       ),
//       body: FadeTransition(
//         opacity: _fadeAnimation,
//         child: IndexedStack(
//           index: _selectedIndex,
//           children: _screens,
//         ),
//       ),
//       bottomNavigationBar: Container(
//         decoration: BoxDecoration(
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.1),
//               blurRadius: 10,
//               spreadRadius: 0,
//             ),
//           ],
//         ),
//         child: ClipRRect(
//           borderRadius: const BorderRadius.only(
//             topLeft: Radius.circular(20),
//             topRight: Radius.circular(20),
//           ),
//           child: BottomNavigationBar(
//             currentIndex: _selectedIndex,
//             onTap: (index) {
//               setState(() {
//                 _selectedIndex = index;
//               });
//             },
//             type: BottomNavigationBarType.fixed,
//             backgroundColor: Colors.white,
//             selectedItemColor: const Color(0xFF00A86B),
//             unselectedItemColor: Colors.grey.shade500,
//             selectedLabelStyle: const TextStyle(
//               fontWeight: FontWeight.w600,
//               fontSize: 12,
//             ),
//             unselectedLabelStyle: const TextStyle(
//               fontWeight: FontWeight.normal,
//               fontSize: 11,
//             ),
//             elevation: 0,
//             items: [
//               bottomNavItem(Icons.home_outlined, Icons.home, 'Home'),
//               bottomNavItem(Icons.join_inner_outlined, Icons.join_inner, 'Join'),
//               bottomNavItem(Icons.volunteer_activism_outlined, Icons.volunteer_activism, 'Donate'),
//               bottomNavItem(Icons.person_outline, Icons.person, 'Profile'),
//               bottomNavItem(Icons.settings_outlined, Icons.settings, 'Settings'),
//             ],
//           ),
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.push(
//             context, 
//             MaterialPageRoute(builder: (context) => ReportScreen())
//           );
//         },
//         backgroundColor: const Color(0xFF00A86B),
//         child: const Icon(Icons.add_alert, color: Colors.white),
//         elevation: 8,
//       ),
//     );
//   }

//   BottomNavigationBarItem bottomNavItem(IconData unselectedIcon, IconData selectedIcon, String label) {
//     return BottomNavigationBarItem(
//       icon: Padding(
//         padding: const EdgeInsets.only(bottom: 4),
//         child: Icon(_selectedIndex == getIndexFromLabel(label) ? selectedIcon : unselectedIcon),
//       ),
//       label: label,
//     );
//   }

//   int getIndexFromLabel(String label) {
//     switch (label) {
//       case 'Home': return 0;
//       case 'Join': return 1;
//       case 'Donate': return 2;
//       case 'Profile': return 3;
//       case 'Settings': return 4;
//       default: return 0;
//     }
//   }
// }


import 'package:care__connect/screens/User/DonationTypeScreen.dart';
import 'package:care__connect/screens/User/nearest_ngo_screen.dart';
import 'package:care__connect/screens/User/profile_screen.dart';
import 'package:care__connect/screens/User/report_screen.dart';
import 'package:care__connect/screens/User/setting_screen.dart';
import 'package:care__connect/screens/User/user_ngo_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:care__connect/screens/User/widgets/custom_drawer.dart';
import 'home_screen.dart';
import 'package:care__connect/screens/User/widgets/join_status.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:care__connect/services/auth_service.dart';
import 'package:care__connect/screens/login_screen.dart';


class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // List of Primary Screens (only tabs)
  final List<Widget> _screens = [
    HomeScreen(),
    UserNGOListScreen(),
    DonationTypeScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

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

  // Navigation from drawer
  void navigateFromDrawer(int index) {
    if (index < 3) {
      // Home, Join, Donate tabs
      setState(() {
        _selectedIndex = index;
      });
      Navigator.pop(context);
    } 

    else if(index == 3){
      Navigator.pop(context); // Close drawer
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => JoinStatusScreen()),
      );
    }
    
    else if (index == 4) {
      Navigator.pop(context); // Close drawer
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProfileScreen()),
      );
    } else if (index == 6) {
      _signOut(context);
    }
    else if(index == 5){
      Navigator.pop(context); // Close drawer
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => NearestNGOScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: const Color(0xFF00A86B),
        elevation: 0,
        title: const Text('Care Connect', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.white),
            onPressed: () {
              // Handle notifications
            },
          ),
        ],
      ),
      drawer: CustomDrawer(
        onNavigate: navigateFromDrawer,
        currentIndex: _selectedIndex,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: IndexedStack(
          index: _selectedIndex,
          children: _screens,
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 0,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedItemColor: const Color(0xFF00A86B),
            unselectedItemColor: Colors.grey.shade500,
            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 11,
            ),
            elevation: 0,
            items: [
              bottomNavItem(Icons.home_outlined, Icons.home, 'Home'),
              bottomNavItem(Icons.join_inner_outlined, Icons.join_inner, 'Join'),
              bottomNavItem(Icons.volunteer_activism_outlined, Icons.volunteer_activism, 'Donate'),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context, 
            MaterialPageRoute(builder: (context) => ReportScreen())
          );
        },
        backgroundColor: const Color(0xFF00A86B),
        child: const Icon(Icons.add_alert, color: Colors.white),
        elevation: 8,
      ),
    );
  }

  BottomNavigationBarItem bottomNavItem(IconData unselectedIcon, IconData selectedIcon, String label) {
    return BottomNavigationBarItem(
      icon: Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Icon(_selectedIndex == getIndexFromLabel(label) ? selectedIcon : unselectedIcon),
      ),
      label: label,
    );
  }

  int getIndexFromLabel(String label) {
    switch (label) {
      case 'Home': return 0;
      case 'Join': return 1;
      case 'Donate': return 2;
      default: return 0;
    }
  }
}