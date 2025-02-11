import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class NGORegistrationScreen extends StatefulWidget {
  @override
  _NGORegistrationScreenState createState() => _NGORegistrationScreenState();
}

class _NGORegistrationScreenState extends State<NGORegistrationScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _ngoNameController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String? _documentUrl;
  String? _logoUrl;

  Future<void> _uploadFile(bool isLogo) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      PlatformFile file = result.files.first;
      Reference storageRef = FirebaseStorage.instance.ref().child('ngos/${file.name}');
      UploadTask uploadTask = storageRef.putData(file.bytes!);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      setState(() {
        if (isLogo) _logoUrl = downloadUrl;
        else _documentUrl = downloadUrl;
      });
    }
  }

  Future<void> _registerNGO() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      await FirebaseFirestore.instance.collection('ngos').doc(userCredential.user!.uid).set({
        'ngoName': _ngoNameController.text.trim(),
        'email': _emailController.text.trim(),
        'role': _roleController.text.trim(),
        'description': _descriptionController.text.trim(),
        'logo': _logoUrl,
        'document': _documentUrl,
        'status': 'pending', // Pending verification by Admin
        'createdAt': DateTime.now(),
      });

      Navigator.pop(context);
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("NGO Registration")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(controller: _ngoNameController, decoration: InputDecoration(labelText: "NGO Name")),
            TextField(controller: _emailController, decoration: InputDecoration(labelText: "Email")),
            TextField(controller: _passwordController, decoration: InputDecoration(labelText: "Password"), obscureText: true),
            TextField(controller: _roleController, decoration: InputDecoration(labelText: "Your Role (CEO/Director)")),
            TextField(controller: _descriptionController, decoration: InputDecoration(labelText: "NGO Description (Optional)")),
            ElevatedButton(onPressed: () => _uploadFile(true), child: Text("Upload Logo")),
            ElevatedButton(onPressed: () => _uploadFile(false), child: Text("Upload Official Document")),
            ElevatedButton(onPressed: _registerNGO, child: Text("Register")),
          ],
        ),
      ),
    );
  }
}
