// import 'package:care__connect/screens/NGO/celebrity_feature_screen.dart';
// import 'package:care__connect/screens/NGO/create_campaign_screen.dart';
// import 'package:care__connect/screens/NGO/widgets/join_requests_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:care__connect/screens/NGO/widgets/donation_details_screen.dart';
// import 'package:care__connect/screens/NGO/widgets/campaign_list_screen.dart';
// import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
// import 'package:care__connect/screens/login_screen.dart';

// class ApprovedNGOView extends StatefulWidget {
//   final DocumentSnapshot ngoData;

//   const ApprovedNGOView({super.key, required this.ngoData});

//   @override
//   _ApprovedNGOViewState createState() => _ApprovedNGOViewState();
// }

// class _ApprovedNGOViewState extends State<ApprovedNGOView> with SingleTickerProviderStateMixin {
//   late double totalDonations;
//   late AnimationController _animationController;
//   late Animation<double> _fadeAnimation;

//   Future<double> fetchTotalDonationsForNgo(String ngoId) async {
//     double totalAmount = 0.0;
//     QuerySnapshot snapshot = await FirebaseFirestore.instance
//         .collection('donations')
//         .where('ngoId', isEqualTo: ngoId)
//         .get();

//     for (var doc in snapshot.docs) {
//       totalAmount += double.tryParse(doc['amount'].toString()) ?? 0.0;
//     }

//     return totalAmount;
//   }

//   int activeCampaignsCount = 0;

//   Future<void> fetchActiveCampaignsCount(String ngoId) async {
//     QuerySnapshot snapshot = await FirebaseFirestore.instance
//       .collection('campaigns')
//       .where('ngoId', isEqualTo: widget.ngoData.id)
//       .where('isClosed', isEqualTo: false)
//       .get();

//     setState(() {
//       activeCampaignsCount = snapshot.docs.length;
//     });
//   }

//   // Function to handle sign out
//   Future<void> _signOut(BuildContext context) async {
//     try {
//       await FirebaseAuth.instance.signOut();
//       // Navigate to login screen or home screen after sign out
//       Navigator.pushReplacement(context, MaterialPageRoute(
//         builder: (context) => const LoginScreen(), // Replace with your login screen
//       ));
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Error signing out: ${e.toString()}'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     totalDonations = 0.0;
//     fetchTotalDonationsForNgo(widget.ngoData.id).then((amount) {
//       setState(() {
//         totalDonations = amount;
//       });
//     });

//     fetchActiveCampaignsCount(widget.ngoData.id);

//     // Initialize animation controller
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

//   @override
//   Widget build(BuildContext context) {
//     final Map<String, dynamic> data =
//         widget.ngoData.data() as Map<String, dynamic>;
//     final String name = data['name'] ?? 'N/A';
//     final String sector = data['sector'] ?? 'N/A';
//     final String description = data['description'] ?? 'N/A';
//     final String logoUrl = data['logoUrl'] ?? '';
//     final List<dynamic> acceptedDonations = data['acceptedDonations'] ?? [];

//     return FadeTransition(
//       opacity: _fadeAnimation,
//       child: SingleChildScrollView(
//         physics: const BouncingScrollPhysics(),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Banner with NGO logo and basic info
//             Container(
//               width: double.infinity,
//               decoration: const BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                   colors: [Color(0xFF00A86B), Color(0xFF009160)],
//                 ),
//                 borderRadius: BorderRadius.only(
//                   bottomLeft: Radius.circular(0),
//                   bottomRight: Radius.circular(0),
//                 ),
//               ),
//               child: Stack(
//                 alignment: Alignment.bottomCenter,
//                 clipBehavior: Clip.none,
//                 children: [
//                   // NGO Info Container
//                   Padding(
//                     padding: const EdgeInsets.fromLTRB(20, 40, 20, 50),
//                     child: Column(
//                       children: [
//                         Row(
//                           children: [
//                             // NGO Logo
//                             Hero(
//                               tag: 'ngo-logo-${widget.ngoData.id}',
//                               child: Container(
//                                 height: 70,
//                                 width: 70,
//                                 decoration: BoxDecoration(
//                                   color: Colors.white,
//                                   shape: BoxShape.circle,
//                                   boxShadow: [
//                                     BoxShadow(
//                                       color: Colors.black.withOpacity(0.1),
//                                       blurRadius: 10,
//                                       spreadRadius: 1,
//                                     ),
//                                   ],
//                                   image: logoUrl.isNotEmpty
//                                       ? DecorationImage(
//                                           image: NetworkImage(logoUrl),
//                                           fit: BoxFit.cover,
//                                         )
//                                       : null,
//                                 ),
//                                 child: logoUrl.isEmpty
//                                     ? Icon(
//                                         Icons.business_rounded,
//                                         size: 35,
//                                         color: Colors.grey[400],
//                                       )
//                                     : null,
//                               ),
//                             ),
//                             const SizedBox(width: 16),

//                             // NGO Name and Sector
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     name,
//                                     style: const TextStyle(
//                                       fontSize: 22,
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                                   const SizedBox(height: 6),
//                                   Container(
//                                     padding: const EdgeInsets.symmetric(
//                                       horizontal: 12,
//                                       vertical: 5,
//                                     ),
//                                     decoration: BoxDecoration(
//                                       color: Colors.white.withOpacity(0.2),
//                                       borderRadius: BorderRadius.circular(15),
//                                     ),
//                                     child: Text(
//                                       sector,
//                                       style: const TextStyle(
//                                         fontSize: 13,
//                                         fontWeight: FontWeight.w500,
//                                         color: Colors.white,
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),

//                             // Approval Badge
//                             Container(
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 12,
//                                 vertical: 8,
//                               ),
//                               decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius: BorderRadius.circular(20),
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: Colors.black.withOpacity(0.05),
//                                     blurRadius: 10,
//                                     spreadRadius: 1,
//                                   ),
//                                 ],
//                               ),
//                               child: const Row(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   Icon(
//                                     Icons.verified,
//                                     color: const Color(0xFF00A86B),
//                                     size: 14,
//                                   ),
//                                   const SizedBox(width: 4),
//                                   Text(
//                                     "Approved",
//                                     style: TextStyle(
//                                       color: const Color(0xFF00A86B),
//                                       fontSize: 12,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 20),

//                         // Description
//                         Container(
//                           padding: const EdgeInsets.all(15),
//                           decoration: BoxDecoration(
//                             color: Colors.white.withOpacity(0.15),
//                             borderRadius: BorderRadius.circular(50),
//                             border: Border.all(
//                               color: Colors.white.withOpacity(0.3),
//                               width: 1,
//                             ),
//                           ),
//                           child: Text(
//                             description,
//                             style: const TextStyle(
//                               color: Colors.white,
//                               fontSize: 14,
//                               height: 1.5,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),

//                   // Stats Summary Card
//                   Positioned(
//                     bottom: -60,
//                     left: 20,
//                     right: 20,
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(20),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black.withOpacity(0.1),
//                             blurRadius: 20,
//                             spreadRadius: 5,
//                             offset: const Offset(0, 5),
//                           ),
//                         ],
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceAround,
//                         children: [
//                           _buildStatsItem(
//                             '₹${totalDonations.toStringAsFixed(0)}',
//                             'Donations',
//                             Icons.monetization_on_outlined,
//                             onTap: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => DonationDetailsScreen(ngoId: widget.ngoData.id),
//                                 ),
//                               );
//                             },
//                           ),
//                           _buildDivider(),
//                           _buildStatsItem(
//                             '$activeCampaignsCount',
//                             'Campaigns',
//                             Icons.campaign_outlined,
//                             onTap: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => CampaignListScreen(ngoId: widget.ngoData.id),
//                                 ),
//                               );
//                             },
//                           ),
//                           _buildDivider(),
//                           _buildStatsItem(
//                             '184',
//                             'Supporters',
//                             Icons.people_outline,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             const SizedBox(height: 100),

//             // Section: Accepted Donations
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       const Text(
//                         "Accepted Donations",
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       TextButton(
//                         onPressed: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => DonationDetailsScreen(ngoId: widget.ngoData.id),
//                             ),
//                           );
//                         },
//                         child: Text(
//                           "View All",
//                           style: TextStyle(
//                             fontSize: 14,
//                             fontWeight: FontWeight.w600,
//                             color: const Color(0xFF00A86B),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 15),

//                   // Donation Types
//                   Wrap(
//                     spacing: 10,
//                     runSpacing: 10,
//                     children: acceptedDonations.map<Widget>((type) {
//                       IconData icon;
//                       Color color;

//                       switch (type) {
//                         case 'Money':
//                           icon = Icons.attach_money;
//                           color = const Color(0xFF00A86B);
//                           break;
//                         case 'Clothes':
//                           icon = Icons.checkroom_outlined;
//                           color = Colors.blue;
//                           break;
//                         case 'Books':
//                           icon = Icons.book_outlined;
//                           color = Colors.orange;
//                           break;
//                         case 'Food':
//                           icon = Icons.fastfood_outlined;
//                           color = Colors.red;
//                           break;
//                         default:
//                           icon = Icons.volunteer_activism;
//                           color = Colors.purple;
//                       }

//                       return Container(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 15,
//                           vertical: 10,
//                         ),
//                         decoration: BoxDecoration(
//                           color: color.withOpacity(0.1),
//                           borderRadius: BorderRadius.circular(20),
//                           border: Border.all(
//                             color: color.withOpacity(0.3),
//                             width: 1.5,
//                           ),
//                         ),
//                         child: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Icon(
//                               icon,
//                               size: 18,
//                               color: color,
//                             ),
//                             const SizedBox(width: 8),
//                             Text(
//                               type,
//                               style: TextStyle(
//                                 color: color,
//                                 fontWeight: FontWeight.w600,
//                                 fontSize: 14,
//                               ),
//                             ),
//                           ],
//                         ),
//                       );
//                     }).toList(),
//                   ),
//                 ],
//               ),
//             ),

//             const SizedBox(height: 30),

//             // Section: Quick Actions
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     "Quick Actions",
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),

//                   // Action Cards
//                   GridView.count(
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     crossAxisCount: 2,
//                     crossAxisSpacing: 15,
//                     mainAxisSpacing: 15,
//                     childAspectRatio: 1.1,
//                     children: [
//                       _buildActionCard(
//                         context,
//                         "Create Campaign",
//                         Icons.campaign_outlined,
//                         const Color(0xFF00A86B),
//                         () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => const CreateCampaignScreen(),
//                             ),
//                           );
//                         },
//                       ),
//                       // _buildActionCard(
//                       //   context,
//                       //   "Donation History",
//                       //   Icons.history,
//                       //   Colors.purple,
//                       //   () {
//                       //     Navigator.push(
//                       //       context,
//                       //       MaterialPageRoute(
//                       //         builder: (context) => ,
//                       //       ),
//                       //     );
//                       //   },
//                       // ),
//                       _buildActionCard(
//                         context,
//                         "Approve Users",
//                         Icons.verified_user_outlined,
//                         Colors.blue,
//                         () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => const JoinRequestsScreen(),
//                             ),
//                           );
//                         },
//                       ),
//                       _buildActionCard(
//                         context,
//                         "Contact Celebrity",
//                         Icons.star,
//                         Colors.orange,
//                         () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => const CelebrityFeatureScreen(),
//                             ),
//                           );
//                         },
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),

//             const SizedBox(height: 30),

//             // Recent Activities Section
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       const Text(
//                         "Recent Activities",
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       TextButton(
//                         onPressed: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => CampaignListScreen(ngoId: widget.ngoData.id),
//                             ),
//                           );
//                         },
//                         child: Text(
//                           "View All",
//                           style: TextStyle(
//                             fontSize: 14,
//                             fontWeight: FontWeight.w600,
//                             color: const Color(0xFF00A86B),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 15),

//                   // Activity cards
//                   _buildActivityCard(
//                     "New Donation Received",
//                     "Rahul donated ₹2,500 to 'Clean Water Campaign'",
//                     "30 min ago",
//                     Icons.monetization_on_outlined,
//                     const Color(0xFF00A86B),
//                   ),
//                   const SizedBox(height: 12),
//                   _buildActivityCard(
//                     "Campaign Updated",
//                     "Education for All campaign reached 75% of the goal",
//                     "2 hours ago",
//                     Icons.campaign_outlined,
//                     Colors.blue,
//                   ),
//                 ],
//               ),
//             ),

//             const SizedBox(height: 30),

//             // Sign Out Button - NEW ADDITION
//             Padding(
//               padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
//               child: Container(
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(15),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.grey.withOpacity(0.1),
//                       spreadRadius: 1,
//                       blurRadius: 8,
//                       offset: const Offset(0, 3),
//                     ),
//                   ],
//                 ),
//                 child: ElevatedButton.icon(
//                   onPressed: () => _showSignOutDialog(context),
//                   icon: const Icon(Icons.logout_rounded, color: Colors.white),
//                   label: const Text(
//                     "Sign Out",
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.white,
//                     ),
//                   ),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFF565656),
//                     foregroundColor: Colors.white,
//                     padding: const EdgeInsets.symmetric(vertical: 16),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(15),
//                     ),
//                     elevation: 0,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // Dialog to confirm sign out - NEW ADDITION
//   void _showSignOutDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20),
//           ),
//           title: const Text(
//             "Sign Out",
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           content: const Text(
//             "Are you sure you want to sign out from your account?",
//             style: TextStyle(
//               fontSize: 15,
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(),
//               child: Text(
//                 "Cancel",
//                 style: TextStyle(
//                   color: Colors.grey[700],
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 _signOut(context);
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color(0xFF00A86B),
//                 foregroundColor: Colors.white,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//               child: const Text(
//                 "Yes, Sign Out",
//                 style: TextStyle(
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Widget _buildStatsItem(String value, String label, IconData icon, {VoidCallback? onTap}) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Container(
//             padding: const EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               color: const Color(0xFF00A86B).withOpacity(0.1),
//               shape: BoxShape.circle,
//             ),
//             child: Icon(
//               icon,
//               color: const Color(0xFF00A86B),
//               size: 20,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             value,
//             style: const TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//               color: Color(0xFF00A86B),
//             ),
//           ),
//           Text(
//             label,
//             style: TextStyle(
//               fontSize: 12,
//               color: Colors.grey[600],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDivider() {
//     return Container(
//       height: 40,
//       width: 1,
//       color: Colors.grey.withOpacity(0.3),
//     );
//   }

//   Widget _buildActionCard(
//     BuildContext context,
//     String title,
//     IconData icon,
//     Color color,
//     VoidCallback onTap,
//   ) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(15),
//       child: Ink(
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(15),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.1),
//               spreadRadius: 1,
//               blurRadius: 8,
//               offset: const Offset(0, 4),
//             ),
//           ],
//           border: Border.all(color: Colors.grey.shade200),
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: color.withOpacity(0.1),
//                 shape: BoxShape.circle,
//               ),
//               child: Icon(
//                 icon,
//                 color: color,
//                 size: 26,
//               ),
//             ),
//             const SizedBox(height: 15),
//             Text(
//               title,
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontWeight: FontWeight.w600,
//                 fontSize: 15,
//                 color: Colors.grey[800],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildActivityCard(
//     String title,
//     String description,
//     String timeAgo,
//     IconData icon,
//     Color color,
//   ) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(15),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             spreadRadius: 1,
//             blurRadius: 8,
//             offset: const Offset(0, 3),
//           ),
//         ],
//         border: Border.all(color: Colors.grey.shade200),
//       ),
//       child: Row(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(10),
//             decoration: BoxDecoration(
//               color: color.withOpacity(0.1),
//               shape: BoxShape.circle,
//             ),
//             child: Icon(
//               icon,
//               color: color,
//               size: 24,
//             ),
//           ),
//           const SizedBox(width: 15),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   style: const TextStyle(
//                     fontWeight: FontWeight.w600,
//                     fontSize: 15,
//                   ),
//                 ),
//                 const SizedBox(height: 5),
//                 Text(
//                   description,
//                   style: TextStyle(
//                     fontSize: 13,
//                     color: Colors.grey[600],
//                   ),
//                 ),
//                 const SizedBox(height: 5),
//                 Text(
//                   timeAgo,
//                   style: TextStyle(
//                     fontSize: 12,
//                     color: Colors.grey[400],
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// import 'package:care__connect/screens/NGO/campaign_drives_screens.dart';
// import 'package:care__connect/screens/NGO/celebrity_feature_screen.dart';
// import 'package:care__connect/screens/NGO/create_campaign_screen.dart';
// import 'package:care__connect/screens/NGO/widgets/join_requests_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:care__connect/screens/NGO/widgets/donation_details_screen.dart';
// import 'package:care__connect/screens/NGO/widgets/campaign_list_screen.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:care__connect/screens/login_screen.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:care__connect/services/auth_service.dart';

// class ApprovedNGOView extends StatefulWidget {
//   final DocumentSnapshot ngoData;

//   const ApprovedNGOView({super.key, required this.ngoData});

//   @override
//   _ApprovedNGOViewState createState() => _ApprovedNGOViewState();
// }

// class _ApprovedNGOViewState extends State<ApprovedNGOView>
//     with TickerProviderStateMixin {
//   late TabController _tabController;
//   late double totalDonations;
//   late AnimationController _animationController;
//   late Animation<double> _fadeAnimation;
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//   int activeCampaignsCount = 0;
//   int supportersCount = 184; // Using the hardcoded value from original code

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 3, vsync: this);
//     totalDonations = 0.0;

//     // Initialize animation controller
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

//     _loadData();
//     _animationController.forward();
//   }

//   Future<void> _loadData() async {
//     final amount = await fetchTotalDonationsForNgo(widget.ngoData.id);
//     await fetchActiveCampaignsCount(widget.ngoData.id);

//     if (mounted) {
//       setState(() {
//         totalDonations = amount;
//       });
//     }
//   }

//   Future<double> fetchTotalDonationsForNgo(String ngoId) async {
//     double totalAmount = 0.0;
//     QuerySnapshot snapshot = await FirebaseFirestore.instance
//         .collection('donations')
//         .where('ngoId', isEqualTo: ngoId)
//         .get();

//     for (var doc in snapshot.docs) {
//       totalAmount += double.tryParse(doc['amount'].toString()) ?? 0.0;
//     }

//     return totalAmount;
//   }

//   Future<void> fetchActiveCampaignsCount(String ngoId) async {
//     QuerySnapshot snapshot = await FirebaseFirestore.instance
//         .collection('campaigns')
//         .where('ngoId', isEqualTo: widget.ngoData.id)
//         .where('isClosed', isEqualTo: false)
//         .get();

//     if (mounted) {
//       setState(() {
//         activeCampaignsCount = snapshot.docs.length;
//       });
//     }
//   }

// Future<void> _deleteFcmTokenForNGO() async {
//   final user = FirebaseAuth.instance.currentUser;

//   if (user != null) {
//     try {
//       await FirebaseFirestore.instance
//           .collection('ngos')
//           .doc(user.uid)
//           .update({'fcmToken': FieldValue.delete()});

//       debugPrint('🧹 FCM token deleted from ngos collection');
//     } catch (e) {
//       debugPrint('❌ Error deleting FCM token for NGO: $e');
//     }
//   }
// }

//   void _signOut(BuildContext context) async {
//   final user = FirebaseAuth.instance.currentUser;

//   // Step 1: Sign out and navigate first
//   await FirebaseAuth.instance.signOut();

//   // Step 2: Navigate immediately
//   Navigator.of(context).pushAndRemoveUntil(
//     MaterialPageRoute(builder: (_) => const LoginScreen()),
//     (route) => false,
//   );

//   // Step 3: After navigation, delete the FCM token in background
//   Future.microtask(() async {
//     try {
//       if (user != null) {
//         await FirebaseFirestore.instance
//             .collection('ngos')
//             .doc(user.uid)
//             .update({'fcmToken': FieldValue.delete()});

//         debugPrint('🧹🧹🧹 FCM token deleted from ngos collection');
//       }
//     } catch (e) {
//       debugPrint('❌❌❌ Failed to delete FCM token: $e');
//     }
//   });
// }

//   void _showSignOutDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20),
//           ),
//           title: const Text(
//             "Sign Out",
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           content: const Text(
//             "Are you sure you want to sign out from your account?",
//             style: TextStyle(
//               fontSize: 15,
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(),
//               child: Text(
//                 "Cancel",
//                 style: TextStyle(
//                   color: Colors.grey[700],
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 _signOut(context);
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color(0xFF00A86B),
//                 foregroundColor: Colors.white,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//               child: const Text(
//                 "Yes, Sign Out",
//                 style: TextStyle(
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     _animationController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final Map<String, dynamic> data =
//         widget.ngoData.data() as Map<String, dynamic>;
//     final String name = data['name'] ?? 'N/A';
//     final String sector = data['sector'] ?? 'N/A';
//     final String description = data['description'] ?? 'N/A';
//     final String logoUrl = data['logoUrl'] ?? '';
//     final List<dynamic> acceptedDonations = data['acceptedDonations'] ?? [];

//     return Scaffold(
//       key: _scaffoldKey,
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF00A86B),
//         elevation: 0,
//         title: const Text(
//           "NGO Dashboard",
//           style: TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.notifications_outlined, color: Colors.white),
//             onPressed: () {
//               // Notification action
//             },
//           ),
//         ],
//         leading: IconButton(
//           icon: const Icon(Icons.menu, color: Colors.white),
//           onPressed: () {
//             _scaffoldKey.currentState?.openDrawer();
//           },
//         ),
//       ),
//       drawer: _buildDrawer(context, name, logoUrl),
//       body: FadeTransition(
//         opacity: _fadeAnimation,
//         child: Column(
//           children: [
//             // Profile Banner
//             _buildProfileBanner(name, sector, description, logoUrl),

//             // Stats Summary
//             _buildStatsSummary(),

//             // Tab Bar
//             Container(
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.1),
//                     spreadRadius: 0,
//                     blurRadius: 4,
//                     offset: const Offset(0, 2),
//                   ),
//                 ],
//               ),
//               child: TabBar(
//                 controller: _tabController,
//                 labelColor: const Color(0xFF00A86B),
//                 unselectedLabelColor: Colors.grey,
//                 indicatorColor: const Color(0xFF00A86B),
//                 indicatorWeight: 3,
//                 labelStyle: const TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 14,
//                 ),
//                 tabs: const [
//                   Tab(
//                     icon: Icon(Icons.dashboard_outlined),
//                     text: "Dashboard",
//                   ),
//                   Tab(
//                     icon: Icon(Icons.campaign_outlined),
//                     text: "Campaigns",
//                   ),
//                   Tab(
//                     icon: Icon(Icons.people_outline),
//                     text: "Community",
//                   ),
//                 ],
//               ),
//             ),

//             // Tab Content
//             Expanded(
//               child: TabBarView(
//                 controller: _tabController,
//                 children: [
//                   // Dashboard Tab
//                   _buildDashboardTab(acceptedDonations),

//                   // Campaigns Tab
//                   _buildCampaignsTab(),

//                   // Community Tab
//                   _buildCommunityTab(),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => const CreateCampaignScreen(),
//             ),
//           );
//         },
//         backgroundColor: const Color(0xFF00A86B),
//         child: const Icon(Icons.add, color: Colors.white),
//       ),
//     );
//   }

//   Widget _buildDrawer(BuildContext context, String name, String logoUrl) {
//     return Drawer(
//       child: ListView(
//         padding: EdgeInsets.zero,
//         children: [
//           DrawerHeader(
//             decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//                 colors: [Color(0xFF00A86B), Color(0xFF009160)],
//               ),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Container(
//                   height: 70,
//                   width: 70,
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     shape: BoxShape.circle,
//                     image: logoUrl.isNotEmpty
//                         ? DecorationImage(
//                             image: NetworkImage(logoUrl),
//                             fit: BoxFit.cover,
//                           )
//                         : null,
//                   ),
//                   child: logoUrl.isEmpty
//                       ? const Icon(
//                           Icons.business_rounded,
//                           size: 35,
//                           color: Colors.grey,
//                         )
//                       : null,
//                 ),
//                 const SizedBox(height: 12),
//                 Text(
//                   name,
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 const Text(
//                   "NGO Admin",
//                   style: TextStyle(
//                     color: Colors.white70,
//                     fontSize: 14,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           _buildDrawerItem(
//             icon: Icons.dashboard_outlined,
//             title: "Dashboard",
//             onTap: () {
//               Navigator.pop(context);
//               _tabController.animateTo(0);
//             },
//           ),
//           _buildDrawerItem(
//             icon: Icons.campaign_outlined,
//             title: "Manage Campaigns",
//             onTap: () {
//               Navigator.pop(context);
//               _tabController.animateTo(1);
//             },
//           ),
//           _buildDrawerItem(
//             icon: Icons.monetization_on_outlined,
//             title: "Donation Details",
//             onTap: () {
//               Navigator.pop(context);
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) =>
//                       DonationDetailsScreen(ngoId: widget.ngoData.id),
//                 ),
//               );
//             },
//           ),
//           _buildDrawerItem(
//             icon: Icons.verified_user_outlined,
//             title: "Join Requests",
//             onTap: () {
//               Navigator.pop(context);
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => const JoinRequestsScreen(),
//                 ),
//               );
//             },
//           ),
//           _buildDrawerItem(
//             icon: Icons.star_outline,
//             title: "Celebrity Feature",
//             onTap: () {
//               Navigator.pop(context);
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => const CelebrityFeatureScreen(),
//                 ),
//               );
//             },
//           ),
//           const Divider(),
//           _buildDrawerItem(
//             icon: Icons.settings_outlined,
//             title: "Settings",
//             onTap: () {
//               Navigator.pop(context);
//               // Navigate to settings
//             },
//           ),
//           _buildDrawerItem(
//             icon: Icons.help_outline,
//             title: "Help & Support",
//             onTap: () {
//               Navigator.pop(context);
//               // Navigate to help
//             },
//           ),
//           const Divider(),
//           _buildDrawerItem(
//             icon: Icons.logout_rounded,
//             title: "Sign Out",
//             onTap: () {
//               Navigator.pop(context);
//               _showSignOutDialog(context);
//             },
//             color: Colors.red,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDrawerItem({
//     required IconData icon,
//     required String title,
//     required VoidCallback onTap,
//     Color? color,
//   }) {
//     return ListTile(
//       leading: Icon(
//         icon,
//         color: color ?? Colors.grey[700],
//       ),
//       title: Text(
//         title,
//         style: TextStyle(
//           color: color ?? Colors.grey[800],
//           fontWeight: FontWeight.w500,
//         ),
//       ),
//       onTap: onTap,
//     );
//   }

//   Widget _buildProfileBanner(
//       String name, String sector, String description, String logoUrl) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//       decoration: const BoxDecoration(
//         color: Color(0xFF00A86B),
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // NGO Logo
//           Container(
//             height: 60,
//             width: 60,
//             decoration: BoxDecoration(
//               color: Colors.white,
//               shape: BoxShape.circle,
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.1),
//                   blurRadius: 10,
//                   spreadRadius: 1,
//                 ),
//               ],
//               image: logoUrl.isNotEmpty
//                   ? DecorationImage(
//                       image: NetworkImage(logoUrl),
//                       fit: BoxFit.cover,
//                     )
//                   : null,
//             ),
//             child: logoUrl.isEmpty
//                 ? Icon(
//                     Icons.business_rounded,
//                     size: 30,
//                     color: Colors.grey[400],
//                   )
//                 : null,
//           ),
//           const SizedBox(width: 15),

//           // NGO Info
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   name,
//                   style: const TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//                 const SizedBox(height: 5),
//                 Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 10,
//                     vertical: 4,
//                   ),
//                   decoration: BoxDecoration(
//                     color: Colors.white.withOpacity(0.2),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Text(
//                     sector,
//                     style: const TextStyle(
//                       fontSize: 12,
//                       fontWeight: FontWeight.w500,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           // Approval Badge
//           Container(
//             padding: const EdgeInsets.symmetric(
//               horizontal: 10,
//               vertical: 6,
//             ),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(15),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.05),
//                   blurRadius: 8,
//                   spreadRadius: 1,
//                 ),
//               ],
//             ),
//             child: const Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Icon(
//                   Icons.verified,
//                   color: Color(0xFF00A86B),
//                   size: 12,
//                 ),
//                 SizedBox(width: 4),
//                 Text(
//                   "Approved",
//                   style: TextStyle(
//                     color: Color(0xFF00A86B),
//                     fontSize: 11,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildStatsSummary() {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
//       padding: const EdgeInsets.all(15),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(15),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             blurRadius: 10,
//             spreadRadius: 0,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: [
//           _buildStatItem(
//             '₹${totalDonations.toStringAsFixed(0)}',
//             'Donations',
//             Icons.monetization_on_outlined,
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) =>
//                       DonationDetailsScreen(ngoId: widget.ngoData.id),
//                 ),
//               );
//             },
//           ),
//           _buildDivider(),
//           _buildStatItem(
//             '$activeCampaignsCount',
//             'Campaigns',
//             Icons.campaign_outlined,
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) =>
//                       CampaignListScreen(ngoId: widget.ngoData.id),
//                 ),
//               );
//             },
//           ),
//           _buildDivider(),
//           _buildStatItem(
//             '$supportersCount',
//             'Supporters',
//             Icons.people_outline,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildStatItem(String value, String label, IconData icon,
//       {VoidCallback? onTap}) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Container(
//             padding: const EdgeInsets.all(10),
//             decoration: BoxDecoration(
//               color: const Color(0xFF00A86B).withOpacity(0.1),
//               shape: BoxShape.circle,
//             ),
//             child: Icon(
//               icon,
//               color: const Color(0xFF00A86B),
//               size: 22,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             value,
//             style: const TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//               color: Color(0xFF00A86B),
//             ),
//           ),
//           Text(
//             label,
//             style: TextStyle(
//               fontSize: 12,
//               color: Colors.grey[600],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDivider() {
//     return Container(
//       height: 40,
//       width: 1,
//       color: Colors.grey.withOpacity(0.3),
//     );
//   }

//   Widget _buildDashboardTab(List<dynamic> acceptedDonations) {
//     return SingleChildScrollView(
//       physics: const BouncingScrollPhysics(),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Quick Actions Cards
//             const Text(
//               "Quick Actions",
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 15),
//             _buildQuickActions(),

//             const SizedBox(height: 25),

//             // Accepted Donations Section
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text(
//                   "Accepted Donations",
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 TextButton(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) =>
//                             DonationDetailsScreen(ngoId: widget.ngoData.id),
//                       ),
//                     );
//                   },
//                   child: const Text(
//                     "View All",
//                     style: TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.w600,
//                       color: Color(0xFF00A86B),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 12),
//             _buildAcceptedDonations(acceptedDonations),

//             const SizedBox(height: 25),

//             // Recent Activities Section
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text(
//                   "Recent Activities",
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 TextButton(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) =>
//                             CampaignListScreen(ngoId: widget.ngoData.id),
//                       ),
//                     );
//                   },
//                   child: const Text(
//                     "View All",
//                     style: TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.w600,
//                       color: Color(0xFF00A86B),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 12),
//             _buildRecentActivities(),

//             const SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildQuickActions() {
//     return SizedBox(
//       height: 110,
//       child: ListView(
//         scrollDirection: Axis.horizontal,
//         physics: const BouncingScrollPhysics(),
//         children: [
//           _buildQuickActionCard(
//             "Create Campaign",
//             Icons.campaign_outlined,
//             const Color(0xFF00A86B),
//             () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => const CreateCampaignScreen(),
//                 ),
//               );
//             },
//           ),
//           _buildQuickActionCard(
//             "Approve Users",
//             Icons.verified_user_outlined,
//             Colors.blue,
//             () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => const JoinRequestsScreen(),
//                 ),
//               );
//             },
//           ),
//           _buildQuickActionCard(
//             "Contact Celebrity",
//             Icons.star,
//             Colors.orange,
//             () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => const CelebrityFeatureScreen(),
//                 ),
//               );
//             },
//           ),
//           _buildQuickActionCard(
//             "Donation Details",
//             Icons.monetization_on_outlined,
//             Colors.purple,
//             () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) =>
//                       DonationDetailsScreen(ngoId: widget.ngoData.id),
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildQuickActionCard(
//     String title,
//     IconData icon,
//     Color color,
//     VoidCallback onTap,
//   ) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         width: 135,
//         margin: const EdgeInsets.only(right: 15),
//         padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(15),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.1),
//               blurRadius: 8,
//               spreadRadius: 0,
//               offset: const Offset(0, 2),
//             ),
//           ],
//           border: Border.all(color: Colors.grey.shade100),
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               padding: const EdgeInsets.all(10),
//               decoration: BoxDecoration(
//                 color: color.withOpacity(0.1),
//                 shape: BoxShape.circle,
//               ),
//               child: Icon(
//                 icon,
//                 color: color,
//                 size: 24,
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               title,
//               textAlign: TextAlign.center,
//               style: const TextStyle(
//                 fontWeight: FontWeight.w600,
//                 fontSize: 12,
//               ),
//               maxLines: 2,
//               overflow: TextOverflow.ellipsis,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildAcceptedDonations(List<dynamic> acceptedDonations) {
//     Map<String, Map<String, dynamic>> donationTypeInfo = {
//       'Money': {
//         'icon': Icons.attach_money,
//         'color': const Color(0xFF00A86B),
//       },
//       'Clothes': {
//         'icon': Icons.checkroom_outlined,
//         'color': Colors.blue,
//       },
//       'Books': {
//         'icon': Icons.book_outlined,
//         'color': Colors.orange,
//       },
//       'Food': {
//         'icon': Icons.fastfood_outlined,
//         'color': Colors.red,
//       },
//       'Volunteer': {
//         'icon': Icons.volunteer_activism,
//         'color': Colors.purple,
//       },
//     };

//     return Wrap(
//       spacing: 10,
//       runSpacing: 10,
//       children: acceptedDonations.map<Widget>((type) {
//         final Map<String, dynamic> info = donationTypeInfo[type] ??
//             {
//               'icon': Icons.volunteer_activism,
//               'color': Colors.purple,
//             };

//         return Container(
//           padding: const EdgeInsets.symmetric(
//             horizontal: 15,
//             vertical: 10,
//           ),
//           decoration: BoxDecoration(
//             color: info['color'].withOpacity(0.1),
//             borderRadius: BorderRadius.circular(20),
//             border: Border.all(
//               color: info['color'].withOpacity(0.3),
//               width: 1.5,
//             ),
//           ),
//           child: Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Icon(
//                 info['icon'],
//                 size: 18,
//                 color: info['color'],
//               ),
//               const SizedBox(width: 8),
//               Text(
//                 type,
//                 style: TextStyle(
//                   color: info['color'],
//                   fontWeight: FontWeight.w600,
//                   fontSize: 14,
//                 ),
//               ),
//             ],
//           ),
//         );
//       }).toList(),
//     );
//   }

//   Widget _buildRecentActivities() {
//     return Column(
//       children: [
//         _buildActivityCard(
//           "New Donation Received",
//           "Rahul donated ₹2,500 to 'Clean Water Campaign'",
//           "30 min ago",
//           Icons.monetization_on_outlined,
//           const Color(0xFF00A86B),
//         ),
//         const SizedBox(height: 12),
//         _buildActivityCard(
//           "Campaign Updated",
//           "Education for All campaign reached 75% of the goal",
//           "2 hours ago",
//           Icons.campaign_outlined,
//           Colors.blue,
//         ),
//         const SizedBox(height: 12),
//         _buildActivityCard(
//           "New Volunteer Joined",
//           "Anjali joined to volunteer for 'Youth Empowerment'",
//           "Yesterday",
//           Icons.person_add_outlined,
//           Colors.purple,
//         ),
//       ],
//     );
//   }

//   Widget _buildActivityCard(
//     String title,
//     String description,
//     String timeAgo,
//     IconData icon,
//     Color color,
//   ) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(15),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             spreadRadius: 0,
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//         border: Border.all(color: Colors.grey.shade100),
//       ),
//       child: Row(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(10),
//             decoration: BoxDecoration(
//               color: color.withOpacity(0.1),
//               shape: BoxShape.circle,
//             ),
//             child: Icon(
//               icon,
//               color: color,
//               size: 24,
//             ),
//           ),
//           const SizedBox(width: 15),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   style: const TextStyle(
//                     fontWeight: FontWeight.w600,
//                     fontSize: 15,
//                   ),
//                 ),
//                 const SizedBox(height: 5),
//                 Text(
//                   description,
//                   style: TextStyle(
//                     fontSize: 13,
//                     color: Colors.grey[600],
//                   ),
//                 ),
//                 const SizedBox(height: 5),
//                 Text(
//                   timeAgo,
//                   style: TextStyle(
//                     fontSize: 12,
//                     color: Colors.grey[400],
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildCampaignsTab() {
//     return FutureBuilder<QuerySnapshot>(
//       future: FirebaseFirestore.instance
//           .collection('campaigns')
//           .where('ngoId', isEqualTo: widget.ngoData.id)
//           .orderBy('createdAt', descending: true)
//           .get(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(
//             child: CircularProgressIndicator(
//               color: Color(0xFF00A86B),
//             ),
//           );
//         }

//         if (snapshot.hasError) {
//           return Center(
//             child: Text(
//               'Error loading campaigns: ${snapshot.error}',
//               style: TextStyle(color: Colors.red[700]),
//             ),
//           );
//         }

//         if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(
//                   Icons.campaign_outlined,
//                   size: 70,
//                   color: Colors.grey[400],
//                 ),
//                 const SizedBox(height: 15),
//                 Text(
//                   "No campaigns yet",
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.grey[600],
//                   ),
//                 ),
//                 const SizedBox(height: 5),
//                 Text(
//                   "Create a new campaign to get started",
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: Colors.grey[500],
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 ElevatedButton.icon(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => const CreateCampaignScreen(),
//                       ),
//                     );
//                   },
//                   icon: const Icon(Icons.add),
//                   label: const Text("Create Campaign"),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFF00A86B),
//                     foregroundColor: Colors.white,
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 20, vertical: 12),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         }

//         // Group campaigns by status
//         List<DocumentSnapshot> activeCampaigns = [];
//         List<DocumentSnapshot> completedCampaigns = [];

//         for (var doc in snapshot.data!.docs) {
//           final data = doc.data() as Map<String, dynamic>;
//           if (data['isClosed'] == true) {
//             completedCampaigns.add(doc);
//           } else {
//             activeCampaigns.add(doc);
//           }
//         }

//         return SingleChildScrollView(
//           padding: const EdgeInsets.all(16),
//           physics: const BouncingScrollPhysics(),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Create Campaign Button
//               Container(
//                 width: double.infinity,
//                 margin: const EdgeInsets.only(bottom: 20),
//                 child: ElevatedButton.icon(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => const CreateCampaignScreen(),
//                       ),
//                     );
//                   },
//                   icon: const Icon(Icons.add),
//                   label: const Text("Create New Campaign"),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFF00A86B),
//                     foregroundColor: Colors.white,
//                     padding: const EdgeInsets.symmetric(vertical: 15),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                 ),
//               ),

//               // Active Campaigns
//               if (activeCampaigns.isNotEmpty) ...[
//                 const Text(
//                   "Active Campaigns",
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 15),
//                 ...activeCampaigns
//                     .map((doc) => _buildCampaignCard(doc, isActive: true))
//                     .toList(),
//                 const SizedBox(height: 25),
//               ],

//               // Completed Campaigns
//               if (completedCampaigns.isNotEmpty) ...[
//                 const Text(
//                   "Completed Campaigns",
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 15),
//                 ...completedCampaigns
//                     .map((doc) => _buildCampaignCard(doc, isActive: false))
//                     .toList(),
//               ],
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildCampaignCard(DocumentSnapshot doc, {required bool isActive}) {
//     final data = doc.data() as Map<String, dynamic>;
//     final String title = data['title'] ?? 'Campaign';
//     final String description = data['description'] ?? 'No description';
//     final String imageUrl = data['imageUrl'] ?? '';
//     final double goal = double.tryParse(data['goal'].toString()) ?? 0.0;
//     final double raised = double.tryParse(data['raised'].toString()) ?? 0.0;
//     final double progress = goal > 0 ? (raised / goal).clamp(0.0, 1.0) : 0.0;

//     return Container(
//       margin: const EdgeInsets.only(bottom: 15),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(15),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             spreadRadius: 0,
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//         border: Border.all(color: Colors.grey.shade100),
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(15),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Campaign Image
//             if (imageUrl.isNotEmpty)
//               Container(
//                 height: 120,
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                   image: DecorationImage(
//                     image: NetworkImage(imageUrl),
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//                 child: Align(
//                   alignment: Alignment.topRight,
//                   child: Container(
//                     margin: const EdgeInsets.all(10),
//                     padding:
//                         const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//                     decoration: BoxDecoration(
//                       color:
//                           isActive ? const Color(0xFF00A86B) : Colors.grey[600],
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: Text(
//                       isActive ? "Active" : "Completed",
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 12,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ),
//                 ),
//               )
//             else
//               Container(
//                 height: 120,
//                 width: double.infinity,
//                 color: Colors.grey[200],
//                 child: Center(
//                   child: Icon(
//                     Icons.image_outlined,
//                     size: 40,
//                     color: Colors.grey[400],
//                   ),
//                 ),
//               ),

//             // Campaign Details
//             Padding(
//               padding: const EdgeInsets.all(15),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     title,
//                     style: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                     ),
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   const SizedBox(height: 5),
//                   Text(
//                     description,
//                     style: TextStyle(
//                       fontSize: 13,
//                       color: Colors.grey[600],
//                     ),
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   const SizedBox(height: 15),

//                   // Progress Bar
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             "₹${raised.toStringAsFixed(0)} raised",
//                             style: const TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.w600,
//                               color: Color(0xFF00A86B),
//                             ),
//                           ),
//                           Text(
//                             "₹${goal.toStringAsFixed(0)} goal",
//                             style: TextStyle(
//                               fontSize: 13,
//                               color: Colors.grey[600],
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 8),
//                       LinearProgressIndicator(
//                         value: progress,
//                         backgroundColor: Colors.grey[200],
//                         valueColor: AlwaysStoppedAnimation<Color>(
//                           isActive
//                               ? const Color(0xFF00A86B)
//                               : Colors.grey[500]!,
//                         ),
//                         minHeight: 7,
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       const SizedBox(height: 10),
//                       Center(
//                         child: Text(
//                           "${(progress * 100).toStringAsFixed(0)}% Completed",
//                           style: TextStyle(
//                             fontSize: 12,
//                             fontWeight: FontWeight.w500,
//                             color: Colors.grey[600],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),

//                   const SizedBox(height: 15),

//                   // Action Buttons
//                   Row(
//                     children: [
//                       Expanded(
//                         child: ElevatedButton(
//                           onPressed: () {
//                             // View campaign details
//                           },
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: isActive
//                                 ? const Color(0xFF00A86B)
//                                 : Colors.grey[600],
//                             foregroundColor: Colors.white,
//                             padding: const EdgeInsets.symmetric(vertical: 10),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                           ),
//                           child: const Text("View Details"),
//                         ),
//                       ),
//                       const SizedBox(width: 10),
//                       if (isActive)
//                         OutlinedButton(
//                           onPressed: () {
//                             // Edit campaign
//                           },
//                           style: OutlinedButton.styleFrom(
//                             foregroundColor: const Color(0xFF00A86B),
//                             side: const BorderSide(color: Color(0xFF00A86B)),
//                             padding: const EdgeInsets.symmetric(vertical: 10),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                           ),
//                           child: const Text("Edit"),
//                         ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildCommunityTab() {
//     return SingleChildScrollView(
//       physics: const BouncingScrollPhysics(),
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Join Requests Section
//           Container(
//             padding: const EdgeInsets.all(20),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(15),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.withOpacity(0.1),
//                   spreadRadius: 0,
//                   blurRadius: 8,
//                   offset: const Offset(0, 2),
//                 ),
//               ],
//               border: Border.all(color: Colors.grey.shade100),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Container(
//                       padding: const EdgeInsets.all(10),
//                       decoration: BoxDecoration(
//                         color: Colors.blue.withOpacity(0.1),
//                         shape: BoxShape.circle,
//                       ),
//                       child: const Icon(
//                         Icons.person_add_outlined,
//                         color: Colors.blue,
//                         size: 24,
//                       ),
//                     ),
//                     const SizedBox(width: 15),
//                     const Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             "Join Requests",
//                             style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           SizedBox(height: 5),
//                           Text(
//                             "Review and approve volunteer requests",
//                             style: TextStyle(
//                               fontSize: 13,
//                               color: Colors.grey,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Container(
//                       padding: const EdgeInsets.all(8),
//                       decoration: BoxDecoration(
//                         color: Colors.red.withOpacity(0.1),
//                         shape: BoxShape.circle,
//                       ),
//                       child: const Text(
//                         "12",
//                         style: TextStyle(
//                           color: Colors.red,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 15),
//                 ElevatedButton(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => const JoinRequestsScreen(),
//                       ),
//                     );
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.blue,
//                     foregroundColor: Colors.white,
//                     padding: const EdgeInsets.symmetric(vertical: 12),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                   child: const Text("View All Requests"),
//                 ),
//               ],
//             ),
//           ),

//           const SizedBox(height: 25),

//           // Celebrity Feature Section
//           Container(
//             padding: const EdgeInsets.all(20),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(15),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.withOpacity(0.1),
//                   spreadRadius: 0,
//                   blurRadius: 8,
//                   offset: const Offset(0, 2),
//                 ),
//               ],
//               border: Border.all(color: Colors.grey.shade100),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Container(
//                       padding: const EdgeInsets.all(10),
//                       decoration: BoxDecoration(
//                         color: Colors.orange.withOpacity(0.1),
//                         shape: BoxShape.circle,
//                       ),
//                       child: const Icon(
//                         Icons.star,
//                         color: Colors.orange,
//                         size: 24,
//                       ),
//                     ),
//                     const SizedBox(width: 15),
//                     const Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             "Celebrity Feature",
//                             style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           SizedBox(height: 5),
//                           Text(
//                             "Invite celebrities to promote your campaigns",
//                             style: TextStyle(
//                               fontSize: 13,
//                               color: Colors.grey,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 15),
//                 ElevatedButton(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => const CelebrityFeatureScreen(),
//                       ),
//                     );
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.orange,
//                     foregroundColor: Colors.white,
//                     padding: const EdgeInsets.symmetric(vertical: 12),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                   child: const Text("Contact Celebrities"),
//                 ),
//               ],
//             ),
//           ),

//           const SizedBox(height: 25),

//           // Team Members Section
//           const Text(
//             "Team Members",
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(height: 15),

//           // Sample team members
//           _buildTeamMemberCard(
//             "Rahul Sharma",
//             "Administrator",
//             "https://randomuser.me/api/portraits/men/32.jpg",
//           ),
//           _buildTeamMemberCard(
//             "Priya Patel",
//             "Campaign Manager",
//             "https://randomuser.me/api/portraits/women/44.jpg",
//           ),
//           _buildTeamMemberCard(
//             "Amit Kumar",
//             "Volunteer Coordinator",
//             "https://randomuser.me/api/portraits/men/45.jpg",
//           ),

//           const SizedBox(height: 15),
//           Center(
//             child: TextButton.icon(
//               onPressed: () {
//                 // View all team members
//               },
//               icon: const Icon(Icons.people_outline),
//               label: const Text("View All Team Members"),
//               style: TextButton.styleFrom(
//                 foregroundColor: const Color(0xFF00A86B),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildTeamMemberCard(String name, String role, String imageUrl) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 10),
//       padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(15),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             spreadRadius: 0,
//             blurRadius: 5,
//             offset: const Offset(0, 2),
//           ),
//         ],
//         border: Border.all(color: Colors.grey.shade100),
//       ),
//       child: Row(
//         children: [
//           Container(
//             width: 50,
//             height: 50,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               image: DecorationImage(
//                 image: NetworkImage(imageUrl),
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//           const SizedBox(width: 15),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   name,
//                   style: const TextStyle(
//                     fontWeight: FontWeight.w600,
//                     fontSize: 15,
//                   ),
//                 ),
//                 Text(
//                   role,
//                   style: TextStyle(
//                     fontSize: 13,
//                     color: Colors.grey[600],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           IconButton(
//             icon: const Icon(
//               Icons.message_outlined,
//               color: Color(0xFF00A86B),
//               size: 20,
//             ),
//             onPressed: () {
//               // Message functionality
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:care__connect/screens/NGO/celebrity_feature_screen.dart';
import 'package:care__connect/screens/NGO/create_campaign_screen.dart';
import 'package:care__connect/screens/NGO/widgets/join_requests_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:care__connect/screens/NGO/widgets/donation_details_screen.dart';
import 'package:care__connect/screens/NGO/widgets/campaign_list_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:care__connect/screens/login_screen.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

class ApprovedNGOView extends StatefulWidget {
  final DocumentSnapshot ngoData;

  const ApprovedNGOView({super.key, required this.ngoData});

  @override
  _ApprovedNGOViewState createState() => _ApprovedNGOViewState();
}

class _ApprovedNGOViewState extends State<ApprovedNGOView>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late double totalDonations;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int activeCampaignsCount = 0;
  int supportersCount = 184;

  late Stream<QuerySnapshot> _activitiesStream;
  List<Map<String, dynamic>> _recentActivities = [];
  bool _isLoadingActivities = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    totalDonations = 0.0;

    // Initialize animation controller
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

    _loadData();
    _loadRecentActivities();
    _animationController.forward();
  }

  Future<void> _loadRecentActivities() async {
    if (mounted) {
      setState(() {
        _isLoadingActivities = true;
      });
    }

    try {
      // Get notifications for this NGO
      final notificationsSnapshot = await FirebaseFirestore.instance
          .collection('notifications')
          .where('ngoId', isEqualTo: widget.ngoData.id)
          .orderBy('timestamp', descending: true)
          .limit(5)
          .get();

      // Get recent donations for this NGO
      final donationsSnapshot = await FirebaseFirestore.instance
          .collection('donations')
          .where('ngoId', isEqualTo: widget.ngoData.id)
          .orderBy('timestamp', descending: true)
          .limit(5)
          .get();

      // Get recent campaigns for this NGO
      final campaignsSnapshot = await FirebaseFirestore.instance
          .collection('campaigns')
          .where('ngoId', isEqualTo: widget.ngoData.id)
          .orderBy('createdAt', descending: true)
          .limit(5)
          .get();

      // Process notifications
      List<Map<String, dynamic>> activities = [];

      for (var doc in notificationsSnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        activities.add({
          'type': 'notification',
          'title': 'Location Alert',
          'description': data['message'] ?? 'New notification',
          'timestamp': data['timestamp'],
          'icon': Icons.notifications_active_outlined,
          'color': Colors.orange,
          'location': data['location'],
        });
      }

      // Process donations
      for (var doc in donationsSnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;

        // Get donor name if available
        String donorName = 'Someone';
        if (data['userId'] != null) {
          try {
            final userDoc = await FirebaseFirestore.instance
                .collection('users')
                .doc(data['userId'])
                .get();
            if (userDoc.exists) {
              final userData = userDoc.data();
              donorName = userData?['name'] ?? 'A supporter';
            }
          } catch (e) {
            debugPrint('Error fetching donor details: $e');
          }
        }

        // Get campaign name if this donation was for a specific campaign
        String campaignName = '';
        if (data['campaignId'] != null) {
          try {
            final campaignDoc = await FirebaseFirestore.instance
                .collection('campaigns')
                .doc(data['campaignId'])
                .get();
            if (campaignDoc.exists) {
              final campaignData = campaignDoc.data();
              campaignName = " to '${campaignData?['title'] ?? 'a campaign'}'";
            }
          } catch (e) {
            debugPrint('Error fetching campaign details: $e');
          }
        }

        activities.add({
          'type': 'donation',
          'title': 'New Donation Received',
          'description': "$donorName donated ₹${data['amount']}$campaignName",
          'timestamp': data['timestamp'],
          'icon': Icons.monetization_on_outlined,
          'color': const Color(0xFF00A86B),
        });
      }

      // Process campaigns
      for (var doc in campaignsSnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final isClosed = data['isClosed'] ?? false;
        final title = data['purpose'] ?? 'Campaign';

        activities.add({
          'type': 'campaign',
          'title': isClosed ? 'Campaign Completed' : 'New Campaign Created',
          'description':
              "The campaign '$title' was ${isClosed ? 'completed' : 'created'}",
          'timestamp': data['createdAt'],
          'icon': Icons.campaign_outlined,
          'color': isClosed ? Colors.grey : Colors.blue,
        });
      }

      // Sort all activities by timestamp (newest first)
      activities.sort((a, b) {
        final dynamic timestampA = a['timestamp'];
        final dynamic timestampB = b['timestamp'];

        // Handle different timestamp types
        if (timestampA is Timestamp && timestampB is Timestamp) {
          return timestampB.compareTo(timestampA);
        } else if (timestampA is String && timestampB is String) {
          // Parse strings to DateTime if needed
          try {
            final dateA = DateTime.parse(timestampA);
            final dateB = DateTime.parse(timestampB);
            return dateB.compareTo(dateA);
          } catch (e) {
            // If parsing fails, compare strings directly
            return timestampB.compareTo(timestampA);
          }
        } else if (timestampA is Timestamp && timestampB is String) {
          try {
            final dateB = DateTime.parse(timestampB);
            return dateB.compareTo(timestampA.toDate());
          } catch (e) {
            return -1; // Timestamp before String as fallback
          }
        } else if (timestampA is String && timestampB is Timestamp) {
          try {
            final dateA = DateTime.parse(timestampA);
            return timestampB.toDate().compareTo(dateA);
          } catch (e) {
            return 1; // String after Timestamp as fallback
          }
        }

        // As a last resort, try toString comparison
        return "$timestampB".compareTo("$timestampA");
      });

      // Take only the 5 most recent activities
      activities = activities.take(5).toList();

      if (mounted) {
        setState(() {
          _recentActivities = activities;
          _isLoadingActivities = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading recent activities: $e');
      if (mounted) {
        setState(() {
          _isLoadingActivities = false;
        });
      }
    }
  }

  String _formatTimeAgo(dynamic timestamp) {
    if (timestamp is Timestamp) {
      return timeago.format(timestamp.toDate(), locale: 'en_short');
    } else if (timestamp is String) {
      try {
        return timeago.format(DateTime.parse(timestamp), locale: 'en_short');
      } catch (e) {
        return 'Recently'; // Fallback text if parsing fails
      }
    } else {
      return 'Recently'; // Default fallback
    }
  }

  Future<void> _loadData() async {
    final amount = await fetchTotalDonationsForNgo(widget.ngoData.id);
    await fetchActiveCampaignsCount(widget.ngoData.id);

    if (mounted) {
      setState(() {
        totalDonations = amount;
      });
    }
  }

  Future<double> fetchTotalDonationsForNgo(String ngoId) async {
    double totalAmount = 0.0;
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('donations')
        .where('ngoId', isEqualTo: ngoId)
        .get();

    for (var doc in snapshot.docs) {
      totalAmount += double.tryParse(doc['amount'].toString()) ?? 0.0;
    }

    return totalAmount;
  }

  Future<void> fetchActiveCampaignsCount(String ngoId) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('campaigns')
        .where('ngoId', isEqualTo: widget.ngoData.id)
        .where('isClosed', isEqualTo: false)
        .get();

    if (mounted) {
      setState(() {
        activeCampaignsCount = snapshot.docs.length;
      });
    }
  }

  Future<void> _deleteFcmTokenForNGO() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        await FirebaseFirestore.instance
            .collection('ngos')
            .doc(user.uid)
            .update({'fcmToken': FieldValue.delete()});

        debugPrint('🧹 FCM token deleted from ngos collection');
      } catch (e) {
        debugPrint('❌ Error deleting FCM token for NGO: $e');
      }
    }
  }

  void _signOut(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;

    // Step 1: Sign out and navigate first
    await FirebaseAuth.instance.signOut();

    // Step 2: Navigate immediately
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );

    // Step 3: After navigation, delete the FCM token in background
    Future.microtask(() async {
      try {
        if (user != null) {
          await FirebaseFirestore.instance
              .collection('ngos')
              .doc(user.uid)
              .update({'fcmToken': FieldValue.delete()});

          debugPrint('🧹🧹🧹 FCM token deleted from ngos collection');
        }
      } catch (e) {
        debugPrint('❌❌❌ Failed to delete FCM token: $e');
      }
    });
  }

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            "Sign Out",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            "Are you sure you want to sign out from your account?",
            style: TextStyle(
              fontSize: 15,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _signOut(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00A86B),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                "Yes, Sign Out",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> data =
        widget.ngoData.data() as Map<String, dynamic>;
    final String name = data['name'] ?? 'N/A';
    final String sector = data['sector'] ?? 'N/A';
    final String description = data['description'] ?? 'N/A';
    final String logoUrl = data['logoUrl'] ?? '';
    final List<dynamic> acceptedDonations = data['acceptedDonations'] ?? [];

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: const Color(0xFF00A86B),
        elevation: 0,
        title: const Text(
          "NGO Dashboard",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.white),
            onPressed: () {
              // Notification action
            },
          ),
        ],
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
      ),
      drawer: _buildDrawer(context, name, logoUrl),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            // Profile Banner
            _buildProfileBanner(name, sector, description, logoUrl),

            // Stats Summary
            _buildStatsSummary(),

            // Tab Bar
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 0,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TabBar(
                controller: _tabController,
                labelColor: const Color(0xFF00A86B),
                unselectedLabelColor: Colors.grey,
                indicatorColor: const Color(0xFF00A86B),
                indicatorWeight: 3,
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                tabs: const [
                  Tab(
                    icon: Icon(Icons.dashboard_outlined),
                    text: "Dashboard",
                  ),
                  Tab(
                    icon: Icon(Icons.campaign_outlined),
                    text: "Campaigns",
                  ),
                  Tab(
                    icon: Icon(Icons.people_outline),
                    text: "Community",
                  ),
                ],
              ),
            ),

            // Tab Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Dashboard Tab
                  _buildDashboardTab(acceptedDonations),

                  // Campaigns Tab
                  _buildCampaignsTab(),

                  // Community Tab
                  _buildCommunityTab(),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateCampaignScreen(),
            ),
          );
        },
        backgroundColor: const Color(0xFF00A86B),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context, String name, String logoUrl) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF00A86B), Color(0xFF009160)],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 70,
                  width: 70,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    image: logoUrl.isNotEmpty
                        ? DecorationImage(
                            image: NetworkImage(logoUrl),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: logoUrl.isEmpty
                      ? const Icon(
                          Icons.business_rounded,
                          size: 35,
                          color: Colors.grey,
                        )
                      : null,
                ),
                const SizedBox(height: 12),
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  "NGO Admin",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          _buildDrawerItem(
            icon: Icons.dashboard_outlined,
            title: "Dashboard",
            onTap: () {
              Navigator.pop(context);
              _tabController.animateTo(0);
            },
          ),
          _buildDrawerItem(
            icon: Icons.campaign_outlined,
            title: "Manage Campaigns",
            onTap: () {
              Navigator.pop(context);
              _tabController.animateTo(1);
            },
          ),
          _buildDrawerItem(
            icon: Icons.monetization_on_outlined,
            title: "Donation Details",
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      DonationDetailsScreen(ngoId: widget.ngoData.id),
                ),
              );
            },
          ),
          _buildDrawerItem(
            icon: Icons.verified_user_outlined,
            title: "Join Requests",
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const JoinRequestsScreen(),
                ),
              );
            },
          ),
          _buildDrawerItem(
            icon: Icons.star_outline,
            title: "Celebrity Feature",
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CelebrityFeatureScreen(),
                ),
              );
            },
          ),
          const Divider(),
          _buildDrawerItem(
            icon: Icons.settings_outlined,
            title: "Settings",
            onTap: () {
              Navigator.pop(context);
              // Navigate to settings
            },
          ),
          _buildDrawerItem(
            icon: Icons.help_outline,
            title: "Help & Support",
            onTap: () {
              Navigator.pop(context);
              // Navigate to help
            },
          ),
          const Divider(),
          _buildDrawerItem(
            icon: Icons.logout_rounded,
            title: "Sign Out",
            onTap: () {
              Navigator.pop(context);
              _showSignOutDialog(context);
            },
            color: Colors.red,
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? color,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: color ?? Colors.grey[700],
      ),
      title: Text(
        title,
        style: TextStyle(
          color: color ?? Colors.grey[800],
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
    );
  }

  Widget _buildProfileBanner(
      String name, String sector, String description, String logoUrl) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: const BoxDecoration(
        color: Color(0xFF00A86B),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // NGO Logo
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ],
              image: logoUrl.isNotEmpty
                  ? DecorationImage(
                      image: NetworkImage(logoUrl),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: logoUrl.isEmpty
                ? Icon(
                    Icons.business_rounded,
                    size: 30,
                    color: Colors.grey[400],
                  )
                : null,
          ),
          const SizedBox(width: 15),

          // NGO Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 5),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    sector,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Approval Badge
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.verified,
                  color: Color(0xFF00A86B),
                  size: 12,
                ),
                SizedBox(width: 4),
                Text(
                  "Approved",
                  style: TextStyle(
                    color: Color(0xFF00A86B),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSummary() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            '₹${totalDonations.toStringAsFixed(0)}',
            'Donations',
            Icons.monetization_on_outlined,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      DonationDetailsScreen(ngoId: widget.ngoData.id),
                ),
              );
            },
          ),
          _buildDivider(),
          _buildStatItem(
            '$activeCampaignsCount',
            'Campaigns',
            Icons.campaign_outlined,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      CampaignListScreen(ngoId: widget.ngoData.id),
                ),
              );
            },
          ),
          _buildDivider(),
          _buildStatItem(
            '$supportersCount',
            'Supporters',
            Icons.people_outline,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label, IconData icon,
      {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF00A86B).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: const Color(0xFF00A86B),
              size: 22,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF00A86B),
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
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
      color: Colors.grey.withOpacity(0.3),
    );
  }

  Widget _buildDashboardTab(List<dynamic> acceptedDonations) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Quick Actions Cards
            const Text(
              "Quick Actions",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            _buildQuickActions(),

            const SizedBox(height: 25),

            // Accepted Donations Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Accepted Donations",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DonationDetailsScreen(ngoId: widget.ngoData.id),
                      ),
                    );
                  },
                  child: const Text(
                    "View All",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF00A86B),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildAcceptedDonations(acceptedDonations),

            const SizedBox(height: 25),

            // Recent Activities Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Recent Activities",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.refresh,
                        color: Color(0xFF00A86B),
                        size: 20,
                      ),
                      onPressed: () {
                        _loadRecentActivities();
                      },
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                CampaignListScreen(ngoId: widget.ngoData.id),
                          ),
                        );
                      },
                      child: const Text(
                        "View All",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF00A86B),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildRecentActivities(),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return SizedBox(
      height: 110,
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        children: [
          _buildQuickActionCard(
            "Create Campaign",
            Icons.campaign_outlined,
            const Color(0xFF00A86B),
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CreateCampaignScreen(),
                ),
              );
            },
          ),
          _buildQuickActionCard(
            "Approve Users",
            Icons.verified_user_outlined,
            Colors.blue,
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const JoinRequestsScreen(),
                ),
              );
            },
          ),
          _buildQuickActionCard(
            "Contact Celebrity",
            Icons.star,
            Colors.orange,
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CelebrityFeatureScreen(),
                ),
              );
            },
          ),
          _buildQuickActionCard(
            "Donation Details",
            Icons.monetization_on_outlined,
            Colors.purple,
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      DonationDetailsScreen(ngoId: widget.ngoData.id),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 135,
        margin: const EdgeInsets.only(right: 15),
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 8,
              spreadRadius: 0,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAcceptedDonations(List<dynamic> acceptedDonations) {
    Map<String, Map<String, dynamic>> donationTypeInfo = {
      'Money': {
        'icon': Icons.attach_money,
        'color': const Color(0xFF00A86B),
      },
      'Clothes': {
        'icon': Icons.checkroom_outlined,
        'color': Colors.blue,
      },
      'Books': {
        'icon': Icons.book_outlined,
        'color': Colors.orange,
      },
      'Food': {
        'icon': Icons.fastfood_outlined,
        'color': Colors.red,
      },
      'Volunteer': {
        'icon': Icons.volunteer_activism,
        'color': Colors.purple,
      },
    };

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: acceptedDonations.map<Widget>((type) {
        final Map<String, dynamic> info = donationTypeInfo[type] ??
            {
              'icon': Icons.volunteer_activism,
              'color': Colors.purple,
            };

        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            color: info['color'].withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: info['color'].withOpacity(0.3),
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                info['icon'],
                size: 18,
                color: info['color'],
              ),
              const SizedBox(width: 8),
              Text(
                type,
                style: TextStyle(
                  color: info['color'],
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildRecentActivities() {
    if (_isLoadingActivities) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: CircularProgressIndicator(
            color: Color(0xFF00A86B),
          ),
        ),
      );
    }

    if (_recentActivities.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.hourglass_empty,
              size: 50,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 10),
            Text(
              "No recent activities",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: _recentActivities.map((activity) {
        // Show location-based notification with extra details
        if (activity['type'] == 'notification' &&
            activity['location'] != null) {
          final Map<String, dynamic> location =
              activity['location'] as Map<String, dynamic>;
          final double? latitude = location['latitude'] as double?;
          final double? longitude = location['longitude'] as double?;

          String locationInfo = '';
          if (latitude != null && longitude != null) {
            locationInfo =
                ' (Lat: ${latitude.toStringAsFixed(2)}, Long: ${longitude.toStringAsFixed(2)})';
          }

          return _buildActivityCard(
            activity['title'],
            "${activity['description']}$locationInfo",
            _formatTimeAgo(activity['timestamp']),
            activity['icon'],
            activity['color'],
            onTap: () {
              // You could add navigation to a map view here
            },
          );
        }

        return _buildActivityCard(
          activity['title'],
          activity['description'],
          _formatTimeAgo(activity['timestamp']),
          activity['icon'],
          activity['color'],
        );
      }).toList(),
    );
  }

  Widget _buildActivityCard(
    String title,
    String description,
    String timeAgo,
    IconData icon,
    Color color, {
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 0,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    timeAgo,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[400],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            // Add a chevron icon for items that have an onTap handler
            if (onTap != null)
              Icon(
                Icons.chevron_right,
                color: Colors.grey[400],
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCampaignsTab() {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance
          .collection('campaigns')
          .where('ngoId', isEqualTo: widget.ngoData.id)
          .orderBy('createdAt', descending: true)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF00A86B),
            ),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error loading campaigns: ${snapshot.error}',
              style: TextStyle(color: Colors.red[700]),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.campaign_outlined,
                  size: 70,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 15),
                Text(
                  "No campaigns yet",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  "Create a new campaign to get started",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[500],
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CreateCampaignScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.add),
                  label: const Text("Create Campaign"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00A86B),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        // Group campaigns by status
        List<DocumentSnapshot> activeCampaigns = [];
        List<DocumentSnapshot> completedCampaigns = [];

        for (var doc in snapshot.data!.docs) {
          final data = doc.data() as Map<String, dynamic>;
          if (data['isClosed'] == true) {
            completedCampaigns.add(doc);
          } else {
            activeCampaigns.add(doc);
          }
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Create Campaign Button
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 20),
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CreateCampaignScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.add),
                  label: const Text("Create New Campaign"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00A86B),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

              // Active Campaigns
              if (activeCampaigns.isNotEmpty) ...[
                const Text(
                  "Active Campaigns",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                ...activeCampaigns
                    .map((doc) => _buildCampaignCard(doc, isActive: true))
                    .toList(),
                const SizedBox(height: 25),
              ],

              // Completed Campaigns
              if (completedCampaigns.isNotEmpty) ...[
                const Text(
                  "Completed Campaigns",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                ...completedCampaigns
                    .map((doc) => _buildCampaignCard(doc, isActive: false))
                    .toList(),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildCampaignCard(DocumentSnapshot doc, {required bool isActive}) {
    final data = doc.data() as Map<String, dynamic>;
    final String title = data['title'] ?? 'Campaign';
    final String description = data['description'] ?? 'No description';
    final String imageUrl = data['imageUrl'] ?? '';
    final double goal = double.tryParse(data['goal'].toString()) ?? 0.0;
    final double raised = double.tryParse(data['raised'].toString()) ?? 0.0;
    final double progress = goal > 0 ? (raised / goal).clamp(0.0, 1.0) : 0.0;

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Campaign Image
            if (imageUrl.isNotEmpty)
              Container(
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color:
                          isActive ? const Color(0xFF00A86B) : Colors.grey[600],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      isActive ? "Active" : "Completed",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              )
            else
              Container(
                height: 120,
                width: double.infinity,
                color: Colors.grey[200],
                child: Center(
                  child: Icon(
                    Icons.image_outlined,
                    size: 40,
                    color: Colors.grey[400],
                  ),
                ),
              ),

            // Campaign Details
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 15),

                  // Progress Bar
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "₹${raised.toStringAsFixed(0)} raised",
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF00A86B),
                            ),
                          ),
                          Text(
                            "₹${goal.toStringAsFixed(0)} goal",
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: progress,
                        backgroundColor: Colors.grey[200],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          isActive
                              ? const Color(0xFF00A86B)
                              : Colors.grey[500]!,
                        ),
                        minHeight: 7,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: Text(
                          "${(progress * 100).toStringAsFixed(0)}% Completed",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // View campaign details
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isActive
                                ? const Color(0xFF00A86B)
                                : Colors.grey[600],
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text("View Details"),
                        ),
                      ),
                      const SizedBox(width: 10),
                      if (isActive)
                        OutlinedButton(
                          onPressed: () {
                            // Edit campaign
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF00A86B),
                            side: const BorderSide(color: Color(0xFF00A86B)),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text("Edit"),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommunityTab() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Join Requests Section
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 0,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
              border: Border.all(color: Colors.grey.shade100),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person_add_outlined,
                        color: Colors.blue,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 15),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Join Requests",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Review and approve volunteer requests",
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Text(
                        "12",
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const JoinRequestsScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text("View All Requests"),
                ),
              ],
            ),
          ),

          const SizedBox(height: 25),

          // Celebrity Feature Section
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 0,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
              border: Border.all(color: Colors.grey.shade100),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.star,
                        color: Colors.orange,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 15),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Celebrity Feature",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Invite celebrities to promote your campaigns",
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CelebrityFeatureScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text("Contact Celebrities"),
                ),
              ],
            ),
          ),

          const SizedBox(height: 25),

          // Team Members Section
          const Text(
            "Team Members",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),

          // Sample team members
          _buildTeamMemberCard(
            "Rahul Sharma",
            "Administrator",
            "https://randomuser.me/api/portraits/men/32.jpg",
          ),
          _buildTeamMemberCard(
            "Priya Patel",
            "Campaign Manager",
            "https://randomuser.me/api/portraits/women/44.jpg",
          ),
          _buildTeamMemberCard(
            "Amit Kumar",
            "Volunteer Coordinator",
            "https://randomuser.me/api/portraits/men/45.jpg",
          ),

          const SizedBox(height: 15),
          Center(
            child: TextButton.icon(
              onPressed: () {
                // View all team members
              },
              icon: const Icon(Icons.people_outline),
              label: const Text("View All Team Members"),
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF00A86B),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamMemberCard(String name, String role, String imageUrl) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                Text(
                  role,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.message_outlined,
              color: Color(0xFF00A86B),
              size: 20,
            ),
            onPressed: () {
              // Message functionality
            },
          ),
        ],
      ),
    );
  }
}
