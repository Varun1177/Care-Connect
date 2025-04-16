import 'package:flutter/material.dart';
 
 class ReportScreen extends StatelessWidget {
   @override
   Widget build(BuildContext context) {
     return Scaffold(
       appBar: AppBar(title: const Text('Report Fraud & Complaints')),
       body: const Center(
         child: Text(
           '⚠️ Report NGO Frauds & Issues',
           style: TextStyle(fontSize: 20),
         ),
       ),
     );
   }
 }