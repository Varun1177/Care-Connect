// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class ProfileScreen extends StatefulWidget {
//   @override
//   _ProfileScreenState createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _animationController;
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   String userEmail = "Loading...";
//   String profileImageUrl = "";
//   double userRating = 0.0;
//   List<String> ngosJoined = [];
//   List<String> drivesAttended = [];
//   List<String> drivesApplied = [];
//   List<String> donationsMade = [];

//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       vsync: this,
//       duration: Duration(milliseconds: 300),
//     );
//     _fetchUserData();
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }

//   Future<void> _fetchUserData() async {
//   try {
//     await Future.delayed(Duration(seconds: 2)); // Ensure Firebase initializes
//     User? user = _auth.currentUser;

//     if (user == null) {
//       print("User is null, they might not be signed in.");
//       return;
//     }

//     print("User found: ${user.uid}");
//     print("Fetching Firestore data...");

//     DocumentSnapshot userData =
//         await _firestore.collection('donations').doc(user.uid).get();

//     print("Fetched Firestore data: ${userData.data()}");

//     setState(() {
//       userEmail = user.email ?? "No Email";
//       profileImageUrl = user.photoURL ?? ""; // Get profile image from Google

//       //userRating = (userData['rating'] ?? 0).toDouble();
//       //ngosJoined = List<String>.from(userData['ngosJoined'] ?? []);
//       //drivesAttended = List<String>.from(userData['drivesAttended'] ?? []);
//       //drivesApplied = List<String>.from(userData['drivesApplied'] ?? []);
//       donationsMade = [userData['amount'].toString()];
//     });

//     print("✅ User Email: $userEmail");
//     print("✅ Profile Image URL: $profileImageUrl");

//   } catch (e) {
//     print("❌ Error fetching user data: $e");
//   }
// }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("My Profile"), backgroundColor: Colors.orange),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Center(
//               child: Column(
//                 children: [
//                   CircleAvatar(
//                     radius: 40,
//                     backgroundColor: Colors.orange,
//                     backgroundImage: profileImageUrl.isNotEmpty
//                         ? NetworkImage(profileImageUrl)
//                         : null,
//                     child: profileImageUrl.isEmpty
//                         ? Icon(Icons.person, size: 50, color: Colors.white)
//                         : null,
//                   ),
//                   SizedBox(height: 10),
//                   Text(
//                     userEmail,
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                   SizedBox(height: 5),
//                   _buildRatingStars(userRating),
//                   SizedBox(height: 20),
//                 ],
//               ),
//             ),
//             Expanded(
//               child: ListView(
//                 children: [
//                   _buildProfileSection("NGOs Joined", ngosJoined),
//                   _buildProfileSection("Drives Attended", drivesAttended),
//                   _buildProfileSection("Drives Applied To", drivesApplied),
//                   _buildProfileSection("Donations Made", donationsMade),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildRatingStars(double rating) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: List.generate(5, (index) {
//         return Icon(
//           index < rating ? Icons.star : Icons.star_border,
//           color: Colors.orange,
//         );
//       }),
//     );
//   }

//   Widget _buildProfileSection(String title, List<String> items) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//         SizedBox(height: 10),
//         Column(
//           children: items.isEmpty
//               ? [Text("No data available", style: TextStyle(color: Colors.grey))]
//               : items.map((item) => _buildProfileItem(item)).toList(),
//         ),
//         SizedBox(height: 20),
//       ],
//     );
//   }

//   Widget _buildProfileItem(String item) {
//     return GestureDetector(
//       onTap: () {
//         _animationController.forward().then((_) => _animationController.reverse());
//         _showDetailsPopup(item);
//       },
//       child: ScaleTransition(
//         scale: Tween(begin: 1.0, end: 1.05).animate(
//           CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
//         ),
//         child: Container(
//           margin: EdgeInsets.symmetric(vertical: 5),
//           padding: EdgeInsets.all(12),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(10),
//             border: Border.all(color: Colors.orange),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.orange.withOpacity(0.3),
//                 blurRadius: 8,
//                 spreadRadius: 1,
//                 offset: Offset(0, 4),
//               ),
//             ],
//           ),
//           child: Row(
//             children: [
//               Icon(Icons.check_circle, color: Colors.orange),
//               SizedBox(width: 10),
//               Expanded(child: Text(item, style: const TextStyle(fontSize: 16,color: Colors.black))),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void _showDetailsPopup(String item) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text("Details"),
//           content: Text("$item - More information coming soon!"),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: Text("OK", style: TextStyle(color: Colors.orange)),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String userName = "Loading...";
  String userEmail = "Loading...";
  String profileImageUrl = "";
  double userRating = 0.0;
  List<String> ngosJoined = [];
  List<String> drivesAttended = [];
  List<String> drivesApplied = [];
  List<String> donationsMade = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );
    _animationController.forward();
    _fetchUserData();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _fetchUserData() async {
    try {
      await Future.delayed(
          const Duration(seconds: 1)); // Ensure Firebase initializes
      User? user = _auth.currentUser;

      if (user == null) {
        print("User is null, they might not be signed in.");
        setState(() {
          isLoading = false;
        });
        return;
      }

      print("User found: ${user.uid}");
      print("Fetching Firestore data...");

      DocumentSnapshot userData =
          await _firestore.collection('donations').doc(user.uid).get();

      print("Fetched Firestore data: ${userData.data()}");

      setState(() {
        userName = user.displayName ?? "User";
        userEmail = user.email ?? "No Email";
        profileImageUrl = user.photoURL ?? "";

        // For demo purposes, adding some example data if not available
        ngosJoined = ["Care Foundation", "Green Earth"];
        drivesAttended = ["Food Drive - March", "Clothing Drive - February"];
        drivesApplied = ["Beach Cleanup - Upcoming"];

        // Try to get real donation data if available
        if (userData.exists && userData.data() != null) {
          var data = userData.data() as Map<String, dynamic>;
          if (data.containsKey('amount')) {
            donationsMade = ["\$${data['amount']}"];
          } else {
            donationsMade = ["\$25.00", "\$50.00"];
          }
        } else {
          donationsMade = ["\$25.00", "\$50.00"];
        }

        isLoading = false;
      });

      print("✅ User Email: $userEmail");
      print("✅ Profile Image URL: $profileImageUrl");
    } catch (e) {
      print("❌ Error fetching user data: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF00A86B),
              ),
            )
          : FadeTransition(
              opacity: _fadeAnimation,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.bottomCenter,
                      children: [
                        // Header gradient background
                        Container(
                          height: screenSize.height * 0.25,
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFF00A86B), Color(0xFF009160)],
                            ),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(40),
                              bottomRight: Radius.circular(40),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.arrow_back_ios_new,
                                    color: Colors.white),
                                onPressed: () => Navigator.pop(context),
                              ),
                              const Text(
                                'My Profile',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.settings_outlined,
                                    color: Colors.white),
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ),
                        // Profile image
                        Positioned(
                          bottom: -50,
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: CircleAvatar(
                              radius: 55,
                              backgroundColor: Colors.grey.shade200,
                              backgroundImage: profileImageUrl.isNotEmpty
                                  ? NetworkImage(profileImageUrl)
                                  : null,
                              child: profileImageUrl.isEmpty
                                  ? const Icon(Icons.person,
                                      size: 55, color: Color(0xFF00A86B))
                                  : null,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 60),
                    // User info section
                    Column(
                      children: [
                        Text(
                          userName,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          userEmail,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildRatingStars(userRating),
                      ],
                    ),
                    const SizedBox(height: 30),
                    // Stats row
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildStatItem("NGOs", ngosJoined.length.toString()),
                          _buildDivider(),
                          _buildStatItem(
                              "Drives", drivesAttended.length.toString()),
                          _buildDivider(),
                          _buildStatItem(
                              "Donations", donationsMade.length.toString()),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    // Activity sections
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          _buildProfileSection("NGOs Joined", ngosJoined,
                              FontAwesomeIcons.handshake),
                          _buildProfileSection("Drives Attended",
                              drivesAttended, FontAwesomeIcons.calendarCheck),
                          _buildProfileSection("Drives Applied To",
                              drivesApplied, FontAwesomeIcons.calendarPlus),
                          _buildProfileSection("Donations Made", donationsMade,
                              FontAwesomeIcons.handHoldingUsd),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 40,
      width: 1,
      color: Colors.grey.shade300,
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF00A86B),
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildRatingStars(double rating) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return Icon(
          index < rating ? Icons.star : Icons.star_border,
          color: const Color(0xFF00A86B),
          size: 20,
        );
      }),
    );
  }

  Widget _buildProfileSection(
      String title, List<String> items, IconData sectionIcon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(sectionIcon, color: const Color(0xFF00A86B), size: 18),
            const SizedBox(width: 8),
            Text(title,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 15),
        items.isEmpty
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Text("No data available",
                      style: TextStyle(color: Colors.grey.shade500)),
                ),
              )
            : Column(
                children: items.map((item) => _buildProfileItem(item)).toList(),
              ),
        const SizedBox(height: 25),
      ],
    );
  }

  Widget _buildProfileItem(String item) {
    return GestureDetector(
      onTap: () {
        _animationController.reset();
        _animationController.forward();
        _showDetailsPopup(item);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 8,
              spreadRadius: 1,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF00A86B).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.check_circle_outline,
                color: Color(0xFF00A86B),
                size: 20,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                item,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Color(0xFF00A86B),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  void _showDetailsPopup(String item) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 5,
                  blurRadius: 10,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00A86B).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.info_outline,
                    color: Color(0xFF00A86B),
                    size: 30,
                  ),
                ),
                const SizedBox(height: 15),
                const Text(
                  "Details",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  "$item - More information coming soon!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00A86B),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text(
                      "OK",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
