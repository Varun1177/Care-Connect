// import 'package:flutter/material.dart';

// class ReportScreen extends StatefulWidget {
//   @override
//   _ReportScreenState createState() => _ReportScreenState();
// }

// class _ReportScreenState extends State<ReportScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _descriptionController = TextEditingController();

//   String? selectedNgo;
//   String? selectedFraudType;
//   String? otherFraudType;
//   String? contactInfo;
//   bool isSubmitting = false;

//   final List<String> userNgos = [
//     'Helping Hands NGO',
//     'Green Earth Foundation',
//     'Education for All',
//     'Health Warriors'
//   ];

//   final List<String> fraudTypes = [
//     'Fake Drive',
//     'Misuse of Funds',
//     'False Information',
//     'Unfulfilled Promises',
//     'Other',
//   ];

//   Future<void> _submitReport() async {
//     if (!_formKey.currentState!.validate() || isSubmitting) return;

//     setState(() => isSubmitting = true);

//     // Simulate API call delay
//     await Future.delayed(Duration(seconds: 2));

//     final reportData = {
//       'ngo': selectedNgo,
//       'type': selectedFraudType == 'Other' ? otherFraudType : selectedFraudType,
//       'description': _descriptionController.text.trim(),
//       'contactInfo': contactInfo,
//       'timestamp': DateTime.now().toString(),
//     };

//     print('Submitted Report: $reportData');

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('Report submitted successfully!'),
//         backgroundColor: Colors.green,
//         duration: Duration(seconds: 3),
//       ),
//     );

//     _formKey.currentState!.reset();
//     _descriptionController.clear();
//     setState(() {
//       selectedNgo = null;
//       selectedFraudType = null;
//       otherFraudType = null;
//       contactInfo = null;
//       isSubmitting = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Report NGO'),
//         backgroundColor: Colors.redAccent,
//       ),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(20),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _buildNgoDropdown(),
//               SizedBox(height: 20),
//               _buildFraudTypeDropdown(),
//               if (selectedFraudType == 'Other') ...[
//                 SizedBox(height: 10),
//                 TextFormField(
//                   decoration: InputDecoration(
//                     labelText: 'Specify Fraud Type',
//                     border: OutlineInputBorder(),
//                     hintText: 'Describe the type of fraud...',
//                   ),
//                   validator: (value) =>
//                       value?.trim().isEmpty ?? true ? 'Required field' : null,
//                   onChanged: (value) => otherFraudType = value,
//                 ),
//               ],
//               SizedBox(height: 20),
//               _buildDescriptionField(),
//               SizedBox(height: 20),
//               _buildContactInfoField(),
//               SizedBox(height: 30),
//               _buildSubmitButton(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildNgoDropdown() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text('Select NGO', style: TextStyle(fontWeight: FontWeight.bold)),
//         DropdownButtonFormField<String>(
//           value: selectedNgo,
//           hint: Text('Choose NGO'),
//           items: userNgos
//               .map((ngo) => DropdownMenuItem(value: ngo, child: Text(ngo)))
//               .toList(),
//           onChanged: (value) => setState(() => selectedNgo = value),
//           validator: (value) => value == null ? 'Please select an NGO' : null,
//           decoration: InputDecoration(border: OutlineInputBorder()),
//         ),
//       ],
//     );
//   }

//   Widget _buildFraudTypeDropdown() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text('Type of Fraud', style: TextStyle(fontWeight: FontWeight.bold)),
//         DropdownButtonFormField<String>(
//           value: selectedFraudType,
//           hint: Text('Select Fraud Type'),
//           items: fraudTypes
//               .map((type) => DropdownMenuItem(value: type, child: Text(type)))
//               .toList(),
//           onChanged: (value) => setState(() {
//             selectedFraudType = value;
//             otherFraudType = null;
//           }),
//           validator: (value) =>
//               value == null ? 'Please select fraud type' : null,
//           decoration: InputDecoration(border: OutlineInputBorder()),
//         ),
//       ],
//     );
//   }

//   Widget _buildDescriptionField() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text('Description', style: TextStyle(fontWeight: FontWeight.bold)),
//         TextFormField(
//           controller: _descriptionController,
//           maxLines: 5,
//           maxLength: 1000,
//           decoration: InputDecoration(
//             border: OutlineInputBorder(),
//             hintText: 'Describe the issue in detail...',
//             counterText: '${_descriptionController.text.length}/1000',
//           ),
//           validator: (value) {
//             if (value?.trim().isEmpty ?? true)
//               return 'Please enter a description';
//             if (value!.trim().length < 30)
//               return 'Minimum 30 characters required';
//             return null;
//           },
//         ),
//       ],
//     );
//   }

//   Widget _buildContactInfoField() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text('Contact Information (optional)',
//             style: TextStyle(fontWeight: FontWeight.bold)),
//         TextFormField(
//           decoration: InputDecoration(
//               border: OutlineInputBorder(),
//               hintText: 'Email or phone for follow-up'),
//           keyboardType: TextInputType.emailAddress,
//           onChanged: (value) => contactInfo = value,
//         ),
//       ],
//     );
//   }

//   Widget _buildSubmitButton() {
//     return Center(
//       child: ElevatedButton.icon(
//         icon: Icon(isSubmitting ? Icons.hourglass_top : Icons.report_problem),
//         label: Text(isSubmitting ? 'Submitting...' : 'Submit Report'),
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.redAccent,
//           foregroundColor: Colors.white,
//           padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//         ),
//         onPressed: isSubmitting ? null : _submitReport,
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _descriptionController.dispose();
//     super.dispose();
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:care__connect/screens/User/widgets/report_repository.dart';
import 'package:care__connect/screens/User/widgets/report.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;


  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Map<String, dynamic>> _interactedNgos= [];

  String? _selectedNgoId;
  String? _selectedNgoName;

  final List<Map<String, dynamic>> reasons = [
    {
      "title": "Money Fraud",
      "icon": Icons.attach_money,
      "color": Colors.red,
      "description": "Report issues related to financial mismanagement or fraud"
    },
    {
      "title": "False Claims",
      "icon": Icons.warning_amber,
      "color": Colors.orange,
      "description":
          "NGO making false statements about their activities or impact"
    },
    {
      "title": "Improper Function",
      "icon": Icons.build_circle,
      "color": Colors.blue,
      "description": "Issues with how the NGO operates or delivers services"
    },
    {
      "title": "Fake NGO",
      "icon": Icons.not_interested,
      "color": Colors.grey,
      "description": "Suspicions that the organization is not a legitimate NGO"
    },
    {
      "title": "Donation Fraud",
      "icon": Icons.card_giftcard,
      "color": Colors.purple,
      "description": "Issues with how donations are collected or used"
    },
    {
      "title": "Corruption",
      "icon": Icons.gavel,
      "color": Colors.green,
      "description": "Reporting corrupt practices within the organization"
    },
  ];

  int? _hoveredIndex;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );
    _slideAnimation = Tween<double>(begin: 30.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );
    _animationController.forward();

    if (_interactedNgos.isNotEmpty) {
      _selectedNgoId = _interactedNgos[0]['ngoId'];
      _selectedNgoName = _interactedNgos[0]['name'];
    }

    _fetchApprovedNGOs();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _fetchApprovedNGOs() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('ngos')
        .where('approved', isEqualTo: true)
        .get();

    List<Map<String, dynamic>> approvedNgos = [];

    for (var doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      final List<dynamic> acceptedDonations = data['acceptedDonations'] ?? [];

      if (acceptedDonations.contains('Money')) {
        approvedNgos.add({
          'id': doc.id,
          'ngoId': data['ngoId'], // Use this if you need the custom ID
          'name': data['name'],
        });
      }
    }

    setState(() {
      _interactedNgos = approvedNgos;

      if (_interactedNgos.isNotEmpty) {
        _selectedNgoId =
            _interactedNgos[0]['ngoId']; // or 'id' if you use Firestore doc ID
        _selectedNgoName = _interactedNgos[0]['name'];
      }
    });
  }

  void _navigateToDescription(
      BuildContext context, String reason, String description) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            _DescriptionScreen(
          ngoId: _selectedNgoId!,
          ngoName: _selectedNgoName!,
          reason: reason,
          description: description,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;
          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                alignment: Alignment.bottomCenter,
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: screenSize.height * 0.32,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF00A86B), Color(0xFF009160)],
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(50),
                        bottomRight: Radius.circular(50),
                      ),
                    ),
                    child: SafeArea(
                      child: Stack(
                        children: [
                          Positioned(
                            top: 20,
                            left: 15,
                            child: IconButton(
                              icon: const Icon(
                                Icons.arrow_back_ios,
                                color: Colors.white,
                              ),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),
                          const Positioned(
                            top: 50,
                            left: 0,
                            right: 0,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'NGO Report',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 35,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Report your issues with NGOs',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -40,
                    child: Hero(
                      tag: 'report_icon',
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.report_problem_rounded,
                          size: 50,
                          color: Color(0xFF00A86B),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 60),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.business_rounded,
                          color: Color(0xFF00A86B),
                          size: 24,
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          "Select NGO",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF00A86B),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    AnimatedBuilder(
                      animation: _slideAnimation,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0, _slideAnimation.value),
                          child: child,
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedNgoId,
                            isExpanded: true,
                            icon: const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: Color(0xFF00A86B),
                            ),
                            style: const TextStyle(
                              color: Color(0xFF333333),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            onChanged: (newNgoId) {
                              setState(() {
                                _selectedNgoId = newNgoId;
                                _selectedNgoName = _interactedNgos.firstWhere(
                                    (ngo) => ngo['ngoId'] == newNgoId)['name'];
                              });
                            },
                            items: _interactedNgos.map((ngo) {
                              return DropdownMenuItem<String>(
                                value: ngo['ngoId'],
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 15.0),
                                  child: Text(ngo['name']),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      children: [
                        const Icon(
                          Icons.report_rounded,
                          color: Color(0xFF00A86B),
                          size: 24,
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          "Reason for Report",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF00A86B),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    AnimatedBuilder(
                      animation: _slideAnimation,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0, _slideAnimation.value),
                          child: child,
                        );
                      },
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: reasons.length,
                        itemBuilder: (context, index) {
                          final reason = reasons[index];
                          final isHovered = _hoveredIndex == index;

                          return MouseRegion(
                            onEnter: (_) =>
                                setState(() => _hoveredIndex = index),
                            onExit: (_) => setState(() => _hoveredIndex = null),
                            child: GestureDetector(
                              onTap: () => _navigateToDescription(
                                context,
                                reason['title'],
                                reason['description'],
                              ),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                curve: Curves.easeOut,
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                padding: EdgeInsets.all(isHovered ? 18 : 16),
                                decoration: BoxDecoration(
                                  color: isHovered
                                      ? reason['color'].withOpacity(0.2)
                                      : reason['color'].withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      color: reason['color']
                                          .withOpacity(isHovered ? 0.3 : 0.1),
                                      blurRadius: isHovered ? 12 : 8,
                                      offset: Offset(0, isHovered ? 6 : 4),
                                    )
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        AnimatedContainer(
                                          duration:
                                              const Duration(milliseconds: 200),
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: reason['color'],
                                            shape: BoxShape.circle,
                                            boxShadow: isHovered
                                                ? [
                                                    BoxShadow(
                                                      color: reason['color']
                                                          .withOpacity(0.4),
                                                      blurRadius: 10,
                                                      spreadRadius: 2,
                                                    )
                                                  ]
                                                : [],
                                          ),
                                          child: Icon(
                                            reason['icon'],
                                            color: Colors.white,
                                            size: isHovered ? 24 : 22,
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Text(
                                            reason['title'],
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: reason['color'],
                                            ),
                                          ),
                                        ),
                                        AnimatedContainer(
                                          duration:
                                              const Duration(milliseconds: 200),
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: isHovered
                                                ? reason['color']
                                                : Colors.transparent,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            Icons.arrow_forward_rounded,
                                            size: 18,
                                            color: isHovered
                                                ? Colors.white
                                                : reason['color'],
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (isHovered) ...[
                                      const SizedBox(height: 12),
                                      Text(
                                        reason['description'],
                                        style: TextStyle(
                                          color: Colors.grey.shade700,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ]
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

class _DescriptionScreen extends StatefulWidget {
  final String ngoId;
  final String ngoName;
  final String reason;
  final String description;

  const _DescriptionScreen({
    required this.ngoId,
    required this.ngoName,
    required this.reason,
    required this.description,
  });

  @override
  State<_DescriptionScreen> createState() => _DescriptionScreenState();
}

class _DescriptionScreenState extends State<_DescriptionScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;
  List<File> _attachedFiles = [];
  List<String> _attachedFileNames = [];
  final ReportRepository _reportRepository = ReportRepository();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //final ReportRepository _reportRepository = ReportRepository();
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
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
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _attachFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf', 'doc', 'docx'],
      );

      if (result != null) {
        File file = File(result.files.single.path!);
        setState(() {
          _attachedFiles.add(file);
          _attachedFileNames.add(result.files.single.name);
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('File ${result.files.single.name} attached successfully')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error attaching file: $e')),
      );
    }
  }

  Future<List<String>> _uploadFiles() async {
    List<String> urls = [];
    
    for (int i = 0; i < _attachedFiles.length; i++) {
      File file = _attachedFiles[i];
      String fileName = _attachedFileNames[i];
      
      try {
        // Create a reference to the location you want to upload to in Firebase Storage
        Reference storageReference = FirebaseStorage.instance
            .ref()
            .child('report_evidence')
            .child('${DateTime.now().millisecondsSinceEpoch}_$fileName');
            
        // Upload the file to Firebase Storage
        UploadTask uploadTask = storageReference.putFile(file);
        
        // Wait until the upload completes
        await uploadTask.whenComplete(() => null);
        
        // Get the download URL
        String downloadUrl = await storageReference.getDownloadURL();
        urls.add(downloadUrl);
      } catch (e) {
        print('Error uploading file: $e');
      }
    }
    
    return urls;
  }

  Future<void> _submitReport() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
      });
      
      try {
        // Upload files if there are any attached
        List<String> evidenceUrls = [];
        if (_attachedFiles.isNotEmpty) {
          evidenceUrls = await _uploadFiles();
        }
        
        // Create a report object
        final report = Report(
          ngoId: widget.ngoId,
          ngoName: widget.ngoName,
          reason: widget.reason,
          description: _descriptionController.text,
          evidenceUrls: evidenceUrls,
          createdAt: DateTime.now(),
          user: _auth.currentUser!.uid,
        );
        
        // Save the report to Firestore
        await _reportRepository.addReport(report);
        
        if (mounted) {
          setState(() {
            _isSubmitting = false;
          });
          
          // Show success dialog
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Row(
                children: [
                  const Icon(Icons.check_circle, color: Color(0xFF00A86B), size: 30),
                  const SizedBox(width: 10),
                  const Text("Report Submitted"),
                ],
              ),
              content: const Text(
                "Your report has been submitted successfully. We'll review it and take appropriate action.",
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close dialog
                    Navigator.pop(context); // Return to previous screen
                  },
                  child: const Text(
                    "OK",
                    style: TextStyle(color: Color(0xFF00A86B)),
                  ),
                ),
              ],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          );
        }
      } catch (e) {
        setState(() {
          _isSubmitting = false;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error submitting report: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF00A86B),
        title: const Text(
          "Report Details",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // NGO Info Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF00A86B), Color(0xFF009160)],
                      ),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.business,
                              color: Colors.white,
                              size: 24,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              widget.ngoName,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const Divider(color: Colors.white38, height: 25),
                        Row(
                          children: [
                            const Icon(
                              Icons.warning_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              widget.reason,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.only(left: 30),
                          child: Text(
                            widget.description,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  // Description Section
                  _buildSectionTitle("Describe the Issue"),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 6,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please describe the issue';
                      }
                      if (value.trim().length < 20) {
                        return 'Description should be at least 20 characters';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: "Please provide details about your issue...",
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(
                            color: Color(0xFF00A86B), width: 2),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide:
                            const BorderSide(color: Colors.red, width: 1),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide:
                            const BorderSide(color: Colors.red, width: 2),
                      ),
                      contentPadding: const EdgeInsets.all(15),
                    ),
                  ),

                  const SizedBox(height: 25),

                  // Evidence Section
                  _buildSectionTitle("Attach Evidence (Optional)"),
                  const SizedBox(height: 15),

                  InkWell(
                    onTap: _attachFile,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(15),
                        border:
                            Border.all(color: Colors.grey.shade300, width: 1),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.cloud_upload_outlined,
                            size: 40,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Tap to upload files",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "Image, PDF, or Document",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  if (_attachedFiles.isNotEmpty) ...[
                    const SizedBox(height: 15),
                    Column(
                      children: List.generate(_attachedFiles.length, (index) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.insert_drive_file,
                                  color: Color(0xFF00A86B)),
                              const SizedBox(width: 10),
                              Expanded(child: Text(_attachedFileNames[index])),
                              IconButton(
                                icon: const Icon(Icons.close, size: 18),
                                onPressed: () {
                                  setState(() {
                                    _attachedFiles.removeAt(index);
                                    _attachedFiles.removeAt(index);
                                  });
                                },
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ],

                  const SizedBox(height: 30),

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: _isSubmitting ? null : _submitReport,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00A86B),
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: _isSubmitting
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.send, size: 20),
                                const SizedBox(width: 10),
                                const Text(
                                  "SUBMIT REPORT",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 24,
          decoration: const BoxDecoration(
            color: Color(0xFF00A86B),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF333333),
          ),
        ),
      ],
    );
  }
}
