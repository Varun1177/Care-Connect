// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';


// class CreateCampaignScreen extends StatefulWidget {
//   const CreateCampaignScreen({super.key});
  
//   @override
//   _CreateCampaignScreenState createState() => _CreateCampaignScreenState();
// }

// class _CreateCampaignScreenState extends State<CreateCampaignScreen> {
//   final _formKey = GlobalKey<FormState>();
//   DateTime? _selectedDate;
//   final TextEditingController _purposeController = TextEditingController();
//   final TextEditingController _descriptionController = TextEditingController();
//   final TextEditingController _volunteersController = TextEditingController();
  
//   @override
//   void dispose() {
//     _purposeController.dispose();
//     _descriptionController.dispose();
//     _volunteersController.dispose();
//     super.dispose();
//   }
  
//   Future<void> _pickDate() async {
//     DateTime now = DateTime.now();
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: now,
//       firstDate: now,
//       lastDate: DateTime(now.year + 5),
//     );
//     if (picked != null && picked != _selectedDate) {
//       setState(() {
//         _selectedDate = picked;
//       });
//     }
//   }
  
//   void _submitCampaign() async {
//   if (_formKey.currentState!.validate() && _selectedDate != null) {
//     try {
//       final ngoId = FirebaseAuth.instance.currentUser!.uid;

//       await FirebaseFirestore.instance.collection('campaigns').add({
//         'ngoId': ngoId,
//         'purpose': _purposeController.text.trim(),
//         'description': _descriptionController.text.trim(),
//         'volunteersNeeded': int.parse(_volunteersController.text.trim()),
//         'date': _selectedDate,
//         'createdAt': Timestamp.now(),
//         'isClosed': false,
//       });

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Campaign Created Successfully')),
//       );
//       Navigator.pop(context);
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error creating campaign: $e')),
//       );
//     }
//   } else {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Please fill all fields')),
//     );
//   }
// }

  
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Create Campaign'),
//         backgroundColor: Colors.lightGreen.shade300,
//       ),
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Colors.lightGreen.shade100, Colors.orange.shade50],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//         ),
//         child: Center(
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Card(
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//               elevation: 8,
//               child: Padding(
//                 padding: const EdgeInsets.all(24),
//                 child: Form(
//                   key: _formKey,
//                   child: ListView(
//                     shrinkWrap: true,
//                     children: [
//                       ListTile(
//                         leading: Icon(Icons.calendar_today, color: Colors.lightGreen.shade300),
//                         title: Text(
//                           _selectedDate == null
//                               ? 'Select Date'
//                               : 'Date: ${_selectedDate!.toLocal()}'.split(' ')[0],
//                           style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//                         ),
//                         trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.lightGreen.shade300),
//                         onTap: _pickDate,
//                       ),
//                       const SizedBox(height: 20),
//                       TextFormField(
//                         controller: _purposeController,
//                         decoration: InputDecoration(
//                           filled: true,
//                           fillColor: Colors.lightGreen.shade50,
//                           labelText: 'Purpose',
//                           prefixIcon: Icon(Icons.edit, color: Colors.lightGreen.shade300),
//                           border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//                         ),
//                         validator: (value) => (value == null || value.isEmpty) ? 'Enter purpose' : null,
//                       ),
//                       const SizedBox(height: 20),
//                       TextFormField(
//                         controller: _descriptionController,
//                         decoration: InputDecoration(
//                           filled: true,
//                           fillColor: Colors.lightGreen.shade50,
//                           labelText: 'Description',
//                           prefixIcon: Icon(Icons.description, color: Colors.lightGreen.shade300),
//                           border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//                         ),
//                         maxLines: 3,
//                         validator: (value) => (value == null || value.isEmpty) ? 'Enter description' : null,
//                       ),
//                       const SizedBox(height: 20),
//                       TextFormField(
//                         controller: _volunteersController,
//                         decoration: InputDecoration(
//                           filled: true,
//                           fillColor: Colors.lightGreen.shade50,
//                           labelText: 'No. of Volunteers Needed',
//                           prefixIcon: Icon(Icons.group, color: Colors.lightGreen.shade300),
//                           border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//                         ),
//                         keyboardType: TextInputType.number,
//                         validator: (value) => (value == null || value.isEmpty) ? 'Enter number of volunteers' : null,
//                       ),
//                       const SizedBox(height: 30),
//                       ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.lightGreen.shade300,
//                           padding: const EdgeInsets.symmetric(vertical: 16),
//                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                         ),
//                         onPressed: _submitCampaign,
//                         child: const Text('Create Campaign', style: TextStyle(fontSize: 16)),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreateCampaignScreen extends StatefulWidget {
  const CreateCampaignScreen({super.key});
  
  @override
  _CreateCampaignScreenState createState() => _CreateCampaignScreenState();
}

class _CreateCampaignScreenState extends State<CreateCampaignScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  DateTime? _selectedDate;
  final TextEditingController _purposeController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _volunteersController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  
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
    _animationController.forward();
  }
  
  @override
  void dispose() {
    _purposeController.dispose();
    _descriptionController.dispose();
    _volunteersController.dispose();
    _animationController.dispose();
    super.dispose();
  }
  
  Future<void> _pickDate() async {
    DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 5),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF00A86B),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF00A86B),
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }
  
  void _submitCampaign() async {
    if (_formKey.currentState!.validate() && _selectedDate != null) {
      final loadingDialog = showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(
            color: Color(0xFF00A86B),
          ),
        ),
      );
      
      try {
        final ngoId = FirebaseAuth.instance.currentUser!.uid;

        await FirebaseFirestore.instance.collection('campaigns').add({
          'ngoId': ngoId,
          'purpose': _purposeController.text.trim(),
          'description': _descriptionController.text.trim(),
          'volunteersNeeded': int.parse(_volunteersController.text.trim()),
          'date': _selectedDate,
          'createdAt': Timestamp.now().toDate().toIso8601String(),
          'isClosed': false,
          'image':"",
          'location': _locationController.text.trim(),
        });

        Navigator.pop(context); // Close loading dialog
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Campaign Created Successfully'),
            backgroundColor: Color(0xFF00A86B),
          ),
        );
        Navigator.pop(context);
      } catch (e) {
        Navigator.pop(context); // Close loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error creating campaign: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all fields'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              Container(
                height: screenSize.height * 0.25,
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
                child: Stack(
                  children: [
                    const Positioned(
                      top: 50,
                      left: 0,
                      right: 0,
                      child: Column(
                        children: [
                          Text(
                            'New Campaign',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Create a new volunteering opportunity',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      left: 0,
                      right: 0,
                      child: Center(
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
                            Icons.volunteer_activism,
                            size: 50,
                            color: Color(0xFF00A86B),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 60),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: _pickDate,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.calendar_today,
                                  color: Color(0xFF00A86B),
                                ),
                                const SizedBox(width: 15),
                                Text(
                                  _selectedDate == null
                                      ? 'Select Campaign Date'
                                      : 'Date: ${_selectedDate!.toLocal().toString().split(' ')[0]}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: _selectedDate == null ? Colors.grey.shade700 : Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      buildInputField(
                        controller: _purposeController,
                        label: 'Campaign Purpose',
                        icon: Icons.edit_outlined,
                        validator: (value) => (value == null || value.isEmpty) ? 'Please enter purpose' : null,
                      ),
                      const SizedBox(height: 20),
                      buildInputField(
                        controller: _locationController,
                        label: 'Location',
                        icon: Icons.location_on_outlined,
                        validator: (value) => (value == null || value.isEmpty) ? 'Please enter purpose' : null,
                      ),
                      const SizedBox(height: 20),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: TextFormField(
                          controller: _descriptionController,
                          validator: (value) => (value == null || value.isEmpty) ? 'Please enter description' : null,
                          maxLines: 5,
                          style: const TextStyle(fontSize: 16),
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                            border: InputBorder.none,
                            hintText: 'Campaign Description',
                            prefixIcon: const Padding(
                              padding: EdgeInsets.only(bottom: 80, left: 15, right: 15),
                              child: Icon(
                                Icons.description_outlined,
                                color: Color(0xFF00A86B),
                              ),
                            ),
                            hintStyle: TextStyle(color: Colors.grey.shade700),
                            alignLabelWithHint: true,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      buildInputField(
                        controller: _volunteersController,
                        label: 'Number of Volunteers Needed',
                        icon: Icons.people_outline,
                        keyboardType: TextInputType.number,
                        validator: (value) => (value == null || value.isEmpty) 
                            ? 'Please enter number of volunteers' 
                            : (int.tryParse(value) == null) 
                                ? 'Please enter a valid number' 
                                : null,
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: _submitCampaign,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF00A86B),
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: const Text(
                            'CREATE CAMPAIGN',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
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
}