import 'package:flutter/material.dart';

class PendingApprovalScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Pending Approval")),
      body: Center(child: Text("Your NGO registration is under review.")),
    );
  }
}
