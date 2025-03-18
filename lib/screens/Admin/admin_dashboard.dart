// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:url_launcher/url_launcher.dart';

// class AdminDashboard extends StatefulWidget {
//   const AdminDashboard({Key? key}) : super(key: key);

//   @override
//   _AdminDashboardState createState() => _AdminDashboardState();
// }

// class _AdminDashboardState extends State<AdminDashboard> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   // Approve NGO function
//   void _approveNGO(String ngoId) async {
//     await _firestore.collection('ngos').doc(ngoId).update({'approved': true});
//   }

//   // Reject NGO function
//   void _rejectNGO(String ngoId) async {
//     await _firestore.collection('ngos').doc(ngoId).delete();
//   }

//   // Logout function
//   void _logout() async {
//     await _auth.signOut();
//     Navigator.pushReplacementNamed(context, '/login');
//   }

//   // Open document in browser
//   void _openDocument(String url) async {
//     if (await canLaunch(url)) {
//       await launch(url);
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Cannot open document")),
//       );
//     }
//   }

//   void approveNGO(String ngoId) async {
//   try {
//     DocumentSnapshot ngoDoc = await FirebaseFirestore.instance.collection('pending_approvals').doc(ngoId).get();

//     if (ngoDoc.exists) {
//       Map<String, dynamic> data = ngoDoc.data() as Map<String, dynamic>;

//       await FirebaseFirestore.instance.collection('ngos').doc(ngoId).set({
//         'ngoId': data['ngoId'],
//         'name': data['name'],
//         'email': data['email'],
//         'sector': data['sector'],
//         'description': data['description'],
//         'personName': data['personName'],
//         'personRole': data['personRole'],
//         'logoUrl': data['logoUrl'],
//         'documents': [data['documentUrl']],
//         'approved': true,
//         'postedDrives': [],
//         'donationsReceived': [],
//         'ratings': {},
//       });

//       // Remove from pending approvals
//       await FirebaseFirestore.instance.collection('pending_approvals').doc(ngoId).delete();

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("NGO Approved Successfully")),
//       );
//     }
//   } catch (e) {
//     print("Error: $e");
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text("Error approving NGO")),
//     );
//   }
// }


//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Admin Dashboard"),
//         backgroundColor: Colors.green,
//         actions: [
//           IconButton(icon: const Icon(Icons.logout), onPressed: _logout),
//         ],
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: _firestore.collection('ngos').where('approved', isEqualTo: false).snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return const Center(child: Text("No pending NGOs"));
//           }

//           final ngos = snapshot.data!.docs;

//           return ListView.builder(
//             itemCount: ngos.length,
//             itemBuilder: (context, index) {
//               var ngo = ngos[index];
//               List<dynamic> documents = ngo['documents'] ?? [];

//               return Card(
//                 margin: const EdgeInsets.all(10),
//                 child: ExpansionTile(
//                   title: Text(ngo['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
//                   subtitle: Text(ngo['email']),
//                   children: [
//                     const Padding(
//                       padding: EdgeInsets.all(10),
//                       child: Text("Uploaded Documents:", style: TextStyle(fontWeight: FontWeight.bold)),
//                     ),
//                     // List uploaded documents
//                     ...documents.map((doc) => ListTile(
//                           title: Text("Document ${documents.indexOf(doc) + 1}"),
//                           trailing: const Icon(Icons.open_in_new, color: Colors.blue),
//                           onTap: () => _openDocument(doc),
//                         )),
//                     // Approve / Reject buttons
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceAround,
//                       children: [
//                         ElevatedButton(
//                           onPressed: () => _approveNGO(ngo.id),
//                           style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
//                           child: const Text("Approve", style: TextStyle(color: Colors.white)),
//                         ),
//                         ElevatedButton(
//                           onPressed: () => _rejectNGO(ngo.id),
//                           style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//                           child: const Text("Reject", style: TextStyle(color: Colors.white)),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 10),
//                   ],
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

class AdminDashboard extends StatefulWidget {
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Approve NGO: Move from `pending_approvals` to `ngos`
  Future<void> approveNGO(String ngoId) async {
    try {
      DocumentSnapshot ngoDoc = await _firestore.collection('pending_approvals').doc(ngoId).get();

      if (ngoDoc.exists) {
        Map<String, dynamic> data = ngoDoc.data() as Map<String, dynamic>;

        await _firestore.collection('ngos').doc(ngoId).set({
          ...data,
          'approved': true,
          'approvedAt': Timestamp.now(),
        });

        await _firestore.collection('pending_approvals').doc(ngoId).delete();

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('NGO Approved Successfully'),
          backgroundColor: Colors.green,
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error approving NGO: $e'),
        backgroundColor: Colors.red,
      ));
    }
  }

  /// Reject NGO (Delete from `pending_approvals`)
  Future<void> rejectNGO(String ngoId) async {
    try {
      await _firestore.collection('pending_approvals').doc(ngoId).delete();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('NGO Rejected and Removed'),
        backgroundColor: Colors.red,
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error rejecting NGO: $e'),
        backgroundColor: Colors.red,
      ));
    }
  }

  /// Open document in browser
  void viewDocument(String docUrl) async {
    if (await canLaunch(docUrl)) {
      await launch(docUrl);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Could not open document'),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Admin Dashboard')),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('pending_approvals').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No NGOs awaiting approval'));
          }

          var pendingNGOs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: pendingNGOs.length,
            itemBuilder: (context, index) {
              var ngo = pendingNGOs[index];
              var ngoData = ngo.data() as Map<String, dynamic>;
              String? documentUrl = ngoData['documentUrl']; // Get document URL

              return Card(
                margin: EdgeInsets.all(10),
                elevation: 3,
                child: ListTile(
                  title: Text(ngoData['name'] ?? 'NGO Name'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(ngoData['email'] ?? 'Email not available'),
                      SizedBox(height: 5),
                      documentUrl != null
                          ? TextButton(
                              onPressed: () => viewDocument(documentUrl),
                              child: Text('View Document', style: TextStyle(color: Colors.blue)),
                            )
                          : Text('No Document Uploaded', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.check, color: Colors.green),
                        onPressed: () => approveNGO(ngo.id),
                      ),
                      IconButton(
                        icon: Icon(Icons.close, color: Colors.red),
                        onPressed: () => rejectNGO(ngo.id),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
