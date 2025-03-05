import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:care__connect/screens/login_screen.dart';

class NGORegistrationScreen extends StatefulWidget {
  const NGORegistrationScreen({super.key});

  @override
  _NGORegistrationScreenState createState() => _NGORegistrationScreenState();
}

class _NGORegistrationScreenState extends State<NGORegistrationScreen> {
  final TextEditingController ngoNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController personNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController personRoleController = TextEditingController();
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  File? _logo;
  File? _document;
  String? selectedSector;

  List<String> sectors = [
    'Health',
    'Education',
    'Environment',
    'Animal Welfare',
    'Women Empowerment',
    'Child Welfare',
    'Disaster Relief',
    'Poverty Alleviation',
    'Elderly Care',
    'Human Rights',
    'Community Development',
    'Water and Sanitation',
    'HIV/AIDS Prevention',
    'Mental Health',
    'Legal Aid',
    'LGBTQ+ Rights',
    'Agriculture',
    'Refugee Support',
    'Cultural Preservation',
    'Disability Support',
    'Food Security',
    'Youth Empowerment',
    'Sports Development',
    'Technology for Good',
    'Employment and Skills Development'
  ];

  Future<void> _pickLogo() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _logo = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickDocument() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        _document = File(result.files.single.path!);
      });
    }
  }

  void registerNGO() {
    // Registration logic here
    print("NGO Registered Successfully!");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("NGO Registration")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Logo Upload Section
            Center(
              child: GestureDetector(
                onTap: _pickLogo,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: _logo != null ? FileImage(_logo!) : null,
                  child: _logo == null
                      ? const Icon(Icons.camera_alt, size: 40)
                      : null,
                ),
              ),
            ),
            const SizedBox(height: 15),

            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: personNameController,
                    decoration: const InputDecoration(
                        labelText: "Your Name", border: OutlineInputBorder()),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: personRoleController,
                    decoration: const InputDecoration(
                        labelText: "Your Role", border: OutlineInputBorder()),
                  ),
                )
              ],
            ),
            const SizedBox(height: 15),
            // Email
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                  labelText: "Email", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 15),
            // Password with Toggle
            TextField(
              controller: passwordController,
              obscureText: !isPasswordVisible,
              decoration: InputDecoration(
                labelText: "Password",
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(isPasswordVisible
                      ? Icons.visibility
                      : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      isPasswordVisible = !isPasswordVisible;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 15),
            // Confirm Password with Toggle
            TextField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Confirm Password",
                border:  OutlineInputBorder(),
              ),
            ),

            const SizedBox(
              height: 50,
            ),
            // NGO Name
            TextField(
              controller: ngoNameController,
              decoration: const InputDecoration(
                  labelText: "NGO Name", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 15),
            // Sector Dropdown with Search
            DropdownButtonFormField<String>(
              isExpanded: true,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: "Sector"),
              value: selectedSector,
              items: sectors.map((sector) {
                return DropdownMenuItem(value: sector, child: Text(sector));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedSector = value;
                });
              },
            ),
            const SizedBox(height: 15),

            TextField(
              controller: descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: "Description (Optional)",
                border: OutlineInputBorder(),
              ),
            ),
            // Document Upload
            ListTile(
              leading: const Icon(Icons.upload_file),
              title: const Text("Upload Registration Document"),
              onTap: _pickDocument,
              subtitle: _document != null
                  ? Text("${_document!.path.split('/').last}")
                  : null,
            ),
            const SizedBox(height: 20),
            // Register Button
            ElevatedButton(
              onPressed: registerNGO,
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50)),
              child: const Text("REGISTER", style: TextStyle(fontSize: 16)),
            ),
            const SizedBox(height: 15),
            // Login Redirect
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already have an account? "),
                GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen())),
                  child: const Text("Login here",
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
