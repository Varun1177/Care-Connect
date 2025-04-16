// // Create a new file: lib/widgets/custom_drawer.dart

// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:care__connect/screens/User/setting_screen.dart';

// class CustomDrawer extends StatefulWidget {
//   final Function(int) onNavigate;
//   final int currentIndex;

//   const CustomDrawer({
//     Key? key, 
//     required this.onNavigate,
//     required this.currentIndex,
//   }) : super(key: key);

//   @override
//   State<CustomDrawer> createState() => _CustomDrawerState();
// }

// class _CustomDrawerState extends State<CustomDrawer> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   String userName = "Loading...";
//   String userEmail = "Loading...";
//   String profileImageUrl = "";

//   @override
//   void initState() {
//     super.initState();
//     _fetchUserData();
//   }

//   Future<void> _fetchUserData() async {
//     try {
//       User? user = _auth.currentUser;

//       if (user == null) {
//         print("User is null, they might not be signed in.");
//         setState(() {});
//         return;
//       }

//       setState(() {
//         userName = user.displayName ?? "User";
//         userEmail = user.email ?? "No Email";
//         profileImageUrl = user.photoURL ?? "";
//       });
//     } catch (e) {
//       print("❌ Error fetching user data: $e");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       child: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [Color.fromARGB(255, 243, 247, 245), Color(0xFFF5F5F5)],
//           ),
//         ),
//         child: SafeArea(
//           child: Column(
//             children: [
//               // Header with user info
//               Container(
//                 padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
//                 decoration: const BoxDecoration(
//                   // gradient: LinearGradient(
//                   //   begin: Alignment.topLeft,
//                   //   end: Alignment.bottomRight,
//                   //   //colors: [Color(0xFF00A86B), Color(0xFF009160)],
//                   // ),
//                 ),
//                 child: Column(
//                   children: [
//                     // Profile image
//                     CircleAvatar(
//                       radius: 45,
//                       backgroundColor: Colors.white,
//                       child: CircleAvatar(
//                         radius: 42,
//                         backgroundColor: Colors.grey.shade200,
//                         backgroundImage: profileImageUrl.isNotEmpty
//                             ? NetworkImage(profileImageUrl)
//                             : null,
//                         child: profileImageUrl.isEmpty
//                             ? const Icon(Icons.person,
//                                 size: 40)
//                             : null,
//                       ),
//                     ),
//                     const SizedBox(height: 12),
//                     // User name
//                     Text(
//                       userName,
//                       style: const TextStyle(
//                         color: Colors.black,
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     // User email
//                     Text(
//                       userEmail,
//                       style: const TextStyle(
//                         color: Colors.black,
//                         fontSize: 14,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
              
//               // Navigation items
//               const SizedBox(height: 20),
//               _buildNavItem(0, 'Home', Icons.home),
//               _buildNavItem(1, 'Join NGOs', Icons.join_inner),
//               _buildNavItem(2, 'Donate', Icons.volunteer_activism),
//               _buildNavItem(3, 'My Profile', Icons.person),
              
//               const Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                 child: Divider(),
//               ),
              
//               _buildNavItem(4, 'Settings', Icons.settings),
              
//               // Report button at the bottom
//               const Spacer(),
//               Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: ElevatedButton.icon(
//                   onPressed: () {
//                     Navigator.pop(context);
//                     Navigator.pushNamed(context, '/report');
//                   },
//                   icon: const Icon(Icons.add_alert),
//                   label: const Text('Report an Issue'),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFF00A86B),
//                     foregroundColor: Colors.white,
//                     minimumSize: const Size(double.infinity, 45),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildNavItem(int index, String title, IconData icon) {
//     final isSelected = widget.currentIndex == index;
    
//     return ListTile(
//       leading: Icon(
//         icon,
//         color: isSelected ? const Color(0xFF00A86B) : Colors.grey.shade700,
//       ),
//       title: Text(
//         title,
//         style: TextStyle(
//           fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
//           color: isSelected ? const Color(0xFF00A86B) : Colors.grey.shade800,
//         ),
//       ),
//       selected: isSelected,
//       selectedTileColor: const Color(0xFF00A86B).withOpacity(0.1),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(10),
//       ),
//       onTap: () {
//         widget.onNavigate(index);
//         Navigator.pop(context); // Close drawer after selection
//       },
//       contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomDrawer extends StatefulWidget {
  final Function(int) onNavigate;
  final int currentIndex;

  const CustomDrawer({
    Key? key, 
    required this.onNavigate,
    required this.currentIndex,
  }) : super(key: key);

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String userName = "Loading...";
  String userEmail = "Loading...";
  String profileImageUrl = "";

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      User? user = _auth.currentUser;

      if (user == null) {
        print("User is null, they might not be signed in.");
        setState(() {});
        return;
      }

      setState(() {
        userName = user.displayName ?? "User";
        userEmail = user.email ?? "No Email";
        profileImageUrl = user.photoURL ?? "";
      });
    } catch (e) {
      print("❌ Error fetching user data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Color(0xFFF5F5F5)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header with user info
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color.fromARGB(255, 255, 255, 255), Color.fromARGB(255, 255, 255, 255)],
                  ),
                ),
                child: Column(
                  children: [
                    // Profile image
                    GestureDetector(
                      onTap: () {
                        // Navigate to profile when tapping the image
                        widget.onNavigate(3);
                      },
                      child: CircleAvatar(
                        radius: 45,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 42,
                          backgroundColor: Colors.grey.shade200,
                          backgroundImage: profileImageUrl.isNotEmpty
                              ? NetworkImage(profileImageUrl)
                              : null,
                          child: profileImageUrl.isEmpty
                              ? const Icon(Icons.person,
                                  size: 40, color: Color(0xFF00A86B))
                              : null,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // User name
                    GestureDetector(
                      onTap: () {
                        // Navigate to profile when tapping the name
                        widget.onNavigate(3);
                      },
                      child: Text(
                        userName,
                        style: const TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    // User email
                    Text(
                      userEmail,
                      style: const TextStyle(
                        color: Color.fromARGB(179, 0, 0, 0),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Navigation items
              const SizedBox(height: 20),
              _buildNavItem(0, 'Home', Icons.home),
              _buildNavItem(1, 'Join NGOs', Icons.join_inner),
              _buildNavItem(2, 'Donate', Icons.volunteer_activism),
              
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Divider(),
              ),
              
              // Profile and Settings are now separate items
              _buildNavItem(3, 'My Profile', Icons.person),
              _buildNavItem(4, 'Settings', Icons.settings),
              
              // Report button at the bottom
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/report');
                  },
                  icon: const Icon(Icons.add_alert),
                  label: const Text('Report an Issue'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00A86B),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 45),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, String title, IconData icon) {
    // Only highlight the first 3 items based on tab navigation
    final bool isSelected = index < 3 ? widget.currentIndex == index : false;
    
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? const Color(0xFF00A86B) : Colors.grey.shade700,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? const Color(0xFF00A86B) : Colors.grey.shade800,
        ),
      ),
      selected: isSelected,
      selectedTileColor: const Color(0xFF00A86B).withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      onTap: () {
        widget.onNavigate(index);
      },
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
    );
  }
}