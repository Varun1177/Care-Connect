// // import 'package:care__connect/screens/NGO/campaign_drives_screens.dart';
// // import 'package:care__connect/screens/NGO/celebrity_feature_screen.dart';
// // import 'package:care__connect/screens/NGO/create_campaign_screen.dart';
// // import 'package:care__connect/screens/NGO/donation_screen.dart';
// // import 'package:flutter/material.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:care__connect/screens/NGO/widgets/dashboard_card.dart';
// // import 'package:care__connect/screens/NGO/widgets/donation_details_screen.dart';
// // import 'package:care__connect/screens/NGO/widgets/campaign_list_screen.dart';

// // class ApprovedNGOView extends StatefulWidget {
// //   final DocumentSnapshot ngoData;

// //   const ApprovedNGOView({super.key, required this.ngoData});

// //   @override
// //   _ApprovedNGOViewState createState() => _ApprovedNGOViewState();
// // }

// // class _ApprovedNGOViewState extends State<ApprovedNGOView> {
// //   late double totalDonations;

// //   Future<double> fetchTotalDonationsForNgo(String ngoId) async {
// //     double totalAmount = 0.0;
// //     QuerySnapshot snapshot = await FirebaseFirestore.instance
// //         .collection('donations')
// //         .where('ngoId', isEqualTo: ngoId)
// //         .get();

// //     for (var doc in snapshot.docs) {
// //       totalAmount += double.tryParse(doc['amount'].toString()) ?? 0.0;
// //     }

// //     return totalAmount;
// //   }

// //   int activeCampaignsCount = 0;

// // Future<void> fetchActiveCampaignsCount(String ngoId) async {
// //   QuerySnapshot snapshot = await FirebaseFirestore.instance
// //     .collection('campaigns')
// //     .where('ngoId', isEqualTo: widget.ngoData.id)
// //     .where('isClosed', isEqualTo: false)
// //     .get();

// //   print("NGO ID: ${widget.ngoData.id}");
// //   print("Campaigns fetched: ${snapshot.docs.length}");



// //   setState(() {
// //     activeCampaignsCount = snapshot.docs.length;
// //   });
// // }


// //   @override
// //   void initState() {
// //     super.initState();
// //     totalDonations = 0.0;
// //     fetchTotalDonationsForNgo(widget.ngoData.id).then((amount) {
// //       setState(() {
// //         totalDonations = amount;
// //       });
// //     });

// //     fetchActiveCampaignsCount(widget.ngoData.id);
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final Map<String, dynamic> data =
// //         widget.ngoData.data() as Map<String, dynamic>;
// //     final String name = data['name'] ?? 'N/A';
// //     final String sector = data['sector'] ?? 'N/A';
// //     final String description = data['description'] ?? 'N/A';
// //     final String logoUrl = data['logoUrl'] ?? '';

// //     // Get the list of accepted donations
// //     final List<dynamic> acceptedDonations = data['acceptedDonations'] ?? [];

// //     return SingleChildScrollView(
// //       physics: const BouncingScrollPhysics(),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           // Banner with NGO logo and basic info
// //           Container(
// //             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
// //             width: double.infinity,
// //             decoration: BoxDecoration(
// //               color: Theme.of(context).primaryColor,
// //               borderRadius: const BorderRadius.only(
// //                 bottomLeft: Radius.circular(30),
// //                 bottomRight: Radius.circular(30),
// //               ),
// //             ),
// //             child: Column(
// //               children: [
// //                 Row(
// //                   children: [
// //                     // NGO Logo
// //                     Container(
// //                       height: 70,
// //                       width: 70,
// //                       decoration: BoxDecoration(
// //                         color: Colors.white,
// //                         shape: BoxShape.circle,
// //                         boxShadow: [
// //                           BoxShadow(
// //                             color: Colors.black.withOpacity(0.1),
// //                             blurRadius: 10,
// //                             spreadRadius: 1,
// //                           ),
// //                         ],
// //                         image: logoUrl.isNotEmpty
// //                             ? DecorationImage(
// //                                 image: NetworkImage(logoUrl),
// //                                 fit: BoxFit.cover,
// //                               )
// //                             : null,
// //                       ),
// //                       child: logoUrl.isEmpty
// //                           ? Icon(
// //                               Icons.business_rounded,
// //                               size: 35,
// //                               color: Colors.grey[400],
// //                             )
// //                           : null,
// //                     ),
// //                     const SizedBox(width: 16),

// //                     // NGO Name and Sector
// //                     Expanded(
// //                       child: Column(
// //                         crossAxisAlignment: CrossAxisAlignment.start,
// //                         children: [
// //                           Text(
// //                             name,
// //                             style: const TextStyle(
// //                               fontSize: 20,
// //                               fontWeight: FontWeight.bold,
// //                               color: Colors.white,
// //                             ),
// //                           ),
// //                           const SizedBox(height: 4),
// //                           Container(
// //                             padding: const EdgeInsets.symmetric(
// //                               horizontal: 10,
// //                               vertical: 4,
// //                             ),
// //                             decoration: BoxDecoration(
// //                               color: Colors.white.withOpacity(0.2),
// //                               borderRadius: BorderRadius.circular(12),
// //                             ),
// //                             child: Text(
// //                               sector,
// //                               style: const TextStyle(
// //                                 fontSize: 12,
// //                                 color: Colors.white,
// //                               ),
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                     ),

// //                     // Approval Badge
// //                     Container(
// //                       padding: const EdgeInsets.symmetric(
// //                         horizontal: 10,
// //                         vertical: 6,
// //                       ),
// //                       decoration: BoxDecoration(
// //                         color: Colors.green,
// //                         borderRadius: BorderRadius.circular(16),
// //                       ),
// //                       child: const Row(
// //                         mainAxisSize: MainAxisSize.min,
// //                         children: [
// //                           Icon(
// //                             Icons.verified,
// //                             color: Colors.white,
// //                             size: 12,
// //                           ),
// //                           SizedBox(width: 4),
// //                           Text(
// //                             "Approved",
// //                             style: TextStyle(
// //                               color: Colors.white,
// //                               fontSize: 12,
// //                               fontWeight: FontWeight.bold,
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //                 const SizedBox(height: 16),

// //                 // Description
// //                 Container(
// //                   padding: const EdgeInsets.all(12),
// //                   decoration: BoxDecoration(
// //                     color: Colors.white.withOpacity(0.1),
// //                     borderRadius: BorderRadius.circular(8),
// //                   ),
// //                   child: Text(
// //                     description,
// //                     style: const TextStyle(
// //                       color: Colors.white,
// //                       fontSize: 13,
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),

// //           const SizedBox(height: 24),

// //           // Section: Dashboard Stats
// //           Padding(
// //             padding: const EdgeInsets.symmetric(horizontal: 20),
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 const Text(
// //                   "Dashboard",
// //                   style: TextStyle(
// //                     fontSize: 18,
// //                     fontWeight: FontWeight.bold,
// //                   ),
// //                 ),
// //                 const SizedBox(height: 16),

// //                 // Dashboard Cards - Stats
// //                 GridView.count(
// //                   shrinkWrap: true,
// //                   physics: const NeverScrollableScrollPhysics(),
// //                   crossAxisCount: 2,
// //                   crossAxisSpacing: 16,
// //                   mainAxisSpacing: 16,
// //                   childAspectRatio: 1.3,
// //                   children: [
// //                     DashboardCard(
// //                       title: "Donations",
// //                       value: "₹${totalDonations.toStringAsFixed(2)}",
// //                       icon: Icons.monetization_on_outlined,
// //                       color: Colors.blue,
// //                       onTap: () {
// //                         Navigator.push(
// //                           context,
// //                           MaterialPageRoute(
// //                             builder: (context) =>
// //                                 DonationDetailsScreen(ngoId: widget.ngoData.id),
// //                           ),
// //                         );
// //                       },
// //                     ),
// //                     DashboardCard(
// //                       title: "Campaigns",
// //                       value: "$activeCampaignsCount",
// //                       icon: Icons.campaign_outlined,
// //                       color: Colors.purple,
// //                       onTap: () {
// //                         Navigator.push(
// //       context,
// //       MaterialPageRoute(
// //         builder: (_) => CampaignListScreen(ngoId: widget.ngoData.id),
// //       ),
// //     );

// //                       },
// //                     ),
// //                     DashboardCard(
// //                       title: "Supporters",
// //                       value: "184",
// //                       icon: Icons.people_outline,
// //                       color: Colors.green,
// //                       onTap: () {
// //                         // Navigate to supporters
// //                       },
// //                     ),
// //                     DashboardCard(
// //                       title: "Requests",
// //                       value: "12",
// //                       icon: Icons.inbox_outlined,
// //                       color: Colors.orange,
// //                       onTap: () {
// //                         // Navigate to donation requests
// //                       },
// //                     ),
// //                   ],
// //                 ),
// //               ],
// //             ),
// //           ),

// //           const SizedBox(height: 24),

// //           // Section: Accepted Donations
// //           Padding(
// //             padding: const EdgeInsets.symmetric(horizontal: 20),
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 const Text(
// //                   "Accepted Donations",
// //                   style: TextStyle(
// //                     fontSize: 18,
// //                     fontWeight: FontWeight.bold,
// //                   ),
// //                 ),
// //                 const SizedBox(height: 12),

// //                 // Donation Types
// //                 Wrap(
// //                   spacing: 8,
// //                   runSpacing: 8,
// //                   children: acceptedDonations.map<Widget>((type) {
// //                     IconData icon;
// //                     Color color;

// //                     switch (type) {
// //                       case 'Money':
// //                         icon = Icons.attach_money;
// //                         color = Colors.green;
// //                         break;
// //                       case 'Clothes':
// //                         icon = Icons.checkroom_outlined;
// //                         color = Colors.blue;
// //                         break;
// //                       case 'Books':
// //                         icon = Icons.book_outlined;
// //                         color = Colors.orange;
// //                         break;
// //                       case 'Food':
// //                         icon = Icons.fastfood_outlined;
// //                         color = Colors.red;
// //                         break;
// //                       default:
// //                         icon = Icons.volunteer_activism;
// //                         color = Colors.purple;
// //                     }

// //                     return Container(
// //                       padding: const EdgeInsets.symmetric(
// //                         horizontal: 12,
// //                         vertical: 8,
// //                       ),
// //                       decoration: BoxDecoration(
// //                         color: color.withOpacity(0.1),
// //                         borderRadius: BorderRadius.circular(16),
// //                         border: Border.all(
// //                           color: color.withOpacity(0.3),
// //                         ),
// //                       ),
// //                       child: Row(
// //                         mainAxisSize: MainAxisSize.min,
// //                         children: [
// //                           Icon(
// //                             icon,
// //                             size: 16,
// //                             color: color,
// //                           ),
// //                           const SizedBox(width: 6),
// //                           Text(
// //                             type,
// //                             style: TextStyle(
// //                               color: color,
// //                               fontWeight: FontWeight.w500,
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                     );
// //                   }).toList(),
// //                 ),
// //               ],
// //             ),
// //           ),

// //           const SizedBox(height: 24),

// //           // Section: Quick Actions
// //           Padding(
// //             padding: const EdgeInsets.symmetric(horizontal: 20),
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 const Text(
// //                   "Quick Actions",
// //                   style: TextStyle(
// //                     fontSize: 18,
// //                     fontWeight: FontWeight.bold,
// //                   ),
// //                 ),
// //                 const SizedBox(height: 16),

// //                 // Action Cards
// //                 Row(
// //                   children: [
// //                     Expanded(
// //                       child: _buildActionCard(
// //                         context,
// //                         "Create Campaign",
// //                         Icons.campaign_outlined,
// //                         Colors.blue,
// //                         () {
// //                           Navigator.push(
// //                               context,
// //                               MaterialPageRoute(
// //                                 builder: (context) =>
// //                                     const CreateCampaignScreen(),
// //                               ));
// //                         },
// //                       ),
// //                     ),
// //                     const SizedBox(width: 16),
// //                     Expanded(
// //                       child: _buildActionCard(
// //                         context,
// //                         "Donation History",
// //                         Icons.history,
// //                         Colors.purple,
// //                         () {
// //                           Navigator.push(
// //                               context,
// //                               MaterialPageRoute(
// //                                 builder: (context) =>
// //                                     const DonationHistoryScreen(),
// //                               ));
// //                         },
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //                 const SizedBox(height: 16),
// //                 Row(
// //                   children: [
// //                     Expanded(
// //                       child: _buildActionCard(
// //                         context,
// //                         "Campaign Drives",
// //                         Icons.drive_file_rename_outline,
// //                         Colors.green,
// //                         () {
// //                           Navigator.push(
// //                               context,
// //                               MaterialPageRoute(
// //                                 builder: (context) =>
// //                                     const CampaignDrivesScreen(),
// //                               ));
// //                         },
// //                       ),
// //                     ),
// //                     const SizedBox(width: 16),
// //                     Expanded(
// //                       child: _buildActionCard(
// //                         context,
// //                         "Contact Celebrity",
// //                         Icons.support_agent_outlined,
// //                         Colors.orange,
// //                         () {
// //                           Navigator.push(
// //                               context,
// //                               MaterialPageRoute(
// //                                 builder: (context) =>
// //                                     const CelebrityFeatureScreen(),
// //                               ));
// //                         },
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ],
// //             ),
// //           ),

// //           const SizedBox(height: 24),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildActionCard(
// //     BuildContext context,
// //     String title,
// //     IconData icon,
// //     Color color,
// //     VoidCallback onTap,
// //   ) {
// //     return InkWell(
// //       onTap: onTap,
// //       borderRadius: BorderRadius.circular(12),
// //       child: Ink(
// //         padding: const EdgeInsets.all(16),
// //         decoration: BoxDecoration(
// //           color: Colors.white,
// //           borderRadius: BorderRadius.circular(12),
// //           boxShadow: [
// //             BoxShadow(
// //               color: Colors.grey.withOpacity(0.1),
// //               spreadRadius: 1,
// //               blurRadius: 5,
// //               offset: const Offset(0, 3),
// //             ),
// //           ],
// //           border: Border.all(color: Colors.grey.shade200),
// //         ),
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: [
// //             Container(
// //               padding: const EdgeInsets.all(12),
// //               decoration: BoxDecoration(
// //                 color: color.withOpacity(0.1),
// //                 shape: BoxShape.circle,
// //               ),
// //               child: Icon(
// //                 icon,
// //                 color: color,
// //                 size: 24,
// //               ),
// //             ),
// //             const SizedBox(height: 12),
// //             Text(
// //               title,
// //               textAlign: TextAlign.center,
// //               style: TextStyle(
// //                 fontWeight: FontWeight.w500,
// //                 color: Colors.grey[800],
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }



// // import 'package:care__connect/screens/NGO/campaign_drives_screens.dart';
// // import 'package:care__connect/screens/NGO/celebrity_feature_screen.dart';
// // import 'package:care__connect/screens/NGO/create_campaign_screen.dart';
// // import 'package:care__connect/screens/NGO/donation_screen.dart';
// // import 'package:flutter/material.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:care__connect/screens/NGO/widgets/donation_details_screen.dart';
// // import 'package:care__connect/screens/NGO/widgets/campaign_list_screen.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:care__connect/screens/splash_screen.dart'; // Import for navigation after sign out

// // class ApprovedNGOView extends StatefulWidget {
// //   final DocumentSnapshot ngoData;

// //   const ApprovedNGOView({super.key, required this.ngoData});

// //   @override
// //   _ApprovedNGOViewState createState() => _ApprovedNGOViewState();
// // }

// // class _ApprovedNGOViewState extends State<ApprovedNGOView> with SingleTickerProviderStateMixin {
// //   late double totalDonations;
// //   late AnimationController _animationController;
// //   late Animation<double> _fadeAnimation;
// //   final FirebaseAuth _auth = FirebaseAuth.instance;

// //   Future<double> fetchTotalDonationsForNgo(String ngoId) async {
// //     double totalAmount = 0.0;
// //     QuerySnapshot snapshot = await FirebaseFirestore.instance
// //         .collection('donations')
// //         .where('ngoId', isEqualTo: ngoId)
// //         .get();

// //     for (var doc in snapshot.docs) {
// //       totalAmount += double.tryParse(doc['amount'].toString()) ?? 0.0;
// //     }

// //     return totalAmount;
// //   }

// //   int activeCampaignsCount = 0;

// //   Future<void> fetchActiveCampaignsCount(String ngoId) async {
// //     QuerySnapshot snapshot = await FirebaseFirestore.instance
// //       .collection('campaigns')
// //       .where('ngoId', isEqualTo: widget.ngoData.id)
// //       .where('isClosed', isEqualTo: false)
// //       .get();

// //     setState(() {
// //       activeCampaignsCount = snapshot.docs.length;
// //     });
// //   }

// //   Future<void> _signOut() async {
// //     try {
// //       // Show loading indicator
// //       showDialog(
// //         context: context,
// //         barrierDismissible: false,
// //         builder: (context) => const Center(
// //           child: CircularProgressIndicator(
// //             color: Color(0xFF00A86B),
// //           ),
// //         ),
// //       );
      
// //       await _auth.signOut();
      
// //       // Dismiss loading indicator
// //       Navigator.of(context).pop();
      
// //       // Navigate to splash screen
// //       Navigator.of(context).pushAndRemoveUntil(
// //         MaterialPageRoute(builder: (context) => const SplashScreen()),
// //         (route) => false,
// //       );
// //     } catch (e) {
// //       // Dismiss loading indicator if error occurs
// //       Navigator.of(context).pop();
      
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text('Sign out failed: ${e.toString()}')),
// //       );
// //     }
// //   }

// //   @override
// //   void initState() {
// //     super.initState();
// //     totalDonations = 0.0;
// //     fetchTotalDonationsForNgo(widget.ngoData.id).then((amount) {
// //       setState(() {
// //         totalDonations = amount;
// //       });
// //     });

// //     fetchActiveCampaignsCount(widget.ngoData.id);
    
// //     // Initialize animation controller
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
// //   }

// //   @override
// //   void dispose() {
// //     _animationController.dispose();
// //     super.dispose();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final Map<String, dynamic> data =
// //         widget.ngoData.data() as Map<String, dynamic>;
// //     final String name = data['name'] ?? 'N/A';
// //     final String sector = data['sector'] ?? 'N/A';
// //     final String description = data['description'] ?? 'N/A';
// //     final String logoUrl = data['logoUrl'] ?? '';
// //     final List<dynamic> acceptedDonations = data['acceptedDonations'] ?? [];

// //     return FadeTransition(
// //       opacity: _fadeAnimation,
// //       child: SingleChildScrollView(
// //         physics: const BouncingScrollPhysics(),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             // Banner with NGO logo and basic info
// //             Container(
// //               width: double.infinity,
// //               decoration: const BoxDecoration(
// //                 gradient: LinearGradient(
// //                   begin: Alignment.topLeft,
// //                   end: Alignment.bottomRight,
// //                   colors: [Color(0xFF00A86B), Color(0xFF009160)],
// //                 ),
// //                 borderRadius: BorderRadius.only(
// //                   bottomLeft: Radius.circular(0),
// //                   bottomRight: Radius.circular(0),
// //                 ),
// //               ),
// //               child: Stack(
// //                 alignment: Alignment.bottomCenter,
// //                 clipBehavior: Clip.none,
// //                 children: [
// //                   // NGO Info Container
// //                   Padding(
// //                     padding: const EdgeInsets.fromLTRB(20, 60, 20, 50),
// //                     child: Column(
// //                       children: [
// //                         Row(
// //                           children: [
// //                             // NGO Logo
// //                             Hero(
// //                               tag: 'ngo-logo-${widget.ngoData.id}',
// //                               child: Container(
// //                                 height: 70,
// //                                 width: 70,
// //                                 decoration: BoxDecoration(
// //                                   color: Colors.white,
// //                                   shape: BoxShape.circle,
// //                                   boxShadow: [
// //                                     BoxShadow(
// //                                       color: Colors.black.withOpacity(0.1),
// //                                       blurRadius: 10,
// //                                       spreadRadius: 1,
// //                                     ),
// //                                   ],
// //                                   image: logoUrl.isNotEmpty
// //                                       ? DecorationImage(
// //                                           image: NetworkImage(logoUrl),
// //                                           fit: BoxFit.cover,
// //                                         )
// //                                       : null,
// //                                 ),
// //                                 child: logoUrl.isEmpty
// //                                     ? Icon(
// //                                         Icons.business_rounded,
// //                                         size: 35,
// //                                         color: Colors.grey[400],
// //                                       )
// //                                     : null,
// //                               ),
// //                             ),
// //                             const SizedBox(width: 16),

// //                             // NGO Name and Sector
// //                             Expanded(
// //                               child: Column(
// //                                 crossAxisAlignment: CrossAxisAlignment.start,
// //                                 children: [
// //                                   Text(
// //                                     name,
// //                                     style: const TextStyle(
// //                                       fontSize: 22,
// //                                       fontWeight: FontWeight.bold,
// //                                       color: Colors.white,
// //                                     ),
// //                                   ),
// //                                   const SizedBox(height: 6),
// //                                   Container(
// //                                     padding: const EdgeInsets.symmetric(
// //                                       horizontal: 12,
// //                                       vertical: 5,
// //                                     ),
// //                                     decoration: BoxDecoration(
// //                                       color: Colors.white.withOpacity(0.2),
// //                                       borderRadius: BorderRadius.circular(15),
// //                                     ),
// //                                     child: Text(
// //                                       sector,
// //                                       style: const TextStyle(
// //                                         fontSize: 13,
// //                                         fontWeight: FontWeight.w500,
// //                                         color: Colors.white,
// //                                       ),
// //                                     ),
// //                                   ),
// //                                 ],
// //                               ),
// //                             ),

// //                             // Approval Badge
// //                             Container(
// //                               padding: const EdgeInsets.symmetric(
// //                                 horizontal: 12,
// //                                 vertical: 8,
// //                               ),
// //                               decoration: BoxDecoration(
// //                                 color: Colors.white,
// //                                 borderRadius: BorderRadius.circular(20),
// //                                 boxShadow: [
// //                                   BoxShadow(
// //                                     color: Colors.black.withOpacity(0.05),
// //                                     blurRadius: 10,
// //                                     spreadRadius: 1,
// //                                   ),
// //                                 ],
// //                               ),
// //                               child: const Row(
// //                                 mainAxisSize: MainAxisSize.min,
// //                                 children: [
// //                                   Icon(
// //                                     Icons.verified,
// //                                     color:  Color(0xFF00A86B),
// //                                     size: 14,
// //                                   ),
// //                                   SizedBox(width: 4),
// //                                   Text(
// //                                     "Approved",
// //                                     style: TextStyle(
// //                                       color:  Color(0xFF00A86B),
// //                                       fontSize: 12,
// //                                       fontWeight: FontWeight.bold,
// //                                     ),
// //                                   ),
// //                                 ],
// //                               ),
// //                             ),
// //                           ],
// //                         ),
// //                         const SizedBox(height: 20),

// //                         // Description
// //                         Container(
// //                           padding: const EdgeInsets.all(15),
// //                           decoration: BoxDecoration(
// //                             color: Colors.white.withOpacity(0.15),
// //                             borderRadius: BorderRadius.circular(15),
// //                             border: Border.all(
// //                               color: Colors.white.withOpacity(0.3),
// //                               width: 1,
// //                             ),
// //                           ),
// //                           child: Text(
// //                             description,
// //                             style: const TextStyle(
// //                               color: Colors.white,
// //                               fontSize: 14,
// //                               height: 1.5,
// //                             ),
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                   ),
                  
// //                   // Stats Summary Card
// //                   Positioned(
// //                     bottom: -60,
// //                     left: 20,
// //                     right: 20,
// //                     child: Container(
// //                       padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
// //                       decoration: BoxDecoration(
// //                         color: Colors.white,
// //                         borderRadius: BorderRadius.circular(20),
// //                         boxShadow: [
// //                           BoxShadow(
// //                             color: Colors.black.withOpacity(0.1),
// //                             blurRadius: 20,
// //                             spreadRadius: 5,
// //                             offset: const Offset(0, 5),
// //                           ),
// //                         ],
// //                       ),
// //                       //height: 120,
// //                       child: Row(
// //                         mainAxisAlignment: MainAxisAlignment.spaceAround,
// //                         children: [
// //                           _buildStatsItem(
// //                             '₹${totalDonations.toStringAsFixed(0)}',
// //                             'Donations',
// //                             Icons.monetization_on_outlined,
// //                             onTap: () {
// //                               Navigator.push(
// //                                 context,
// //                                 MaterialPageRoute(
// //                                   builder: (context) => DonationDetailsScreen(ngoId: widget.ngoData.id),
// //                                 ),
// //                               );
// //                             },
// //                           ),
// //                           _buildDivider(),
// //                           _buildStatsItem(
// //                             '$activeCampaignsCount',
// //                             'Campaigns',
// //                             Icons.campaign_outlined,
// //                             onTap: () {
// //                               Navigator.push(
// //                                 context,
// //                                 MaterialPageRoute(
// //                                   builder: (context) => CampaignListScreen(ngoId: widget.ngoData.id),
// //                                 ),
// //                               );
// //                             },
// //                           ),
// //                           _buildDivider(),
// //                           _buildStatsItem(
// //                             '184',
// //                             'Supporters',
// //                             Icons.people_outline,
// //                           ),
// //                         ],
// //                       ),
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),

// //             const SizedBox(height: 70),

// //             // Section: Accepted Donations
// //             Padding(
// //               padding: const EdgeInsets.symmetric(horizontal: 20),
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   Row(
// //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                     children: [
// //                       const Text(
// //                         "Accepted Donations",
// //                         style: TextStyle(
// //                           fontSize: 18,
// //                           fontWeight: FontWeight.bold,
// //                         ),
// //                       ),
// //                       TextButton(
// //                         onPressed: () {
// //                           Navigator.push(
// //                             context,
// //                             MaterialPageRoute(
// //                               builder: (context) => DonationDetailsScreen(ngoId: widget.ngoData.id),
// //                             ),
// //                           );
// //                         },
// //                         child: const Text(
// //                           "View All",
// //                           style: TextStyle(
// //                             fontSize: 14,
// //                             fontWeight: FontWeight.w600,
// //                             color: const Color(0xFF00A86B),
// //                           ),
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                   const SizedBox(height: 15),

// //                   // Donation Types
// //                   Wrap(
// //                     spacing: 10,
// //                     runSpacing: 10,
// //                     children: acceptedDonations.map<Widget>((type) {
// //                       IconData icon;
// //                       Color color;

// //                       switch (type) {
// //                         case 'Money':
// //                           icon = Icons.attach_money;
// //                           color = const Color(0xFF00A86B);
// //                           break;
// //                         case 'Clothes':
// //                           icon = Icons.checkroom_outlined;
// //                           color = Colors.blue;
// //                           break;
// //                         case 'Books':
// //                           icon = Icons.book_outlined;
// //                           color = Colors.orange;
// //                           break;
// //                         case 'Food':
// //                           icon = Icons.fastfood_outlined;
// //                           color = Colors.red;
// //                           break;
// //                         default:
// //                           icon = Icons.volunteer_activism;
// //                           color = Colors.purple;
// //                       }

// //                       return Container(
// //                         padding: const EdgeInsets.symmetric(
// //                           horizontal: 15,
// //                           vertical: 10,
// //                         ),
// //                         decoration: BoxDecoration(
// //                           color: color.withOpacity(0.1),
// //                           borderRadius: BorderRadius.circular(20),
// //                           border: Border.all(
// //                             color: color.withOpacity(0.3),
// //                             width: 1.5,
// //                           ),
// //                         ),
// //                         child: Row(
// //                           mainAxisSize: MainAxisSize.min,
// //                           children: [
// //                             Icon(
// //                               icon,
// //                               size: 18,
// //                               color: color,
// //                             ),
// //                             const SizedBox(width: 8),
// //                             Text(
// //                               type,
// //                               style: TextStyle(
// //                                 color: color,
// //                                 fontWeight: FontWeight.w600,
// //                                 fontSize: 14,
// //                               ),
// //                             ),
// //                           ],
// //                         ),
// //                       );
// //                     }).toList(),
// //                   ),
// //                 ],
// //               ),
// //             ),

// //             const SizedBox(height: 30),

// //             // Section: Quick Actions
// //             Padding(
// //               padding: const EdgeInsets.symmetric(horizontal: 20),
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   const Text(
// //                     "Quick Actions",
// //                     style: TextStyle(
// //                       fontSize: 18,
// //                       fontWeight: FontWeight.bold,
// //                     ),
// //                   ),

// //                   // Action Cards
// //                   GridView.count(
// //                     shrinkWrap: true,
// //                     physics: const NeverScrollableScrollPhysics(),
// //                     crossAxisCount: 2,
// //                     crossAxisSpacing: 15,
// //                     mainAxisSpacing: 15,
// //                     childAspectRatio: 1.1,
// //                     children: [
// //                       _buildActionCard(
// //                         context,
// //                         "Create Campaign",
// //                         Icons.campaign_outlined,
// //                         const Color(0xFF00A86B),
// //                         () {
// //                           Navigator.push(
// //                             context,
// //                             MaterialPageRoute(
// //                               builder: (context) => const CreateCampaignScreen(),
// //                             ),
// //                           );
// //                         },
// //                       ),
// //                       _buildActionCard(
// //                         context,
// //                         "Donation History",
// //                         Icons.history,
// //                         Colors.purple,
// //                         () {
// //                           Navigator.push(
// //                             context,
// //                             MaterialPageRoute(
// //                               builder: (context) => const DonationHistoryScreen(),
// //                             ),
// //                           );
// //                         },
// //                       ),
// //                       _buildActionCard(
// //                         context,
// //                         "Campaign Drives",
// //                         Icons.drive_file_rename_outline,
// //                         Colors.blue,
// //                         () {
// //                           Navigator.push(
// //                             context,
// //                             MaterialPageRoute(
// //                               builder: (context) => const CampaignDrivesScreen(),
// //                             ),
// //                           );
// //                         },
// //                       ),
// //                       _buildActionCard(
// //                         context,
// //                         "Contact Celebrity",
// //                         Icons.star,
// //                         Colors.orange,
// //                         () {
// //                           Navigator.push(
// //                             context,
// //                             MaterialPageRoute(
// //                               builder: (context) => const CelebrityFeatureScreen(),
// //                             ),
// //                           );
// //                         },
// //                       ),
// //                     ],
// //                   ),
// //                 ],
// //               ),
// //             ),

// //             const SizedBox(height: 0),

// //             // Recent Activities Section
// //             Padding(
// //               padding: const EdgeInsets.symmetric(horizontal: 20),
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   Row(
// //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                     children: [
// //                       const Text(
// //                         "Recent Activities",
// //                         style: TextStyle(
// //                           fontSize: 18,
// //                           fontWeight: FontWeight.bold,
// //                         ),
// //                       ),
// //                       TextButton(
// //                         onPressed: () {
// //                           Navigator.push(
// //                             context,
// //                             MaterialPageRoute(
// //                               builder: (context) => CampaignListScreen(ngoId: widget.ngoData.id),
// //                             ),
// //                           );
// //                         },
// //                         child: Text(
// //                           "View All",
// //                           style: TextStyle(
// //                             fontSize: 14,
// //                             fontWeight: FontWeight.w600,
// //                             color: const Color(0xFF00A86B),
// //                           ),
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                   const SizedBox(height: 15),
                  
// //                   // Activity cards
// //                   _buildActivityCard(
// //                     "New Donation Received",
// //                     "Rahul donated ₹2,500 to 'Clean Water Campaign'",
// //                     "30 min ago",
// //                     Icons.monetization_on_outlined,
// //                     const Color(0xFF00A86B),
// //                   ),
// //                   const SizedBox(height: 12),
// //                   _buildActivityCard(
// //                     "Campaign Updated",
// //                     "Education for All campaign reached 75% of the goal",
// //                     "2 hours ago",
// //                     Icons.campaign_outlined,
// //                     Colors.blue,
// //                   ),
// //                 ],
// //               ),
// //             ),

// //             const SizedBox(height: 30),
            
// //             // Sign Out Button
// //             Padding(
// //               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
// //               child: SizedBox(
// //                 width: double.infinity,
// //                 height: 55,
// //                 child: ElevatedButton(
// //                   onPressed: _signOut,
// //                   style: ElevatedButton.styleFrom(
// //                     backgroundColor: Colors.white,
// //                     foregroundColor: const Color(0xFF00A86B),
// //                     elevation: 2,
// //                     shape: RoundedRectangleBorder(
// //                       borderRadius: BorderRadius.circular(15),
// //                       side: BorderSide(color: const Color(0xFF00A86B), width: 1.5),
// //                     ),
// //                   ),
// //                   child: Row(
// //                     mainAxisAlignment: MainAxisAlignment.center,
// //                     children: [
// //                       Icon(
// //                         Icons.logout,
// //                         color: const Color(0xFF00A86B),
// //                         size: 20,
// //                       ),
// //                       const SizedBox(width: 10),
// //                       const Text(
// //                         'SIGN OUT',
// //                         style: TextStyle(
// //                           fontWeight: FontWeight.bold,
// //                           fontSize: 16,
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ),
// //             ),
            
// //             const SizedBox(height: 20),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildStatsItem(String value, String label, IconData icon) {
// //     return Column(
// //       mainAxisSize: MainAxisSize.min,
// //       children: [
// //         Container(
// //           padding: const EdgeInsets.all(8),
// //           decoration: BoxDecoration(
// //             color: const Color(0xFF00A86B).withOpacity(0.1),
// //             shape: BoxShape.circle,
// //           ),
// //           child: Icon(
// //             icon,
// //             color: const Color(0xFF00A86B),
// //             size: 20,
// //           ),
// //         ),
// //         const SizedBox(height: 8),
// //         Text(
// //           value,
// //           style: const TextStyle(
// //             fontSize: 16,
// //             fontWeight: FontWeight.bold,
// //             color: Color(0xFF00A86B),
// //           ),
// //         ),
// //         Text(
// //           label,
// //           style: TextStyle(
// //             fontSize: 12,
// //             color: Colors.grey[600],
// //           ),
// //         ),
// //       ],
// //     );
// //   }

// //   Widget _buildDivider() {
// //     return Container(
// //       height: 40,
// //       width: 1,
// //       color: Colors.grey.withOpacity(0.3),
// //     );
// //   }

// //   Widget _buildActionCard(
// //     BuildContext context,
// //     String title,
// //     IconData icon,
// //     Color color,
// //     VoidCallback onTap,
// //   ) {
// //     return InkWell(
// //       onTap: onTap,
// //       borderRadius: BorderRadius.circular(15),
// //       child: Ink(
// //         padding: const EdgeInsets.all(16),
// //         decoration: BoxDecoration(
// //           color: Colors.white,
// //           borderRadius: BorderRadius.circular(15),
// //           boxShadow: [
// //             BoxShadow(
// //               color: Colors.grey.withOpacity(0.1),
// //               spreadRadius: 1,
// //               blurRadius: 8,
// //               offset: const Offset(0, 4),
// //             ),
// //           ],
// //           border: Border.all(color: Colors.grey.shade200),
// //         ),
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: [
// //             Container(
// //               padding: const EdgeInsets.all(12),
// //               decoration: BoxDecoration(
// //                 color: color.withOpacity(0.1),
// //                 shape: BoxShape.circle,
// //               ),
// //               child: Icon(
// //                 icon,
// //                 color: color,
// //                 size: 26,
// //               ),
// //             ),
// //             const SizedBox(height: 15),
// //             Text(
// //               title,
// //               textAlign: TextAlign.center,
// //               style: TextStyle(
// //                 fontWeight: FontWeight.w600,
// //                 fontSize: 15,
// //                 color: Colors.grey[800],
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildActivityCard(
// //     String title,
// //     String description,
// //     String timeAgo,
// //     IconData icon,
// //     Color color,
// //   ) {
// //     return Container(
// //       padding: const EdgeInsets.all(16),
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.circular(15),
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.grey.withOpacity(0.1),
// //             spreadRadius: 1,
// //             blurRadius: 8,
// //             offset: const Offset(0, 3),
// //           ),
// //         ],
// //         border: Border.all(color: Colors.grey.shade200),
// //       ),
// //       child: Row(
// //         children: [
// //           Container(
// //             padding: const EdgeInsets.all(10),
// //             decoration: BoxDecoration(
// //               color: color.withOpacity(0.1),
// //               shape: BoxShape.circle,
// //             ),
// //             child: Icon(
// //               icon,
// //               color: color,
// //               size: 24,
// //             ),
// //           ),
// //           const SizedBox(width: 15),
// //           Expanded(
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Text(
// //                   title,
// //                   style: const TextStyle(
// //                     fontWeight: FontWeight.w600,
// //                     fontSize: 15,
// //                   ),
// //                 ),
// //                 const SizedBox(height: 5),
// //                 Text(
// //                   description,
// //                   style: TextStyle(
// //                     fontSize: 13,
// //                     color: Colors.grey[600],
// //                   ),
// //                 ),
// //                 const SizedBox(height: 5),
// //                 Text(
// //                   timeAgo,
// //                   style: TextStyle(
// //                     fontSize: 12,
// //                     color: Colors.grey[400],
// //                     fontWeight: FontWeight.w500,
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// import 'package:care__connect/screens/NGO/campaign_drives_screens.dart';
// import 'package:care__connect/screens/NGO/celebrity_feature_screen.dart';
// import 'package:care__connect/screens/NGO/create_campaign_screen.dart';
// import 'package:care__connect/screens/NGO/donation_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:care__connect/screens/NGO/widgets/dashboard_card.dart';
// import 'package:care__connect/screens/NGO/widgets/donation_details_screen.dart';
// import 'package:care__connect/screens/NGO/widgets/campaign_list_screen.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
//                       _buildActionCard(
//                         context,
//                         "Donation History",
//                         Icons.history,
//                         Colors.purple,
//                         () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => const DonationHistoryScreen(),
//                             ),
//                           );
//                         },
//                       ),
//                       _buildActionCard(
//                         context,
//                         "Campaign Drives",
//                         Icons.drive_file_rename_outline,
//                         Colors.blue,
//                         () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => const CampaignDrivesScreen(),
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
//           ],
//         ),
//       ),
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



import 'package:care__connect/screens/NGO/campaign_drives_screens.dart';
import 'package:care__connect/screens/NGO/celebrity_feature_screen.dart';
import 'package:care__connect/screens/NGO/create_campaign_screen.dart';
import 'package:care__connect/screens/NGO/donation_screen.dart';
import 'package:care__connect/screens/NGO/widgets/join_requests_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:care__connect/screens/NGO/widgets/donation_details_screen.dart';
import 'package:care__connect/screens/NGO/widgets/campaign_list_screen.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'package:care__connect/screens/login_screen.dart';

class ApprovedNGOView extends StatefulWidget {
  final DocumentSnapshot ngoData;

  const ApprovedNGOView({super.key, required this.ngoData});

  @override
  _ApprovedNGOViewState createState() => _ApprovedNGOViewState();
}

class _ApprovedNGOViewState extends State<ApprovedNGOView> with SingleTickerProviderStateMixin {
  late double totalDonations;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

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

  int activeCampaignsCount = 0;

  Future<void> fetchActiveCampaignsCount(String ngoId) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection('campaigns')
      .where('ngoId', isEqualTo: widget.ngoData.id)
      .where('isClosed', isEqualTo: false)
      .get();

    setState(() {
      activeCampaignsCount = snapshot.docs.length;
    });
  }

  // Function to handle sign out
  Future<void> _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      // Navigate to login screen or home screen after sign out
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) => const LoginScreen(), // Replace with your login screen
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error signing out: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    totalDonations = 0.0;
    fetchTotalDonationsForNgo(widget.ngoData.id).then((amount) {
      setState(() {
        totalDonations = amount;
      });
    });

    fetchActiveCampaignsCount(widget.ngoData.id);
    
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
    _animationController.forward();
  }

  @override
  void dispose() {
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

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner with NGO logo and basic info
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF00A86B), Color(0xFF009160)],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(0),
                  bottomRight: Radius.circular(0),
                ),
              ),
              child: Stack(
                alignment: Alignment.bottomCenter,
                clipBehavior: Clip.none,
                children: [
                  // NGO Info Container
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 40, 20, 50),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            // NGO Logo
                            Hero(
                              tag: 'ngo-logo-${widget.ngoData.id}',
                              child: Container(
                                height: 70,
                                width: 70,
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
                                        size: 35,
                                        color: Colors.grey[400],
                                      )
                                    : null,
                              ),
                            ),
                            const SizedBox(width: 16),

                            // NGO Name and Sector
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    name,
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Text(
                                      sector,
                                      style: const TextStyle(
                                        fontSize: 13,
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
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 10,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.verified,
                                    color: const Color(0xFF00A86B),
                                    size: 14,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    "Approved",
                                    style: TextStyle(
                                      color: const Color(0xFF00A86B),
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Description
                        Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            description,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Stats Summary Card
                  Positioned(
                    bottom: -60,
                    left: 20,
                    right: 20,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            spreadRadius: 5,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatsItem(
                            '₹${totalDonations.toStringAsFixed(0)}',
                            'Donations',
                            Icons.monetization_on_outlined,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DonationDetailsScreen(ngoId: widget.ngoData.id),
                                ),
                              );
                            },
                          ),
                          _buildDivider(),
                          _buildStatsItem(
                            '$activeCampaignsCount',
                            'Campaigns',
                            Icons.campaign_outlined,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CampaignListScreen(ngoId: widget.ngoData.id),
                                ),
                              );
                            },
                          ),
                          _buildDivider(),
                          _buildStatsItem(
                            '184',
                            'Supporters',
                            Icons.people_outline,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 100),

            // Section: Accepted Donations
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                              builder: (context) => DonationDetailsScreen(ngoId: widget.ngoData.id),
                            ),
                          );
                        },
                        child: Text(
                          "View All",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF00A86B),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),

                  // Donation Types
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: acceptedDonations.map<Widget>((type) {
                      IconData icon;
                      Color color;

                      switch (type) {
                        case 'Money':
                          icon = Icons.attach_money;
                          color = const Color(0xFF00A86B);
                          break;
                        case 'Clothes':
                          icon = Icons.checkroom_outlined;
                          color = Colors.blue;
                          break;
                        case 'Books':
                          icon = Icons.book_outlined;
                          color = Colors.orange;
                          break;
                        case 'Food':
                          icon = Icons.fastfood_outlined;
                          color = Colors.red;
                          break;
                        default:
                          icon = Icons.volunteer_activism;
                          color = Colors.purple;
                      }

                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: color.withOpacity(0.3),
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              icon,
                              size: 18,
                              color: color,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              type,
                              style: TextStyle(
                                color: color,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Section: Quick Actions
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Quick Actions",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // Action Cards
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: 1.1,
                    children: [
                      _buildActionCard(
                        context,
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
                      _buildActionCard(
                        context,
                        "Donation History",
                        Icons.history,
                        Colors.purple,
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const DonationHistoryScreen(),
                            ),
                          );
                        },
                      ),
                      _buildActionCard(
                        context,
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
                      _buildActionCard(
                        context,
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
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Recent Activities Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CampaignListScreen(ngoId: widget.ngoData.id),
                            ),
                          );
                        },
                        child: Text(
                          "View All",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF00A86B),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  
                  // Activity cards
                  _buildActivityCard(
                    "New Donation Received",
                    "Rahul donated ₹2,500 to 'Clean Water Campaign'",
                    "30 min ago",
                    Icons.monetization_on_outlined,
                    const Color(0xFF00A86B),
                  ),
                  const SizedBox(height: 12),
                  _buildActivityCard(
                    "Campaign Updated",
                    "Education for All campaign reached 75% of the goal",
                    "2 hours ago",
                    Icons.campaign_outlined,
                    Colors.blue,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Sign Out Button - NEW ADDITION
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ElevatedButton.icon(
                  onPressed: () => _showSignOutDialog(context),
                  icon: const Icon(Icons.logout_rounded, color: Colors.white),
                  label: const Text(
                    "Sign Out",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF565656),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Dialog to confirm sign out - NEW ADDITION
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

  Widget _buildStatsItem(String value, String label, IconData icon, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF00A86B).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: const Color(0xFF00A86B),
              size: 20,
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

  Widget _buildActionCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Ink(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: color,
                size: 26,
              ),
            ),
            const SizedBox(height: 15),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityCard(
    String title,
    String description,
    String timeAgo,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(color: Colors.grey.shade200),
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
        ],
      ),
    );
  }
}