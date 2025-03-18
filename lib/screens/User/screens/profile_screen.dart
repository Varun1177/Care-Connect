import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  final double userRating = 4.7; // Example rating

  final List<String> ngosJoined = [
    "Helping Hands",
    "Save the Earth",
    "Food for All"
  ];
  final List<String> drivesAttended = [
    "Clothes Donation Drive",
    "Tree Plantation",
    "Blood Donation Camp"
  ];
  final List<String> drivesApplied = [
    "Orphanage Visit",
    "Food Distribution",
    "Medical Camp"
  ];
  final List<String> donationsMade = [
    "₹500 to Education",
    "₹1000 to Medical Aid",
    "₹200 to Animal Welfare"
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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
            // User Rating Section
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.orange,
                    child: Icon(Icons.person, size: 50, color: Colors.white),
                  ),
                  SizedBox(height: 10),
                  Text("John Doe",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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

  // Rating Stars Widget
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

  // Animated Profile Section
  Widget _buildProfileSection(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        Column(
          children: items.map((item) => _buildProfileItem(item)).toList(),
        ),
        SizedBox(height: 20),
      ],
    );
  }

  // Profile Item with Hover & Animation
  Widget _buildProfileItem(String item) {
    return GestureDetector(
      onTap: () {
        _animationController
            .forward()
            .then((_) => _animationController.reverse());
        _showDetailsPopup(item);
      },
      child: ScaleTransition(
        scale: Tween(begin: 1.0, end: 1.05).animate(
          CurvedAnimation(
              parent: _animationController, curve: Curves.easeInOut),
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

  // Show Details Popup
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
