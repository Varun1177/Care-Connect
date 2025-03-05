import 'package:flutter/material.dart';

class NgoDashboard extends StatelessWidget {
  const NgoDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('NGO Dashboard')), body: const Center(child: Text('Welcome, NGO Member!')));
  }
}
