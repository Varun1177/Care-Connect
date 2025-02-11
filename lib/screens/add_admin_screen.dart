import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddAdminScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();

  void addAdmin() async {
    String email = emailController.text.trim();
    if (email.isNotEmpty) {
      var userQuery = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (userQuery.docs.isNotEmpty) {
        String userId = userQuery.docs.first.id;
        await FirebaseFirestore.instance.collection('users').doc(userId).update({
          'role': 'admin',
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Admin")),
      body: Column(
        children: [
          TextField(controller: emailController, decoration: InputDecoration(labelText: "Email")),
          ElevatedButton(onPressed: addAdmin, child: Text("Make Admin"))
        ],
      ),
    );
  }
}
