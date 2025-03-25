import 'package:flutter/material.dart';
 
 class AlertsScreen extends StatelessWidget {
   @override
   Widget build(BuildContext context) {
     return Scaffold(
       appBar: AppBar(title: Text('Alerts')),
       body: Center(
         child: Text(
           '🔔 Get Notified for Donation Drives',
           style: TextStyle(fontSize: 20),
         ),
       ),
     );
   }
 }