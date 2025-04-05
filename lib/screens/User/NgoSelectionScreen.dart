import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NgoSelectionScreen extends StatelessWidget {
  final String donationType;
  NgoSelectionScreen({required this.donationType});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Select NGO for $donationType"), backgroundColor: Colors.orange),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('ngos')
            .where('acceptedDonations', arrayContains: donationType)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No NGOs found for $donationType"));
          }

          return ListView(
            children: snapshot.data!.docs.map((ngo) {
              return Card(
                margin: EdgeInsets.all(10),
                child: ListTile(
                  leading: Icon(Icons.home, color: Colors.orange),
                  title: Text(ngo['name']),
                  subtitle: Text(ngo['location']),
                  trailing: IconButton(
                    icon: Icon(Icons.phone, color: Colors.green),
                    onPressed: () {
                      // Handle NGO contact (e.g., call or open chat)
                    },
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
