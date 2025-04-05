// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:care__connect/services/auth_service.dart';
// import 'package:care__connect/screens/login_screen.dart';

// class AdminDashboard extends StatefulWidget {
//   @override
//   _AdminDashboardState createState() => _AdminDashboardState();
// }

// class _AdminDashboardState extends State<AdminDashboard> {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   void _signOut(BuildContext context) async {
//     await AuthService().signOut();
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (context) => LoginScreen()),
//     );
//   }

//   /// Approve NGO: Move from `pending_approvals` to `ngos`
//   Future<void> approveNGO(String ngoId) async {
//     try {
//       DocumentSnapshot ngoDoc =
//           await _firestore.collection('pending_approvals').doc(ngoId).get();

//       if (ngoDoc.exists) {
//         Map<String, dynamic> data = ngoDoc.data() as Map<String, dynamic>;

//         await _firestore.collection('ngos').doc(ngoId).set({
//           ...data,
//           'approved': true,
//           'approvedAt': Timestamp.now(),
//         });

//         await _firestore.collection('pending_approvals').doc(ngoId).delete();

//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           content: Text('NGO Approved Successfully'),
//           backgroundColor: Colors.green,
//         ));
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text('Error approving NGO: $e'),
//         backgroundColor: Colors.red,
//       ));
//     }
//   }

//   /// Reject NGO (Delete from `pending_approvals`)
//   Future<void> rejectNGO(String ngoId) async {
//     try {
//       await _firestore.collection('pending_approvals').doc(ngoId).delete();
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text('NGO Rejected and Removed'),
//         backgroundColor: Colors.red,
//       ));
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text('Error rejecting NGO: $e'),
//         backgroundColor: Colors.red,
//       ));
//     }
//   }

//   /// Open document in browser
//   void viewDocument(String docUrl) async {
//     if (await canLaunch(docUrl)) {
//       await launch(docUrl);
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text('Could not open document'),
//         backgroundColor: Colors.red,
//       ));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Admin Dashboard'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.logout),
//             onPressed: () => _signOut(context),
//           ),
//         ],
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: _firestore.collection('pending_approvals').snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }

//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return Center(child: Text('No NGOs awaiting approval'));
//           }

//           var pendingNGOs = snapshot.data!.docs;

//           return ListView.builder(
//             itemCount: pendingNGOs.length,
//             itemBuilder: (context, index) {
//               var ngo = pendingNGOs[index];
//               var ngoData = ngo.data() as Map<String, dynamic>;
//               String? documentUrl = ngoData['documentUrl']; // Get document URL

//               return Card(
//                 margin: EdgeInsets.all(10),
//                 elevation: 3,
//                 child: ListTile(
//                   title: Text(ngoData['name'] ?? 'NGO Name'),
//                   subtitle: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(ngoData['email'] ?? 'Email not available'),
//                       SizedBox(height: 5),
//                       documentUrl != null
//                           ? TextButton(
//                               onPressed: () => viewDocument(documentUrl),
//                               child: Text('View Document',
//                                   style: TextStyle(color: Colors.blue)),
//                             )
//                           : Text('No Document Uploaded',
//                               style: TextStyle(color: Colors.red)),
//                     ],
//                   ),
//                   trailing: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       IconButton(
//                         icon: Icon(Icons.check, color: Colors.green),
//                         onPressed: () => approveNGO(ngo.id),
//                       ),
//                       IconButton(
//                         icon: Icon(Icons.close, color: Colors.red),
//                         onPressed: () => rejectNGO(ngo.id),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           );
//         },
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

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key? key}) : super(key: key);
  
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> with SingleTickerProviderStateMixin {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  
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
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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
              _buildDashboardBody(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF00A86B), Color(0xFF009160)],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x40000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
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
                    'Manage NGO Applications',
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
          const SizedBox(height: 20),
          StreamBuilder<QuerySnapshot>(
            stream: _firestore.collection('pending_approvals').snapshots(),
            builder: (context, snapshot) {
              int count = snapshot.hasData ? snapshot.data!.docs.length : 0;
              return Row(
                children: [
                  _buildStatCard(
                    'Pending Applications',
                    count.toString(),
                    Icons.assignment_late_outlined,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(15),
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
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
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
            const SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardBody() {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
      ),
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