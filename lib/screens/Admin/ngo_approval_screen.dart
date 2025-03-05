import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NGOApprovalScreen extends StatelessWidget {
  const NGOApprovalScreen({super.key});

  void approveNGO(String ngoId) async {
    await FirebaseFirestore.instance.collection('users').doc(ngoId).update({
      'status': 'approved',
    });
  }

  void rejectNGO(String ngoId) async {
    await FirebaseFirestore.instance.collection('users').doc(ngoId).update({
      'status': 'rejected',
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("NGO Approvals")),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('role', isEqualTo: 'ngo')
            .where('status', isEqualTo: 'pending')
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          return ListView(
            children: snapshot.data!.docs.map((ngo) {
              return ListTile(
                title: Text(ngo['email']),
                subtitle: Text("Document: ${ngo['documentUrl']}"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed: () => approveNGO(ngo.id),
                      child: const Text("Approve"),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () => rejectNGO(ngo.id),
                      child: const Text("Reject"),
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
