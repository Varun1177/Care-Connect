// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';
// import 'package:file_picker/file_picker.dart';
// import 'package:care__connect/screens/login_screen.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'ngo_dashboard.dart';

// class NGORegistrationScreen extends StatefulWidget {
//   const NGORegistrationScreen({super.key});

//   @override
//   _NGORegistrationScreenState createState() => _NGORegistrationScreenState();
// }

// class _NGORegistrationScreenState extends State<NGORegistrationScreen> {
//   final TextEditingController ngoNameController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final TextEditingController confirmPasswordController =
//       TextEditingController();
//   final TextEditingController personNameController = TextEditingController();
//   final TextEditingController descriptionController = TextEditingController();
//   final TextEditingController personRoleController = TextEditingController();
//   bool isPasswordVisible = false;
//   bool isConfirmPasswordVisible = false;
//   File? _logo;
//   File? _document;
//   String? selectedSector;

//   List<String> sectors = [
//     'Health',
//     'Education',
//     'Environment',
//     'Animal Welfare',
//     'Women Empowerment',
//     'Child Welfare',
//     'Disaster Relief',
//     'Poverty Alleviation',
//     'Elderly Care',
//     'Human Rights',
//     'Community Development',
//     'Water and Sanitation',
//     'HIV/AIDS Prevention',
//     'Mental Health',
//     'Legal Aid',
//     'LGBTQ+ Rights',
//     'Agriculture',
//     'Refugee Support',
//     'Cultural Preservation',
//     'Disability Support',
//     'Food Security',
//     'Youth Empowerment',
//     'Sports Development',
//     'Technology for Good',
//     'Employment and Skills Development'
//   ];

//   Future<void> _pickLogo() async {
//     final pickedFile =
//         await ImagePicker().pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       setState(() {
//         _logo = File(pickedFile.path);
//       });
//     }
//   }

//   Future<void> _pickDocument() async {
//     final result = await FilePicker.platform.pickFiles();
//     if (result != null) {
//       setState(() {
//         _document = File(result.files.single.path!);
//       });
//     }
//   }

//   void registerNGO() async {
//     if (_document == null || _logo == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please upload both logo and document")),
//       );
//       return;
//     }

//     try {
//       String ngoId =
//           FirebaseFirestore.instance.collection('pending_approvals').doc().id;

//       // Upload Logo
//       String logoPath = 'ngos/$ngoId/logo.jpg';
//       String logoUrl = await uploadFile(_logo!, logoPath);

//       // Upload Document
//       String docPath = 'ngos/$ngoId/document.pdf';
//       String docUrl = await uploadFile(_document!, docPath);

//       // Save in Firestore (pending approval)
//       await FirebaseFirestore.instance
//           .collection('pending_approvals')
//           .doc(ngoId)
//           .set({
//         'ngoId': ngoId,
//         'name': ngoNameController.text,
//         'email': emailController.text,
//         'sector': selectedSector,
//         'description': descriptionController.text,
//         'personName': personNameController.text,
//         'personRole': personRoleController.text,
//         'logoUrl': logoUrl,
//         'documentUrl': docUrl,
//         'submittedAt': Timestamp.now(),
//         'status': 'pending',
//       });

//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => NGODashboard()),
//       );

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Registration submitted for approval")),
//       );
//     } catch (e) {
//       print("Error: $e");
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Error submitting registration")),
//       );
//     }
//   }

//   Future<String> uploadFile(File file, String path) async {
//     final ref = FirebaseStorage.instance.ref().child(path);
//     await ref.putFile(file);
//     return await ref.getDownloadURL();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("NGO Registration")),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Logo Upload Section
//             Center(
//               child: GestureDetector(
//                 onTap: _pickLogo,
//                 child: CircleAvatar(
//                   radius: 50,
//                   backgroundImage: _logo != null ? FileImage(_logo!) : null,
//                   child: _logo == null
//                       ? const Icon(Icons.camera_alt, size: 40)
//                       : null,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 15),

//             Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: personNameController,
//                     decoration: const InputDecoration(
//                         labelText: "Your Name", border: OutlineInputBorder()),
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 Expanded(
//                   child: TextField(
//                     controller: personRoleController,
//                     decoration: const InputDecoration(
//                         labelText: "Your Role", border: OutlineInputBorder()),
//                   ),
//                 )
//               ],
//             ),
//             const SizedBox(height: 15),
//             // Email
//             TextField(
//               controller: emailController,
//               decoration: const InputDecoration(
//                   labelText: "Email", border: OutlineInputBorder()),
//             ),
//             const SizedBox(height: 15),
//             // Password with Toggle
//             TextField(
//               controller: passwordController,
//               obscureText: !isPasswordVisible,
//               decoration: InputDecoration(
//                 labelText: "Password",
//                 border: const OutlineInputBorder(),
//                 suffixIcon: IconButton(
//                   icon: Icon(isPasswordVisible
//                       ? Icons.visibility
//                       : Icons.visibility_off),
//                   onPressed: () {
//                     setState(() {
//                       isPasswordVisible = !isPasswordVisible;
//                     });
//                   },
//                 ),
//               ),
//             ),
//             const SizedBox(height: 15),
//             // Confirm Password with Toggle
//             TextField(
//               controller: confirmPasswordController,
//               obscureText: true,
//               decoration: const InputDecoration(
//                 labelText: "Confirm Password",
//                 border: OutlineInputBorder(),
//               ),
//             ),

//             const SizedBox(
//               height: 50,
//             ),
//             // NGO Name
//             TextField(
//               controller: ngoNameController,
//               decoration: const InputDecoration(
//                   labelText: "NGO Name", border: OutlineInputBorder()),
//             ),
//             const SizedBox(height: 15),
//             // Sector Dropdown with Search
//             DropdownButtonFormField<String>(
//               isExpanded: true,
//               decoration: const InputDecoration(
//                   border: OutlineInputBorder(), labelText: "Sector"),
//               value: selectedSector,
//               items: sectors.map((sector) {
//                 return DropdownMenuItem(value: sector, child: Text(sector));
//               }).toList(),
//               onChanged: (value) {
//                 setState(() {
//                   selectedSector = value;
//                 });
//               },
//             ),
//             const SizedBox(height: 15),

//             TextField(
//               controller: descriptionController,
//               maxLines: 3,
//               decoration: const InputDecoration(
//                 labelText: "Description (Optional)",
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             // Document Upload
//             ListTile(
//               leading: const Icon(Icons.upload_file),
//               title: const Text("Upload Registration Document"),
//               onTap: _pickDocument,
//               subtitle: _document != null
//                   ? Text("${_document!.path.split('/').last}")
//                   : null,
//             ),
//             const SizedBox(height: 20),
//             // Register Button
//             ElevatedButton(
//               onPressed: registerNGO,
//               style: ElevatedButton.styleFrom(
//                   minimumSize: const Size(double.infinity, 50)),
//               child: const Text("REGISTER", style: TextStyle(fontSize: 16)),
//             ),
//             const SizedBox(height: 15),
//             // Login Redirect
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const Text("Already have an account? "),
//                 GestureDetector(
//                   onTap: () => Navigator.push(context,
//                       MaterialPageRoute(builder: (context) => LoginScreen())),
//                   child: const Text("Login here",
//                       style: TextStyle(
//                           color: Colors.blue, fontWeight: FontWeight.bold)),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';
// import 'package:file_picker/file_picker.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'ngo_dashboard.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class NGORegistrationScreen extends StatefulWidget {
//   const NGORegistrationScreen({super.key});

//   @override
//   _NGORegistrationScreenState createState() => _NGORegistrationScreenState();
// }

// class _NGORegistrationScreenState extends State<NGORegistrationScreen> {
//   final TextEditingController ngoNameController = TextEditingController();
//   final TextEditingController cityController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController personNameController = TextEditingController();
//   final TextEditingController personRoleController = TextEditingController();
//   final TextEditingController descriptionController = TextEditingController();
//   final TextEditingController accountNumberController = TextEditingController();
//   final TextEditingController ifscController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final TextEditingController confirmPasswordController =
//       TextEditingController();

//   File? _logo;
//   File? _document;
//   String? selectedSector;
//   bool isLoading = false;
//   bool isPasswordVisible = true;
//   bool isConfirmPasswordVisible = true;

//   List<String> donationTypes = ['Money', 'Clothes', 'Books', 'Food'];
//   List<String> selectedDonations = [];

//   List<String> sectors = [
//     'Health',
//     'Education',
//     'Environment',
//     'Animal Welfare',
//     'Women Empowerment',
//     'Child Welfare',
//     'Disaster Relief',
//     'Poverty Alleviation',
//     'Elderly Care'
//   ];

//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   void signUp() async {
//     if (passwordController.text != confirmPasswordController.text) {
//       ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Passwords do not match!")));
//       return;
//     }

//     setState(() {
//       isLoading = true;
//     });

//     try {
//       UserCredential userCredential =
//           await _auth.createUserWithEmailAndPassword(
//         email: emailController.text.trim(),
//         password: passwordController.text.trim(),
//       );

//       // Store user info in Firestore
//       await _firestore.collection('users').doc(userCredential.user!.uid).set({
//         'uid': userCredential.user!.uid,
//         'email': emailController.text.trim(),
//         'role': 'ngo',
//       });

//       // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Account created successfully!")));
//       // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
//     } on FirebaseAuthException catch (e) {
//       String errorMessage = "Signup failed!";
//       if (e.code == 'email-already-in-use') {
//         errorMessage = "Email already in use!";
//       } else if (e.code == 'weak-password') {
//         errorMessage = "Password is too weak!";
//       }
//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text(errorMessage)));
//     }

//     setState(() {
//       isLoading = false;
//     });
//   }

//   Future<void> _pickLogo() async {
//     final pickedFile =
//         await ImagePicker().pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       setState(() {
//         _logo = File(pickedFile.path);
//       });
//     }
//   }

//   Future<void> _pickDocument() async {
//     final result = await FilePicker.platform.pickFiles();
//     if (result != null) {
//       setState(() {
//         _document = File(result.files.single.path!);
//       });
//     }
//   }

//   void registerNGO() async {
//     if (_document == null || _logo == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please upload both logo and document")),
//       );
//       return;
//     }

//     try {
//       String ngoId =
//           FirebaseFirestore.instance.collection('pending_approvals').doc().id;

//       // Upload Logo
//       String logoPath = 'ngos/$ngoId/logo.jpg';
//       String logoUrl = await uploadFile(_logo!, logoPath);

//       // Upload Document
//       String docPath = 'ngos/$ngoId/document.pdf';
//       String docUrl = await uploadFile(_document!, docPath);

//       await FirebaseFirestore.instance
//           .collection('pending_approvals')
//           .doc(ngoId)
//           .set({
//         'ngoId': ngoId,
//         'name': ngoNameController.text,
//         'city': cityController.text,
//         'email': emailController.text,
//         'sector': selectedSector,
//         'description': descriptionController.text,
//         'personName': personNameController.text,
//         'personRole': personRoleController.text,
//         'acceptedDonations': selectedDonations,
//         'logoUrl': logoUrl,
//         'documentUrl': docUrl,
//         'bankAccount': accountNumberController.text,
//         'ifscCode': ifscController.text,
//         'submittedAt': Timestamp.now(),
//         'status': 'pending',
//       });

//       signUp();

//       Navigator.pushReplacement(
//           context, MaterialPageRoute(builder: (context) => NGODashboard()));

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Registration submitted for approval")),
//       );
//     } catch (e) {
//       print("Error: $e");
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Error submitting registration")),
//       );
//     }
//   }

//   Future<String> uploadFile(File file, String path) async {
//     final ref = FirebaseStorage.instance.ref().child(path);
//     await ref.putFile(file);
//     return await ref.getDownloadURL();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("NGO Registration")),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Logo Upload Section
//             Center(
//               child: GestureDetector(
//                 onTap: _pickLogo,
//                 child: CircleAvatar(
//                   radius: 50,
//                   backgroundImage: _logo != null ? FileImage(_logo!) : null,
//                   child: _logo == null
//                       ? const Icon(Icons.camera_alt, size: 40)
//                       : null,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 15),

//             // Upload Document Button
//             Center(
//               child: ElevatedButton(
//                 onPressed: _pickDocument,
//                 child: const Text("Upload Document"),
//               ),
//             ),
//             if (_document != null)
//               Padding(
//                 padding: const EdgeInsets.only(top: 8.0),
//                 child: Text(
//                   "Document: ${_document!.path.split('/').last}",
//                   style: const TextStyle(
//                       fontWeight: FontWeight.bold, color: Colors.green),
//                 ),
//               ),
//             const SizedBox(height: 15),

//             // Personal Information
//             Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: personNameController,
//                     decoration: const InputDecoration(
//                         labelText: "Your Name", border: OutlineInputBorder()),
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 Expanded(
//                   child: TextField(
//                     controller: personRoleController,
//                     decoration: const InputDecoration(
//                         labelText: "Your Role", border: OutlineInputBorder()),
//                   ),
//                 )
//               ],
//             ),
//             const SizedBox(height: 15),

//             // City Input Field
//             TextField(
//               controller: cityController,
//               decoration: const InputDecoration(
//                   labelText: "City", border: OutlineInputBorder()),
//             ),
//             const SizedBox(height: 15),

//             // Email
//             TextField(
//               controller: emailController,
//               decoration: const InputDecoration(
//                   labelText: "Email", border: OutlineInputBorder()),
//             ),
//             const SizedBox(height: 15),

//             TextField(
//               controller: passwordController,
//               obscureText: isPasswordVisible,
//               decoration: InputDecoration(
//                 labelText: "Password",
//                 border: const OutlineInputBorder(),
//                 suffixIcon: IconButton(
//                     icon: Icon(isPasswordVisible
//                         ? Icons.visibility
//                         : Icons.visibility_off),
//                     onPressed: () {
//                       setState(() {
//                         isPasswordVisible = !isPasswordVisible;
//                       });
//                     }),
//               ),
//             ),
//             const SizedBox(height: 15),

//             TextField(
//               controller: confirmPasswordController,
//               obscureText: isConfirmPasswordVisible,
//               decoration: InputDecoration(
//                 labelText: "confirm Password",
//                 border: const OutlineInputBorder(),
//                 suffixIcon: IconButton(
//                     icon: Icon(isConfirmPasswordVisible
//                         ? Icons.visibility
//                         : Icons.visibility_off),
//                     onPressed: () {
//                       setState(() {
//                         isConfirmPasswordVisible = !isConfirmPasswordVisible;
//                       });
//                     }),
//               ),
//             ),
//             const SizedBox(height: 15),

//             // NGO Name
//             TextField(
//               controller: ngoNameController,
//               decoration: const InputDecoration(
//                   labelText: "NGO Name", border: OutlineInputBorder()),
//             ),
//             const SizedBox(height: 15),

//             // Sector Dropdown
//             DropdownButtonFormField<String>(
//               isExpanded: true,
//               decoration: const InputDecoration(
//                   border: OutlineInputBorder(), labelText: "Sector"),
//               value: selectedSector,
//               items: sectors
//                   .map((sector) =>
//                       DropdownMenuItem(value: sector, child: Text(sector)))
//                   .toList(),
//               onChanged: (value) => setState(() => selectedSector = value),
//             ),
//             const SizedBox(height: 15),

//             TextField(
//               controller: descriptionController,
//               maxLines: 3,
//               decoration: const InputDecoration(
//                 labelText: "Description (Optional)",
//                 border: OutlineInputBorder(),
//               ),
//             ),

//             const SizedBox(height: 15),

//             // Donation Type Selection
//             const Text("Accepted Donations:",
//                 style: TextStyle(fontWeight: FontWeight.bold)),
//             Wrap(
//               children: donationTypes.map((type) {
//                 return Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Checkbox(
//                       value: selectedDonations.contains(type),
//                       onChanged: (bool? value) {
//                         setState(() {
//                           value == true
//                               ? selectedDonations.add(type)
//                               : selectedDonations.remove(type);
//                         });
//                       },
//                     ),
//                     Text(type),
//                   ],
//                 );
//               }).toList(),
//             ),
//             const SizedBox(height: 15),

//             // Register Button
//             Center(
//               child: ElevatedButton(
//                 onPressed: registerNGO,
//                 child: const Text("REGISTER"),
//                 style: ButtonStyle(
//                   minimumSize: MaterialStateProperty.all(
//                       const Size(double.infinity, 50)),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';
// import 'package:file_picker/file_picker.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'ngo_dashboard.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class NGORegistrationScreen extends StatefulWidget {
//   const NGORegistrationScreen({super.key});

//   @override
//   _NGORegistrationScreenState createState() => _NGORegistrationScreenState();
// }

// class _NGORegistrationScreenState extends State<NGORegistrationScreen> {
//   final TextEditingController ngoNameController = TextEditingController();
//   final TextEditingController cityController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController personNameController = TextEditingController();
//   final TextEditingController personRoleController = TextEditingController();
//   final TextEditingController descriptionController = TextEditingController();
//   final TextEditingController accountNumberController = TextEditingController();
//   final TextEditingController ifscController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final TextEditingController confirmPasswordController = TextEditingController();

//   File? _logo;
//   File? _document;
//   String? selectedSector;
//   bool isLoading = false;
//   bool isPasswordVisible = true;
//   bool isConfirmPasswordVisible = true;

//   // Track form steps
//   int _currentStep = 0;

//   List<String> donationTypes = ['Money', 'Clothes', 'Books', 'Food'];
//   List<String> selectedDonations = [];

//   List<String> sectors = [
//     'Health',
//     'Education',
//     'Environment',
//     'Animal Welfare',
//     'Women Empowerment',
//     'Child Welfare',
//     'Disaster Relief',
//     'Poverty Alleviation',
//     'Elderly Care'
//   ];

//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   void signUp() async {
//     if (passwordController.text != confirmPasswordController.text) {
//       ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Passwords do not match!")));
//       return;
//     }

//     setState(() {
//       isLoading = true;
//     });

//     try {
//       UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
//         email: emailController.text.trim(),
//         password: passwordController.text.trim(),
//       );

//       // Store user info in Firestore
//       await _firestore.collection('users').doc(userCredential.user!.uid).set({
//         'uid': userCredential.user!.uid,
//         'email': emailController.text.trim(),
//         'role': 'ngo',
//       });
//     } on FirebaseAuthException catch (e) {
//       String errorMessage = "Signup failed!";
//       if (e.code == 'email-already-in-use') {
//         errorMessage = "Email already in use!";
//       } else if (e.code == 'weak-password') {
//         errorMessage = "Password is too weak!";
//       }
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage)));
//     }

//     setState(() {
//       isLoading = false;
//     });
//   }

//   Future<void> _pickLogo() async {
//     final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       setState(() {
//         _logo = File(pickedFile.path);
//       });
//     }
//   }

//   Future<void> _pickDocument() async {
//     final result = await FilePicker.platform.pickFiles();
//     if (result != null) {
//       setState(() {
//         _document = File(result.files.single.path!);
//       });
//     }
//   }

//   void registerNGO() async {
//     if (_document == null || _logo == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text("Please upload both logo and document"),
//           backgroundColor: Colors.red,
//         ),
//       );
//       return;
//     }

//     setState(() {
//       isLoading = true;
//     });

//     try {
//       String ngoId = FirebaseFirestore.instance.collection('pending_approvals').doc().id;

//       // Upload Logo
//       String logoPath = 'ngos/$ngoId/logo.jpg';
//       String logoUrl = await uploadFile(_logo!, logoPath);

//       // Upload Document
//       String docPath = 'ngos/$ngoId/document.pdf';
//       String docUrl = await uploadFile(_document!, docPath);

//       await FirebaseFirestore.instance.collection('pending_approvals').doc(ngoId).set({
//         'ngoId': ngoId,
//         'name': ngoNameController.text,
//         'city': cityController.text,
//         'email': emailController.text,
//         'sector': selectedSector,
//         'description': descriptionController.text,
//         'personName': personNameController.text,
//         'personRole': personRoleController.text,
//         'acceptedDonations': selectedDonations,
//         'logoUrl': logoUrl,
//         'documentUrl': docUrl,
//         'bankAccount': accountNumberController.text,
//         'ifscCode': ifscController.text,
//         'submittedAt': Timestamp.now(),
//         'status': 'pending',
//       });

//       signUp();

//       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NGODashboard()));

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text("Registration submitted for approval"),
//           backgroundColor: Colors.green,
//         ),
//       );
//     } catch (e) {
//       print("Error: $e");
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text("Error submitting registration"),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }

//     setState(() {
//       isLoading = false;
//     });
//   }

//   Future<String> uploadFile(File file, String path) async {
//     final ref = FirebaseStorage.instance.ref().child(path);
//     await ref.putFile(file);
//     return await ref.getDownloadURL();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("NGO Registration"),
//         elevation: 0,
//         backgroundColor: Theme.of(context).primaryColor,
//         foregroundColor: Colors.white,
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : Theme(
//               data: Theme.of(context).copyWith(
//                 colorScheme: ColorScheme.light(
//                   primary: Theme.of(context).primaryColor,
//                   onSurface: Colors.black87,
//                 ),
//               ),
//               child: Stepper(
//                 type: StepperType.horizontal,
//                 currentStep: _currentStep,
//                 onStepContinue: () {
//                   if (_currentStep == 2) {
//                     registerNGO();
//                   } else {
//                     setState(() {
//                       _currentStep += 1;
//                     });
//                   }
//                 },
//                 onStepCancel: () {
//                   if (_currentStep > 0) {
//                     setState(() {
//                       _currentStep -= 1;
//                     });
//                   }
//                 },
//                 controlsBuilder: (context, details) {
//                   return Padding(
//                     padding: const EdgeInsets.only(top: 20.0),
//                     child: Row(
//                       children: [
//                         Expanded(
//                           child: ElevatedButton(
//                             onPressed: details.onStepContinue,
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Theme.of(context).primaryColor,
//                               foregroundColor: Colors.white,
//                               padding: const EdgeInsets.symmetric(vertical: 12),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                             ),
//                             child: Text(_currentStep == 2 ? "SUBMIT" : "CONTINUE"),
//                           ),
//                         ),
//                         if (_currentStep > 0) ...[
//                           const SizedBox(width: 12),
//                           Expanded(
//                             child: OutlinedButton(
//                               onPressed: details.onStepCancel,
//                               style: OutlinedButton.styleFrom(
//                                 padding: const EdgeInsets.symmetric(vertical: 12),
//                                 side: BorderSide(color: Theme.of(context).primaryColor),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(8),
//                                 ),
//                               ),
//                               child: const Text("BACK"),
//                             ),
//                           ),
//                         ],
//                       ],
//                     ),
//                   );
//                 },
//                 steps: [
//                   // Step 1: Personal Information
//                   Step(
//                     isActive: _currentStep >= 0,
//                     title: const Text("Personal"),
//                     content: Column(
//                       children: [
//                         // Logo Upload Section with animation
//                         Center(
//                           child: Stack(
//                             children: [
//                               Container(
//                                 decoration: BoxDecoration(
//                                   color: Colors.grey.shade200,
//                                   shape: BoxShape.circle,
//                                   boxShadow: [
//                                     BoxShadow(
//                                       color: Colors.black.withOpacity(0.1),
//                                       spreadRadius: 2,
//                                       blurRadius: 5,
//                                     ),
//                                   ],
//                                 ),
//                                 child: CircleAvatar(
//                                   radius: 60,
//                                   backgroundColor: Colors.grey.shade100,
//                                   backgroundImage: _logo != null ? FileImage(_logo!) : null,
//                                   child: _logo == null
//                                       ? Icon(Icons.camera_alt, size: 40, color: Theme.of(context).primaryColor)
//                                       : null,
//                                 ),
//                               ),
//                               Positioned(
//                                 bottom: 0,
//                                 right: 0,
//                                 child: InkWell(
//                                   onTap: _pickLogo,
//                                   child: Container(
//                                     padding: const EdgeInsets.all(8),
//                                     decoration: BoxDecoration(
//                                       color: Theme.of(context).primaryColor,
//                                       shape: BoxShape.circle,
//                                     ),
//                                     child: const Icon(Icons.add_a_photo, color: Colors.white, size: 20),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         Text(
//                           "Upload NGO Logo",
//                           style: TextStyle(color: Colors.grey.shade600),
//                         ),
//                         const SizedBox(height: 24),

//                         // Email and Password
//                         _buildTextField(
//                           controller: emailController,
//                           label: "Email Address",
//                           prefixIcon: Icons.email_outlined,
//                           keyboardType: TextInputType.emailAddress,
//                         ),
//                         const SizedBox(height: 16),

//                         _buildTextField(
//                           controller: passwordController,
//                           label: "Password",
//                           prefixIcon: Icons.lock_outline,
//                           isPassword: true,
//                           isVisible: isPasswordVisible,
//                           toggleVisibility: () {
//                             setState(() {
//                               isPasswordVisible = !isPasswordVisible;
//                             });
//                           },
//                         ),
//                         const SizedBox(height: 16),

//                         _buildTextField(
//                           controller: confirmPasswordController,
//                           label: "Confirm Password",
//                           prefixIcon: Icons.lock_outline,
//                           isPassword: true,
//                           isVisible: isConfirmPasswordVisible,
//                           toggleVisibility: () {
//                             setState(() {
//                               isConfirmPasswordVisible = !isConfirmPasswordVisible;
//                             });
//                           },
//                         ),
//                         const SizedBox(height: 16),
//                       ],
//                     ),
//                   ),

//                   // Step 2: NGO Information
//                   Step(
//                     isActive: _currentStep >= 1,
//                     title: const Text("NGO Info"),
//                     content: Column(
//                       children: [
//                         _buildTextField(
//                           controller: ngoNameController,
//                           label: "NGO Name",
//                           prefixIcon: Icons.business,
//                         ),
//                         const SizedBox(height: 16),

//                         _buildTextField(
//                           controller: cityController,
//                           label: "City",
//                           prefixIcon: Icons.location_city,
//                         ),
//                         const SizedBox(height: 16),

//                         // Sector Dropdown
//                         Container(
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(8),
//                             border: Border.all(color: Colors.grey.shade400),
//                           ),
//                           child: Padding(
//                             padding: const EdgeInsets.symmetric(horizontal: 12),
//                             child: DropdownButtonHideUnderline(
//                               child: DropdownButtonFormField<String>(
//                                 decoration: InputDecoration(
//                                   prefixIcon: Icon(Icons.category_outlined, color: Theme.of(context).primaryColor),
//                                   border: InputBorder.none,
//                                   labelText: "Sector",
//                                 ),
//                                 value: selectedSector,
//                                 isExpanded: true,
//                                 items: sectors.map((sector) =>
//                                   DropdownMenuItem(value: sector, child: Text(sector))
//                                 ).toList(),
//                                 onChanged: (value) => setState(() => selectedSector = value),
//                               ),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 16),

//                         _buildTextField(
//                           controller: descriptionController,
//                           label: "Description",
//                           prefixIcon: Icons.description_outlined,
//                           maxLines: 3,
//                         ),
//                         const SizedBox(height: 16),
//                       ],
//                     ),
//                   ),

//                   // Step 3: Additional Details
//                   Step(
//                     isActive: _currentStep >= 2,
//                     title: const Text("Details"),
//                     content: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           children: [
//                             Expanded(
//                               child: _buildTextField(
//                                 controller: personNameController,
//                                 label: "Your Name",
//                                 prefixIcon: Icons.person_outline,
//                               ),
//                             ),
//                             const SizedBox(width: 16),
//                             Expanded(
//                               child: _buildTextField(
//                                 controller: personRoleController,
//                                 label: "Your Role",
//                                 prefixIcon: Icons.work_outline,
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 16),

//                         _buildTextField(
//                           controller: accountNumberController,
//                           label: "Bank Account Number",
//                           prefixIcon: Icons.account_balance,
//                           keyboardType: TextInputType.number,
//                         ),
//                         const SizedBox(height: 16),

//                         _buildTextField(
//                           controller: ifscController,
//                           label: "IFSC Code",
//                           prefixIcon: Icons.confirmation_number_outlined,
//                         ),
//                         const SizedBox(height: 24),

//                         // Document upload
//                         InkWell(
//                           onTap: _pickDocument,
//                           child: Container(
//                             width: double.infinity,
//                             padding: const EdgeInsets.symmetric(vertical: 16),
//                             decoration: BoxDecoration(
//                               border: Border.all(color: Colors.grey.shade400),
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             child: Column(
//                               children: [
//                                 Icon(
//                                   _document != null ? Icons.check_circle : Icons.upload_file,
//                                   size: 40,
//                                   color: _document != null ? Colors.green : Theme.of(context).primaryColor,
//                                 ),
//                                 const SizedBox(height: 8),
//                                 Text(
//                                   _document != null
//                                       ? "Document uploaded: ${_document!.path.split('/').last}"
//                                       : "Upload Registration Document",
//                                   style: TextStyle(
//                                     color: _document != null ? Colors.green : Colors.grey.shade700,
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 24),

//                         // Donation Type Selection
//                         Text(
//                           "Accepted Donations",
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 16,
//                             color: Theme.of(context).primaryColor,
//                           ),
//                         ),
//                         const SizedBox(height: 8),

//                         Wrap(
//                           spacing: 4,
//                           runSpacing: 0,
//                           children: donationTypes.map((type) {
//                             final isSelected = selectedDonations.contains(type);
//                             return FilterChip(
//                               label: Text(type),
//                               selected: isSelected,
//                               onSelected: (bool selected) {
//                                 setState(() {
//                                   selected
//                                       ? selectedDonations.add(type)
//                                       : selectedDonations.remove(type);
//                                 });
//                               },
//                               selectedColor: Theme.of(context).primaryColor.withOpacity(0.15),
//                               checkmarkColor: Theme.of(context).primaryColor,
//                               backgroundColor: Colors.grey.shade100,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(16),
//                                 side: BorderSide(
//                                   color: isSelected
//                                       ? Theme.of(context).primaryColor
//                                       : Colors.grey.shade400,
//                                 ),
//                               ),
//                             );
//                           }).toList(),
//                         ),
//                         const SizedBox(height: 16),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//     );
//   }

//   Widget _buildTextField({
//     required TextEditingController controller,
//     required String label,
//     required IconData prefixIcon,
//     bool isPassword = false,
//     bool? isVisible,
//     Function()? toggleVisibility,
//     int maxLines = 1,
//     TextInputType keyboardType = TextInputType.text,
//   }) {
//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(color: Colors.grey.shade400),
//       ),
//       child: TextField(
//         controller: controller,
//         obscureText: isPassword ? (isVisible ?? false) : false,
//         maxLines: maxLines,
//         keyboardType: keyboardType,
//         decoration: InputDecoration(
//           contentPadding: const EdgeInsets.symmetric(vertical: 16),
//           border: InputBorder.none,
//           labelText: label,
//           prefixIcon: Icon(prefixIcon, color: Theme.of(context).primaryColor),
//           suffixIcon: isPassword
//               ? IconButton(
//                   icon: Icon(
//                     isVisible! ? Icons.visibility : Icons.visibility_off,
//                     color: Colors.grey,
//                   ),
//                   onPressed: toggleVisibility,
//                 )
//               : null,
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';
// import 'package:file_picker/file_picker.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'ngo_dashboard.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'EmailVerificationCheckScreen.dart';

// class NGORegistrationScreen extends StatefulWidget {
//   const NGORegistrationScreen({super.key});

//   @override
//   _NGORegistrationScreenState createState() => _NGORegistrationScreenState();
// }

// class _NGORegistrationScreenState extends State<NGORegistrationScreen> with SingleTickerProviderStateMixin {
//   final TextEditingController ngoNameController = TextEditingController();
//   final TextEditingController cityController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController personNameController = TextEditingController();
//   final TextEditingController personRoleController = TextEditingController();
//   final TextEditingController descriptionController = TextEditingController();
//   final TextEditingController accountNumberController = TextEditingController();
//   final TextEditingController ifscController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final TextEditingController confirmPasswordController = TextEditingController();

//   File? _logo;
//   File? _document;
//   String? selectedSector;
//   bool isLoading = false;
//   bool isPasswordVisible = false;
//   bool isConfirmPasswordVisible = false;

//   // Track form steps
//   int _currentStep = 0;
//   late PageController _pageController;
//   late AnimationController _animationController;
//   late Animation<double> _fadeAnimation;

//   List<String> donationTypes = ['Money', 'Clothes', 'Books'];
//   List<String> selectedDonations = [];
//   List<String> members = [];

//   List<String> sectors = [
//     'Health',
//     'Education',
//     'Environment',
//     'Animal Welfare',
//     'Women Empowerment',
//     'Child Welfare',
//     'Disaster Relief',
//     'Poverty Alleviation',
//     'Elderly Care'
//   ];

//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   @override
//   void initState() {
//     super.initState();
//     _pageController = PageController();
//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 800),
//     );
//     _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(
//         parent: _animationController,
//         curve: Curves.easeIn,
//       ),
//     );
//     _animationController.forward();
//   }

//   @override
//   void dispose() {
//     _pageController.dispose();
//     _animationController.dispose();
//     ngoNameController.dispose();
//     cityController.dispose();
//     emailController.dispose();
//     personNameController.dispose();
//     personRoleController.dispose();
//     descriptionController.dispose();
//     accountNumberController.dispose();
//     ifscController.dispose();
//     passwordController.dispose();
//     confirmPasswordController.dispose();
//     super.dispose();
//   }

// Future<void> signUp() async {
//   if (passwordController.text != confirmPasswordController.text) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text("Passwords do not match")),
//     );
//     return;
//   }

//   setState(() {
//     isLoading = true;
//   });

//   try {
//     // Create the user
//     UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
//       email: emailController.text.trim(),
//       password: passwordController.text.trim(),
//     );

//     User? user = userCredential.user;

//     if (user != null) {
//       await user.updateDisplayName(personNameController.text.trim());
//       await user.reload();
//       user = _auth.currentUser;
//     }

//     // Send email verification
//     if (user != null && !user.emailVerified) {
//       await user.sendEmailVerification();

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text("A verification email has been sent. Please verify your email."),
//           backgroundColor: Colors.green,
//         ),
//       );

//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => EmailVerificationCheckScreen()),
//       );

//       return;
//     }

//     // Store user info in Firestore
//     await _firestore.collection('users').doc(user!.uid).set({
//       'uid': user.uid,
//       'email': emailController.text.trim(),
//       'role': 'ngo',
//     });

//   } on FirebaseAuthException catch (e) {
//     String errorMessage = "Signup failed!";
//     if (e.code == 'email-already-in-use') {
//       errorMessage = "Email already in use!";
//     } else if (e.code == 'weak-password') {
//       errorMessage = "Password is too weak!";
//     }

//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage)));
//   }

//   setState(() {
//     isLoading = false;
//   });
// }

//   Future<void> _pickLogo() async {
//     final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       setState(() {
//         _logo = File(pickedFile.path);
//       });
//     }
//   }

//   Future<void> _pickDocument() async {
//     final result = await FilePicker.platform.pickFiles();
//     if (result != null) {
//       setState(() {
//         _document = File(result.files.single.path!);
//       });
//     }
//   }

//   void registerNGO() async {
//     if (_document == null || _logo == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text("Please upload both logo and document"),
//           backgroundColor: Colors.red,
//         ),
//       );
//       return;
//     }

//     setState(() {
//       isLoading = true;
//     });

//     try {

//       try{
//         await signUp();
//       }
//       catch(e){
//         print("Error signing up: $e");
//         return;
//       }

//       print("User ID: ${FirebaseAuth.instance.currentUser!.uid}");
//       String ngoId = FirebaseAuth.instance.currentUser!.uid;

//       // Upload Logo
//       String logoPath = 'ngos/$ngoId/logo.jpg';
//       String logoUrl = await uploadFile(_logo!, logoPath);

//       // Upload Document
//       String docPath = 'ngos/$ngoId/document.pdf';
//       String docUrl = await uploadFile(_document!, docPath);

//       try{

//       await FirebaseFirestore.instance.collection('pending_approvals').doc(ngoId).set({
//         'ngoId': ngoId,
//         'name': ngoNameController.text,
//         'city': cityController.text,
//         'email': emailController.text,
//         'sector': selectedSector,
//         'description': descriptionController.text,
//         'personName': personNameController.text,
//         'personRole': personRoleController.text,
//         'acceptedDonations': selectedDonations,
//         'logoUrl': logoUrl,
//         'documentUrl': docUrl,
//         'bankAccount': accountNumberController.text,
//         'ifscCode': ifscController.text,
//         'submittedAt': Timestamp.now(),
//         'status': 'pending',
//         'members': members,
//       });

//       }
//       catch(e){
//         print("Error saving NGO data: $e");
//         return;
//       }
//             setState(() {
//       isLoading = true;
//     });

//       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NGODashboard()));

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text("Registration submitted for approval"),
//           backgroundColor: Colors.green,
//         ),
//       );
//     } catch (e) {
//       print("Error: $e");
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text("Error submitting registration"),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }

//     setState(() {
//       isLoading = false;
//     });
//   }

//   Future<String> uploadFile(File file, String path) async {
//     final ref = FirebaseStorage.instance.ref().child(path);
//     await ref.putFile(file);
//     return await ref.getDownloadURL();
//   }

//   void _nextStep() {
//     if (_currentStep < 2) {
//       setState(() {
//         _currentStep += 1;
//       });
//       _pageController.animateToPage(
//         _currentStep,
//         duration: const Duration(milliseconds: 400),
//         curve: Curves.easeInOut,
//       );
//     } else {
//       registerNGO();
//     }
//   }

//   void _previousStep() {
//     if (_currentStep > 0) {
//       setState(() {
//         _currentStep -= 1;
//       });
//       _pageController.animateToPage(
//         _currentStep,
//         duration: const Duration(milliseconds: 400),
//         curve: Curves.easeInOut,
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator(color: Color(0xFF00A86B)))
//           : Column(
//               children: [
//                 _buildHeader(),
//                 Expanded(
//                   child: FadeTransition(
//                     opacity: _fadeAnimation,
//                     child: PageView(
//                       controller: _pageController,
//                       physics: const NeverScrollableScrollPhysics(),
//                       children: [
//                         _buildPersonalInfoStep(),
//                         _buildNGOInfoStep(),
//                         _buildAdditionalDetailsStep(),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//     );
//   }

//   Widget _buildHeader() {
//     return Container(
//       height: MediaQuery.of(context).size.height * 0.25,
//       decoration: const BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [Color(0xFF00A86B), Color(0xFF009160)],
//         ),
//         borderRadius: BorderRadius.only(
//           bottomLeft: Radius.circular(30),
//           bottomRight: Radius.circular(30),
//         ),
//       ),
//       child: SafeArea(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const SizedBox(height: 10),
//             Row(
//               children: [
//                 IconButton(
//                   icon: const Icon(Icons.arrow_back, color: Colors.white),
//                   onPressed: () => Navigator.pop(context),
//                 ),
//                 const Text(
//                   'NGO Registration',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 20),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               child: Row(
//                 children: [
//                   _buildStepIndicator(0, "Personal"),
//                   _buildStepDivider(0),
//                   _buildStepIndicator(1, "NGO Info"),
//                   _buildStepDivider(1),
//                   _buildStepIndicator(2, "Details"),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildStepIndicator(int step, String label) {
//     final isActive = _currentStep >= step;
//     final isCurrent = _currentStep == step;

//     return Expanded(
//       child: Column(
//         children: [
//           Container(
//             width: 35,
//             height: 35,
//             decoration: BoxDecoration(
//               color: isActive ? Colors.white : Colors.white.withOpacity(0.3),
//               shape: BoxShape.circle,
//               border: isCurrent ? Border.all(color: Colors.white, width: 2) : null,
//             ),
//             child: Center(
//               child: Text(
//                 '${step + 1}',
//                 style: TextStyle(
//                   color: isActive ? const Color(0xFF00A86B) : Colors.white,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             label,
//             style: TextStyle(
//               color: Colors.white,
//               fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
//               fontSize: 12,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildStepDivider(int beforeStep) {
//     final isActive = _currentStep > beforeStep;

//     return Container(
//       width: 30,
//       height: 2,
//       color: isActive ? Colors.white : Colors.white.withOpacity(0.3),
//     );
//   }

//   Widget _buildPersonalInfoStep() {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
//       child: Column(
//         children: [
//           // Logo Upload Section with animation
//           Center(
//             child: Stack(
//               children: [
//                 Container(
//                   decoration: BoxDecoration(
//                     color: Colors.grey.shade100,
//                     shape: BoxShape.circle,
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.1),
//                         spreadRadius: 2,
//                         blurRadius: 5,
//                       ),
//                     ],
//                   ),
//                   child: CircleAvatar(
//                     radius: 60,
//                     backgroundColor: Colors.grey.shade100,
//                     backgroundImage: _logo != null ? FileImage(_logo!) : null,
//                     child: _logo == null
//                         ? const Icon(Icons.camera_alt, size: 40, color: Color(0xFF00A86B))
//                         : null,
//                   ),
//                 ),
//                 Positioned(
//                   bottom: 0,
//                   right: 0,
//                   child: InkWell(
//                     onTap: _pickLogo,
//                     child: Container(
//                       padding: const EdgeInsets.all(8),
//                       decoration: const BoxDecoration(
//                         color: Color(0xFF00A86B),
//                         shape: BoxShape.circle,
//                       ),
//                       child: const Icon(Icons.add_a_photo, color: Colors.white, size: 20),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             "Upload NGO Logo",
//             style: TextStyle(color: Colors.grey.shade600),
//           ),
//           const SizedBox(height: 24),

//           // Email and Password
//           _buildInputField(
//             controller: emailController,
//             label: "Email Address",
//             icon: Icons.email_outlined,
//             keyboardType: TextInputType.emailAddress,
//           ),
//           const SizedBox(height: 20),

//           _buildPasswordField(
//             controller: passwordController,
//             label: "Password",
//             obscureText: !isPasswordVisible,
//             toggleVisibility: () {
//               setState(() {
//                 isPasswordVisible = !isPasswordVisible;
//               });
//             },
//           ),
//           const SizedBox(height: 20),

//           _buildPasswordField(
//             controller: confirmPasswordController,
//             label: "Confirm Password",
//             obscureText: !isConfirmPasswordVisible,
//             toggleVisibility: () {
//               setState(() {
//                 isConfirmPasswordVisible = !isConfirmPasswordVisible;
//               });
//             },
//           ),
//           const SizedBox(height: 40),

//           _buildActionButton(
//             onPressed: _nextStep,
//             label: "CONTINUE",
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildNGOInfoStep() {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
//       child: Column(
//         children: [
//           _buildInputField(
//             controller: ngoNameController,
//             label: "NGO Name",
//             icon: Icons.business,
//           ),
//           const SizedBox(height: 20),

//           _buildInputField(
//             controller: cityController,
//             label: "City",
//             icon: Icons.location_city,
//           ),
//           const SizedBox(height: 20),

//           // Sector Dropdown
//           Container(
//             decoration: BoxDecoration(
//               color: Colors.grey.shade100,
//               borderRadius: BorderRadius.circular(15),
//             ),
//             child: DropdownButtonFormField<String>(
//               decoration: const InputDecoration(
//                 contentPadding: EdgeInsets.symmetric(vertical: 20),
//                 border: InputBorder.none,
//                 hintText: "Select Sector",
//                 hintStyle: TextStyle(color: Colors.grey),
//                 prefixIcon: Icon(
//                   Icons.category_outlined,
//                   color: Color(0xFF00A86B),
//                 ),
//               ),
//               value: selectedSector,
//               isExpanded: true,
//               icon: const Icon(Icons.arrow_drop_down),
//               iconSize: 24,
//               elevation: 16,
//               style: const TextStyle(color: Colors.black87, fontSize: 16),
//               dropdownColor: Colors.white,
//               items: sectors.map<DropdownMenuItem<String>>((String value) {
//                 return DropdownMenuItem<String>(
//                   value: value,
//                   child: Text(value),
//                 );
//               }).toList(),
//               onChanged: (String? newValue) {
//                 setState(() {
//                   selectedSector = newValue!;
//                 });
//               },
//             ),
//           ),
//           const SizedBox(height: 20),

//           Container(
//             decoration: BoxDecoration(
//               color: Colors.grey.shade100,
//               borderRadius: BorderRadius.circular(15),
//             ),
//             child: TextField(
//               controller: descriptionController,
//               maxLines: 4,
//               decoration: const InputDecoration(
//                 contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
//                 border: InputBorder.none,
//                 hintText: "Description",
//                 hintStyle: TextStyle(color: Colors.grey),
//                 prefixIcon: Icon(
//                   Icons.description_outlined,
//                   color: Color(0xFF00A86B),
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(height: 40),

//           Row(
//             children: [
//               Expanded(
//                 child: _buildActionButton(
//                   onPressed: _previousStep,
//                   label: "BACK",
//                   isPrimary: false,
//                 ),
//               ),
//               const SizedBox(width: 15),
//               Expanded(
//                 child: _buildActionButton(
//                   onPressed: _nextStep,
//                   label: "CONTINUE",
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildAdditionalDetailsStep() {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildInputField(
//             controller: personNameController,
//             label: "Your Name",
//             icon: Icons.person_outline,
//           ),
//           const SizedBox(height: 20),

//           _buildInputField(
//             controller: personRoleController,
//             label: "Your Role",
//             icon: Icons.work_outline,
//           ),
//           const SizedBox(height: 20),

//           _buildInputField(
//             controller: accountNumberController,
//             label: "Bank Account Number",
//             icon: Icons.account_balance,
//             keyboardType: TextInputType.number,
//           ),
//           const SizedBox(height: 20),

//           _buildInputField(
//             controller: ifscController,
//             label: "IFSC Code",
//             icon: Icons.confirmation_number_outlined,
//           ),
//           const SizedBox(height: 20),

//           // Document upload
//           InkWell(
//             onTap: _pickDocument,
//             child: Container(
//               width: double.infinity,
//               padding: const EdgeInsets.symmetric(vertical: 20),
//               decoration: BoxDecoration(
//                 color: Colors.grey.shade100,
//                 borderRadius: BorderRadius.circular(15),
//                 border: Border.all(
//                   color: _document != null ? const Color(0xFF00A86B) : Colors.transparent,
//                   width: 1,
//                 ),
//               ),
//               child: Column(
//                 children: [
//                   Icon(
//                     _document != null ? Icons.check_circle : Icons.upload_file,
//                     size: 40,
//                     color: _document != null ? const Color(0xFF00A86B) : Colors.grey.shade700,
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     _document != null
//                         ? "Document uploaded"
//                         : "Upload Registration Document",
//                     style: TextStyle(
//                       color: _document != null ? const Color(0xFF00A86B) : Colors.grey.shade700,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                   if (_document != null)
//                     Padding(
//                       padding: const EdgeInsets.only(top: 5),
//                       child: Text(
//                         _document!.path.split('/').last,
//                         style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ),
//                 ],
//               ),
//             ),
//           ),
//           const SizedBox(height: 24),

//           // Donation Type Selection
//           Text(
//             "Accepted Donations",
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: 16,
//               color: Colors.grey.shade800,
//             ),
//           ),
//           const SizedBox(height: 10),

//           Center(
//             child: Wrap(
//               spacing: 15,
//               runSpacing: 5,
//               children: donationTypes.map((type) {
//                 final isSelected = selectedDonations.contains(type);
//                 return FilterChip(
//                   label: Text(type),
//                   selected: isSelected,
//                   showCheckmark: false,
//                   onSelected: (bool selected) {
//                     setState(() {
//                       selected
//                           ? selectedDonations.add(type)
//                           : selectedDonations.remove(type);
//                     });
//                   },
//                   selectedColor: const Color(0xFF00A86B).withOpacity(0.2),
//                   backgroundColor: Colors.grey.shade100,
//                   labelStyle: TextStyle(
//                     color: isSelected ? const Color(0xFF00A86B) : Colors.grey.shade800,
//                     fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
//                   ),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(30),
//                     side: BorderSide(
//                       color: isSelected
//                           ? const Color(0xFF00A86B)
//                           : Colors.grey.shade400,
//                       width: 1.5,
//                     ),
//                   ),
//                   padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
//                 );
//               }).toList(),
//             ),
//           ),
//           const SizedBox(height:25),

//           Row(
//             children: [
//               Expanded(
//                 child: _buildActionButton(
//                   onPressed: _previousStep,
//                   label: "BACK",
//                   isPrimary: false,
//                 ),
//               ),
//               const SizedBox(width: 15),
//               Expanded(
//                 child: _buildActionButton(
//                   onPressed: _nextStep,
//                   label: "SUBMIT",
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildInputField({
//     required TextEditingController controller,
//     required String label,
//     required IconData icon,
//     TextInputType keyboardType = TextInputType.text,
//   }) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.grey.shade100,
//         borderRadius: BorderRadius.circular(15),
//       ),
//       child: TextField(
//         controller: controller,
//         keyboardType: keyboardType,
//         style: const TextStyle(fontSize: 16),
//         decoration: InputDecoration(
//           contentPadding: const EdgeInsets.symmetric(vertical: 20),
//           border: InputBorder.none,
//           hintText: label,
//           prefixIcon: Icon(
//             icon,
//             color: const Color(0xFF00A86B),
//           ),
//           hintStyle: TextStyle(color: Colors.grey.shade700),
//         ),
//       ),
//     );
//   }

//   Widget _buildPasswordField({
//     required TextEditingController controller,
//     required String label,
//     required bool obscureText,
//     required VoidCallback toggleVisibility,
//   }) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.grey.shade100,
//         borderRadius: BorderRadius.circular(15),
//       ),
//       child: TextField(
//         controller: controller,
//         obscureText: obscureText,
//         style: const TextStyle(fontSize: 16),
//         decoration: InputDecoration(
//           contentPadding: const EdgeInsets.symmetric(vertical: 20),
//           border: InputBorder.none,
//           hintText: label,
//           prefixIcon: const Icon(
//             Icons.lock_outline,
//             color: Color(0xFF00A86B),
//           ),
//           suffixIcon: IconButton(
//             icon: Icon(
//               obscureText ? Icons.visibility_off : Icons.visibility,
//               color: Colors.grey.shade700,
//             ),
//             onPressed: toggleVisibility,
//           ),
//           hintStyle: TextStyle(color: Colors.grey.shade700),
//         ),
//       ),
//     );
//   }

//   Widget _buildActionButton({
//     required VoidCallback onPressed,
//     required String label,
//     bool isPrimary = true,
//   }) {
//     return SizedBox(
//       height: 55,
//       child: isPrimary
//         ? ElevatedButton(
//             onPressed: onPressed,
//             style: ElevatedButton.styleFrom(
//               backgroundColor: const Color(0xFF00A86B),
//               foregroundColor: Colors.white,
//               elevation: 3,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(15),
//               ),
//             ),
//             child: Text(
//               label,
//               style: const TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           )
//         : OutlinedButton(
//             onPressed: onPressed,
//             style: OutlinedButton.styleFrom(
//               foregroundColor: const Color(0xFF00A86B),
//               side: const BorderSide(color: Color(0xFF00A86B), width: 1.5),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(15),
//               ),
//             ),
//             child: Text(
//               label,
//               style: const TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'ngo_dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'EmailVerificationCheckScreen.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:location/location.dart';
import 'package:latlong2/latlong.dart';

class NGORegistrationScreen extends StatefulWidget {
  const NGORegistrationScreen({super.key});

  @override
  _NGORegistrationScreenState createState() => _NGORegistrationScreenState();
}

class _NGORegistrationScreenState extends State<NGORegistrationScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController ngoNameController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController personNameController = TextEditingController();
  final TextEditingController personRoleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController accountNumberController = TextEditingController();
  final TextEditingController ifscController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  // Map related variables
  late Location _location;
  LatLng? _currentLocation;
  late MapController _mapController;

  File? _logo;
  File? _document;
  String? selectedSector;
  bool isLoading = false;
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  // Track form steps
  int _currentStep = 0;
  late PageController _pageController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  List<String> donationTypes = ['Money', 'Clothes', 'Books'];
  List<String> selectedDonations = [];
  List<String> members = [];

  List<String> sectors = [
    'Health',
    'Education',
    'Environment',
    'Animal Welfare',
    'Women Empowerment',
    'Child Welfare',
    'Disaster Relief',
    'Poverty Alleviation',
    'Elderly Care'
  ];

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );
    _animationController.forward();

    // Initialize map controller and location
    _location = Location();
    _mapController = MapController();
    _getCurrentLocation();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    ngoNameController.dispose();
    cityController.dispose();
    emailController.dispose();
    personNameController.dispose();
    personRoleController.dispose();
    descriptionController.dispose();
    accountNumberController.dispose();
    ifscController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    _mapController.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    try {
      final LocationData currentLocation = await _location.getLocation();
      setState(() {
        _currentLocation =
            LatLng(currentLocation.latitude!, currentLocation.longitude!);
      });
    } catch (e) {
      print('Could not get current location: $e');
      // Set a default location (e.g., New Delhi)
      setState(() {
        _currentLocation = LatLng(28.6139, 77.2090);
      });
    }
  }

  void _onTap(LatLng latLng) {
    setState(() {
      _currentLocation = latLng; // Update location on map tap
    });
  }

  Future<void> signUp() async {
  if (passwordController.text != confirmPasswordController.text) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Passwords do not match")),
    );
    return;
  }

  setState(() {
    isLoading = true;
  });

  try {
    // Create the user
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );

    User? user = userCredential.user;

    if (user != null) {
      await user.updateDisplayName(personNameController.text.trim());
      await user.reload();
      user = _auth.currentUser;
    }

    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("A verification email has been sent. Please verify your email."),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => EmailVerificationCheckScreen()),
      );

      return;
    }

    // Store user info in Firestore
    await _firestore.collection('users').doc(user!.uid).set({
      'uid': user.uid,
      'email': emailController.text.trim(),
      'role': 'ngo',
    });

  } on FirebaseAuthException catch (e) {
    String errorMessage = "Signup failed!";
    if (e.code == 'email-already-in-use') {
      errorMessage = "Email already in use!";
    } else if (e.code == 'weak-password') {
      errorMessage = "Password is too weak!";
    }

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage)));
  }

  setState(() {
    isLoading = false;
  });
}

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

  void registerNGO() async {
    if (_document == null || _logo == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please upload both logo and document"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_currentLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select a location on the map"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      try {
        await signUp();
      } catch (e) {
        print("Error signing up: $e");
        return;
      }

      print("User ID: ${FirebaseAuth.instance.currentUser!.uid}");
      String ngoId = FirebaseAuth.instance.currentUser!.uid;

      // Upload Logo
      String logoPath = 'ngos/$ngoId/logo.jpg';
      String logoUrl = await uploadFile(_logo!, logoPath);

      // Upload Document
      String docPath = 'ngos/$ngoId/document.pdf';
      String docUrl = await uploadFile(_document!, docPath);

      try {
        await FirebaseFirestore.instance
            .collection('pending_approvals')
            .doc(ngoId)
            .set({
          'ngoId': ngoId,
          'name': ngoNameController.text,
          'city': cityController.text,
          'email': emailController.text,
          'sector': selectedSector,
          'description': descriptionController.text,
          'personName': personNameController.text,
          'personRole': personRoleController.text,
          'acceptedDonations': selectedDonations,
          'logoUrl': logoUrl,
          'documentUrl': docUrl,
          'bankAccount': accountNumberController.text,
          'ifscCode': ifscController.text,
          'submittedAt': Timestamp.now(),
          'status': 'pending',
          'members': members,
          'latitude': _currentLocation!.latitude,
          'longitude': _currentLocation!.longitude,
        });
      } catch (e) {
        print("Error saving NGO data: $e");
        return;
      }

      setState(() {
        isLoading = true;
      });

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => NGODashboard()));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Registration submitted for approval"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Error submitting registration"),
          backgroundColor: Colors.red,
        ),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<String> uploadFile(File file, String path) async {
    final ref = FirebaseStorage.instance.ref().child(path);
    await ref.putFile(file);
    return await ref.getDownloadURL();
  }

  void _nextStep() {
    if (_currentStep < 3) {
      // Updated to include the new map step
      setState(() {
        _currentStep += 1;
      });
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      registerNGO();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep -= 1;
      });
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF00A86B)))
          : Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: PageView(
                      controller: _pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        _buildPersonalInfoStep(),
                        _buildNGOInfoStep(),
                        _buildAdditionalDetailsStep(),
                        _buildLocationStep(), // New step for location
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.25,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF00A86B), Color(0xFF009160)],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                const Text(
                  'NGO Registration',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _buildStepIndicator(0, "Personal"),
                  _buildStepDivider(0),
                  _buildStepIndicator(1, "NGO Info"),
                  _buildStepDivider(1),
                  _buildStepIndicator(2, "Details"),
                  _buildStepDivider(2),
                  _buildStepIndicator(3, "Location"), // New step indicator
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepIndicator(int step, String label) {
    final isActive = _currentStep >= step;
    final isCurrent = _currentStep == step;

    return Expanded(
      child: Column(
        children: [
          Container(
            width: 35,
            height: 35,
            decoration: BoxDecoration(
              color: isActive ? Colors.white : Colors.white.withOpacity(0.3),
              shape: BoxShape.circle,
              border:
                  isCurrent ? Border.all(color: Colors.white, width: 2) : null,
            ),
            child: Center(
              child: Text(
                '${step + 1}',
                style: TextStyle(
                  color: isActive ? const Color(0xFF00A86B) : Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepDivider(int beforeStep) {
    final isActive = _currentStep > beforeStep;

    return Container(
      width: 30,
      height: 2,
      color: isActive ? Colors.white : Colors.white.withOpacity(0.3),
    );
  }

  Widget _buildPersonalInfoStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
      child: Column(
        children: [
          // Logo Upload Section with animation
          Center(
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey.shade100,
                    backgroundImage: _logo != null ? FileImage(_logo!) : null,
                    child: _logo == null
                        ? const Icon(Icons.camera_alt,
                            size: 40, color: Color(0xFF00A86B))
                        : null,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: InkWell(
                    onTap: _pickLogo,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Color(0xFF00A86B),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.add_a_photo,
                          color: Colors.white, size: 20),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Upload NGO Logo",
            style: TextStyle(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 24),

          // Email and Password
          _buildInputField(
            controller: emailController,
            label: "Email Address",
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 20),

          _buildPasswordField(
            controller: passwordController,
            label: "Password",
            obscureText: !isPasswordVisible,
            toggleVisibility: () {
              setState(() {
                isPasswordVisible = !isPasswordVisible;
              });
            },
          ),
          const SizedBox(height: 20),

          _buildPasswordField(
            controller: confirmPasswordController,
            label: "Confirm Password",
            obscureText: !isConfirmPasswordVisible,
            toggleVisibility: () {
              setState(() {
                isConfirmPasswordVisible = !isConfirmPasswordVisible;
              });
            },
          ),
          const SizedBox(height: 40),

          _buildActionButton(
            onPressed: _nextStep,
            label: "CONTINUE",
          ),
        ],
      ),
    );
  }

  Widget _buildNGOInfoStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
      child: Column(
        children: [
          _buildInputField(
            controller: ngoNameController,
            label: "NGO Name",
            icon: Icons.business,
          ),
          const SizedBox(height: 20),

          _buildInputField(
            controller: cityController,
            label: "City",
            icon: Icons.location_city,
          ),
          const SizedBox(height: 20),

          // Sector Dropdown
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(15),
            ),
            child: DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 20),
                border: InputBorder.none,
                hintText: "Select Sector",
                hintStyle: TextStyle(color: Colors.grey),
                prefixIcon: Icon(
                  Icons.category_outlined,
                  color: Color(0xFF00A86B),
                ),
              ),
              value: selectedSector,
              isExpanded: true,
              icon: const Icon(Icons.arrow_drop_down),
              iconSize: 24,
              elevation: 16,
              style: const TextStyle(color: Colors.black87, fontSize: 16),
              dropdownColor: Colors.white,
              items: sectors.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedSector = newValue!;
                });
              },
            ),
          ),
          const SizedBox(height: 20),

          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(15),
            ),
            child: TextField(
              controller: descriptionController,
              maxLines: 4,
              decoration: const InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                border: InputBorder.none,
                hintText: "Description",
                hintStyle: TextStyle(color: Colors.grey),
                prefixIcon: Icon(
                  Icons.description_outlined,
                  color: Color(0xFF00A86B),
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),

          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  onPressed: _previousStep,
                  label: "BACK",
                  isPrimary: false,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: _buildActionButton(
                  onPressed: _nextStep,
                  label: "CONTINUE",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAdditionalDetailsStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInputField(
            controller: personNameController,
            label: "Your Name",
            icon: Icons.person_outline,
          ),
          const SizedBox(height: 20),

          _buildInputField(
            controller: personRoleController,
            label: "Your Role",
            icon: Icons.work_outline,
          ),
          const SizedBox(height: 20),

          _buildInputField(
            controller: accountNumberController,
            label: "Bank Account Number",
            icon: Icons.account_balance,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 20),

          _buildInputField(
            controller: ifscController,
            label: "IFSC Code",
            icon: Icons.confirmation_number_outlined,
          ),
          const SizedBox(height: 20),

          // Document upload
          InkWell(
            onTap: _pickDocument,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: _document != null
                      ? const Color(0xFF00A86B)
                      : Colors.transparent,
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    _document != null ? Icons.check_circle : Icons.upload_file,
                    size: 40,
                    color: _document != null
                        ? const Color(0xFF00A86B)
                        : Colors.grey.shade700,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _document != null
                        ? "Document uploaded"
                        : "Upload Registration Document",
                    style: TextStyle(
                      color: _document != null
                          ? const Color(0xFF00A86B)
                          : Colors.grey.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (_document != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text(
                        _document!.path.split('/').last,
                        style: TextStyle(
                            color: Colors.grey.shade600, fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Donation Type Selection
          Text(
            "Accepted Donations",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 10),

          Center(
            child: Wrap(
              spacing: 15,
              runSpacing: 5,
              children: donationTypes.map((type) {
                final isSelected = selectedDonations.contains(type);
                return FilterChip(
                  label: Text(type),
                  selected: isSelected,
                  showCheckmark: false,
                  onSelected: (bool selected) {
                    setState(() {
                      selected
                          ? selectedDonations.add(type)
                          : selectedDonations.remove(type);
                    });
                  },
                  selectedColor: const Color(0xFF00A86B).withOpacity(0.2),
                  backgroundColor: Colors.grey.shade100,
                  labelStyle: TextStyle(
                    color: isSelected
                        ? const Color(0xFF00A86B)
                        : Colors.grey.shade800,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                    side: BorderSide(
                      color: isSelected
                          ? const Color(0xFF00A86B)
                          : Colors.grey.shade400,
                      width: 1.5,
                    ),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 25),

          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  onPressed: _previousStep,
                  label: "BACK",
                  isPrimary: false,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: _buildActionButton(
                  onPressed: _nextStep,
                  label: "CONTINUE",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // New step for location selection
  Widget _buildLocationStep() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
          child: Text(
            "Select NGO Location",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
          ),
        ),
        Text(
          "Tap on the map to set your NGO's exact location",
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: _currentLocation == null
              ? const Center(
                  child: CircularProgressIndicator(color: Color(0xFF00A86B)))
              : FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: _currentLocation ??
                        const LatLng(
                            28.6139, 77.2090), // Default to New Delhi if null
                    //zoom: 15,
                    initialZoom: 15,
                    onTap: (tapPosition, point) {
                      _onTap(point);
                    },
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                      subdomains: const ['a', 'b', 'c'],
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          width: 80.0,
                          height: 80.0,
                          point: _currentLocation!,
                          child: const Icon(
                            Icons.location_pin,
                            color: Color(0xFF00A86B),
                            size: 40.0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  onPressed: _previousStep,
                  label: "BACK",
                  isPrimary: false,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: _buildActionButton(
                  onPressed: _nextStep,
                  label: "SUBMIT",
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(fontSize: 16),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 20),
          border: InputBorder.none,
          hintText: label,
          prefixIcon: Icon(
            icon,
            color: const Color(0xFF00A86B),
          ),
          hintStyle: TextStyle(color: Colors.grey.shade700),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool obscureText,
    required VoidCallback toggleVisibility,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        style: const TextStyle(fontSize: 16),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 20),
          border: InputBorder.none,
          hintText: label,
          prefixIcon: const Icon(
            Icons.lock_outline,
            color: Color(0xFF00A86B),
          ),
          suffixIcon: IconButton(
            icon: Icon(
              obscureText ? Icons.visibility_off : Icons.visibility,
              color: Colors.grey.shade700,
            ),
            onPressed: toggleVisibility,
          ),
          hintStyle: TextStyle(color: Colors.grey.shade700),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required VoidCallback onPressed,
    required String label,
    bool isPrimary = true,
  }) {
    return SizedBox(
      height: 55,
      child: isPrimary
          ? ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00A86B),
                foregroundColor: Colors.white,
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : OutlinedButton(
              onPressed: onPressed,
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF00A86B),
                side: const BorderSide(color: Color(0xFF00A86B), width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
    );
  }
}
