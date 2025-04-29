// // import 'package:flutter/material.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:location/location.dart';
// // import 'package:url_launcher/url_launcher.dart';
// // import 'dart:math';

// // class NearestNGOScreen extends StatefulWidget {
// //   const NearestNGOScreen({super.key});

// //   @override
// //   State<NearestNGOScreen> createState() => _NearestNGOScreenState();
// // }

// // class _NearestNGOScreenState extends State<NearestNGOScreen> {
// //   Map<String, dynamic>? nearestNGO;
// //   bool loading = true;
// //   String? error;

// //   Location location = Location();

// //   @override
// //   void initState() {
// //     super.initState();
// //     findNearestNGO();
// //   }

// //   Future<void> findNearestNGO() async {
// //   try {
// //     debugPrint("🔍 Getting user location...");
// //     final userLocation = await _getCurrentLocation().timeout(const Duration(seconds: 10));
// //     if (userLocation.latitude == null || userLocation.longitude == null) {
// //       throw Exception("Location data is null.");
// //     }

// //     debugPrint("📍 User Location: ${userLocation.latitude}, ${userLocation.longitude}");

// //     debugPrint("📥 Fetching approved NGOs from Firestore...");
// //     final ngos = await _getAllApprovedNGOs();

// //     if (ngos.isEmpty) {
// //       debugPrint("⚠️ No NGOs found.");
// //       setState(() {
// //         nearestNGO = null;
// //         loading = false;
// //       });
// //       return;
// //     }

// //     double shortestDistance = double.infinity;
// //     Map<String, dynamic>? closestNGO;

// //     for (var ngo in ngos) {
// //       if (ngo['latitude'] != null && ngo['longitude'] != null) {
// //         final distance = _calculateDistance(
// //           userLocation.latitude!,
// //           userLocation.longitude!,
// //           ngo['latitude'],
// //           ngo['longitude'],
// //         );

// //         debugPrint("🧭 Distance to ${ngo['name']}: ${distance.toStringAsFixed(2)} km");

// //         if (distance < shortestDistance) {
// //           shortestDistance = distance;
// //           closestNGO = ngo;
// //         }
// //       }
// //     }

// //     setState(() {
// //       nearestNGO = closestNGO;
// //       loading = false;
// //     });

// //     debugPrint("✅ Nearest NGO: ${closestNGO?['name']}");
// //   } catch (e) {
// //     debugPrint("❌ Error: $e");
// //     setState(() {
// //       error = e.toString();
// //       loading = false;
// //     });
// //   }
// // }


// //   Future<LocationData> _getCurrentLocation() async {
// //   final Location location = Location();

// //   bool serviceEnabled = await location.serviceEnabled();
// //   if (!serviceEnabled) {
// //     serviceEnabled = await location.requestService();
// //     if (!serviceEnabled) throw Exception("Location services are disabled.");
// //   }

// //   PermissionStatus permissionGranted = await location.hasPermission();
// //   if (permissionGranted == PermissionStatus.denied) {
// //     permissionGranted = await location.requestPermission();
// //     if (permissionGranted != PermissionStatus.granted) {
// //       throw Exception("Location permission denied.");
// //     }
// //   }

// //   return await location.getLocation();
// // }


// //   Future<List<Map<String, dynamic>>> _getAllApprovedNGOs() async {
// //     QuerySnapshot query = await FirebaseFirestore.instance
// //         .collection("ngos")
// //         .where("approved", isEqualTo: true)
// //         .get();

// //     return query.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
// //   }

// //   double _calculateDistance(
// //     double lat1,
// //     double lon1,
// //     double lat2,
// //     double lon2,
// //   ) {
// //     const double earthRadius = 6371; // km
// //     double dLat = _degreesToRadians(lat2 - lat1);
// //     double dLon = _degreesToRadians(lon2 - lon1);
// //     double a = sin(dLat / 2) * sin(dLat / 2) +
// //         cos(_degreesToRadians(lat1)) *
// //             cos(_degreesToRadians(lat2)) *
// //             sin(dLon / 2) *
// //             sin(dLon / 2);
// //     double c = 2 * atan2(sqrt(a), sqrt(1 - a));
// //     return earthRadius * c;
// //   }

// //   double _degreesToRadians(double degrees) {
// //     return degrees * pi / 180;
// //   }

// //   void _openGoogleMaps(double lat, double lon) async {
// //     final url =
// //         "https://www.google.com/maps/dir/?api=1&destination=$lat,$lon&travelmode=driving";

// //     if (await canLaunchUrl(Uri.parse(url))) {
// //       await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
// //     } else {
// //       throw 'Could not launch Maps';
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text("Nearest NGO"),
// //       ),
// //       body: loading
// //           ? const Center(child: CircularProgressIndicator())
// //           : error != null
// //               ? Center(child: Text("Error: $error"))
// //               : nearestNGO == null
// //                   ? const Center(child: Text("No NGOs found nearby"))
// //                   : Padding(
// //                       padding: const EdgeInsets.all(16.0),
// //                       child: Card(
// //                         elevation: 4,
// //                         shape: RoundedRectangleBorder(
// //                             borderRadius: BorderRadius.circular(12)),
// //                         child: Padding(
// //                           padding: const EdgeInsets.all(16.0),
// //                           child: Column(
// //                             mainAxisSize: MainAxisSize.min,
// //                             children: [
// //                               Text(
// //                                 nearestNGO!['name'] ?? "Unknown NGO",
// //                                 style: const TextStyle(
// //                                     fontSize: 20, fontWeight: FontWeight.bold),
// //                               ),
// //                               const SizedBox(height: 10),
// //                               Text(nearestNGO!['description'] ?? ""),
// //                               const SizedBox(height: 10),
// //                               Text(
// //                                   "Accepted: ${nearestNGO!['acceptedDonations']?.join(", ")}"),
// //                               const SizedBox(height: 10),
// //                               Text("Contact: ${nearestNGO!['contact'] ?? 'N/A'}"),
// //                               const SizedBox(height: 10),
// //                               Text("Address: ${nearestNGO!['address'] ?? 'N/A'}"),
// //                               const SizedBox(height: 20),
// //                               ElevatedButton.icon(
// //                                 onPressed: () {
// //                                   _openGoogleMaps(
// //                                     nearestNGO!['latitude'],
// //                                     nearestNGO!['longitude'],
// //                                   );
// //                                 },
// //                                 icon: const Icon(Icons.map),
// //                                 label: const Text("Get Directions"),
// //                               )
// //                             ],
// //                           ),
// //                         ),
// //                       ),
// //                     ),
// //     );
// //   }
// // }


// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:location/location.dart';
// import 'package:url_launcher/url_launcher.dart';

// class NearestNGOScreen extends StatefulWidget {
//   const NearestNGOScreen({super.key});

//   @override
//   State<NearestNGOScreen> createState() => _NearestNGOScreenState();
// }

// class _NearestNGOScreenState extends State<NearestNGOScreen> {
//   List<Map<String, dynamic>> allNGOs = [];
//   List<Map<String, dynamic>> filteredNGOs = [];
//   bool loading = true;
//   String selectedSector = 'All';
//   String selectedDonationType = 'All';

//   List<String> sectors = [
//     'All',
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

//   final List<String> donationTypes = ['All', 'Food', 'Clothes', 'Books'];

//   @override
//   void initState() {
//     super.initState();
//     fetchNearbyNGOs();
//   }

//   Future<void> fetchNearbyNGOs() async {
//     try {
//       final location = Location();

//       bool serviceEnabled = await location.serviceEnabled();
//       if (!serviceEnabled) {
//         serviceEnabled = await location.requestService();
//         if (!serviceEnabled) throw Exception("Location service is disabled.");
//       }

//       PermissionStatus permissionGranted = await location.hasPermission();
//       if (permissionGranted == PermissionStatus.denied) {
//         permissionGranted = await location.requestPermission();
//         if (permissionGranted != PermissionStatus.granted) {
//           throw Exception("Location permission denied.");
//         }
//       }

//       final userLocation = await location.getLocation();
//       final userLat = userLocation.latitude!;
//       final userLng = userLocation.longitude!;

//       final snapshot = await FirebaseFirestore.instance
//           .collection('ngos')
//           .where('approved', isEqualTo: true)
//           .get();

//       List<Map<String, dynamic>> ngos = [];

//       for (var doc in snapshot.docs) {
//         final data = doc.data();
//         if (data['latitude'] != null && data['longitude'] != null) {
//           double distance = _calculateDistance(
//             userLat,
//             userLng,
//             data['latitude'],
//             data['longitude'],
//           );

//           ngos.add({
//             ...data,
//             'id': doc.id,
//             'distance': distance,
//           });
//         }
//       }

//       ngos.sort((a, b) => a['distance'].compareTo(b['distance']));
//       setState(() {
//         allNGOs = ngos.take(10).toList();
//         filteredNGOs = allNGOs;
//         loading = false;
//       });
//     } catch (e) {
//       debugPrint("Error fetching NGOs: $e");
//       setState(() => loading = false);
//     }
//   }

//   double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
//     const double earthRadius = 6371;
//     final dLat = _degToRad(lat2 - lat1);
//     final dLon = _degToRad(lon2 - lon1);
//     final a = sin(dLat / 2) * sin(dLat / 2) +
//         cos(_degToRad(lat1)) * cos(_degToRad(lat2)) *
//             sin(dLon / 2) * sin(dLon / 2);
//     final c = 2 * atan2(sqrt(a), sqrt(1 - a));
//     return earthRadius * c;
//   }

//   double _degToRad(double deg) => deg * (pi / 180);

//   void applyFilters() {
//     List<Map<String, dynamic>> filtered = allNGOs.where((ngo) {
//       final matchesSector = selectedSector == 'All' || ngo['sector'] == selectedSector;
//       final matchesDonation = selectedDonationType == 'All' ||
//           (ngo['acceptedDonations'] as List<dynamic>).contains(selectedDonationType);
//       return matchesSector && matchesDonation;
//     }).toList();

//     setState(() {
//       filteredNGOs = filtered;
//     });
//   }

//   void _openDirections(Map<String, dynamic> ngo) async {
//     final lat = ngo['latitude'];
//     final lng = ngo['longitude'];
//     final name = Uri.encodeComponent(ngo['name'] ?? 'NGO');
//     final url = 'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng&destination_place_id=$name';
//     if (await canLaunchUrl(Uri.parse(url))) {
//       await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
//     } else {
//       throw 'Could not launch $url';
//     }
//   }

//   void _showNGODetails(Map<String, dynamic> ngo) {
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: Text(ngo['name'] ?? 'NGO Details'),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text("Sector: ${ngo['sector']}"),
//             const SizedBox(height: 10),
//             Text("Accepted Donations: ${(ngo['acceptedDonations'] as List<dynamic>).join(', ')}"),
//             const SizedBox(height: 10),
//             Text("Distance: ${ngo['distance'].toStringAsFixed(2)} km"),
//           ],
//         ),
//         actions: [
//           TextButton(
//             child: const Text("Get Directions"),
//             onPressed: () {
//               Navigator.of(context).pop();
//               _openDirections(ngo);
//             },
//           ),
//           TextButton(
//             child: const Text("Close"),
//             onPressed: () => Navigator.of(context).pop(),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Nearest NGOs")),
//       body: loading
//           ? const Center(child: CircularProgressIndicator())
//           : Column(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(12.0),
//                   child: Row(
//                     children: [
//                       Expanded(
//                         child: DropdownButton<String>(
//                           value: selectedSector,
//                           isExpanded: true,
//                           items: sectors.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
//                           onChanged: (val) {
//                             setState(() {
//                               selectedSector = val!;
//                               applyFilters();
//                             });
//                           },
//                         ),
//                       ),
//                       const SizedBox(width: 10),
//                       Expanded(
//                         child: DropdownButton<String>(
//                           value: selectedDonationType,
//                           isExpanded: true,
//                           items: donationTypes.map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(),
//                           onChanged: (val) {
//                             setState(() {
//                               selectedDonationType = val!;
//                               applyFilters();
//                             });
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Expanded(
//                   child: filteredNGOs.isEmpty
//                       ? const Center(child: Text("No NGOs found matching the filters."))
//                       : ListView.builder(
//                           itemCount: filteredNGOs.length,
//                           itemBuilder: (context, index) {
//                             final ngo = filteredNGOs[index];
//                             return Card(
//                               margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                               child: ListTile(
//                                 title: Text(ngo['name'] ?? 'Unnamed NGO'),
//                                 subtitle: Text(
//                                   "${ngo['sector']} • ${ngo['distance'].toStringAsFixed(2)} km away",
//                                 ),
//                                 trailing: const Icon(Icons.arrow_forward_ios),
//                                 onTap: () => _showNGODetails(ngo),
//                               ),
//                             );
//                           },
//                         ),
//                 ),
//               ],
//             ),
//     );
//   }
// }



import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NearestNGOScreen extends StatefulWidget {
  const NearestNGOScreen({super.key});

  @override
  State<NearestNGOScreen> createState() => _NearestNGOScreenState();
}

class _NearestNGOScreenState extends State<NearestNGOScreen> with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> allNGOs = [];
  List<Map<String, dynamic>> filteredNGOs = [];
  bool loading = true;
  String selectedSector = 'All';
  String selectedDonationType = 'All';
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  List<String> sectors = [
    'All',
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

  final List<String> donationTypes = ['All', 'Money', 'Clothes', 'Books'];
  
  // Icons mapping for sectors
  final Map<String, IconData> sectorIcons = {
    'Health': Icons.local_hospital,
    'Education': Icons.school,
    'Environment': Icons.eco,
    'Animal Welfare': Icons.pets,
    'Women Empowerment': Icons.female,
    'Child Welfare': Icons.child_care,
    'Disaster Relief': Icons.warning_amber,
    'Poverty Alleviation': Icons.volunteer_activism,
    'Elderly Care': Icons.elderly,
    'All': Icons.category
  };
  
  // Icons mapping for donation types
  final Map<String, IconData> donationIcons = {
    'Money': Icons.money,
    'Clothes': Icons.checkroom,
    'Books': Icons.book,
    'All': Icons.all_inclusive
  };

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
    fetchNearbyNGOs();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> fetchNearbyNGOs() async {
    try {
      final location = Location();

      bool serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) throw Exception("Location service is disabled.");
      }

      PermissionStatus permissionGranted = await location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          throw Exception("Location permission denied.");
        }
      }

      final userLocation = await location.getLocation();
      final userLat = userLocation.latitude!;
      final userLng = userLocation.longitude!;

      final snapshot = await FirebaseFirestore.instance
          .collection('ngos')
          .where('approved', isEqualTo: true)
          .get();

      List<Map<String, dynamic>> ngos = [];

      for (var doc in snapshot.docs) {
        final data = doc.data();
        if (data['latitude'] != null && data['longitude'] != null) {
          double distance = _calculateDistance(
            userLat,
            userLng,
            data['latitude'],
            data['longitude'],
          );

          ngos.add({
            ...data,
            'id': doc.id,
            'distance': distance,
          });
        }
      }

      ngos.sort((a, b) => a['distance'].compareTo(b['distance']));
      setState(() {
        allNGOs = ngos.take(10).toList();
        filteredNGOs = allNGOs;
        loading = false;
      });
    } catch (e) {
      debugPrint("Error fetching NGOs: $e");
      setState(() => loading = false);
    }
  }

  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371;
    final dLat = _degToRad(lat2 - lat1);
    final dLon = _degToRad(lon2 - lon1);
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degToRad(lat1)) * cos(_degToRad(lat2)) *
            sin(dLon / 2) * sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }

  double _degToRad(double deg) => deg * (pi / 180);

  void applyFilters() {
    List<Map<String, dynamic>> filtered = allNGOs.where((ngo) {
      final matchesSector = selectedSector == 'All' || ngo['sector'] == selectedSector;
      final matchesDonation = selectedDonationType == 'All' ||
          (ngo['acceptedDonations'] as List<dynamic>).contains(selectedDonationType);
      return matchesSector && matchesDonation;
    }).toList();

    setState(() {
      filteredNGOs = filtered;
    });
  }

  void _openDirections(Map<String, dynamic> ngo) async {
    final lat = ngo['latitude'];
    final lng = ngo['longitude'];
    final name = Uri.encodeComponent(ngo['name'] ?? 'NGO');
    final url = 'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng&destination_place_id=$name';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _showNGODetails(Map<String, dynamic> ngo) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(
              sectorIcons[ngo['sector']] ?? Icons.location_on,
              color: const Color(0xFF00A86B),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                ngo['name'] ?? 'NGO Details',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF00A86B),
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow(Icons.category, "Sector", ngo['sector']),
            const SizedBox(height: 15),
            _buildDetailRow(
              Icons.card_giftcard,
              "Accepted Donations", 
              (ngo['acceptedDonations'] as List<dynamic>).join(', ')
            ),
            const SizedBox(height: 15),
            _buildDetailRow(
              Icons.location_on, 
              "Distance", 
              "${ngo['distance'].toStringAsFixed(2)} km"
            ),
          ],
        ),
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.directions, color: Color(0xFF00A86B)),
            label: const Text(
              "Get Directions",
              style: TextStyle(color: Color(0xFF00A86B)),
            ),
            onPressed: () {
              Navigator.of(context).pop();
              _openDirections(ngo);
            },
          ),
          TextButton.icon(
            icon: const Icon(Icons.close, color: Colors.grey),
            label: const Text(
              "Close",
              style: TextStyle(color: Colors.grey),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: const Color(0xFF00A86B), size: 20),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildFilterChip({
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF00A86B) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(15),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF00A86B).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  )
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? Colors.white : const Color(0xFF00A86B),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey.shade800,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: loading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF00A86B),
                ),
              )
            : Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.25,
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
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.arrow_back_ios,
                                    color: Colors.white,
                                  ),
                                  onPressed: () => Navigator.pop(context),
                                ),
                                const Text(
                                  "Nearest NGOs",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              "Find and connect with NGOs near you",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.20,
                    ),
                    child: Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.8,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Filter by Sector",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                SizedBox(
                                  height: 40,
                                  child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    children: sectors.map((sector) {
                                      return _buildFilterChip(
                                        label: sector,
                                        icon: sectorIcons[sector] ?? Icons.category,
                                        isSelected: selectedSector == sector,
                                        onTap: () {
                                          setState(() {
                                            selectedSector = sector;
                                            applyFilters();
                                          });
                                        },
                                      );
                                    }).toList(),
                                  ),
                                ),
                                const SizedBox(height: 15),
                                const Text(
                                  "Filter by Donation Type",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                SizedBox(
                                  height: 40,
                                  child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    children: donationTypes.map((type) {
                                      return _buildFilterChip(
                                        label: type,
                                        icon: donationIcons[type] ?? Icons.card_giftcard,
                                        isSelected: selectedDonationType == type,
                                        onTap: () {
                                          setState(() {
                                            selectedDonationType = type;
                                            applyFilters();
                                          });
                                        },
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Expanded(
                            child: filteredNGOs.isEmpty
                                ? Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.search_off,
                                          size: 60,
                                          color: Colors.grey.shade400,
                                        ),
                                        const SizedBox(height: 15),
                                        Text(
                                          "No NGOs found matching the filters.",
                                          style: TextStyle(
                                            color: Colors.grey.shade600,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        ElevatedButton.icon(
                                          icon: const Icon(Icons.refresh),
                                          label: const Text("Reset Filters"),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: const Color(0xFF00A86B),
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(15),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 20,
                                              vertical: 12,
                                            ),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              selectedSector = 'All';
                                              selectedDonationType = 'All';
                                              filteredNGOs = allNGOs;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  )
                                : ListView.builder(
                                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                                    itemCount: filteredNGOs.length,
                                    itemBuilder: (context, index) {
                                      final ngo = filteredNGOs[index];
                                      return Card(
                                        margin: const EdgeInsets.symmetric(vertical: 8),
                                        elevation: 3,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                        child: InkWell(
                                          borderRadius: BorderRadius.circular(15),
                                          onTap: () => _showNGODetails(ngo),
                                          child: Padding(
                                            padding: const EdgeInsets.all(15),
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: 50,
                                                  height: 50,
                                                  decoration: BoxDecoration(
                                                    color: const Color(0xFF00A86B).withOpacity(0.1),
                                                    borderRadius: BorderRadius.circular(15),
                                                  ),
                                                  child: Icon(
                                                    sectorIcons[ngo['sector']] ?? Icons.location_on,
                                                    color: const Color(0xFF00A86B),
                                                    size: 26,
                                                  ),
                                                ),
                                                const SizedBox(width: 15),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        ngo['name'] ?? 'Unnamed NGO',
                                                        style: const TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 5),
                                                      Row(
                                                        children: [
                                                          Icon(
                                                            Icons.category,
                                                            size: 14,
                                                            color: Colors.grey.shade600,
                                                          ),
                                                          const SizedBox(width: 5),
                                                          Text(
                                                            ngo['sector'],
                                                            style: TextStyle(
                                                              color: Colors.grey.shade600,
                                                              fontSize: 14,
                                                            ),
                                                          ),
                                                          const SizedBox(width: 15),
                                                          Icon(
                                                            Icons.location_on,
                                                            size: 14,
                                                            color: Colors.grey.shade600,
                                                          ),
                                                          const SizedBox(width: 5),
                                                          Text(
                                                            "${ngo['distance'].toStringAsFixed(2)} km",
                                                            style: TextStyle(
                                                              color: Colors.grey.shade600,
                                                              fontSize: 14,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                Container(
                                                  width: 40,
                                                  height: 40,
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey.shade100,
                                                    borderRadius: BorderRadius.circular(12),
                                                  ),
                                                  child: IconButton(
                                                    icon: const Icon(
                                                      Icons.directions,
                                                      color: Color(0xFF00A86B),
                                                      size: 20,
                                                    ),
                                                    onPressed: () => _openDirections(ngo),
                                                  ),
                                                ),
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
                  ),
                ],
              ),
      ),
    );
  }
}