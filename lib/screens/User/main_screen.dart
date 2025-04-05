// import 'package:care__connect/screens/User/DonationTypeScreen.dart';
// import 'package:care__connect/screens/User/donate_screen.dart';
// import 'package:care__connect/screens/User/report_screen.dart';
// import 'package:care__connect/screens/User/setting_screen.dart';
// import 'package:flutter/material.dart';
// import 'home_screen.dart';
// import 'profile_screen.dart';


// class MainScreen extends StatefulWidget {
//   @override
//   _MainScreenState createState() => _MainScreenState();
// }

// class _MainScreenState extends State<MainScreen> {
//   int _selectedIndex = 0;

//   // List of Screens
//   final List<Widget> _screens = [
//     HomeScreen(),
//     DonationTypeScreen(),
//     ProfileScreen(), 
//     SettingsScreen(), 
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: IndexedStack(
//         index: _selectedIndex,
//         children: _screens,
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _selectedIndex,
//         onTap: (index) {
//           setState(() {
//             _selectedIndex = index;
//           });
//         },
//         type: BottomNavigationBarType.fixed,
//         selectedItemColor: Colors.orange,
//         unselectedItemColor: Colors.grey,
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.volunteer_activism),
//             label: 'Donate',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person),
//             label: 'Profile',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.settings),
//             label: 'Settings',
//           ),
//         ],
//       ),
//     );
//   }
// }


import 'package:care__connect/screens/User/DonationTypeScreen.dart';
import 'package:care__connect/screens/User/report_screen.dart';
import 'package:care__connect/screens/User/setting_screen.dart';
import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // List of Screens
  final List<Widget> _screens = [
    HomeScreen(),
    DonationTypeScreen(),
    ProfileScreen(),
    SettingsScreen(),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              bottomNavItem(Icons.volunteer_activism_outlined, Icons.volunteer_activism, 'Donate'),
              bottomNavItem(Icons.person_outline, Icons.person, 'Profile'),
              bottomNavItem(Icons.settings_outlined, Icons.settings, 'Settings'),
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
      case 'Donate': return 1;
      case 'Profile': return 2;
      case 'Settings': return 3;
      default: return 0;
    }
  }
}