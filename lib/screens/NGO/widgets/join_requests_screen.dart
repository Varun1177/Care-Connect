// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart'; // For formatting the timestamp

// class JoinRequestsScreen extends StatelessWidget {
//   const JoinRequestsScreen({super.key});

//   Future<void> updateRequestStatus(String docId, String status) async {
//     await FirebaseFirestore.instance
//         .collection('ngo_join_requests')
//         .doc(docId)
//         .update({
//       'status': status,
//     });
//   }

//   void _showUserDetailsDialog(BuildContext context, DocumentSnapshot userData) {
//     // Extract user data fields with null safety
//     final name = userData['name'] as String? ?? 'Not provided';
//     final email = userData['email'] as String? ?? 'Not provided';
//     final phone = userData['phone'] as String? ?? 'Not provided';
//     final age = userData['age'] as String? ?? 'Not provided';
//     final address = userData['address'] as String? ?? 'Not provided';
//     final location = userData['location'] as String? ?? 'Not provided';
//     final profileImageUrl = userData['profileImageUrl'] as String? ?? '';
    
//     // Format timestamp if available
//     String lastUpdated = 'Not available';
//     if (userData['lastUpdated'] != null) {
//       try {
//         final timestamp = userData['lastUpdated'] as Timestamp;
//         lastUpdated = DateFormat('MMM d, yyyy at h:mm a').format(timestamp.toDate());
//       } catch (e) {
//         lastUpdated = 'Invalid date';
//       }
//     }

//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('User Details'),
//         content: SingleChildScrollView(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Profile image if available
//               if (profileImageUrl.isNotEmpty)
//                 Center(
//                   child: CircleAvatar(
//                     radius: 50,
//                     backgroundImage: NetworkImage(profileImageUrl),
//                     onBackgroundImageError: (_, __) {},
//                   ),
//                 ),
//               const SizedBox(height: 16),
              
//               // User details in list format
//               _buildDetailRow('Name', name),
//               _buildDetailRow('Email', email),
//               _buildDetailRow('Phone', phone),
//               _buildDetailRow('Age', age),
//               _buildDetailRow('Address', address),
//               _buildDetailRow('Location', location),
//               _buildDetailRow('Last Updated', lastUpdated),
//             ],
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: const Text('Close'),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDetailRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(
//             width: 100,
//             child: Text(
//               '$label:',
//               style: const TextStyle(fontWeight: FontWeight.bold),
//             ),
//           ),
//           Expanded(
//             child: Text(value),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final String ngoId = FirebaseAuth.instance.currentUser!.uid;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Join Requests'),
//         backgroundColor: Colors.green.shade400,
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('ngo_join_requests')
//             .where('ngoId', isEqualTo: ngoId)
//             .where('status', isEqualTo: 'pending')
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData)
//             return const Center(child: CircularProgressIndicator());

//           final requests = snapshot.data!.docs;

//           if (requests.isEmpty) {
//             return const Center(child: Text('No pending join requests.'));
//           }

//           return ListView.builder(
//             itemCount: requests.length,
//             itemBuilder: (context, index) {
//               final request = requests[index];
//               final docId = request.id;
//               final userId = request['userId'];

//               return FutureBuilder<DocumentSnapshot>(
//                 future: FirebaseFirestore.instance
//                     .collection('user_data')
//                     .doc(userId)
//                     .get(),
//                 builder: (context, userSnapshot) {
//                   if (!userSnapshot.hasData)
//                     return const ListTile(title: Text("Loading user..."));

//                   final userData = userSnapshot.data!;
//                   final userName = userData['name'] ?? 'Unknown';
//                   final userEmail = userData['email'] ?? '';

//                   return Card(
//                     margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                     child: ListTile(
//                       leading: userData['profileImageUrl'] != null && userData['profileImageUrl'].toString().isNotEmpty
//                           ? CircleAvatar(
//                               backgroundImage: NetworkImage(userData['profileImageUrl']),
//                               onBackgroundImageError: (_, __) {
//                                 // Fallback for invalid image URLs
//                                 // Will show the first letter of the name
//                               },
//                             )
//                           : CircleAvatar(
//                               child: Text(userName.isNotEmpty ? userName[0] : '?'),
//                             ),
//                       title: Text(userName),
//                       subtitle: Text(userEmail),
//                       onTap: () => _showUserDetailsDialog(context, userData),
//                       trailing: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           IconButton(
//                             icon: const Icon(Icons.check_circle, color: Colors.green),
//                             onPressed: () async {
//                               await FirebaseFirestore.instance
//                                   .collection('ngos')
//                                   .doc(ngoId)
//                                   .update({
//                                 'members': FieldValue.arrayUnion([userId]),
//                               });
                              
//                               await updateRequestStatus(docId, 'approved');
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 SnackBar(content: Text('$userName approved')),
//                               );
//                             },
//                           ),
//                           IconButton(
//                             icon: const Icon(Icons.cancel, color: Colors.red),
//                             onPressed: () async {
//                               await updateRequestStatus(docId, 'rejected');
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 SnackBar(content: Text('$userName rejected')),
//                               );
//                             },
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For formatting the timestamp

class JoinRequestsScreen extends StatefulWidget {
  const JoinRequestsScreen({super.key});

  @override
  State<JoinRequestsScreen> createState() => _JoinRequestsScreenState();
}

class _JoinRequestsScreenState extends State<JoinRequestsScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
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

  Future<void> updateRequestStatus(String docId, String status) async {
    await FirebaseFirestore.instance
        .collection('ngo_join_requests')
        .doc(docId)
        .update({
      'status': status,
    });
  }

  void _showUserDetailsDialog(BuildContext context, DocumentSnapshot userData) {
    // Extract user data fields with null safety
    final name = userData['name'] as String? ?? 'Not provided';
    final email = userData['email'] as String? ?? 'Not provided';
    final phone = userData['phone'] as String? ?? 'Not provided';
    final age = userData['age'] as String? ?? 'Not provided';
    final address = userData['address'] as String? ?? 'Not provided';
    final location = userData['location'] as String? ?? 'Not provided';
    final profileImageUrl = userData['profileImageUrl'] as String? ?? '';
    
    // Format timestamp if available
    String lastUpdated = 'Not available';
    if (userData['lastUpdated'] != null) {
      try {
        final timestamp = userData['lastUpdated'] as Timestamp;
        lastUpdated = DateFormat('MMM d, yyyy at h:mm a').format(timestamp.toDate());
      } catch (e) {
        lastUpdated = 'Invalid date';
      }
    }

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 10,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'User Details',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF00A86B),
                ),
              ),
              const SizedBox(height: 20),
              
              // Profile image if available
              if (profileImageUrl.isNotEmpty)
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage(profileImageUrl),
                    onBackgroundImageError: (_, __) {},
                  ),
                ),
              const SizedBox(height: 25),
              
              // User details in styled format
              Flexible(
                child: SingleChildScrollView(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 5,
                          spreadRadius: 1,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        children: [
                          _buildDetailRow(Icons.person_outline, 'Name', name),
                          _buildDivider(),
                          _buildDetailRow(Icons.email_outlined, 'Email', email),
                          _buildDivider(),
                          _buildDetailRow(Icons.phone_outlined, 'Phone', phone),
                          _buildDivider(),
                          _buildDetailRow(Icons.calendar_today_outlined, 'Age', age),
                          _buildDivider(),
                          _buildDetailRow(Icons.home_outlined, 'Address', address),
                          _buildDivider(),
                          _buildDetailRow(Icons.location_on_outlined, 'Location', location),
                          _buildDivider(),
                          _buildDetailRow(Icons.update_outlined, 'Last Updated', lastUpdated),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              // Close button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00A86B),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 3,
                  ),
                  child: const Text(
                    'Close',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: Colors.grey.shade300,
      thickness: 1,
      height: 20,
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: const Color(0xFF00A86B)),
          const SizedBox(width: 10),
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String ngoId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      body: Column(
        children: [
          // Stylized app bar with gradient
          Container(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF00A86B), Color(0xFF009160)],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25),
              ),
              boxShadow: [
                BoxShadow(
                  color: Color(0x40000000),
                  blurRadius: 10,
                  spreadRadius: 0,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      const Expanded(
                        child: Text(
                          'Join Requests',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 48), // For symmetry
                    ],
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Manage user requests to join your NGO',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Main content
          Expanded(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('ngo_join_requests')
                    .where('ngoId', isEqualTo: ngoId)
                    .where('status', isEqualTo: 'pending')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF00A86B),
                      ),
                    );
                  }

                  final requests = snapshot.data!.docs;

                  if (requests.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.people_alt_outlined,
                            size: 70,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 15),
                          Text(
                            'No pending join requests',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'When users request to join, they will appear here',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                    child: ListView.builder(
                      itemCount: requests.length,
                      itemBuilder: (context, index) {
                        final request = requests[index];
                        final docId = request.id;
                        final userId = request['userId'];

                        return FutureBuilder<DocumentSnapshot>(
                          future: FirebaseFirestore.instance
                              .collection('user_data')
                              .doc(userId)
                              .get(),
                          builder: (context, userSnapshot) {
                            if (!userSnapshot.hasData) {
                              return Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                elevation: 2,
                                child: const Padding(
                                  padding: EdgeInsets.all(15),
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: Color(0xFF00A86B),
                                    ),
                                  ),
                                ),
                              );
                            }

                            final userData = userSnapshot.data!;
                            final userName = userData['name'] ?? 'Unknown';
                            final userEmail = userData['email'] ?? '';

                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              elevation: 3,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(15),
                                onTap: () => _showUserDetailsDialog(context, userData),
                                child: Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: Row(
                                    children: [
                                      // User avatar
                                      Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.1),
                                              blurRadius: 5,
                                              spreadRadius: 1,
                                            ),
                                          ],
                                        ),
                                        child: userData['profileImageUrl'] != null && 
                                               userData['profileImageUrl'].toString().isNotEmpty
                                            ? CircleAvatar(
                                                radius: 30,
                                                backgroundImage: NetworkImage(userData['profileImageUrl']),
                                                onBackgroundImageError: (_, __) {},
                                              )
                                            : CircleAvatar(
                                                radius: 30,
                                                backgroundColor: const Color(0xFF00A86B),
                                                child: Text(
                                                  userName.isNotEmpty ? userName[0].toUpperCase() : '?',
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 22,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                      ),
                                      const SizedBox(width: 15),
                                      // User info
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              userName,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              userEmail,
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey.shade600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      // Action buttons
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          _buildActionButton(
                                            onPressed: () async {
                                              await FirebaseFirestore.instance
                                                  .collection('ngos')
                                                  .doc(ngoId)
                                                  .update({
                                                'members': FieldValue.arrayUnion([userId]),
                                              });
                                              
                                              await updateRequestStatus(docId, 'approved');
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                  content: Text('$userName approved'),
                                                  backgroundColor: const Color(0xFF00A86B),
                                                  behavior: SnackBarBehavior.floating,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(10),
                                                  ),
                                                ),
                                              );
                                            },
                                            color: const Color(0xFF00A86B),
                                            icon: Icons.check_circle_outline,
                                            label: 'Approve',
                                          ),
                                          const SizedBox(width: 10),
                                          _buildActionButton(
                                            onPressed: () async {
                                              await updateRequestStatus(docId, 'rejected');
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                  content: Text('$userName rejected'),
                                                  backgroundColor: Colors.redAccent,
                                                  behavior: SnackBarBehavior.floating,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(10),
                                                  ),
                                                ),
                                              );
                                            },
                                            color: Colors.redAccent,
                                            icon: Icons.cancel_outlined,
                                            label: 'Reject',
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required VoidCallback onPressed,
    required Color color,
    required IconData icon,
    required String label,
  }) {
    return Material(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(30),
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 18),
              const SizedBox(width: 5),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}