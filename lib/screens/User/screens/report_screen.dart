import 'package:flutter/material.dart';

class ReportScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Report Fraud & Complaints')),
      body: Center(
        child: Text(
          '⚠️ Report NGO Frauds & Issues',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
