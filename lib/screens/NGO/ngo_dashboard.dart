// // // import 'package:flutter/material.dart';
// // // import 'package:cloud_firestore/cloud_firestore.dart';
// // // import 'package:firebase_auth/firebase_auth.dart';
// // // import 'package:care__connect/services/auth_service.dart';
// // // import 'package:care__connect/screens/login_screen.dart';

// // // class NGODashboard extends StatelessWidget {

// // //   void _signOut(BuildContext context) async {
// // //     await AuthService().signOut();
// // //     Navigator.pushReplacement(
// // //       context,
// // //       MaterialPageRoute(builder: (context) => const LoginScreen()),
// // //     );
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     User? user = FirebaseAuth.instance.currentUser;
// // //     if (user == null) {
// // //       return Scaffold(
// // //         appBar: AppBar(title: const Text("NGO Dashboard",),actions: [
// // //           IconButton(
// // //             icon: const Icon(Icons.logout),
// // //             onPressed: () => _signOut(context),
// // //           ),
// // //         ],),
// // //         body: const Center(child: Text("Please log in first.")),
// // //       );
// // //     } else {
// // //       return Scaffold(
// // //         appBar: AppBar(title: const Text("NGO Dashboard"),actions: [
// // //           IconButton(
// // //             icon: const Icon(Icons.logout),
// // //             onPressed: () => _signOut(context),
// // //           ),
// // //         ],),
// // //         body: StreamBuilder<QuerySnapshot>(
// // //           stream: FirebaseFirestore.instance
// // //               .collection('ngos')
// // //               .where('email', isEqualTo: user.email)
// // //               .snapshots(), // 🔥 Listens for real-time updates!
// // //           builder: (context, approvedSnapshot) {
// // //             return StreamBuilder<QuerySnapshot>(
// // //               stream: FirebaseFirestore.instance
// // //                   .collection('pending_approvals')
// // //                   .where('email', isEqualTo: user.email)
// // //                   .snapshots(), // 🔥 Listens for real-time updates!
// // //               builder: (context, pendingSnapshot) {
// // //                 if (approvedSnapshot.connectionState ==
// // //                         ConnectionState.waiting ||
// // //                     pendingSnapshot.connectionState ==
// // //                         ConnectionState.waiting) {
// // //                   return const Center(child: CircularProgressIndicator());
// // //                 }

// // //                 // ✅ NGO is approved
// // //                 if (approvedSnapshot.hasData &&
// // //                     approvedSnapshot.data!.docs.isNotEmpty) {
// // //                   var ngoData = approvedSnapshot.data!.docs.first;
// // //                   return NGOApprovedView(ngoData: ngoData);
// // //                 }

// // //                 // 🚀 NGO is pending approval
// // //                 if (pendingSnapshot.hasData &&
// // //                     pendingSnapshot.data!.docs.isNotEmpty) {
// // //                   return PendingApprovalView();
// // //                 }

// // //                 // ❌ NGO not found
// // //                 return const Center(
// // //                   child: Text("No NGO data found. Please register first."),
// // //                 );
// // //               },
// // //             );
// // //           },
// // //         ),
// // //       );
// // //     }
// // //   }
// // // }

// // // class NGOApprovedView extends StatelessWidget {
// // //   final DocumentSnapshot ngoData;

// // //   const NGOApprovedView({required this.ngoData});

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Padding(
// // //       padding: const EdgeInsets.all(16),
// // //       child: Column(
// // //         crossAxisAlignment: CrossAxisAlignment.start,
// // //         children: [
// // //           // NGO Logo
// // //           Center(
// // //             child: CircleAvatar(
// // //               radius: 50,
// // //               backgroundImage: ngoData['logoUrl'] != null
// // //                   ? NetworkImage(ngoData['logoUrl'])
// // //                   : null,
// // //               child: ngoData['logoUrl'] == null
// // //                   ? const Icon(Icons.image, size: 40)
// // //                   : null,
// // //             ),
// // //           ),
// // //           const SizedBox(height: 15),

// // //           // NGO Details
// // //           Text("NGO Name: ${ngoData['name']}",
// // //               style:
// // //                   const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
// // //           Text("Sector: ${ngoData['sector']}",
// // //               style: const TextStyle(fontSize: 16)),
// // //           Text("Description: ${ngoData['description']}",
// // //               style: const TextStyle(fontSize: 16)),
// // //           const SizedBox(height: 20),

// // //           // Status Message
// // //           const Center(
// // //             child: Text(
// // //               "Your NGO is Approved! 🎉",
// // //               style: const TextStyle(
// // //                   fontSize: 16,
// // //                   color: Colors.green,
// // //                   fontWeight: FontWeight.bold),
// // //             ),
// // //           ),

// // //           const SizedBox(height: 30),

// // //           // Button to access NGO Features
// // //           ElevatedButton(
// // //             onPressed: () => navigateToFeature(context),
// // //             style: ElevatedButton.styleFrom(
// // //               minimumSize: const Size(double.infinity, 50),
// // //               backgroundColor: Colors.blue,
// // //             ),
// // //             child: const Text("Access NGO Features",
// // //                 style: TextStyle(fontSize: 16)),
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }

// // //   void navigateToFeature(BuildContext context) {
// // //     ScaffoldMessenger.of(context).showSnackBar(
// // //       const SnackBar(content: Text("Navigating to NGO Features...")),
// // //     );
// // //     // TODO: Navigate to NGO feature screen
// // //   }
// // // }

// // // class PendingApprovalView extends StatelessWidget {
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return const Center(
// // //       child: Text(
// // //         "Your NGO is Pending Approval 🚀",
// // //         style: TextStyle(
// // //             fontSize: 16, color: Colors.orange, fontWeight: FontWeight.bold),
// // //       ),
// // //     );
// // //   }
// // // }

// // // // import 'package:flutter/material.dart';
// // // // import 'package:cloud_firestore/cloud_firestore.dart';
// // // // import 'package:firebase_auth/firebase_auth.dart';
// // // // import 'package:care__connect/services/auth_service.dart';
// // // // import 'package:care__connect/screens/login_screen.dart';
// // // // import 'package:care__connect/screens/NGO/ngo_approved_view.dart';
// // // // import 'package:care__connect/screens/NGO/ngo_pending_view.dart';

// // // // class NGODashboard extends StatelessWidget {
// // // //   void _signOut(BuildContext context) async {
// // // //     await AuthService().signOut();
// // // //     Navigator.pushReplacement(
// // // //       context,
// // // //       MaterialPageRoute(builder: (context) => const LoginScreen()),
// // // //     );
// // // //   }

// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     User? user = FirebaseAuth.instance.currentUser;
// // // //     if (user == null) {
// // // //       return Scaffold(
// // // //         appBar: AppBar(
// // // //           title: const Text("NGO Dashboard"),
// // // //           actions: [
// // // //             IconButton(
// // // //               icon: const Icon(Icons.logout),
// // // //               onPressed: () => _signOut(context),
// // // //             ),
// // // //           ],
// // // //         ),
// // // //         body: const Center(child: Text("Please log in first.")),
// // // //       );
// // // //     }

// // // //     return Scaffold(
// // // //       appBar: AppBar(
// // // //         title: const Text("NGO Dashboard"),
// // // //         actions: [
// // // //           IconButton(
// // // //             icon: const Icon(Icons.logout),
// // // //             onPressed: () => _signOut(context),
// // // //           ),
// // // //         ],
// // // //       ),
// // // //       body: StreamBuilder<QuerySnapshot>(
// // // //         stream: FirebaseFirestore.instance
// // // //             .collection('ngos')
// // // //             .where('email', isEqualTo: user.email)
// // // //             .snapshots(),
// // // //         builder: (context, approvedSnapshot) {
// // // //           return StreamBuilder<QuerySnapshot>(
// // // //             stream: FirebaseFirestore.instance
// // // //                 .collection('pending_approvals')
// // // //                 .where('email', isEqualTo: user.email)
// // // //                 .snapshots(),
// // // //             builder: (context, pendingSnapshot) {
// // // //               if (approvedSnapshot.connectionState == ConnectionState.waiting ||
// // // //                   pendingSnapshot.connectionState == ConnectionState.waiting) {
// // // //                 return const Center(child: CircularProgressIndicator());
// // // //               }

// // // //               if (approvedSnapshot.hasData &&
// // // //                   approvedSnapshot.data!.docs.isNotEmpty) {
// // // //                 var ngoData = approvedSnapshot.data!.docs.first;
// // // //                 return NGOApprovedView(ngoData: ngoData);
// // // //               }

// // // //               if (pendingSnapshot.hasData &&
// // // //                   pendingSnapshot.data!.docs.isNotEmpty) {
// // // //                 return const NGOPendingApprovalView();
// // // //               }

// // // //               return const Center(
// // // //                 child: Text("No NGO data found. Please register first."),
// // // //               );
// // // //             },
// // // //           );
// // // //         },
// // // //       ),
// // // //     );
// // // //   }
// // // // }

// // // import 'package:flutter/material.dart';
// // // import 'package:cloud_firestore/cloud_firestore.dart';
// // // import 'package:firebase_auth/firebase_auth.dart';
// // // import 'package:care__connect/services/auth_service.dart';
// // // import 'package:care__connect/screens/login_screen.dart';
// // // import 'widgets/approved_ngo_view.dart';
// // // import 'widgets/pending_approval_view.dart';

// // // class NGODashboard extends StatelessWidget {
// // //   const NGODashboard({Key? key}) : super(key: key);

// // //   void _signOut(BuildContext context) async {
// // //     await AuthService().signOut();
// // //     Navigator.pushReplacement(
// // //       context,
// // //       MaterialPageRoute(builder: (context) => const LoginScreen()),
// // //     );
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     User? user = FirebaseAuth.instance.currentUser;

// // //     if (user == null) {
// // //       return _buildNotLoggedInView(context);
// // //     }

// // //     return Scaffold(
// // //       appBar: AppBar(
// // //         title: const Text(
// // //           "NGO Dashboard",
// // //           style: TextStyle(fontWeight: FontWeight.bold),
// // //         ),
// // //         elevation: 0,
// // //         actions: [
// // //           IconButton(
// // //             icon: const Icon(Icons.logout),
// // //             tooltip: "Logout",
// // //             onPressed: () => _signOut(context),
// // //           ),
// // //         ],
// // //       ),
// // //       body: _buildDashboardContent(context, user),
// // //     );
// // //   }

// // //   Widget _buildNotLoggedInView(BuildContext context) {
// // //     return Scaffold(
// // //       appBar: AppBar(
// // //         title: const Text("NGO Dashboard"),
// // //         elevation: 0,
// // //         actions: [
// // //           IconButton(
// // //             icon: const Icon(Icons.logout),
// // //             onPressed: () => _signOut(context),
// // //           ),
// // //         ],
// // //       ),
// // //       body: Center(
// // //         child: Column(
// // //           mainAxisAlignment: MainAxisAlignment.center,
// // //           children: [
// // //             Icon(Icons.account_circle_outlined,
// // //                 size: 80,
// // //                 color: Theme.of(context).primaryColor.withOpacity(0.7)),
// // //             const SizedBox(height: 16),
// // //             const Text(
// // //               "Please log in to access your dashboard",
// // //               style: TextStyle(fontSize: 18),
// // //             ),
// // //             const SizedBox(height: 24),
// // //             ElevatedButton(
// // //               onPressed: () {
// // //                 Navigator.pushReplacement(
// // //                   context,
// // //                   MaterialPageRoute(builder: (context) => const LoginScreen()),
// // //                 );
// // //               },
// // //               style: ElevatedButton.styleFrom(
// // //                 padding:
// // //                     const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
// // //               ),
// // //               child: const Text("Go to Login", style: TextStyle(fontSize: 16)),
// // //             ),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }

// // //   Widget _buildDashboardContent(BuildContext context, User user) {
// // //     return StreamBuilder<QuerySnapshot>(
// // //       stream: FirebaseFirestore.instance
// // //           .collection('ngos')
// // //           .where('email', isEqualTo: user.email)
// // //           .snapshots(),
// // //       builder: (context, approvedSnapshot) {
// // //         return StreamBuilder<QuerySnapshot>(
// // //           stream: FirebaseFirestore.instance
// // //               .collection('pending_approvals')
// // //               .where('email', isEqualTo: user.email)
// // //               .snapshots(),
// // //           builder: (context, pendingSnapshot) {
// // //             if (approvedSnapshot.connectionState == ConnectionState.waiting ||
// // //                 pendingSnapshot.connectionState == ConnectionState.waiting) {
// // //               return const Center(
// // //                 child: CircularProgressIndicator(),
// // //               );
// // //             }

// // //             // NGO is approved
// // //             if (approvedSnapshot.hasData &&
// // //                 approvedSnapshot.data!.docs.isNotEmpty) {
// // //               var ngoData = approvedSnapshot.data!.docs.first;
// // //               return ApprovedNGOView(ngoData: ngoData);
// // //             }

// // //             // NGO is pending approval
// // //             if (pendingSnapshot.hasData &&
// // //                 pendingSnapshot.data!.docs.isNotEmpty) {
// // //               var pendingData = pendingSnapshot.data!.docs.first;

// // //               // Navigate to PendingApprovalScreen just once after build
// // //               Future.microtask(() {
// // //                 Navigator.pushReplacement(
// // //                   context,
// // //                   MaterialPageRoute(
// // //                     builder: (context) =>
// // //                         PendingApprovalView(pendingData: pendingData),
// // //                   ),
// // //                 );
// // //               });

// // //               // Return a loading widget while navigation happens
// // //               return const Center(child: CircularProgressIndicator());
// // //             }

// // //             // NGO not found
// // //             return _buildNoNGOFoundView(context);
// // //           },
// // //         );
// // //       },
// // //     );
// // //   }

// // //   Widget _buildNoNGOFoundView(BuildContext context) {
// // //     return Center(
// // //       child: Padding(
// // //         padding: const EdgeInsets.all(24.0),
// // //         child: Column(
// // //           mainAxisAlignment: MainAxisAlignment.center,
// // //           children: [
// // //             Container(
// // //               padding: const EdgeInsets.all(24),
// // //               decoration: BoxDecoration(
// // //                 color: Colors.amber.withOpacity(0.2),
// // //                 borderRadius: BorderRadius.circular(100),
// // //               ),
// // //               child: const Icon(Icons.business_outlined,
// // //                   size: 80, color: Colors.amber),
// // //             ),
// // //             const SizedBox(height: 24),
// // //             const Text(
// // //               "No NGO found",
// // //               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
// // //             ),
// // //             const SizedBox(height: 12),
// // //             const Text(
// // //               "It looks like you haven't registered your NGO yet. Please register first to access the dashboard features.",
// // //               textAlign: TextAlign.center,
// // //               style: TextStyle(fontSize: 16, color: Colors.black54),
// // //             ),
// // //             const SizedBox(height: 32),
// // //             ElevatedButton(
// // //               onPressed: () {
// // //                 // TODO: Navigate to NGO registration
// // //                 Navigator.pop(context);
// // //               },
// // //               style: ElevatedButton.styleFrom(
// // //                 padding:
// // //                     const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
// // //               ),
// // //               child: const Text("Register NGO", style: TextStyle(fontSize: 16)),
// // //             ),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// import 'package:care__connect/services/auth_service.dart';
// import 'package:care__connect/screens/login_screen.dart';

// import 'package:care__connect/screens/NGO/widgets/approved_ngo_view.dart';
// import 'widgets/pending_approval_view.dart';

// class NGODashboard extends StatelessWidget {
//   const NGODashboard({Key? key}) : super(key: key);

//   void _signOut(BuildContext context) async {
//     await AuthService().signOut();
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (context) => const LoginScreen()),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     User? user = FirebaseAuth.instance.currentUser;

    

//     if (user == null) {
//       return _buildNotLoggedInView(context);
//     }

//     return Scaffold(
//       body: _buildDashboardContent(context, user),
//     );
//   }

//   Widget _buildNotLoggedInView(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("NGO Dashboard"),
//         elevation: 0,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.logout),
//             onPressed: () => _signOut(context),
//           ),
//         ],
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.account_circle_outlined,
//                 size: 80,
//                 color: Theme.of(context).primaryColor.withOpacity(0.7)),
//             const SizedBox(height: 16),
//             const Text(
//               "Please log in to access your dashboard",
//               style: TextStyle(fontSize: 18),
//             ),
//             const SizedBox(height: 24),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(builder: (context) => const LoginScreen()),
//                 );
//               },
//               style: ElevatedButton.styleFrom(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
//               ),
//               child: const Text("Go to Login", style: TextStyle(fontSize: 16)),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildDashboardContent(BuildContext context, User user) {
//     return StreamBuilder<QuerySnapshot>(
//       stream: FirebaseFirestore.instance
//           .collection('ngos')
//           .where('email', isEqualTo: user.email)
//           .snapshots(),
//       builder: (context, approvedSnapshot) {
//         return StreamBuilder<QuerySnapshot>(
//           stream: FirebaseFirestore.instance
//               .collection('pending_approvals')
//               .where('email', isEqualTo: user.email)
//               .snapshots(),
//           builder: (context, pendingSnapshot) {
//             if (approvedSnapshot.connectionState == ConnectionState.waiting ||
//                 pendingSnapshot.connectionState == ConnectionState.waiting) {
//               return const Center(child: CircularProgressIndicator());
//             }

//             if (approvedSnapshot.hasData &&
//                 approvedSnapshot.data!.docs.isNotEmpty) {
//               var ngoData = approvedSnapshot.data!.docs.first;
//               return ApprovedNGOView(ngoData: ngoData);
//               // WidgetsBinding.instance.addPostFrameCallback((_) {
//               //   Navigator.pushReplacement(
//               //     context,
//               //     MaterialPageRoute(
//               //       builder: (context) => ApprovedNGOView(ngoData: ngoData),
//               //     ),
//               //   );
//               // });
//             }

//             if (pendingSnapshot.hasData &&
//                 pendingSnapshot.data!.docs.isNotEmpty) {
//               var pendingData = pendingSnapshot.data!.docs.first;

//               Future.microtask(() {
//                 Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) =>
//                         PendingApprovalView(pendingData: pendingData),
//                   ),
//                 );
//               });

//               return const Center(child: CircularProgressIndicator());
//             }

//             return _buildNoNGOFoundView(context);
//           },
//         );
//       },
//     );
//   }

//   Widget _buildNoNGOFoundView(BuildContext context) {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(24.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               padding: const EdgeInsets.all(24),
//               decoration: BoxDecoration(
//                 color: Colors.amber.withOpacity(0.2),
//                 borderRadius: BorderRadius.circular(100),
//               ),
//               child: const Icon(Icons.business_outlined,
//                   size: 80, color: Colors.amber),
//             ),
//             const SizedBox(height: 24),
//             const Text(
//               "No NGO found",
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 12),
//             const Text(
//               "It looks like you haven't registered your NGO yet. Please register first to access the dashboard features.",
//               textAlign: TextAlign.center,
//               style: TextStyle(fontSize: 16, color: Colors.black54),
//             ),
//             const SizedBox(height: 32),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.pop(
//                     context); // You can replace this with registration navigation
//               },
//               style: ElevatedButton.styleFrom(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
//               ),
//               child: const Text("Register NGO", style: TextStyle(fontSize: 16)),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }



// // import 'package:flutter/material.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:firebase_auth/firebase_auth.dart';

// // import 'package:care__connect/services/auth_service.dart';
// // import 'package:care__connect/screens/login_screen.dart';
// // import 'package:care__connect/screens/NGO/widgets/approved_ngo_view.dart';
// // import 'widgets/pending_approval_view.dart';

// // class NGODashboard extends StatefulWidget {
// //   const NGODashboard({Key? key}) : super(key: key);

// //   @override
// //   State<NGODashboard> createState() => _NGODashboardState();
// // }

// // class _NGODashboardState extends State<NGODashboard> {
// //   User? user;
// //   bool isLoading = true;
// //   bool hasNGO = false;
// //   DocumentSnapshot? ngoData;
// //   DocumentSnapshot? pendingData;

// //   @override
// //   void initState() {
// //     super.initState();
// //     user = FirebaseAuth.instance.currentUser;
    
// //     // Use Future.delayed to avoid calling setState during build
// //     if (user != null) {
// //       _checkNGOStatus();
// //     } else {
// //       setState(() {
// //         isLoading = false;
// //       });
// //     }
// //   }

// //   void _signOut(BuildContext context) async {
// //     await AuthService().signOut();
// //     Navigator.pushReplacement(
// //       context,
// //       MaterialPageRoute(builder: (context) => const LoginScreen()),
// //     );
// //   }

// //   Future<void> _checkNGOStatus() async {
// //     if (user == null) {
// //       setState(() {
// //         isLoading = false;
// //       });
// //       return;
// //     }

// //     final firestore = FirebaseFirestore.instance;

// //     try {
// //       // Check if user has an approved NGO
// //       final approvedSnapshot = await firestore
// //           .collection('ngos')
// //           .where('email', isEqualTo: user!.email)
// //           .get();

// //       if (approvedSnapshot.docs.isNotEmpty) {
// //         setState(() {
// //           ngoData = approvedSnapshot.docs.first;
// //           hasNGO = true;
// //           isLoading = false;
// //         });
// //         return;
// //       }

// //       // Check if user has a pending NGO approval
// //       final pendingSnapshot = await firestore
// //           .collection('pending_approvals')
// //           .where('email', isEqualTo: user!.email)
// //           .get();

// //       if (pendingSnapshot.docs.isNotEmpty) {
// //         setState(() {
// //           pendingData = pendingSnapshot.docs.first;
// //           hasNGO = true;
// //           isLoading = false;
// //         });
// //         return;
// //       }

// //       // If no NGO found
// //       setState(() {
// //         hasNGO = false;
// //         isLoading = false;
// //       });
// //     } catch (e) {
// //       print('Error checking NGO status: $e');
// //       setState(() {
// //         isLoading = false;
// //       });
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     if (user == null) {
// //       return _buildNotLoggedInView(context);
// //     }

// //     if (isLoading) {
// //       return Scaffold(
// //         appBar: AppBar(
// //           title: const Text("NGO Dashboard"),
// //           actions: [
// //             IconButton(
// //               icon: const Icon(Icons.logout),
// //               onPressed: () => _signOut(context),
// //             ),
// //           ],
// //         ),
// //         body: const Center(
// //           child: CircularProgressIndicator(),
// //         ),
// //       );
// //     }

// //     // If has approved NGO data
// //     if (hasNGO && ngoData != null) {
// //       return ApprovedNGOView(ngoData: ngoData!);
// //     }
    
// //     // If has pending NGO data
// //     if (hasNGO && pendingData != null) {
// //       return PendingApprovalView(pendingData: pendingData!);
// //     }

// //     // No NGO found
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text("NGO Dashboard"),
// //         actions: [
// //           IconButton(
// //             icon: const Icon(Icons.logout),
// //             onPressed: () => _signOut(context),
// //           ),
// //         ],
// //       ),
// //       body: _buildNoNGOFoundView(context),
// //     );
// //   }

// //   Widget _buildNotLoggedInView(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text("NGO Dashboard"),
// //         actions: [
// //           IconButton(
// //             icon: const Icon(Icons.logout),
// //             onPressed: () => _signOut(context),
// //           ),
// //         ],
// //       ),
// //       body: Center(
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: [
// //             Icon(Icons.account_circle_outlined,
// //                 size: 80,
// //                 color: Theme.of(context).primaryColor.withOpacity(0.7)),
// //             const SizedBox(height: 16),
// //             const Text(
// //               "Please log in to access your dashboard",
// //               style: TextStyle(fontSize: 18),
// //             ),
// //             const SizedBox(height: 24),
// //             ElevatedButton(
// //               onPressed: () {
// //                 Navigator.pushReplacement(
// //                   context,
// //                   MaterialPageRoute(builder: (context) => const LoginScreen()),
// //                 );
// //               },
// //               style: ElevatedButton.styleFrom(
// //                 padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
// //               ),
// //               child: const Text("Go to Login", style: TextStyle(fontSize: 16)),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildNoNGOFoundView(BuildContext context) {
// //     return Padding(
// //       padding: const EdgeInsets.all(24.0),
// //       child: Column(
// //         mainAxisAlignment: MainAxisAlignment.center,
// //         children: [
// //           Container(
// //             padding: const EdgeInsets.all(24),
// //             decoration: BoxDecoration(
// //               color: Colors.amber.withOpacity(0.2),
// //               borderRadius: BorderRadius.circular(100),
// //             ),
// //             child: const Icon(Icons.business_outlined,
// //                 size: 80, color: Colors.amber),
// //           ),
// //           const SizedBox(height: 24),
// //           const Text(
// //             "No NGO found",
// //             style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
// //           ),
// //           const SizedBox(height: 12),
// //           const Text(
// //             "It looks like you haven't registered your NGO yet. Please register first to access the dashboard features.",
// //             textAlign: TextAlign.center,
// //             style: TextStyle(fontSize: 16, color: Colors.black54),
// //           ),
// //           const SizedBox(height: 32),
// //           ElevatedButton(
// //             onPressed: () {
// //               Navigator.pop(context); // Or navigate to the registration page
// //             },
// //             style: ElevatedButton.styleFrom(
// //               padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
// //             ),
// //             child: const Text("Register NGO", style: TextStyle(fontSize: 16)),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }


import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:care__connect/services/auth_service.dart';
import 'package:care__connect/screens/login_screen.dart';

import 'package:care__connect/screens/NGO/widgets/approved_ngo_view.dart';
import 'widgets/pending_approval_view.dart';

class NGODashboard extends StatefulWidget {
  const NGODashboard({Key? key}) : super(key: key);

  @override
  State<NGODashboard> createState() => _NGODashboardState();
}

class _NGODashboardState extends State<NGODashboard> {
  bool _navigated = false;

  void _signOut(BuildContext context) async {
    await AuthService().signOut();
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return _buildNotLoggedInView(context);
    }

    return Scaffold(
      body: _buildDashboardContent(context, user),
    );
  }

  Widget _buildDashboardContent(BuildContext context, User user) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('ngos')
          .where('email', isEqualTo: user.email)
          .snapshots(),
      builder: (context, approvedSnapshot) {
        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('pending_approvals')
              .where('email', isEqualTo: user.email)
              .snapshots(),
          builder: (context, pendingSnapshot) {
            if (approvedSnapshot.connectionState == ConnectionState.waiting ||
                pendingSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (_navigated) {
              return const Center(child: CircularProgressIndicator());
            }

            if (approvedSnapshot.hasData &&
                approvedSnapshot.data!.docs.isNotEmpty) {
              var ngoData = approvedSnapshot.data!.docs.first;

              // Navigate safely to ApprovedNGOView
              Future.microtask(() {
                if (mounted) {
                  setState(() => _navigated = true);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ApprovedNGOView(ngoData: ngoData),
                    ),
                  );
                }
              });

              return const Center(child: CircularProgressIndicator());
            }

            if (pendingSnapshot.hasData &&
                pendingSnapshot.data!.docs.isNotEmpty) {
              var pendingData = pendingSnapshot.data!.docs.first;

              // Navigate safely to PendingApprovalView
              Future.microtask(() {
                if (mounted) {
                  setState(() => _navigated = true);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          PendingApprovalView(pendingData: pendingData),
                    ),
                  );
                }
              });

              return const Center(child: CircularProgressIndicator());
            }

            return _buildNoNGOFoundView(context);
          },
        );
      },
    );
  }

  Widget _buildNotLoggedInView(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("NGO Dashboard"),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _signOut(context),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.account_circle_outlined,
                size: 80,
                color: Theme.of(context).primaryColor.withOpacity(0.7)),
            const SizedBox(height: 16),
            const Text(
              "Please log in to access your dashboard",
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
              child: const Text("Go to Login", style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoNGOFoundView(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.2),
                borderRadius: BorderRadius.circular(100),
              ),
              child: const Icon(Icons.business_outlined,
                  size: 80, color: Colors.amber),
            ),
            const SizedBox(height: 24),
            const Text(
              "No NGO found",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              "It looks like you haven't registered your NGO yet. Please register first to access the dashboard features.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(
                    context); // You can replace this with registration navigation
              },
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              child: const Text("Register NGO", style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
