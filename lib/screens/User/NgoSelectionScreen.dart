// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class NgoSelectionScreen extends StatelessWidget {
//   final String donationType;
//   NgoSelectionScreen({required this.donationType});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Select NGO for $donationType"), backgroundColor: Colors.orange),
//       body: StreamBuilder(
//         stream: FirebaseFirestore.instance
//             .collection('ngos')
//             .where('acceptedDonations', arrayContains: donationType)
//             .snapshots(),
//         builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }
//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return Center(child: Text("No NGOs found for $donationType"));
//           }

//           return ListView(
//             children: snapshot.data!.docs.map((ngo) {
//               return Card(
//                 margin: EdgeInsets.all(10),
//                 child: ListTile(
//                   leading: Icon(Icons.home, color: Colors.orange),
//                   title: Text(ngo['name']),
//                   subtitle: Text(ngo['location']),
//                   trailing: IconButton(
//                     icon: Icon(Icons.phone, color: Colors.green),
//                     onPressed: () {
//                       // Handle NGO contact (e.g., call or open chat)
//                     },
//                   ),
//                 ),
//               );
//             }).toList(),
//           );
//         },
//       ),
//     );
//   }
// }
// NgoSelectionScreen.dart
import 'package:flutter/material.dart';
import 'package:care__connect/screens/User/books_donation_form.dart';
import 'package:care__connect/screens/User/food_donation_form.dart';
import 'package:care__connect/screens/User/cloth_donation_form.dart';


import 'common_header.dart';


class NgoSelectionScreen extends StatefulWidget {
  final String donationType;

  const NgoSelectionScreen({Key? key, required this.donationType}) : super(key: key);

  @override
  _NgoSelectionScreenState createState() => _NgoSelectionScreenState();
}

class _NgoSelectionScreenState extends State<NgoSelectionScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Example NGO list. Replace with dynamic data as needed.
  final List<String> ngoList = [
    "Helping Hands",
    "Care Foundation",
    "Community Aid",
    "Support Network"
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _navigateToDonationDetail(String ngoName) {
    switch (widget.donationType) {
      case "Books":
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BooksDonationDetailScreen(ngoName: ngoName),
          ),
        );
        break;
      case "Food":
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => FoodDonationDetailScreen(ngoName: ngoName),
          ),
        );
        break;
      case "Clothes":
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ClothesDonationDetailScreen(ngoName: ngoName),
          ),
        );
        break;
      default:
        // For other donation types, implement accordingly.
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Reusable gradient header.
          GradientHeader(
            title: 'Make a Difference',
            subtitle: 'Your donation matters',
            onBack: () => Navigator.pop(context),
          ),
          Expanded(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        "Select an NGO",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF333333),
                          
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: Text(
                        "For ${widget.donationType} donation",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: ListView.builder(
                        itemCount: ngoList.length,
                        itemBuilder: (context, index) {
                          return Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: ListTile(
                              leading: Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF00A86B).withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.account_balance,
                                  color: Color(0xFF00A86B),
                                  size: 28,
                                ),
                              ),
                              title: Text(
                                ngoList[index],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF333333)),
                              ),
                              subtitle: const Text("Tap to select this NGO"),
                              trailing: const Icon(Icons.arrow_forward_ios),
                              onTap: () => _navigateToDonationDetail(ngoList[index]),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
