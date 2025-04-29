// // import 'package:flutter/material.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:url_launcher/url_launcher.dart';
// // import 'package:care__connect/services/auth_service.dart';
// // import 'package:care__connect/screens/login_screen.dart';

// // class AdminDashboard extends StatefulWidget {
// //   @override
// //   _AdminDashboardState createState() => _AdminDashboardState();
// // }

// // class _AdminDashboardState extends State<AdminDashboard> {
// //   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

// //   void _signOut(BuildContext context) async {
// //     await AuthService().signOut();
// //     Navigator.pushReplacement(
// //       context,
// //       MaterialPageRoute(builder: (context) => LoginScreen()),
// //     );
// //   }

// //   /// Approve NGO: Move from `pending_approvals` to `ngos`
// //   Future<void> approveNGO(String ngoId) async {
// //     try {
// //       DocumentSnapshot ngoDoc =
// //           await _firestore.collection('pending_approvals').doc(ngoId).get();

// //       if (ngoDoc.exists) {
// //         Map<String, dynamic> data = ngoDoc.data() as Map<String, dynamic>;

// //         await _firestore.collection('ngos').doc(ngoId).set({
// //           ...data,
// //           'approved': true,
// //           'approvedAt': Timestamp.now(),
// //         });

// //         await _firestore.collection('pending_approvals').doc(ngoId).delete();

// //         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
// //           content: Text('NGO Approved Successfully'),
// //           backgroundColor: Colors.green,
// //         ));
// //       }
// //     } catch (e) {
// //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
// //         content: Text('Error approving NGO: $e'),
// //         backgroundColor: Colors.red,
// //       ));
// //     }
// //   }

// //   /// Reject NGO (Delete from `pending_approvals`)
// //   Future<void> rejectNGO(String ngoId) async {
// //     try {
// //       await _firestore.collection('pending_approvals').doc(ngoId).delete();
// //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
// //         content: Text('NGO Rejected and Removed'),
// //         backgroundColor: Colors.red,
// //       ));
// //     } catch (e) {
// //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
// //         content: Text('Error rejecting NGO: $e'),
// //         backgroundColor: Colors.red,
// //       ));
// //     }
// //   }

// //   /// Open document in browser
// //   void viewDocument(String docUrl) async {
// //     if (await canLaunch(docUrl)) {
// //       await launch(docUrl);
// //     } else {
// //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
// //         content: Text('Could not open document'),
// //         backgroundColor: Colors.red,
// //       ));
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Admin Dashboard'),
// //         actions: [
// //           IconButton(
// //             icon: const Icon(Icons.logout),
// //             onPressed: () => _signOut(context),
// //           ),
// //         ],
// //       ),
// //       body: StreamBuilder<QuerySnapshot>(
// //         stream: _firestore.collection('pending_approvals').snapshots(),
// //         builder: (context, snapshot) {
// //           if (snapshot.connectionState == ConnectionState.waiting) {
// //             return Center(child: CircularProgressIndicator());
// //           }

// //           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
// //             return Center(child: Text('No NGOs awaiting approval'));
// //           }

// //           var pendingNGOs = snapshot.data!.docs;

// //           return ListView.builder(
// //             itemCount: pendingNGOs.length,
// //             itemBuilder: (context, index) {
// //               var ngo = pendingNGOs[index];
// //               var ngoData = ngo.data() as Map<String, dynamic>;
// //               String? documentUrl = ngoData['documentUrl']; // Get document URL

// //               return Card(
// //                 margin: EdgeInsets.all(10),
// //                 elevation: 3,
// //                 child: ListTile(
// //                   title: Text(ngoData['name'] ?? 'NGO Name'),
// //                   subtitle: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       Text(ngoData['email'] ?? 'Email not available'),
// //                       SizedBox(height: 5),
// //                       documentUrl != null
// //                           ? TextButton(
// //                               onPressed: () => viewDocument(documentUrl),
// //                               child: Text('View Document',
// //                                   style: TextStyle(color: Colors.blue)),
// //                             )
// //                           : Text('No Document Uploaded',
// //                               style: TextStyle(color: Colors.red)),
// //                     ],
// //                   ),
// //                   trailing: Row(
// //                     mainAxisSize: MainAxisSize.min,
// //                     children: [
// //                       IconButton(
// //                         icon: Icon(Icons.check, color: Colors.green),
// //                         onPressed: () => approveNGO(ngo.id),
// //                       ),
// //                       IconButton(
// //                         icon: Icon(Icons.close, color: Colors.red),
// //                         onPressed: () => rejectNGO(ngo.id),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               );
// //             },
// //           );
// //         },
// //       ),
// //     );
// //   }
// // }






// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:care__connect/services/auth_service.dart';
// import 'package:care__connect/screens/login_screen.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:intl/intl.dart';
// import 'package:cached_network_image/cached_network_image.dart';

// class AdminDashboard extends StatefulWidget {
//   const AdminDashboard({Key? key}) : super(key: key);
  
//   @override
//   _AdminDashboardState createState() => _AdminDashboardState();
// }

// class _AdminDashboardState extends State<AdminDashboard> with SingleTickerProviderStateMixin {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   late AnimationController _animationController;
//   late Animation<double> _fadeAnimation;
  
//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1200),
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

//   void _signOut(BuildContext context) async {
//     // Show confirmation dialog
//     bool confirm = await showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//         title: const Text('Confirm Logout'),
//         content: const Text('Are you sure you want to logout?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(false),
//             child: Text(
//               'Cancel',
//               style: TextStyle(color: Colors.grey.shade700),
//             ),
//           ),
//           ElevatedButton(
//             onPressed: () => Navigator.of(context).pop(true),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: const Color(0xFF00A86B),
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//             ),
//             child: const Text('Logout', style: TextStyle(color: Colors.white)),
//           ),
//         ],
//       ),
//     ) ?? false;
    
//     if (confirm) {
//       await AuthService().signOut();
//       if (!mounted) return;
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => const LoginScreen()),
//       );
//     }
//   }

//   /// Approve NGO: Move from `pending_approvals` to `ngos`
//   Future<void> approveNGO(String ngoId) async {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => const Center(
//         child: CircularProgressIndicator(
//           color: Color(0xFF00A86B),
//         ),
//       ),
//     );
    
//     try {
//       DocumentSnapshot ngoDoc = await _firestore.collection('pending_approvals').doc(ngoId).get();

//       if (ngoDoc.exists) {
//         Map<String, dynamic> data = ngoDoc.data() as Map<String, dynamic>;

//         await _firestore.collection('ngos').doc(ngoId).set({
//           ...data,
//           'approved': true,
//           'approvedAt': Timestamp.now(),
//           'status': 'approved',
//         });

//         await _firestore.collection('pending_approvals').doc(ngoId).delete();
        
//         Navigator.of(context).pop(); // Close loading dialog
        
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: const Text('NGO Approved Successfully'),
//             backgroundColor: const Color(0xFF00A86B),
//             behavior: SnackBarBehavior.floating,
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//           ),
//         );
//       }
//     } catch (e) {
//       Navigator.of(context).pop(); // Close loading dialog
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Error approving NGO: $e'),
//           backgroundColor: Colors.red,
//           behavior: SnackBarBehavior.floating,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//         ),
//       );
//     }
//   }

//   /// Reject NGO (Delete from `pending_approvals`)
//   Future<void> rejectNGO(String ngoId) async {
//     bool confirm = await showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//         title: const Text('Confirm Rejection'),
//         content: const Text('Are you sure you want to reject this NGO application?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(false),
//             child: Text(
//               'Cancel',
//               style: TextStyle(color: Colors.grey.shade700),
//             ),
//           ),
//           ElevatedButton(
//             onPressed: () => Navigator.of(context).pop(true),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.red,
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//             ),
//             child: const Text('Reject', style: TextStyle(color: Colors.white)),
//           ),
//         ],
//       ),
//     ) ?? false;
    
//     if (confirm) {
//       showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (context) => const Center(
//           child: CircularProgressIndicator(
//             color: Color(0xFF00A86B),
//           ),
//         ),
//       );
      
//       try {
//         await _firestore.collection('pending_approvals').doc(ngoId).delete();
        
//         Navigator.of(context).pop(); // Close loading dialog
        
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: const Text('NGO Application Rejected'),
//             backgroundColor: Colors.red,
//             behavior: SnackBarBehavior.floating,
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//           ),
//         );
//       } catch (e) {
//         Navigator.of(context).pop(); // Close loading dialog
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Error rejecting NGO: $e'),
//             backgroundColor: Colors.red,
//             behavior: SnackBarBehavior.floating,
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//           ),
//         );
//       }
//     }
//   }

//   /// Open document in browser
//   void _viewUrl(String url) async {
//     try {
//       if (await canLaunch(url)) {
//         await launch(url);
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: const Text('Could not open URL'),
//             backgroundColor: Colors.red,
//             behavior: SnackBarBehavior.floating,
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//           ),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Error: $e'),
//           backgroundColor: Colors.red,
//           behavior: SnackBarBehavior.floating,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade100,
//       body: FadeTransition(
//         opacity: _fadeAnimation,
//         child: SafeArea(
//           child: Column(
//             children: [
//               _buildHeader(),
//               _buildDashboardBody(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildHeader() {
//     return Container(
//       padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
//       decoration: const BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [Color(0xFF00A86B), Color(0xFF009160)],
//         ),
//         borderRadius: BorderRadius.only(
//           bottomLeft: Radius.circular(30),
//           bottomRight: Radius.circular(30),
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Color(0x40000000),
//             blurRadius: 10,
//             offset: Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               const Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Admin Dashboard',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   SizedBox(height: 5),
//                   Text(
//                     'Manage NGO Applications',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 14,
//                     ),
//                   ),
//                 ],
//               ),
//               Container(
//                 decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.2),
//                   borderRadius: BorderRadius.circular(15),
//                 ),
//                 child: IconButton(
//                   icon: const Icon(Icons.logout, color: Colors.white),
//                   onPressed: () => _signOut(context),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 20),
//           StreamBuilder<QuerySnapshot>(
//             stream: _firestore.collection('pending_approvals').snapshots(),
//             builder: (context, snapshot) {
//               int count = snapshot.hasData ? snapshot.data!.docs.length : 0;
//               return Row(
//                 children: [
//                   _buildStatCard(
//                     'Pending Applications',
//                     count.toString(),
//                     Icons.assignment_late_outlined,
//                   ),
//                 ],
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildStatCard(String title, String value, IconData icon) {
//     return Expanded(
//       child: Container(
//         padding: const EdgeInsets.all(15),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(15),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.1),
//               blurRadius: 10,
//               spreadRadius: 1,
//             ),
//           ],
//         ),
//         child: Row(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(10),
//               decoration: BoxDecoration(
//                 color: const Color(0xFF00A86B).withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Icon(
//                 icon,
//                 color: const Color(0xFF00A86B),
//                 size: 24,
//               ),
//             ),
//             const SizedBox(width: 15),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   value,
//                   style: const TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 5),
//                 Text(
//                   title,
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: Colors.grey.shade700,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildDashboardBody() {
//     return Expanded(
//       child: Container(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'NGO Applications',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 15),
//             Expanded(
//               child: StreamBuilder<QuerySnapshot>(
//                 stream: _firestore.collection('pending_approvals').snapshots(),
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return const Center(
//                       child: CircularProgressIndicator(
//                         color: Color(0xFF00A86B),
//                       ),
//                     );
//                   }

//                   if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                     return Center(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(
//                             Icons.check_circle_outline,
//                             size: 70,
//                             color: Colors.grey.shade400,
//                           ),
//                           const SizedBox(height: 20),
//                           Text(
//                             'No pending applications',
//                             style: TextStyle(
//                               fontSize: 16,
//                               color: Colors.grey.shade600,
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                   }

//                   var pendingNGOs = snapshot.data!.docs;

//                   return ListView.builder(
//                     itemCount: pendingNGOs.length,
//                     itemBuilder: (context, index) {
//                       var ngo = pendingNGOs[index];
//                       var ngoData = ngo.data() as Map<String, dynamic>;
                      
//                       // Extract NGO data
//                       String ngoName = ngoData['name'] ?? 'NGO Name';
//                       String ngoEmail = ngoData['email'] ?? 'Email not available';
//                       String ngoId = ngoData['ngoId'] ?? '';
//                       String logoUrl = ngoData['logoUrl'] ?? '';
//                       String documentUrl = ngoData['documentUrl'] ?? '';
//                       String sector = ngoData['sector'] ?? 'Not specified';
//                       String city = ngoData['city'] ?? 'Not specified';
//                       String description = ngoData['description'] ?? 'No description available';
//                       String personName = ngoData['personName'] ?? 'Not specified';
//                       String personRole = ngoData['personRole'] ?? 'Not specified';
//                       String bankAccount = ngoData['bankAccount'] ?? 'Not specified';
//                       String ifscCode = ngoData['ifscCode'] ?? 'Not specified';
//                       List<dynamic> acceptedDonations = ngoData['acceptedDonations'] ?? [];
//                       Timestamp submittedAt = ngoData['submittedAt'] ?? Timestamp.now();
//                       String formattedDate = DateFormat('MMM d, yyyy • hh:mm a')
//                           .format(submittedAt.toDate());

//                       return Container(
//                         margin: const EdgeInsets.only(bottom: 15),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(15),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.black.withOpacity(0.05),
//                               blurRadius: 10,
//                               spreadRadius: 1,
//                             ),
//                           ],
//                         ),
//                         child: ExpansionTile(
//                           tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                           childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
//                           leading: Container(
//                             width: 50,
//                             height: 50,
//                             decoration: BoxDecoration(
//                               color: logoUrl.isNotEmpty 
//                                 ? null 
//                                 : const Color(0xFF00A86B).withOpacity(0.1),
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             child: logoUrl.isNotEmpty
//                               ? ClipRRect(
//                                   borderRadius: BorderRadius.circular(10),
//                                   child: CachedNetworkImage(
//                                     imageUrl: logoUrl,
//                                     fit: BoxFit.cover,
//                                     placeholder: (context, url) => const Center(
//                                       child: CircularProgressIndicator(
//                                         color: Color(0xFF00A86B),
//                                         strokeWidth: 2,
//                                       ),
//                                     ),
//                                     errorWidget: (context, url, error) => const Center(
//                                       child: Icon(
//                                         Icons.error_outline,
//                                         color: Color(0xFF00A86B),
//                                       ),
//                                     ),
//                                   ),
//                                 )
//                               : const Center(
//                                   child: Icon(
//                                     FontAwesomeIcons.building,
//                                     color: Color(0xFF00A86B),
//                                   ),
//                                 ),
//                           ),
//                           title: Text(
//                             ngoName,
//                             style: const TextStyle(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 16,
//                             ),
//                           ),
//                           subtitle: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 ngoEmail,
//                                 style: TextStyle(
//                                   color: Colors.grey.shade700,
//                                   fontSize: 14,
//                                 ),
//                               ),
//                               const SizedBox(height: 4),
//                               Text(
//                                 formattedDate,
//                                 style: TextStyle(
//                                   color: Colors.grey.shade500,
//                                   fontSize: 12,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           trailing: Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               _buildActionButton(
//                                 icon: Icons.check,
//                                 color: const Color(0xFF00A86B),
//                                 onTap: () => approveNGO(ngoId),
//                                 tooltip: 'Approve',
//                               ),
//                               const SizedBox(width: 10),
//                               _buildActionButton(
//                                 icon: Icons.close,
//                                 color: Colors.red,
//                                 onTap: () => rejectNGO(ngoId),
//                                 tooltip: 'Reject',
//                               ),
//                             ],
//                           ),
//                           children: [
//                             const Divider(),
//                             // Basic Information Section
//                             _buildSectionTitle('Basic Information'),
//                             _buildInfoRow(Icons.category, 'Sector: $sector'),
//                             _buildInfoRow(Icons.location_city, 'City: $city'),
//                             _buildInfoRow(Icons.person, 'Contact Person: $personName ($personRole)'),
                            
//                             const SizedBox(height: 10),
//                             // Description Section
//                             _buildSectionTitle('Description'),
//                             Container(
//                               width: double.infinity,
//                               padding: const EdgeInsets.all(15),
//                               decoration: BoxDecoration(
//                                 color: Colors.grey.shade50,
//                                 borderRadius: BorderRadius.circular(10),
//                                 border: Border.all(color: Colors.grey.shade200),
//                               ),
//                               child: Text(
//                                 description,
//                                 style: TextStyle(
//                                   fontSize: 14,
//                                   color: Colors.grey.shade800,
//                                 ),
//                               ),
//                             ),
                            
//                             const SizedBox(height: 15),
//                             // Banking Information Section
//                             _buildSectionTitle('Banking Information'),
//                             _buildInfoRow(Icons.account_balance, 'Account Number: $bankAccount'),
//                             _buildInfoRow(Icons.confirmation_number, 'IFSC Code: $ifscCode'),
                            
//                             const SizedBox(height: 15),
//                             // Accepted Donations Section
//                             _buildSectionTitle('Accepted Donations'),
//                             acceptedDonations.isEmpty 
//                                 ? Text(
//                                     'No donations specified',
//                                     style: TextStyle(
//                                       fontSize: 14,
//                                       color: Colors.grey.shade700,
//                                       fontStyle: FontStyle.italic,
//                                     ),
//                                   )
//                                 : Wrap(
//                                     spacing: 8,
//                                     runSpacing: 8,
//                                     children: acceptedDonations.map<Widget>((donation) {
//                                       return Container(
//                                         padding: const EdgeInsets.symmetric(
//                                           horizontal: 12,
//                                           vertical: 6,
//                                         ),
//                                         decoration: BoxDecoration(
//                                           color: const Color(0xFF00A86B).withOpacity(0.1),
//                                           borderRadius: BorderRadius.circular(20),
//                                           border: Border.all(
//                                             color: const Color(0xFF00A86B).withOpacity(0.3),
//                                           ),
//                                         ),
//                                         child: Text(
//                                           donation.toString(),
//                                           style: const TextStyle(
//                                             fontSize: 12,
//                                             color: Color(0xFF00A86B),
//                                           ),
//                                         ),
//                                       );
//                                     }).toList(),
//                                   ),
                            
//                             const SizedBox(height: 20),
//                             // Documents & Logo Section
//                             Row(
//                               children: [
//                                 Expanded(
//                                   child: ElevatedButton.icon(
//                                     onPressed: documentUrl.isNotEmpty 
//                                         ? () => _viewUrl(documentUrl)
//                                         : null,
//                                     icon: const Icon(Icons.description),
//                                     label: const Text('View Documents'),
//                                     style: ElevatedButton.styleFrom(
//                                       backgroundColor: const Color(0xFF00A86B),
//                                       padding: const EdgeInsets.symmetric(vertical: 12),
//                                       shape: RoundedRectangleBorder(
//                                         borderRadius: BorderRadius.circular(10),
//                                       ),
//                                       disabledBackgroundColor: Colors.grey.shade300,
//                                     ),
//                                   ),
//                                 ),
//                                 const SizedBox(width: 10),
//                                 Expanded(
//                                   child: ElevatedButton.icon(
//                                     onPressed: logoUrl.isNotEmpty 
//                                         ? () => _viewUrl(logoUrl)
//                                         : null,
//                                     icon: const Icon(Icons.image),
//                                     label: const Text('View Logo'),
//                                     style: ElevatedButton.styleFrom(
//                                       backgroundColor: const Color(0xFF00A86B),
//                                       padding: const EdgeInsets.symmetric(vertical: 12),
//                                       shape: RoundedRectangleBorder(
//                                         borderRadius: BorderRadius.circular(10),
//                                       ),
//                                       disabledBackgroundColor: Colors.grey.shade300,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       );
//                     },
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSectionTitle(String title) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 10),
//       child: Text(
//         title,
//         style: const TextStyle(
//           fontSize: 16,
//           fontWeight: FontWeight.bold,
//           color: Color(0xFF00A86B),
//         ),
//       ),
//     );
//   }

//   Widget _buildInfoRow(IconData icon, String text) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 5),
//       child: Row(
//         children: [
//           Icon(
//             icon,
//             size: 18,
//             color: const Color(0xFF00A86B),
//           ),
//           const SizedBox(width: 10),
//           Expanded(
//             child: Text(
//               text,
//               style: TextStyle(
//                 fontSize: 14,
//                 color: Colors.grey.shade700,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildActionButton({
//     required IconData icon,
//     required Color color,
//     required VoidCallback onTap,
//     required String tooltip,
//   }) {
//     return Container(
//       width: 35,
//       height: 35,
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Tooltip(
//         message: tooltip,
//         child: InkWell(
//           onTap: onTap,
//           borderRadius: BorderRadius.circular(8),
//           child: Icon(
//             icon,
//             color: color,
//             size: 18,
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:care__connect/services/auth_service.dart';
import 'package:care__connect/screens/login_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_functions/cloud_functions.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key? key}) : super(key: key);
  
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> with TickerProviderStateMixin {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late TabController _tabController;
  
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
    _tabController = TabController(length: 4, vsync: this);
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  /// Approve Report (Take action against NGO)
Future<void> approveReport(String reportId, String ngoId) async {
  bool confirm = await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: const Text('Confirm Report Approval'),
      content: const Text('Are you sure you want to approve this report? This will mark the report as valid and may require further action against the NGO.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(
            'Cancel',
            style: TextStyle(color: Colors.grey.shade700),
          ),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF00A86B),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: const Text('Approve', style: TextStyle(color: Colors.white)),
        ),
      ],
    ),
  ) ?? false;
  
  if (confirm) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(
          color: Color(0xFF00A86B),
        ),
      ),
    );
    
    try {
      // Update report status
      await _firestore.collection('reports').doc(reportId).update({
        'status': 'approved',
        'reviewedAt': Timestamp.now(),
      });
      
      // Optionally flag the NGO or take other actions
      await _firestore.collection('ngos').doc(ngoId).update({
        'flagged': true,
        'flagReason': 'Approved report against NGO',
        'flaggedAt': Timestamp.now(),
      });
      
      Navigator.of(context).pop(); // Close loading dialog
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Report Approved'),
          backgroundColor: const Color(0xFF00A86B),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    } catch (e) {
      Navigator.of(context).pop(); // Close loading dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error approving report: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }
}

/// Reject Report (Dismiss as invalid)
Future<void> rejectReport(String reportId) async {
  bool confirm = await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: const Text('Confirm Report Rejection'),
      content: const Text('Are you sure you want to reject this report as invalid?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(
            'Cancel',
            style: TextStyle(color: Colors.grey.shade700),
          ),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: const Text('Reject', style: TextStyle(color: Colors.white)),
        ),
      ],
    ),
  ) ?? false;
  
  if (confirm) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(
          color: Color(0xFF00A86B),
        ),
      ),
    );
    
    try {
      await _firestore.collection('reports').doc(reportId).update({
        'status': 'rejected',
        'reviewedAt': Timestamp.now(),
      });
      
      Navigator.of(context).pop(); // Close loading dialog
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Report Rejected'),
          backgroundColor: Colors.grey,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    } catch (e) {
      Navigator.of(context).pop(); // Close loading dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error rejecting report: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }
}

/// View evidence document
void _viewEvidenceDocument(String url) async {
  _viewUrl(url); // Reuse your existing _viewUrl method
}

  void _signOut(BuildContext context) async {
    // Show confirmation dialog
    bool confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.grey.shade700),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00A86B),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Logout', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    ) ?? false;
    
    if (confirm) {
      await AuthService().signOut();
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  /// Approve NGO: Move from `pending_approvals` to `ngos`
  Future<void> approveNGO(String ngoId) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(
          color: Color(0xFF00A86B),
        ),
      ),
    );
    
    try {
      DocumentSnapshot ngoDoc = await _firestore.collection('pending_approvals').doc(ngoId).get();

      if (ngoDoc.exists) {
        Map<String, dynamic> data = ngoDoc.data() as Map<String, dynamic>;

        await _firestore.collection('ngos').doc(ngoId).set({
          ...data,
          'approved': true,
          'approvedAt': Timestamp.now(),
          'status': 'approved',
        });

        await _firestore.collection('pending_approvals').doc(ngoId).delete();
        
        Navigator.of(context).pop(); // Close loading dialog
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('NGO Approved Successfully'),
            backgroundColor: const Color(0xFF00A86B),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    } catch (e) {
      Navigator.of(context).pop(); // Close loading dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error approving NGO: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  /// Reject NGO (Delete from `pending_approvals`)
  Future<void> rejectNGO(String ngoId) async {
    bool confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text('Confirm Rejection'),
        content: const Text('Are you sure you want to reject this NGO application?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.grey.shade700),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Reject', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    ) ?? false;
    
    if (confirm) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(
            color: Color(0xFF00A86B),
          ),
        ),
      );
      
      try {
        await _firestore.collection('pending_approvals').doc(ngoId).delete();
        
        Navigator.of(context).pop(); // Close loading dialog
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('NGO Application Rejected'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      } catch (e) {
        Navigator.of(context).pop(); // Close loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error rejecting NGO: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    }
  }

  /// Remove approved NGO
  Future<void> removeNGO(String ngoId, String ngoName) async {
    bool confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text('Confirm Removal'),
        content: Text('Are you sure you want to remove $ngoName?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.grey.shade700),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Remove', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    ) ?? false;
    
    if (confirm) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(
            color: Color(0xFF00A86B),
          ),
        ),
      );

      final deleteNgo = FirebaseFunctions.instance.httpsCallable('deleteUserAccount');
      
      try {
        await deleteNgo.call({'uid': ngoId});
        await _firestore.collection('ngos').doc(ngoId).delete();
        await _firestore.collection('users').doc(ngoId).delete();
        
        Navigator.of(context).pop(); // Close loading dialog
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$ngoName has been removed'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      } catch (e) {
        Navigator.of(context).pop(); // Close loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error removing NGO: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    }
  }

  /// Remove user
  Future<void> removeUser(String userId, String userName) async {
    bool confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text('Confirm User Removal'),
        content: Text('Are you sure you want to remove user $userName?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.grey.shade700),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Remove', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    ) ?? false;
    
    if (confirm) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(
            color: Color(0xFF00A86B),
          ),
        ),
      );
      final deleteUser = FirebaseFunctions.instance.httpsCallable('deleteUserAccount');

      try {
        await deleteUser.call({'uid': userId});
        await _firestore.collection('users').doc(userId).delete();
        await _firestore.collection('user_data').doc(userId).delete();
        
        Navigator.of(context).pop(); // Close loading dialog
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('User $userName has been removed'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      } catch (e) {
        Navigator.of(context).pop(); // Close loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error removing user: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    }
  }

  /// Open document in browser
  void _viewUrl(String url) async {
    try {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Could not open URL'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              _buildTabBar(),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildPendingApprovals(),
                    _buildApprovedNGOs(),
                    _buildUsersManagement(),
                    _buildReportsManagement(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF00A86B), Color(0xFF009160)],
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x40000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Admin Dashboard',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              Text(
                'NGO & User Management',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15),
            ),
            child: IconButton(
              icon: const Icon(Icons.logout, color: Colors.white),
              onPressed: () => _signOut(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF00A86B),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 2),
            blurRadius: 5,
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        indicatorColor: Colors.white,
        indicatorWeight: 3,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white.withOpacity(0.7),
        tabs: const [
          Tab(
            icon: Icon(Icons.pending_actions),
            text: 'Pending',
          ),
          Tab(
            icon: Icon(Icons.check_circle),
            text: 'Approved',
          ),
          Tab(
            icon: Icon(Icons.people),
            text: 'Users',
          ),
          Tab(
            icon: Icon(Icons.report),
            text: 'Reports',
          ),
        ],
      ),
    );
  }

  Widget _buildStatCards() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: _firestore.collection('pending_approvals').snapshots(),
            builder: (context, snapshot) {
              int pendingCount = snapshot.hasData ? snapshot.data!.docs.length : 0;
              return _buildStatCard(
                'Pending',
                pendingCount.toString(),
                Icons.pending_actions,
              );
            },
          ),
          const SizedBox(width: 10),
          StreamBuilder<QuerySnapshot>(
            stream: _firestore.collection('ngos').snapshots(),
            builder: (context, snapshot) {
              int ngoCount = snapshot.hasData ? snapshot.data!.docs.length : 0;
              return _buildStatCard(
                'Approved NGOs',
                ngoCount.toString(),
                Icons.verified,
              );
            },
          ),
          const SizedBox(width: 10),
          StreamBuilder<QuerySnapshot>(
            stream: _firestore.collection('users').snapshots(),
            builder: (context, snapshot) {
              int userCount = snapshot.hasData ? snapshot.data!.docs.length : 0;
              return _buildStatCard(
                'Users',
                userCount.toString(),
                Icons.people,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Container(
      width: 1200, // Set a fixed width to reduce the size
      margin: const EdgeInsets.symmetric(horizontal: 5), // Add margin for spacing
      padding: const EdgeInsets.all(10), // Reduce padding
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF00A86B).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF00A86B),
              size: 24,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18, // Slightly smaller font size
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12, // Smaller font size
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }

  // TAB VIEW 1: PENDING APPROVALS
  Widget _buildPendingApprovals() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: _firestore.collection('pending_approvals').snapshots(),
            builder: (context, snapshot) {
              int pendingCount = snapshot.hasData ? snapshot.data!.docs.length : 0;
              return _buildStatCard(
                'Pending Applications',
                pendingCount.toString(),
                Icons.assignment_late_outlined,
              );
            },
          ),
          const SizedBox(height: 15),
          const Text(
            'NGO Applications',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('pending_approvals').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF00A86B),
                    ),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          size: 70,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'No pending applications',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                var pendingNGOs = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: pendingNGOs.length,
                  itemBuilder: (context, index) {
                    var ngo = pendingNGOs[index];
                    var ngoData = ngo.data() as Map<String, dynamic>;
                    
                    // Extract NGO data
                    String ngoName = ngoData['name'] ?? 'NGO Name';
                    String ngoEmail = ngoData['email'] ?? 'Email not available';
                    String ngoId = ngoData['ngoId'] ?? '';
                    String logoUrl = ngoData['logoUrl'] ?? '';
                    String documentUrl = ngoData['documentUrl'] ?? '';
                    String sector = ngoData['sector'] ?? 'Not specified';
                    String city = ngoData['city'] ?? 'Not specified';
                    String description = ngoData['description'] ?? 'No description available';
                    String personName = ngoData['personName'] ?? 'Not specified';
                    String personRole = ngoData['personRole'] ?? 'Not specified';
                    String bankAccount = ngoData['bankAccount'] ?? 'Not specified';
                    String ifscCode = ngoData['ifscCode'] ?? 'Not specified';
                    List<dynamic> acceptedDonations = ngoData['acceptedDonations'] ?? [];
                    Timestamp submittedAt = ngoData['submittedAt'] ?? Timestamp.now();
                    String formattedDate = DateFormat('MMM d, yyyy • hh:mm a')
                        .format(submittedAt.toDate());

                    return Container(
                      margin: const EdgeInsets.only(bottom: 15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: ExpansionTile(
                        tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                        leading: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: logoUrl.isNotEmpty 
                              ? null 
                              : const Color(0xFF00A86B).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: logoUrl.isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: CachedNetworkImage(
                                  imageUrl: logoUrl,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator(
                                      color: Color(0xFF00A86B),
                                      strokeWidth: 2,
                                    ),
                                  ),
                                  errorWidget: (context, url, error) => const Center(
                                    child: Icon(
                                      Icons.error_outline,
                                      color: Color(0xFF00A86B),
                                    ),
                                  ),
                                ),
                              )
                            : const Center(
                                child: Icon(
                                  FontAwesomeIcons.building,
                                  color: Color(0xFF00A86B),
                                ),
                              ),
                        ),
                        title: Flexible(
                          child: Text(
                            ngoName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                              child: Text(
                                ngoEmail,
                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontSize: 14,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              formattedDate,
                              style: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildActionButton(
                              icon: Icons.check,
                              color: const Color(0xFF00A86B),
                              onTap: () => approveNGO(ngoId),
                              tooltip: 'Approve',
                            ),
                            const SizedBox(width: 10),
                            _buildActionButton(
                              icon: Icons.close,
                              color: Colors.red,
                              onTap: () => rejectNGO(ngoId),
                              tooltip: 'Reject',
                            ),
                          ],
                        ),
                        children: [
                          const Divider(),
                          // Basic Information Section
                          _buildSectionTitle('Basic Information'),
                          _buildInfoRow(Icons.category, 'Sector: $sector'),
                          _buildInfoRow(Icons.location_city, 'City: $city'),
                          _buildInfoRow(Icons.person, 'Contact Person: $personName ($personRole)'),
                          
                          const SizedBox(height: 10),
                          // Description Section
                          _buildSectionTitle('Description'),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey.shade200),
                            ),
                            child: Text(
                              description,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade800,
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: 15),
                          // Banking Information Section
                          _buildSectionTitle('Banking Information'),
                          _buildInfoRow(Icons.account_balance, 'Account Number: $bankAccount'),
                          _buildInfoRow(Icons.confirmation_number, 'IFSC Code: $ifscCode'),
                          
                          const SizedBox(height: 15),
                          // Accepted Donations Section
                          _buildSectionTitle('Accepted Donations'),
                          acceptedDonations.isEmpty 
                              ? Text(
                                  'No donations specified',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade700,
                                    fontStyle: FontStyle.italic,
                                  ),
                                )
                              : Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: acceptedDonations.map<Widget>((donation) {
                                    return Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF00A86B).withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: const Color(0xFF00A86B).withOpacity(0.3),
                                        ),
                                      ),
                                      child: Text(
                                        donation.toString(),
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF00A86B),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                          
                          const SizedBox(height: 20),
                          // Documents & Logo Section
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: documentUrl.isNotEmpty 
                                      ? () => _viewUrl(documentUrl)
                                      : null,
                                  icon: const Icon(Icons.description),
                                  label: const Text('View Documents'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF00A86B),
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    disabledBackgroundColor: Colors.grey.shade300,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: logoUrl.isNotEmpty 
                                      ? () => _viewUrl(logoUrl)
                                      : null,
                                  icon: const Icon(Icons.image),
                                  label: const Text('View Logo'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF00A86B),
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    disabledBackgroundColor: Colors.grey.shade300,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // TAB VIEW 2: APPROVED NGOS
  Widget _buildApprovedNGOs() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: _firestore.collection('ngos').snapshots(),
            builder: (context, snapshot) {
              int ngoCount = snapshot.hasData ? snapshot.data!.docs.length : 0;
              return _buildStatCard(
                'Approved NGOs',
                ngoCount.toString(),
                Icons.verified_user,
              );
            },
          ),
          const SizedBox(height: 15),
          const Text(
            'Approved NGOs',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('ngos').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF00A86B),
                    ),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.business,
                          size: 70,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'No approved NGOs found',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                var approvedNGOs = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: approvedNGOs.length,
                  itemBuilder: (context, index) {
                    var ngo = approvedNGOs[index];
                    var ngoData = ngo.data() as Map<String, dynamic>;
                    
                    // Extract NGO data
                    String ngoName = ngoData['name'] ?? 'NGO Name';
                    String ngoEmail = ngoData['email'] ?? 'Email not available';
                    String ngoId = ngoData['ngoId'] ?? '';
                    String logoUrl = ngoData['logoUrl'] ?? '';
                    //String sector = ngoData['sector'] ?? 'Not specified';
                    String city = ngoData['city'] ?? 'Not specified';
                    Timestamp approvedAt = ngoData['approvedAt'] ?? Timestamp.now();
                    String formattedDate = DateFormat('MMM d, yyyy').format(approvedAt.toDate());
                    String documentUrl = ngoData['documentUrl'] ?? '';

                    return Container(
                      margin: const EdgeInsets.only(bottom: 15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: ExpansionTile(
                        tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                        leading: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: logoUrl.isNotEmpty 
                              ? null 
                              : const Color(0xFF00A86B).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: logoUrl.isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: CachedNetworkImage(
                                  imageUrl: logoUrl,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator(
                                      color: Color(0xFF00A86B),
                                      strokeWidth: 2,
                                    ),
                                  ),
                                  errorWidget: (context, url, error) => const Center(
                                    child: Icon(
                                      Icons.error_outline,
                                      color: Color(0xFF00A86B),
                                    ),
                                  ),
                                ),
                              )
                            : const Center(
                                child: Icon(
                                  FontAwesomeIcons.building,
                                  color: Color(0xFF00A86B),
                                ),
                              ),
                        ),
                        title: Text(
                          ngoName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ngoEmail,
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  size: 12,
                                  color: Colors.grey.shade500,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  city,
                                  style: TextStyle(
                                    color: Colors.grey.shade500,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Icon(
                                  Icons.check_circle,
                                  size: 12,
                                  color: Colors.grey.shade500,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Approved',
                                  style: TextStyle(
                                    color: Colors.grey.shade500,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        trailing: _buildActionButton(
                          icon: Icons.delete,
                          color: Colors.red,
                          onTap: () => removeNGO(ngoId, ngoName),
                          tooltip: 'Remove NGO',
                        ),
                        children: [
                          const Divider(),
                          // NGO Details Section
                          _buildNGODetails(ngoData),
                          
                          const SizedBox(height: 20),
                          // Logo View Button
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: documentUrl.isNotEmpty 
                                      ? () => _viewUrl(documentUrl)
                                      : null,
                                  icon: const Icon(Icons.document_scanner, color: Color.fromARGB(255, 255, 255, 255)),
                                    label: const Text(
                                    'View Document',
                                    style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                                    ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF00A86B),
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    disabledBackgroundColor: Colors.grey.shade300,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () => removeNGO(ngoId, ngoName),
                                  icon: const Icon(Icons.delete,color: Colors.white,),
                                  label: const Text('Remove NGO',style: TextStyle(color: Colors.white),),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build NGO details section
  Widget _buildNGODetails(Map<String, dynamic> ngoData) {
    String description = ngoData['description'] ?? 'No description available';
    String personName = ngoData['personName'] ?? 'Not specified';
    String personRole = ngoData['personRole'] ?? 'Not specified';
    String bankAccount = ngoData['bankAccount'] ?? 'Not specified';
    String ifscCode = ngoData['ifscCode'] ?? 'Not specified';
    String sector = ngoData['sector'] ?? 'Not specified';
    List<dynamic> acceptedDonations = ngoData['acceptedDonations'] ?? [];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Basic Information
        _buildSectionTitle('Basic Information'),
        _buildInfoRow(Icons.category, 'Sector: $sector'),
        _buildInfoRow(Icons.person, 'Contact Person: $personName ($personRole)'),
        
        const SizedBox(height: 10),
        // Description Section
        _buildSectionTitle('Description'),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Text(
            description,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade800,
            ),
          ),
        ),
        
        const SizedBox(height: 15),
        // Banking Information Section
        _buildSectionTitle('Banking Information'),
        _buildInfoRow(Icons.account_balance, 'Account Number: $bankAccount'),
        _buildInfoRow(Icons.confirmation_number, 'IFSC Code: $ifscCode'),
        
        const SizedBox(height: 15),
        // Accepted Donations Section
        _buildSectionTitle('Accepted Donations'),
        acceptedDonations.isEmpty 
            ? Text(
                'No donations specified',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                  fontStyle: FontStyle.italic,
                ),
              )
            : Wrap(
                spacing: 8,
                runSpacing: 8,
                children: acceptedDonations.map<Widget>((donation) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF00A86B).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFF00A86B).withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      donation.toString(),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF00A86B),
                      ),
                    ),
                  );
                }).toList(),
              ),
      ],
    );
  }

  // TAB VIEW 3: USERS MANAGEMENT
  Widget _buildUsersManagement() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: _firestore
              .collection('user_data')
              //.where('role', isEqualTo: 'user')
              .snapshots(),
            builder: (context, snapshot) {
              int userCount = snapshot.hasData ? snapshot.data!.docs.length : 0;
              return _buildStatCard(
                'Registered Users',
                userCount.toString(),
                Icons.people,
              );
            },
          ),
          const SizedBox(height: 15),
          const Text(
            'User Management',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:_firestore
              .collection('user_data')
              //.where('role', isEqualTo: 'user')
              .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF00A86B),
                    ),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.people_outline,
                          size: 70,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'No users found',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                var users = snapshot.data!.docs;
                


                //print("😧$data_user");
                print("😧$users");

                
                return ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    var user = users[index];
                    var userData = user.data() as Map<String, dynamic>;
                    
                    // Extract user data
                    String userId = user.id;
                    String userName =  userData['name'] ?? 'User Name';
                    String userEmail = userData['email'] ?? 'Email not available';
                    String photoUrl = userData['profileImageUrl'] ?? '';
                    String phone = userData['phone'] ?? 'Not provided';
                    Timestamp? createdAt = userData['createdAt'] as Timestamp?;
                    String formattedDate = createdAt != null 
                        ? DateFormat('MMM d, yyyy').format(createdAt.toDate())
                        : 'Unknown';
                    
                    return Container(
                      margin: const EdgeInsets.only(bottom: 15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: ExpansionTile(
                        tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                        leading: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: photoUrl.isNotEmpty 
                              ? null 
                              : Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: photoUrl.isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(25),
                                child: CachedNetworkImage(
                                  imageUrl: photoUrl,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator(
                                      color: Color(0xFF00A86B),
                                      strokeWidth: 2,
                                    ),
                                  ),
                                  errorWidget: (context, url, error) => const Center(
                                    child: Icon(
                                      Icons.person,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              )
                            : const Center(
                                child: Icon(
                                  Icons.person,
                                  color: Colors.grey,
                                ),
                              ),
                        ),
                        title: Text(
                          userName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userEmail,
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            // Row(
                            //   children: [
                            //     Icon(
                            //       Icons.calendar_today,
                            //       size: 12,
                            //       color: Colors.grey.shade500,
                            //     ),
                            //     const SizedBox(width: 4),
                            //     // Text(
                            //     //   'Joined: $formattedDate',
                            //     //   style: TextStyle(
                            //     //     color: Colors.grey.shade500,
                            //     //     fontSize: 12,
                            //     //   ),
                            //     // ),
                            //   ],
                            // ),
                          ],
                        ),
                        trailing: _buildActionButton(
                          icon: Icons.delete,
                          color: Colors.red,
                          onTap: () => removeUser(userId, userName),
                          tooltip: 'Remove User',
                        ),
                        children: [
                          const Divider(),
                          // User Details Section
                          _buildUserDetails(userData),
                          
                          const SizedBox(height: 20),
                          // Remove User Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () => removeUser(userId, userName),
                              icon: const Icon(Icons.delete,color: Colors.white,),
                              label: const Text('Remove User',style: TextStyle(color: Colors.white),),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // TAB VIEW 4: REPORTS MANAGEMENT
Widget _buildReportsManagement() {
  return Container(
    padding: const EdgeInsets.all(20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StreamBuilder<QuerySnapshot>(
          stream: _firestore.collection('reports').snapshots(),
          builder: (context, snapshot) {
            int reportCount = snapshot.hasData ? snapshot.data!.docs.length : 0;
            return _buildStatCard(
              'Total Reports',
              reportCount.toString(),
              Icons.report_problem,
            );
          },
        ),
        const SizedBox(height: 15),
        const Text(
          'User Reports Against NGOs',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 15),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: _firestore.collection('reports').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF00A86B),
                  ),
                );
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.report_off,
                        size: 70,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'No reports found',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                );
              }

              var reports = snapshot.data!.docs;

              return ListView.builder(
                itemCount: reports.length,
                itemBuilder: (context, index) {
                  var report = reports[index];
                  var reportData = report.data() as Map<String, dynamic>;
                  
                  // Extract report data
                  String reportId = report.id;
                  String ngoName = reportData['ngoName'] ?? 'NGO Name';
                  String ngoId = reportData['ngoId'] ?? '';
                  String reason = reportData['reason'] ?? 'Not specified';
                  String description = reportData['description'] ?? 'No description available';
                  List<dynamic> evidenceUrls = reportData['evidenceUrls'] ?? [];
                  String userId = reportData['user'] ?? '';
                  String status = reportData['status'] ?? 'pending';
                  Timestamp createdAt = reportData['createdAt'] ?? Timestamp.now();
                  String formattedDate = DateFormat('MMM d, yyyy • hh:mm a')
                      .format(createdAt.toDate());

                  // Determine badge color based on status
                  Color statusColor;
                  if (status == 'approved') {
                    statusColor = Colors.green;
                  } else if (status == 'rejected') {
                    statusColor = Colors.red;
                  } else {
                    statusColor = Colors.orange; // pending
                  }

                  return Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: ExpansionTile(
                      tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      leading: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.report_problem,
                            color: Colors.red,
                          ),
                        ),
                      ),
                      title: Row(
                        children: [
                          Expanded(
                            child: Text(
                              ngoName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: statusColor.withOpacity(0.3)),
                            ),
                            child: Text(
                              status.toUpperCase(),
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: statusColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Reason: $reason',
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontSize: 14,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            formattedDate,
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      trailing: status == 'pending' 
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _buildActionButton(
                                icon: Icons.check,
                                color: const Color(0xFF00A86B),
                                onTap: () => approveReport(reportId, ngoId),
                                tooltip: 'Approve Report',
                              ),
                              const SizedBox(width: 10),
                              _buildActionButton(
                                icon: Icons.close,
                                color: Colors.red,
                                onTap: () => rejectReport(reportId),
                                tooltip: 'Reject Report',
                              ),
                            ],
                          )
                        : null,
                      children: [
                        const Divider(),
                        
                        // Description Section
                        _buildSectionTitle('Description'),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Text(
                            description,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade800,
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 15),
                        
                        // Evidence Documents Section
                        _buildSectionTitle('Evidence Documents'),
                        evidenceUrls.isEmpty 
                            ? Text(
                                'No evidence documents provided',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade700,
                                  fontStyle: FontStyle.italic,
                                ),
                              )
                            : Column(
                                children: List.generate(evidenceUrls.length, (i) {
                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 10),
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade50,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: Colors.grey.shade200),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF00A86B).withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: const Icon(
                                            Icons.description,
                                            color: Color(0xFF00A86B),
                                            size: 20,
                                          ),
                                        ),
                                        const SizedBox(width: 15),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Evidence Document ${i + 1}',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                'Click to view document',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey.shade600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () => _viewEvidenceDocument(evidenceUrls[i]),
                                          icon: const Icon(
                                            Icons.open_in_new,
                                            color: Color(0xFF00A86B),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                              ),
                        
                        const SizedBox(height: 20),
                        
                        // Action Buttons
                        if (status == 'pending')
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () => approveReport(reportId, ngoId),
                                  icon: const Icon(Icons.check, color: Colors.white),
                                  label: const Text(
                                    'Approve Report',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF00A86B),
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () => rejectReport(reportId),
                                  icon: const Icon(Icons.close, color: Colors.white),
                                  label: const Text(
                                    'Reject Report',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    ),
  );
}

  // Helper method to build user details section
  Widget _buildUserDetails(Map<String, dynamic> userData) {
    String phone = userData['phone'] ?? 'Not provided';
    String address = userData['address'] ?? 'Not provided';
    int donationsCount = (userData['donationsCount'] ?? 0) as int;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Contact Information
        _buildSectionTitle('Contact Information'),
        _buildInfoRow(Icons.phone, 'Phone: $phone'),
        _buildInfoRow(Icons.location_on, 'Address: $address'),
        
        const SizedBox(height: 15),
        // Donations Information
       // _buildSectionTitle('Donation Activity'),
        //_buildInfoRow(
        //  Icons.volunteer_activism,
        //  'Total Donations: $donationsCount',
       // ),
        
        // Additional user information can be added here as needed
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Color(0xFF00A86B),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Icon(
            icon,
            size: 18,
            color: const Color(0xFF00A86B),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    required String tooltip,
  }) {
    return Container(
      width: 35,
      height: 35,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Tooltip(
        message: tooltip,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Icon(
            icon,
            color: color,
            size: 18,
          ),
        ),
      ),
    );
  }
}