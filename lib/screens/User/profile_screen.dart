import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String userEmail = "Loading...";
  String profileImageUrl = "";
  double userRating = 0.0;
  List<String> ngosJoined = [];
  List<String> drivesAttended = [];
  List<String> drivesApplied = [];
  List<String> donationsMade = [];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _fetchUserData();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _fetchUserData() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot userData =
            await _firestore.collection('users').doc(user.uid).get();
        setState(() {
          userEmail = user.email ?? "No Email";
          profileImageUrl = userData.exists ? userData['profileImage'] ?? "" : "";
          userRating = (userData['rating'] ?? 0).toDouble();
          ngosJoined = List<String>.from(userData['ngosJoined'] ?? []);
          drivesAttended = List<String>.from(userData['drivesAttended'] ?? []);
          drivesApplied = List<String>.from(userData['drivesApplied'] ?? []);
          donationsMade = List<String>.from(userData['donationsMade'] ?? []);
        });
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My Profile"), backgroundColor: Colors.orange),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.orange,
                    backgroundImage: profileImageUrl.isNotEmpty
                        ? NetworkImage(profileImageUrl)
                        : null,
                    child: profileImageUrl.isEmpty
                        ? Icon(Icons.person, size: 50, color: Colors.white)
                        : null,
                  ),
                  SizedBox(height: 10),
                  Text(
                    userEmail,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  _buildRatingStars(userRating),
                  SizedBox(height: 20),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  _buildProfileSection("NGOs Joined", ngosJoined),
                  _buildProfileSection("Drives Attended", drivesAttended),
                  _buildProfileSection("Drives Applied To", drivesApplied),
                  _buildProfileSection("Donations Made", donationsMade),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingStars(double rating) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return Icon(
          index < rating ? Icons.star : Icons.star_border,
          color: Colors.orange,
        );
      }),
    );
  }

  Widget _buildProfileSection(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        Column(
          children: items.isEmpty
              ? [Text("No data available", style: TextStyle(color: Colors.grey))]
              : items.map((item) => _buildProfileItem(item)).toList(),
        ),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _buildProfileItem(String item) {
    return GestureDetector(
      onTap: () {
        _animationController.forward().then((_) => _animationController.reverse());
        _showDetailsPopup(item);
      },
      child: ScaleTransition(
        scale: Tween(begin: 1.0, end: 1.05).animate(
          CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
        ),
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 5),
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.orange),
            boxShadow: [
              BoxShadow(
                color: Colors.orange.withOpacity(0.3),
                blurRadius: 8,
                spreadRadius: 1,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.orange),
              SizedBox(width: 10),
              Expanded(child: Text(item, style: TextStyle(fontSize: 16))),
            ],
          ),
        ),
      ),
    );
  }

  void _showDetailsPopup(String item) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Details"),
          content: Text("$item - More information coming soon!"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK", style: TextStyle(color: Colors.orange)),
            ),
          ],
        );
      },
    );
  }
}

