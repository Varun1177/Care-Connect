import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:care__connect/services/auth_service.dart';
import 'package:care__connect/screens/login_screen.dart';

class AdminDashboard extends StatefulWidget {
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _signOut(BuildContext context) async {
    await AuthService().signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  /// Approve NGO: Move from `pending_approvals` to `ngos`
  Future<void> approveNGO(String ngoId) async {
    try {
      DocumentSnapshot ngoDoc =
          await _firestore.collection('pending_approvals').doc(ngoId).get();

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
      appBar: AppBar(
        title: Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _signOut(context),
          ),
        ],
      ),
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
                              child: Text('View Document',
                                  style: TextStyle(color: Colors.blue)),
                            )
                          : Text('No Document Uploaded',
                              style: TextStyle(color: Colors.red)),
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
