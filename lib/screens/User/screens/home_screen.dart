import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final List<Map<String, String>> ngoDrives = [
    {
      'name': 'Food Donation Drive',
      'location': 'Delhi, India',
      'date': 'March 25, 2025',
      'image': 'lib/assets/food_donation.png',
    },
    {
      'name': 'Clothes for the Needy',
      'location': 'Mumbai, India',
      'date': 'April 10, 2025',
      'image': 'lib/assets/clothes_donation.png',
    },
    {
      'name': 'Blood Donation Camp',
      'location': 'Bangalore, India',
      'date': 'April 20, 2025',
      'image': 'lib/assets/blood_donation.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('NGO Drives'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: ngoDrives.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Responsive Grid
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.8,
          ),
          itemBuilder: (context, index) {
            return _buildNGODriveCard(context, ngoDrives[index]);
          },
        ),
      ),
    );
  }

  Widget _buildNGODriveCard(BuildContext context, Map<String, String> drive) {
    return MouseRegion(
      onEnter: (_) => print("Hovered"), // For debugging
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  JoinDriveScreen(drive: drive),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return FadeTransition(opacity: animation, child: child);
              },
            ),
          );
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                blurRadius: 8,
                spreadRadius: 2,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(12)),
                    child: Image.asset(drive['image']!,
                        width: double.infinity, fit: BoxFit.cover),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    drive['name']!,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    "📍 ${drive['location']}",
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 4.0),
                  child: Text(
                    "📅 ${drive['date']}",
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
                SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class JoinDriveScreen extends StatelessWidget {
  final Map<String, String> drive;

  JoinDriveScreen({required this.drive});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Join ${drive['name']}")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Do you want to join this drive?",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Successfully joined ${drive['name']}!"),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              child: Text("Join Drive"),
            ),
          ],
        ),
      ),
    );
  }
}
