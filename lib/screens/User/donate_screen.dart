// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class DonateScreen extends StatefulWidget {
//   @override
//   _DonateScreenState createState() => _DonateScreenState();
// }

// class _DonateScreenState extends State<DonateScreen> with SingleTickerProviderStateMixin {
//   int _selectedAmount = 500;
//   String _selectedCause = "Food Donation";
//   late AnimationController _animationController;
//   final _auth = FirebaseAuth.instance;

//   final List<int> donationAmounts = [100, 500, 1000, 5000];
//   final List<String> donationCauses = [
//     "Food Donation",
//     "Education for Kids",
//     "Medical Assistance",
//     "Women Empowerment",
//     "Animal Welfare"
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 300),
//     );
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }

//   Future<void> _donate() async {
//     User? user = _auth.currentUser;
//     if (user == null) {
//       _showError("You must be logged in to donate.");
//       return;
//     }

//     try {
//       DocumentReference donationRef = FirebaseFirestore.instance.collection('donations').doc(user.uid);

//       await donationRef.set({
//         'userId': user.uid,
//         'amount': FieldValue.increment(_selectedAmount), // 🔹 Adds the new amount to existing one
//         'cause': _selectedCause,
//         'timestamp': FieldValue.serverTimestamp(),
//       }, SetOptions(merge: true)); // 🔹 Merge so that existing data isn't overwritten

//       _animationController.forward().then((_) {
//         _animationController.reverse();
//         _showConfirmation();
//       });
//     } catch (e) {
//       _showError("Failed to process donation. Please try again.");
//     }
//   }

//   void _showConfirmation() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text("Donation Successful 🎉"),
//         content: Text("You donated ₹$_selectedAmount to $_selectedCause!"),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text("OK", style: TextStyle(color: Colors.orange)),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showError(String message) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text("Error ❌"),
//         content: Text(message),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text("OK", style: TextStyle(color: Colors.red)),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Center(child:  Text("Donate to a Cause",style: TextStyle(color: Colors.white),)), backgroundColor: const Color.fromARGB(255, 0, 39, 107)),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text("Choose an Amount", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 12),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: donationAmounts.map((amount) => _buildAmountButton(amount)).toList(),
//             ),
//             const SizedBox(height: 20),
//             const Text("Select a Cause", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 12),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: donationCauses.length,
//                 itemBuilder: (context, index) => _buildCauseCard(donationCauses[index]),
//               ),
//             ),
//             const SizedBox(height: 20),
//             GestureDetector(
//               onTap: _donate,
//               child: ScaleTransition(
//                 scale: Tween(begin: 1.0, end: 1.05).animate(
//                   CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
//                 ),
//                 child: Container(
//                   width: double.infinity,
//                   padding: EdgeInsets.symmetric(vertical: 14),
//                   decoration: BoxDecoration(
//                     color: Color.fromARGB(255, 0, 39, 107),
//                     borderRadius: BorderRadius.circular(8),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.orange.withOpacity(0.5),
//                         blurRadius: 10,
//                         spreadRadius: 1,
//                         offset: Offset(0, 4),
//                       ),
//                     ],
//                   ),
//                   child: Center(
//                     child: Text(
//                       "Donate ₹$_selectedAmount",
//                       style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildAmountButton(int amount) {
//     bool isSelected = _selectedAmount == amount;
//     return GestureDetector(
//       onTap: () => setState(() => _selectedAmount = amount),
//       child: AnimatedContainer(
//         duration: Duration(milliseconds: 300),
//         padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//         decoration: BoxDecoration(
//           color: isSelected ? Colors.orange : Colors.white,
//           borderRadius: BorderRadius.circular(8),
//           border: Border.all(color: isSelected ? Colors.orange : Colors.grey),
//           boxShadow: isSelected
//               ? [BoxShadow(color: Colors.orange.withOpacity(0.5), blurRadius: 8, spreadRadius: 1, offset: Offset(0, 4))]
//               : [],
//         ),
//         child: Text(
//           "₹$amount",
//           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isSelected ? Colors.white : Colors.black),
//         ),
//       ),
//     );
//   }

//   Widget _buildCauseCard(String cause) {
//     bool isSelected = _selectedCause == cause;
//     return GestureDetector(
//       onTap: () => setState(() => _selectedCause = cause),
//       child: AnimatedContainer(
//         duration: Duration(milliseconds: 300),
//         margin: EdgeInsets.symmetric(vertical: 6),
//         padding: EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: isSelected ? Colors.orange.withOpacity(0.2) : Colors.white,
//           borderRadius: BorderRadius.circular(10),
//           border: Border.all(color: isSelected ? Colors.orange : Colors.grey),
//           boxShadow: isSelected
//               ? [BoxShadow(color: Colors.orange.withOpacity(0.3), blurRadius: 8, spreadRadius: 1, offset: Offset(0, 4))]
//               : [],
//         ),
//         child: Row(
//           children: [
//             Icon(Icons.favorite, color: isSelected ? Colors.orange : Colors.grey),
//             SizedBox(width: 10),
//             Expanded(child: Text(cause, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500,color: Colors.black))),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DonateScreen extends StatefulWidget {
  const DonateScreen({super.key});

  @override
  _DonateScreenState createState() => _DonateScreenState();
}

class _DonateScreenState extends State<DonateScreen> with SingleTickerProviderStateMixin {
  int _selectedAmount = 500;
  String _selectedCause = "Food Donation";
  late AnimationController _animationController;
  final _auth = FirebaseAuth.instance;
  late Animation<double> _fadeAnimation;

  final List<int> donationAmounts = [100, 500, 1000, 5000];
  final List<Map<String, dynamic>> donationCauses = [
    {"name": "Food Donation", "icon": Icons.fastfood},
    {"name": "Education for Kids", "icon": Icons.school},
    {"name": "Medical Assistance", "icon": Icons.medical_services},
    {"name": "Women Empowerment", "icon": Icons.people},
    {"name": "Animal Welfare", "icon": Icons.pets}
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
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

  Future<void> _donate() async {
    User? user = _auth.currentUser;
    if (user == null) {
      _showError("You must be logged in to donate.");
      return;
    }

    final loadingDialog = showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(
          color: Color(0xFF00A86B),
        ),
      ),
    );

    try {
      DocumentReference donationRef = FirebaseFirestore.instance.collection('donations').doc();

      await donationRef.set({
        'userId': user.uid,
        'amount': _selectedAmount,
        'cause': _selectedCause,
        'timestamp': FieldValue.serverTimestamp(),
      });

      Navigator.pop(context); // Close loading dialog
      _showConfirmation();
    } catch (e) {
      Navigator.pop(context); // Close loading dialog
      _showError("Failed to process donation. Please try again.");
    }
  }

  void _showConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Icon(
              Icons.check_circle,
              color: const Color(0xFF00A86B),
              size: 28,
            ),
            const SizedBox(width: 10),
            const Text(
              "Donation Successful",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Thank you for your contribution!",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(
              "You donated ₹$_selectedAmount to $_selectedCause.",
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF00A86B).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.volunteer_activism,
                    color: const Color(0xFF00A86B),
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: Text(
                      "Your donation will make a difference in someone's life.",
                      style: TextStyle(
                        color: const Color(0xFF00A86B),
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF00A86B),
            ),
            child: const Text(
              "CLOSE",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 28,
            ),
            const SizedBox(width: 10),
            const Text(
              "Error",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF00A86B),
            ),
            child: const Text(
              "OK",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    
    return Scaffold(
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Top gradient container with title
              Stack(
                alignment: Alignment.bottomCenter,
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: screenSize.height * 0.28,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF00A86B), Color(0xFF009160)],
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(50),
                        bottomRight: Radius.circular(50),
                      ),
                    ),
                    child: const Stack(
                      children: [
                        Positioned(
                          top: 70,
                          left: 0,
                          right: 0,
                          child: Column(
                            children: [
                              Text(
                                'Make a Donation',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Your support makes a difference',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: -40,
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.volunteer_activism,
                        size: 50,
                        color: Color(0xFF00A86B),
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 60),
              
              // Main content
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Choose amount section
                    const Text(
                      "Choose an Amount",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF00A86B),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Container(
                      height: 60,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: donationAmounts.length,
                        itemBuilder: (context, index) => _buildAmountButton(donationAmounts[index]),
                      ),
                    ),
                    
                    const SizedBox(height: 25),
                    
                    // Choose cause section
                    const Text(
                      "Select a Cause",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF00A86B),
                      ),
                    ),
                    const SizedBox(height: 15),
                    
                    // Causes list
                    for (var cause in donationCauses)
                      _buildCauseCard(cause["name"], cause["icon"]),
                    
                    const SizedBox(height: 30),
                    
                    // Donate button
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: _donate,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00A86B),
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: Text(
                          "DONATE ₹$_selectedAmount",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAmountButton(int amount) {
    bool isSelected = _selectedAmount == amount;
    
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: GestureDetector(
        onTap: () => setState(() => _selectedAmount = amount),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF00A86B) : Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: isSelected ? const Color(0xFF00A86B) : Colors.grey.shade300,
              width: 1.5,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: const Color(0xFF00A86B).withOpacity(0.3),
                      blurRadius: 8,
                      spreadRadius: 1,
                      offset: const Offset(0, 4),
                    )
                  ]
                : [],
          ),
          child: Center(
            child: Text(
              "₹$amount",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.grey.shade700,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCauseCard(String cause, IconData icon) {
    bool isSelected = _selectedCause == cause;
    
    return GestureDetector(
      onTap: () => setState(() => _selectedCause = cause),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF00A86B).withOpacity(0.1) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected ? const Color(0xFF00A86B) : Colors.transparent,
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF00A86B).withOpacity(0.2),
                    blurRadius: 8,
                    spreadRadius: 1,
                    offset: const Offset(0, 4),
                  )
                ]
              : [],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF00A86B) : Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 5,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : const Color(0xFF00A86B),
                size: 22,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                cause,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: isSelected ? const Color(0xFF00A86B) : Colors.grey.shade700,
                ),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: const Color(0xFF00A86B),
              ),
          ],
        ),
      ),
    );
  }
}
