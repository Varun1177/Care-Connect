// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:location/location.dart';

// class DonationDetailsScreen extends StatefulWidget {
//   final String donationType;

//   const DonationDetailsScreen({super.key, required this.donationType});

//   @override
//   _DonationDetailsScreenState createState() => _DonationDetailsScreenState();
// }

// class _DonationDetailsScreenState extends State<DonationDetailsScreen> {
//   final TextEditingController _quantityController = TextEditingController();
//   LocationData? _locationData;
//   bool isSubmitting = false;

//   @override
//   void initState() {
//     super.initState();
//     fetchCurrentLocation();
//   }

//   Future<void> fetchCurrentLocation() async {
//     Location location = Location();

//     bool serviceEnabled = await location.serviceEnabled();
//     if (!serviceEnabled) {
//       serviceEnabled = await location.requestService();
//       if (!serviceEnabled) return;
//     }

//     PermissionStatus permissionGranted = await location.hasPermission();
//     if (permissionGranted == PermissionStatus.denied) {
//       permissionGranted = await location.requestPermission();
//       if (permissionGranted != PermissionStatus.granted) return;
//     }

//     final locationData = await location.getLocation();
//     setState(() {
//       _locationData = locationData;
//     });
//   }

//   Future<void> submitDonation() async {
//     if (_locationData == null || _quantityController.text.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please enter quantity and wait for location to load.")),
//       );
//       return;
//     }

//     setState(() {
//       isSubmitting = true;
//     });

//     final uid = FirebaseAuth.instance.currentUser?.uid;

//     await FirebaseFirestore.instance.collection('donation_requests').add({
//       'userId': uid,
//       'type': widget.donationType,
//       'quantity': int.tryParse(_quantityController.text) ?? 0,
//       'latitude': _locationData!.latitude,
//       'longitude': _locationData!.longitude,
//       'timestamp': Timestamp.now(),
//     });

//     setState(() {
//       isSubmitting = false;
//     });

//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text("Donation submitted successfully.")),
//     );

//     Navigator.pop(context);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Donate ${widget.donationType}'),
//         backgroundColor: const Color(0xFF00A86B),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           children: [
//             const SizedBox(height: 20),
//             TextField(
//               controller: _quantityController,
//               keyboardType: TextInputType.number,
//               decoration: const InputDecoration(
//                 labelText: 'Quantity',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 20),
//             _locationData == null
//                 ? const CircularProgressIndicator()
//                 : Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text("Latitude: ${_locationData!.latitude}"),
//                       Text("Longitude: ${_locationData!.longitude}"),
//                     ],
//                   ),
//             const SizedBox(height: 30),
//             ElevatedButton.icon(
//               onPressed: isSubmitting ? null : submitDonation,
//               icon: const Icon(Icons.check),
//               label: isSubmitting
//                   ? const CircularProgressIndicator(
//                       color: Colors.white,
//                       strokeWidth: 2,
//                     )
//                   : const Text("Submit Donation"),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color(0xFF00A86B),
//                 minimumSize: const Size(double.infinity, 50),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:location/location.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DonationDetailsScreen extends StatefulWidget {
  final String donationType;

  const DonationDetailsScreen({super.key, required this.donationType});

  @override
  _DonationDetailsScreenState createState() => _DonationDetailsScreenState();
}

class _DonationDetailsScreenState extends State<DonationDetailsScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  LocationData? _locationData;
  bool isSubmitting = false;
  bool _isLocationExpanded = false;
  
  // Initialize these variables directly instead of using 'late'
  AnimationController? _animationController;
  Animation<double>? _fadeAnimation;

  @override
  void initState() {
    super.initState();
    fetchCurrentLocation();
    
    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    
    // Initialize fade animation
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController!,
        curve: Curves.easeIn,
      ),
    );
    
    // Start the animation
    _animationController!.forward();
  }

  @override
  void dispose() {
    _animationController?.dispose();
    _quantityController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> fetchCurrentLocation() async {
    Location location = Location();

    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) return;
    }

    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return;
    }

    final locationData = await location.getLocation();
    setState(() {
      _locationData = locationData;
    });
  }

  Future<void> submitDonation() async {
    if (_locationData == null || _quantityController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter quantity and wait for location to load."),
          backgroundColor: Color(0xFF00A86B),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() {
      isSubmitting = true;
    });

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(
                  color: Color(0xFF00A86B),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Submitting your donation...',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    final uid = FirebaseAuth.instance.currentUser?.uid;

    try {
      await FirebaseFirestore.instance.collection('donation_requests').add({
        'userId': uid,
        'type': widget.donationType,
        'quantity': int.tryParse(_quantityController.text) ?? 0,
        'description': _descriptionController.text,
        'latitude': _locationData!.latitude,
        'longitude': _locationData!.longitude,
        'timestamp': Timestamp.now(),
        'status': 'pending',
      });

      // Close loading dialog
      Navigator.pop(context);

      setState(() {
        isSubmitting = false;
      });

      // Show success dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF00A86B), Color(0xFF009160)],
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_circle,
                      color: Color(0xFF00A86B),
                      size: 50,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Thank You!',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Your donation has been submitted successfully.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); // Close dialog
                        Navigator.pop(context); // Go back to previous screen
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Text(
                        'DONE',
                        style: TextStyle(
                          color: Color(0xFF00A86B),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    } catch (e) {
      // Close loading dialog
      Navigator.pop(context);
      
      setState(() {
        isSubmitting = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: ${e.toString()}"),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

@override
Widget build(BuildContext context) {
  final screenSize = MediaQuery.of(context).size;
  
  return Scaffold(
    backgroundColor: Colors.white,
    body: _fadeAnimation == null 
      ? const Center(child: CircularProgressIndicator(color: Color(0xFF00A86B)))
      : FadeTransition(
          opacity: _fadeAnimation!,
          child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                alignment: Alignment.bottomCenter,
                clipBehavior: Clip.none,
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
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                    child: SafeArea(
                      child: Stack(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back, color: Colors.white),
                            onPressed: () => Navigator.pop(context),
                          ),
                          const Positioned(
                            top: 20,
                            left: 0,
                            right: 0,
                            child: Column(
                              children: [
                                Text(
                                  'Donate & Help',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'Your generosity makes a difference',
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
                      child: Icon(
                        _getDonationIcon(),
                        size: 50,
                        color: const Color(0xFF00A86B),
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
                    Text(
                      'Donating ${widget.donationType}',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF00A86B),
                      ),
                    ),
                    const SizedBox(height: 20),
                    buildInputField(
                      controller: _quantityController,
                      label: 'Quantity',
                      icon: Icons.production_quantity_limits,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 20),
                    buildInputField(
                      controller: _descriptionController,
                      label: 'Description (Optional)',
                      icon: Icons.description_outlined,
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                    ),
                    const SizedBox(height: 20),
                    buildLocationSection(),
                    const SizedBox(height: 30),
                    buildSubmitButton(),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getDonationIcon() {
    switch(widget.donationType.toLowerCase()) {
      case 'food':
        return Icons.fastfood;
      case 'clothes':
        return Icons.checkroom;
      case 'books':
        return Icons.book;
      case 'medicine':
        return Icons.medical_services;
      case 'money':
        return Icons.monetization_on;
      default:
        return Icons.card_giftcard;
    }
  }

  Widget buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        style: const TextStyle(fontSize: 16),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: maxLines > 1 ? 20 : 20, horizontal: 10),
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

  Widget buildLocationSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(15),
      ),
      child: ExpansionTile(
        initiallyExpanded: _isLocationExpanded,
        onExpansionChanged: (expanded) {
          setState(() {
            _isLocationExpanded = expanded;
          });
        },
        leading: const Icon(
          Icons.location_on,
          color: Color(0xFF00A86B),
        ),
        title: const Text(
          'Your Location',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          _locationData == null
              ? 'Detecting your location...'
              : 'Location detected',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade700,
          ),
        ),
        trailing: _locationData == null
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Color(0xFF00A86B),
                  strokeWidth: 2,
                ),
              )
            : const Icon(Icons.keyboard_arrow_down),
        children: [
          if (_locationData != null)
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.pin_drop,
                        size: 16,
                        color: Color(0xFF00A86B),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        "Latitude: ${_locationData!.latitude!.toStringAsFixed(6)}",
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(
                        Icons.pin_drop,
                        size: 16,
                        color: Color(0xFF00A86B),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        "Longitude: ${_locationData!.longitude!.toStringAsFixed(6)}",
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "This location will be used to connect you with nearby pickup volunteers.",
                    style: TextStyle(
                      fontSize: 13,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton.icon(
        onPressed: isSubmitting ? null : submitDonation,
        //icon: const Icon(Icons.favorite),
        label: const Text(
          'SUBMIT DONATION',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF00A86B),
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }
}