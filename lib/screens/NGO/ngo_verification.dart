import 'package:flutter/material.dart';
import '../services/api_service.dart';

class NGOVerificationScreen extends StatefulWidget {
  const NGOVerificationScreen({Key? key}) : super(key: key);

  @override
  _NGOVerificationScreenState createState() => _NGOVerificationScreenState();
}

class _NGOVerificationScreenState extends State<NGOVerificationScreen> {
  List<dynamic> ngos = [];
  bool loading = false;

  @override
  void initState() {
    super.initState();
    loadNGOs();
  }

  void loadNGOs() async {
    setState(() {
      loading = true;
    });
    try {
      final fetchedNGOs = await ApiService.fetchNGOs();
      setState(() {
        ngos = fetchedNGOs;
      });
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching NGO data")),
      );
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("NGO Verification")),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ngos.isEmpty
              ? const Center(child: Text("No NGO data found"))
              : ListView.builder(
                  itemCount: ngos.length,
                  itemBuilder: (context, index) {
                    final ngo = ngos[index];
                    return ListTile(
                      title: Text(ngo['NGO Name']),
                      subtitle: Text(ngo['Address']),
                    );
                  },
                ),
    );
  }
}
