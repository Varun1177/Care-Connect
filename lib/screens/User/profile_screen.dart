// // import 'package:care__connect/screens/User/setting_screen.dart';
// // import 'package:flutter/material.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// // class ProfileScreen extends StatefulWidget {
// //   const ProfileScreen({Key? key}) : super(key: key);

// //   @override
// //   _ProfileScreenState createState() => _ProfileScreenState();
// // }

// // class _ProfileScreenState extends State<ProfileScreen>
// //     with SingleTickerProviderStateMixin {
// //   late AnimationController _animationController;
// //   late Animation<double> _fadeAnimation;
// //   final FirebaseAuth _auth = FirebaseAuth.instance;
// //   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

// //   String userName = "Loading...";
// //   String userEmail = "Loading...";
// //   String profileImageUrl = "";
// //   double userRating = 0.0;
// //   List<String> ngosJoined = [];
// //   List<String> drivesAttended = [];
// //   List<String> drivesApplied = [];
// //   List<String> donationsMade = [];
// //   bool isLoading = true;

// //   @override
// //   void initState() {
// //     super.initState();
// //     _animationController = AnimationController(
// //       vsync: this,
// //       duration: const Duration(milliseconds: 1200),
// //     );
// //     _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
// //       CurvedAnimation(
// //         parent: _animationController,
// //         curve: Curves.easeIn,
// //       ),
// //     );
// //     _animationController.forward();
// //     _fetchUserData();
// //   }

// //   @override
// //   void dispose() {
// //     _animationController.dispose();
// //     super.dispose();
// //   }

// //   Future<void> _fetchUserData() async {
// //     try {
// //       await Future.delayed(const Duration(seconds: 1));
// //       User? user = _auth.currentUser;

// //       if (user == null) {
// //         print("User is null, they might not be signed in.");
// //         setState(() {
// //           isLoading = false;
// //         });
// //         return;
// //       }

// //       print("User found: ${user.uid}");
// //       print("Fetching Firestore donation data...");

// //       // Fetch all donations made by the user
// //       QuerySnapshot donationSnapshot = await _firestore
// //           .collection('donations')
// //           .where('userId', isEqualTo: user.uid)
// //           .get();

// //       List<String> fetchedDonations = [];

// //       for (var doc in donationSnapshot.docs) {
// //         var donation = doc.data() as Map<String, dynamic>;

// //         double amount = 0.0;
// //         String ngoName = "Unknown NGO";

// //         // Check and parse amount
// //         if (donation['amount'] != null) {
// //           amount = (donation['amount'] as num).toDouble();
// //         }

// //         // Check for valid ngoId
// //         if (donation['ngoId'] != null && donation['ngoId'] is String) {
// //           String ngoId = donation['ngoId'];

// //           try {
// //             DocumentSnapshot ngoSnapshot =
// //                 await _firestore.collection('ngos').doc(ngoId).get();

// //             if (ngoSnapshot.exists) {
// //               var ngoData = ngoSnapshot.data() as Map<String, dynamic>?;
// //               if (ngoData != null && ngoData.containsKey('name')) {
// //                 ngoName = ngoData['name'];
// //               }
// //             }
// //           } catch (e) {
// //             print("⚠️ Error fetching NGO with ID $ngoId: $e");
// //           }
// //         }

// //         fetchedDonations.add('$ngoName: \$${amount.toStringAsFixed(2)}');
// //       }

// //       setState(() {
// //         userName = user.displayName ?? "User";
// //         userEmail = user.email ?? "No Email";
// //         profileImageUrl = user.photoURL ?? "";

// //         ngosJoined = ["Care Foundation", "Green Earth"];
// //         drivesAttended = ["Food Drive - March", "Clothing Drive - February"];
// //         drivesApplied = ["Beach Cleanup - Upcoming"];

// //         donationsMade = fetchedDonations.isNotEmpty
// //             ? fetchedDonations
// //             : ["No donations made yet"];

// //         isLoading = false;
// //       });

// //       print("✅ User Email: $userEmail");
// //       print("✅ Profile Image URL: $profileImageUrl");
// //     } catch (e) {
// //       print("❌ Error fetching user data: $e");
// //       setState(() {
// //         isLoading = false;
// //         donationsMade = ["Error loading donations"];
// //       });
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final screenSize = MediaQuery.of(context).size;

// //     return Scaffold(
// //       backgroundColor: Colors.white,
// //       body: isLoading
// //           ? const Center(
// //               child: CircularProgressIndicator(
// //                 color: Color(0xFF00A86B),
// //               ),
// //             )
// //           : FadeTransition(
// //               opacity: _fadeAnimation,
// //               child: SingleChildScrollView(
// //                 child: Column(
// //                   children: [
// //                     Stack(
// //                       clipBehavior: Clip.none,
// //                       alignment: Alignment.bottomCenter,
// //                       children: [
// //                         // Header gradient background
// //                         Container(
// //                           height: screenSize.height * 0.25,
// //                           width: double.infinity,
// //                           decoration: const BoxDecoration(
// //                             gradient: LinearGradient(
// //                               begin: Alignment.topLeft,
// //                               end: Alignment.bottomRight,
// //                               colors: [Color(0xFF00A86B), Color(0xFF009160)],
// //                             ),
// //                             borderRadius: BorderRadius.only(
// //                               bottomLeft: Radius.circular(40),
// //                               bottomRight: Radius.circular(40),
// //                             ),
// //                           ),
// //                           child: Stack(
// //                             children: [
// //                               const Align(
// //                                 alignment: Alignment.center,
// //                                 child: Text(
// //                                   'My Profile',
// //                                   style: TextStyle(
// //                                     color: Colors.white,
// //                                     fontSize: 22,
// //                                     fontWeight: FontWeight.bold,
// //                                   ),
// //                                 ),
// //                               ),
// //                               Align(
// //                                 alignment: Alignment.centerRight,
// //                                 child: IconButton(
// //                                   icon: const Icon(Icons.settings_outlined,
// //                                       color: Colors.white),
// //                                   onPressed: () {
// //                                     Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsScreen()));
// //                                   },
// //                                 ),
// //                               ),
// //                             ],
// //                           ),
// //                         ),
// //                         // Profile image
// //                         Positioned(
// //                           bottom: -50,
// //                           child: Container(
// //                             padding: const EdgeInsets.all(5),
// //                             decoration: BoxDecoration(
// //                               color: Colors.white,
// //                               shape: BoxShape.circle,
// //                               boxShadow: [
// //                                 BoxShadow(
// //                                   color: Colors.black.withOpacity(0.1),
// //                                   blurRadius: 20,
// //                                   spreadRadius: 5,
// //                                 ),
// //                               ],
// //                             ),
// //                             child: CircleAvatar(
// //                               radius: 55,
// //                               backgroundColor: Colors.grey.shade200,
// //                               backgroundImage: profileImageUrl.isNotEmpty
// //                                   ? NetworkImage(profileImageUrl)
// //                                   : null,
// //                               child: profileImageUrl.isEmpty
// //                                   ? const Icon(Icons.person,
// //                                       size: 55, color: Color(0xFF00A86B))
// //                                   : null,
// //                             ),
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                     const SizedBox(height: 60),
// //                     // User info section
// //                     Column(
// //                       children: [
// //                         Text(
// //                           userName,
// //                           style: const TextStyle(
// //                             fontSize: 22,
// //                             fontWeight: FontWeight.bold,
// //                           ),
// //                         ),
// //                         const SizedBox(height: 5),
// //                         Text(
// //                           userEmail,
// //                           style: TextStyle(
// //                             fontSize: 16,
// //                             color: Colors.grey.shade600,
// //                           ),
// //                         ),
// //                         const SizedBox(height: 8),
// //                         _buildRatingStars(userRating),
// //                       ],
// //                     ),
// //                     const SizedBox(height: 30),
// //                     // Stats row
// //                     Padding(
// //                       padding: const EdgeInsets.symmetric(horizontal: 20),
// //                       child: Row(
// //                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// //                         children: [
// //                           _buildStatItem("NGOs", ngosJoined.length.toString()),
// //                           _buildDivider(),
// //                           _buildStatItem(
// //                               "Drives", drivesAttended.length.toString()),
// //                           _buildDivider(),
// //                           _buildStatItem(
// //                               "Donations", donationsMade.length.toString()),
// //                         ],
// //                       ),
// //                     ),
// //                     const SizedBox(height: 30),
// //                     // Activity sections
// //                     Padding(
// //                       padding: const EdgeInsets.symmetric(horizontal: 20),
// //                       child: Column(
// //                         children: [
// //                           _buildProfileSection("NGOs Joined", ngosJoined,
// //                               FontAwesomeIcons.handshake),
// //                           _buildProfileSection("Drives Attended",
// //                               drivesAttended, FontAwesomeIcons.calendarCheck),
// //                           _buildProfileSection("Drives Applied To",
// //                               drivesApplied, FontAwesomeIcons.calendarPlus),
// //                           _buildProfileSection("Donations Made", donationsMade,
// //                               FontAwesomeIcons.handHoldingUsd),
// //                         ],
// //                       ),
// //                     ),
// //                     const SizedBox(height: 20),
// //                   ],
// //                 ),
// //               ),
// //             ),
// //     );
// //   }

// //   Widget _buildDivider() {
// //     return Container(
// //       height: 40,
// //       width: 1,
// //       color: Colors.grey.shade300,
// //     );
// //   }

// //   Widget _buildStatItem(String label, String value) {
// //     return Column(
// //       children: [
// //         Text(
// //           value,
// //           style: const TextStyle(
// //             fontSize: 22,
// //             fontWeight: FontWeight.bold,
// //             color: Color(0xFF00A86B),
// //           ),
// //         ),
// //         Text(
// //           label,
// //           style: TextStyle(
// //             fontSize: 14,
// //             color: Colors.grey.shade600,
// //           ),
// //         ),
// //       ],
// //     );
// //   }

// //   Widget _buildRatingStars(double rating) {
// //     return Row(
// //       mainAxisAlignment: MainAxisAlignment.center,
// //       children: List.generate(5, (index) {
// //         return Icon(
// //           index < rating ? Icons.star : Icons.star_border,
// //           color: const Color(0xFF00A86B),
// //           size: 20,
// //         );
// //       }),
// //     );
// //   }

// //   Widget _buildProfileSection(
// //       String title, List<String> items, IconData sectionIcon) {
// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         Row(
// //           children: [
// //             Icon(sectionIcon, color: const Color(0xFF00A86B), size: 18),
// //             const SizedBox(width: 8),
// //             Text(title,
// //                 style:
// //                     const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
// //           ],
// //         ),
// //         const SizedBox(height: 15),
// //         items.isEmpty
// //             ? Center(
// //                 child: Padding(
// //                   padding: const EdgeInsets.all(15),
// //                   child: Text("No data available",
// //                       style: TextStyle(color: Colors.grey.shade500)),
// //                 ),
// //               )
// //             : Column(
// //                 children: items.map((item) => _buildProfileItem(item)).toList(),
// //               ),
// //         const SizedBox(height: 25),
// //       ],
// //     );
// //   }

// //   Widget _buildProfileItem(String item) {
// //     return GestureDetector(
// //       onTap: () {
// //         _animationController.reset();
// //         _animationController.forward();
// //         _showDetailsPopup(item);
// //       },
// //       child: Container(
// //         margin: const EdgeInsets.only(bottom: 12),
// //         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
// //         decoration: BoxDecoration(
// //           color: Colors.white,
// //           borderRadius: BorderRadius.circular(15),
// //           boxShadow: [
// //             BoxShadow(
// //               color: Colors.grey.withOpacity(0.1),
// //               blurRadius: 8,
// //               spreadRadius: 1,
// //               offset: const Offset(0, 2),
// //             ),
// //           ],
// //           border: Border.all(color: Colors.grey.shade200),
// //         ),
// //         child: Row(
// //           children: [
// //             Container(
// //               padding: const EdgeInsets.all(8),
// //               decoration: BoxDecoration(
// //                 color: const Color(0xFF00A86B).withOpacity(0.1),
// //                 borderRadius: BorderRadius.circular(10),
// //               ),
// //               child: const Icon(
// //                 Icons.check_circle_outline,
// //                 color: Color(0xFF00A86B),
// //                 size: 20,
// //               ),
// //             ),
// //             const SizedBox(width: 15),
// //             Expanded(
// //               child: Text(
// //                 item,
// //                 style: const TextStyle(
// //                   fontSize: 16,
// //                   fontWeight: FontWeight.w500,
// //                 ),
// //               ),
// //             ),
// //             const Icon(
// //               Icons.arrow_forward_ios,
// //               color: Color(0xFF00A86B),
// //               size: 16,
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   void _showDetailsPopup(String item) {
// //     showDialog(
// //       context: context,
// //       builder: (context) {
// //         return Dialog(
// //           shape: RoundedRectangleBorder(
// //             borderRadius: BorderRadius.circular(20),
// //           ),
// //           elevation: 0,
// //           backgroundColor: Colors.transparent,
// //           child: Container(
// //             padding: const EdgeInsets.all(20),
// //             decoration: BoxDecoration(
// //               color: Colors.white,
// //               borderRadius: BorderRadius.circular(20),
// //               boxShadow: [
// //                 BoxShadow(
// //                   color: Colors.black.withOpacity(0.1),
// //                   spreadRadius: 5,
// //                   blurRadius: 10,
// //                 ),
// //               ],
// //             ),
// //             child: Column(
// //               mainAxisSize: MainAxisSize.min,
// //               children: [
// //                 Container(
// //                   padding: const EdgeInsets.all(15),
// //                   decoration: BoxDecoration(
// //                     color: const Color(0xFF00A86B).withOpacity(0.1),
// //                     shape: BoxShape.circle,
// //                   ),
// //                   child: const Icon(
// //                     Icons.info_outline,
// //                     color: Color(0xFF00A86B),
// //                     size: 30,
// //                   ),
// //                 ),
// //                 const SizedBox(height: 15),
// //                 const Text(
// //                   "Details",
// //                   style: TextStyle(
// //                     fontSize: 20,
// //                     fontWeight: FontWeight.bold,
// //                   ),
// //                 ),
// //                 const SizedBox(height: 15),
// //                 Text(
// //                   "$item - More information coming soon!",
// //                   textAlign: TextAlign.center,
// //                   style: TextStyle(
// //                     fontSize: 16,
// //                     color: Colors.grey.shade700,
// //                   ),
// //                 ),
// //                 const SizedBox(height: 20),
// //                 SizedBox(
// //                   width: double.infinity,
// //                   child: ElevatedButton(
// //                     onPressed: () => Navigator.pop(context),
// //                     style: ElevatedButton.styleFrom(
// //                       backgroundColor: const Color(0xFF00A86B),
// //                       foregroundColor: Colors.white,
// //                       padding: const EdgeInsets.symmetric(vertical: 14),
// //                       shape: RoundedRectangleBorder(
// //                         borderRadius: BorderRadius.circular(15),
// //                       ),
// //                     ),
// //                     child: const Text(
// //                       "OK",
// //                       style: TextStyle(
// //                         fontSize: 16,
// //                         fontWeight: FontWeight.bold,
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         );
// //       },
// //     );
// //   }
// // }


import 'package:care__connect/screens/User/setting_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//import 'package:geolocator/geolocator.dart'; // Removed geolocator
//import 'package:geocoding/geocoding.dart'; // Removed geocoding dependency
//import 'package:intl/intl.dart';

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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // User profile data
  String userName = "Loading...";
  String userEmail = "Loading...";
  String profileImageUrl = "";
  String userPhone = "";
  String userAddress = "";
  String userLocation = "";
  String userAge = "";
  double userRating = 0.0;
  double profileCompletionPercentage = 0.0;
  
  // Activity data
  List<String> ngosJoined = [];
  List<String> drivesAttended = [];
  List<String> drivesApplied = [];
  List<String> donationsMade = [];
  bool isLoading = true;
  bool isEditing = false;

  // Controllers for editable fields
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController addressController;
  late TextEditingController ageController;
  late TextEditingController locationController;

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
    
    // Initialize controllers
    nameController = TextEditingController();
    phoneController = TextEditingController();
    addressController = TextEditingController();
    ageController = TextEditingController();
    locationController = TextEditingController();
    
    _animationController.forward();
    _fetchUserData();
  }

  @override
  void dispose() {
    _animationController.dispose();
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    ageController.dispose();
    locationController.dispose();
    super.dispose();
  }

  void _calculateProfileCompletion() {
    int totalFields = 5; // name, phone, address, location, age (email and profile pic are prefilled)
    int filledFields = 0;
    
    if (userName != "Loading..." && userName.isNotEmpty) filledFields++;
    if (userPhone.isNotEmpty) filledFields++;
    if (userAddress.isNotEmpty) filledFields++;
    if (userLocation.isNotEmpty) filledFields++;
    if (userAge.isNotEmpty) filledFields++;
    
    setState(() {
      profileCompletionPercentage = (filledFields / totalFields) * 100;
    });
  }

  // Manual location update instead of using geolocator
  void _showLocationDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Enter Your Location'),
          content: TextField(
            controller: locationController,
            decoration: const InputDecoration(
              hintText: 'City, State/Province, Country',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _updateLocation(locationController.text);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00A86B),
                foregroundColor: Colors.white,
              ),
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateLocation(String location) async {
    if (location.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid location'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    setState(() {
      isLoading = true;
    });
    
    try {
      setState(() {
        userLocation = location;
        isLoading = false;
      });
      
      // Save to Firestore
      User? user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('user_data').doc(user.uid).update({
          'location': location,
          'lastUpdated': FieldValue.serverTimestamp(),
        });
      }
      
      _calculateProfileCompletion();
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Location updated successfully'),
          backgroundColor: Color(0xFF00A86B),
        ),
      );
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating location: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _fetchUserData() async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      User? user = _auth.currentUser;

      if (user == null) {
        print("User is null, they might not be signed in.");
        setState(() {
          isLoading = false;
        });
        return;
      }

      print("User found: ${user.uid}");
      
      // First check if user_data document exists
      DocumentSnapshot userDataSnapshot = await _firestore
          .collection('user_data')
          .doc(user.uid)
          .get();
      
      // Fetch all donations made by the user
      QuerySnapshot donationSnapshot = await _firestore
          .collection('donations')
          .where('userId', isEqualTo: user.uid)
          .get();

      List<String> fetchedDonations = [];

      for (var doc in donationSnapshot.docs) {
        var donation = doc.data() as Map<String, dynamic>;

        double amount = 0.0;
        String ngoName = "Unknown NGO";

        // Check and parse amount
        if (donation['amount'] != null) {
          amount = (donation['amount'] as num).toDouble();
        }

        // Check for valid ngoId
        if (donation['ngoId'] != null && donation['ngoId'] is String) {
          String ngoId = donation['ngoId'];

          try {
            DocumentSnapshot ngoSnapshot =
                await _firestore.collection('ngos').doc(ngoId).get();

            if (ngoSnapshot.exists) {
              var ngoData = ngoSnapshot.data() as Map<String, dynamic>?;
              if (ngoData != null && ngoData.containsKey('name')) {
                ngoName = ngoData['name'];
              }
            }
          } catch (e) {
            print("⚠️ Error fetching NGO with ID $ngoId: $e");
          }
        }

        fetchedDonations.add('$ngoName: \$${amount.toStringAsFixed(2)}');
      }

      setState(() {
        // Set basic info from Firebase Auth
        userName = user.displayName ?? "User";
        userEmail = user.email ?? "No Email";
        profileImageUrl = user.photoURL ?? "";
        
        // Set data from user_data collection if it exists
        if (userDataSnapshot.exists) {
          Map<String, dynamic>? userData = userDataSnapshot.data() as Map<String, dynamic>?;
          if (userData != null) {
            userName = userData['name'] ?? userName;
            userPhone = userData['phone'] ?? "";
            userAddress = userData['address'] ?? "";
            userLocation = userData['location'] ?? "";
            userAge = userData['age'] ?? "";
          }
        }
        
        // Setup controllers with current values
        nameController.text = userName;
        phoneController.text = userPhone;
        addressController.text = userAddress;
        ageController.text = userAge;
        locationController.text = userLocation;
        
        // Activity data
        ngosJoined = ["Care Foundation", "Green Earth"];
        drivesAttended = ["Food Drive - March", "Clothing Drive - February"];
        drivesApplied = ["Beach Cleanup - Upcoming"];
        donationsMade = fetchedDonations.isNotEmpty
            ? fetchedDonations
            : ["No donations made yet"];

        isLoading = false;
      });
      
      _calculateProfileCompletion();

      print("✅ User Email: $userEmail");
      print("✅ Profile Image URL: $profileImageUrl");
    } catch (e) {
      print("❌ Error fetching user data: $e");
      setState(() {
        isLoading = false;
        donationsMade = ["Error loading donations"];
      });
    }
  }

  Future<void> _saveUserProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    setState(() {
      isLoading = true;
    });
    
    try {
      User? user = _auth.currentUser;
      if (user == null) {
        throw Exception("User not signed in");
      }
      
      // Update state variables
      userName = nameController.text.trim();
      userPhone = phoneController.text.trim();
      userAddress = addressController.text.trim();
      userAge = ageController.text.trim();
      
      // Save to Firestore
      await _firestore.collection('user_data').doc(user.uid).set({
        'name': userName,
        'email': userEmail,
        'phone': userPhone,
        'address': userAddress,
        'location': userLocation,
        'age': userAge,
        'profileImageUrl': profileImageUrl,
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      
      // Update display name in Firebase Auth
      await user.updateDisplayName(userName);
      
      setState(() {
        isEditing = false;
        isLoading = false;
      });
      
      _calculateProfileCompletion();
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully'),
          backgroundColor: Color(0xFF00A86B),
        ),
      );
    } catch (e) {
      print("❌ Error saving user data: $e");
      setState(() {
        isLoading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating profile: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
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
                          child: Stack(
                            children: [
                              const Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'My Profile',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        isEditing ? Icons.save : Icons.edit,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        if (isEditing) {
                                          _saveUserProfile();
                                        } else {
                                          setState(() {
                                            isEditing = true;
                                          });
                                        }
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.settings_outlined,
                                        color: Colors.white
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context, 
                                          MaterialPageRoute(
                                            builder: (context) => SettingsScreen()
                                          )
                                        );
                                      },
                                    ),
                                  ],
                                ),
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
                    
                    // Profile completion indicator
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Profile Completion",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade800,
                                ),
                              ),
                              Text(
                                "${profileCompletionPercentage.toInt()}%",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF00A86B),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: LinearProgressIndicator(
                              value: profileCompletionPercentage / 100,
                              backgroundColor: Colors.grey.shade200,
                              color: const Color(0xFF00A86B),
                              minHeight: 8,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    
                    // User profile edit form
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Personal Information",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade800,
                              ),
                            ),
                            const SizedBox(height: 20),
                            
                            // Name field
                            _buildProfileField(
                              label: "Name",
                              icon: Icons.person,
                              controller: nameController,
                              isEditable: isEditing,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Name is required';
                                }
                                return null;
                              },
                            ),
                            
                            // Email field (disabled)
                            _buildProfileField(
                              label: "Email",
                              icon: Icons.email,
                              value: userEmail,
                              isEditable: false,
                            ),
                            
                            // Phone field
                            _buildProfileField(
                              label: "Phone Number",
                              icon: Icons.phone,
                              controller: phoneController,
                              isEditable: isEditing,
                              keyboardType: TextInputType.phone,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Phone number is required';
                                }
                                if (!RegExp(r'^\+?[0-9]{10,15}$').hasMatch(value)) {
                                  return 'Enter a valid phone number';
                                }
                                return null;
                              },
                            ),
                            
                            // Age field
                            _buildProfileField(
                              label: "Age",
                              icon: Icons.cake,
                              controller: ageController,
                              isEditable: isEditing,
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Age is required';
                                }
                                if (int.tryParse(value) == null || int.parse(value) < 1) {
                                  return 'Enter a valid age';
                                }
                                return null;
                              },
                            ),
                            
                            // Address field
                            _buildProfileField(
                              label: "Address",
                              icon: Icons.home,
                              controller: addressController,
                              isEditable: isEditing,
                              maxLines: 2,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Address is required';
                                }
                                return null;
                              },
                            ),
                            
                            // Location field - Manual Input
                            _buildLocationField(
                              label: "Location",
                              icon: Icons.location_on,
                              value: userLocation,
                              onLocationUpdate: _showLocationDialog,
                            ),
                            
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
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

  Widget _buildProfileField({
    required String label,
    required IconData icon,
    String? value,
    TextEditingController? controller,
    bool isEditable = false,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey.shade50,
              border: Border.all(
                color: isEditable 
                    ? const Color(0xFF00A86B).withOpacity(0.5)
                    : Colors.grey.shade200,
              ),
            ),
            child: isEditable
                ? TextFormField(
                    controller: controller,
                    validator: validator,
                    maxLines: maxLines,
                    keyboardType: keyboardType,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        icon,
                        color: const Color(0xFF00A86B),
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 15,
                      ),
                    ),
                  )
                : ListTile(
                    leading: Icon(
                      icon,
                      color: const Color(0xFF00A86B),
                    ),
                    title: Text(
                      controller?.text ?? value ?? "Not set",
                      style: TextStyle(
                        color: (controller?.text.isEmpty ?? value?.isEmpty ?? true)
                            ? Colors.grey.shade400
                            : Colors.black87,
                      ),
                    ),
                    dense: true,
                  ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildLocationField({
    required String label,
    required IconData icon,
    required String value,
    required Function onLocationUpdate,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey.shade50,
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              children: [
                Expanded(
                  child: ListTile(
                    leading: Icon(
                      icon,
                      color: const Color(0xFF00A86B),
                    ),
                    title: Text(
                      value.isEmpty ? "Not set" : value,
                      style: TextStyle(
                        color: value.isEmpty
                            ? Colors.grey.shade400
                            : Colors.black87,
                      ),
                    ),
                    dense: true,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: IconButton(
                    icon: const Icon(
                      Icons.edit_location_alt,
                      color: Color(0xFF00A86B),
                    ),
                    onPressed: () => onLocationUpdate(),
                    tooltip: "Enter location",
                  ),
                ),
              ],
            ),
          ),
        ],
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