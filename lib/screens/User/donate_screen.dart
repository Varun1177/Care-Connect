import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DonateScreen extends StatefulWidget {
  @override
  _DonateScreenState createState() => _DonateScreenState();
}

class _DonateScreenState extends State<DonateScreen> with SingleTickerProviderStateMixin {
  int _selectedAmount = 500;
  String _selectedCause = "Food Donation";
  late AnimationController _animationController;
  final _auth = FirebaseAuth.instance;

  final List<int> donationAmounts = [100, 500, 1000, 5000];
  final List<String> donationCauses = [
    "Food Donation",
    "Education for Kids",
    "Medical Assistance",
    "Women Empowerment",
    "Animal Welfare"
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

  Future<void> _donate() async {
    User? user = _auth.currentUser;
    if (user == null) {
      _showError("You must be logged in to donate.");
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('donations').add({
        'userId': user.uid,
        'amount': _selectedAmount,
        'cause': _selectedCause,
        'timestamp': FieldValue.serverTimestamp(),
      });

      _animationController.forward().then((_) {
        _animationController.reverse();
        _showConfirmation();
      });
    } catch (e) {
      _showError("Failed to process donation. Please try again.");
    }
  }

  void _showConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Donation Successful 🎉"),
        content: Text("You donated ₹$_selectedAmount to $_selectedCause!"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK", style: TextStyle(color: Colors.orange)),
          ),
        ],
      ),
    );
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Error ❌"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Donate to a Cause"), backgroundColor: Colors.orange),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Choose an Amount", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: donationAmounts.map((amount) => _buildAmountButton(amount)).toList(),
            ),
            SizedBox(height: 20),
            Text("Select a Cause", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: donationCauses.length,
                itemBuilder: (context, index) => _buildCauseCard(donationCauses[index]),
              ),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: _donate,
              child: ScaleTransition(
                scale: Tween(begin: 1.0, end: 1.05).animate(
                  CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
                ),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orange.withOpacity(0.5),
                        blurRadius: 10,
                        spreadRadius: 1,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      "Donate ₹$_selectedAmount",
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountButton(int amount) {
    bool isSelected = _selectedAmount == amount;
    return GestureDetector(
      onTap: () => setState(() => _selectedAmount = amount),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.orange : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: isSelected ? Colors.orange : Colors.grey),
          boxShadow: isSelected
              ? [BoxShadow(color: Colors.orange.withOpacity(0.5), blurRadius: 8, spreadRadius: 1, offset: Offset(0, 4))]
              : [],
        ),
        child: Text(
          "₹$amount",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isSelected ? Colors.white : Colors.black),
        ),
      ),
    );
  }

  Widget _buildCauseCard(String cause) {
    bool isSelected = _selectedCause == cause;
    return GestureDetector(
      onTap: () => setState(() => _selectedCause = cause),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        margin: EdgeInsets.symmetric(vertical: 6),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.orange.withOpacity(0.2) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: isSelected ? Colors.orange : Colors.grey),
          boxShadow: isSelected
              ? [BoxShadow(color: Colors.orange.withOpacity(0.3), blurRadius: 8, spreadRadius: 1, offset: Offset(0, 4))]
              : [],
        ),
        child: Row(
          children: [
            Icon(Icons.favorite, color: isSelected ? Colors.orange : Colors.grey),
            SizedBox(width: 10),
            Expanded(child: Text(cause, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500))),
          ],
        ),
      ),
    );
  }
}
