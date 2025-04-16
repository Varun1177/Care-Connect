import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class UserNGOListScreen extends StatefulWidget {
  const UserNGOListScreen({super.key});

  @override
  State<UserNGOListScreen> createState() => _UserNGOListScreenState();
}

class _UserNGOListScreenState extends State<UserNGOListScreen> with SingleTickerProviderStateMixin {
  String _searchText = "";
  String? _selectedSector;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  final List<String> _sectors = [
    'All Sectors',
    'Education',
    'Healthcare',
    'Environment',
    'Animal Welfare',
    'Poverty Alleviation',
    'Children & Youth',
    'Disaster Relief',
    'Human Rights',
    'Others'
  ];

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
    _selectedSector = 'All Sectors';
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Filter by Sector',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF00A86B),
                  ),
                ),
                const SizedBox(height: 15),
                SizedBox(
                  height: 300,
                  width: double.maxFinite,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _sectors.length,
                    itemBuilder: (context, index) {
                      final sector = _sectors[index];
                      return RadioListTile<String>(
                        title: Text(sector),
                        value: sector,
                        groupValue: _selectedSector,
                        activeColor: const Color(0xFF00A86B),
                        onChanged: (String? value) {
                          Navigator.pop(context);
                          setState(() {
                            _selectedSector = value;
                          });
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showNGODetails(DocumentSnapshot ngo) {
    // Safely extract data with type checking
    final name = ngo['name'] as String;
    
    // Handle potentially problematic fields with safe conversion
    final description = ngo['description'] != null 
        ? ngo['description'] is String 
            ? ngo['description'] as String 
            : ngo['description'].toString()
        : 'No description available';
        
    final sector = ngo['sector'] != null 
        ? ngo['sector'] is String 
            ? ngo['sector'] as String 
            : ngo['sector'].toString()
        : 'Not specified';
        
    final acceptedDonations = ngo['acceptedDonations'] != null 
        ? ngo['acceptedDonations'] is String 
            ? ngo['acceptedDonations'] as String 
            : ngo['acceptedDonations'] is List 
                ? (ngo['acceptedDonations'] as List).join(', ') 
                : ngo['acceptedDonations'].toString()
        : 'Any donations';
        
    final registeredBy = ngo['personName'] != null 
        ? ngo['personName'] is String 
            ? ngo['personName'] as String 
            : ngo['personName'].toString()
        : 'Not specified';
        
    final registrarRole = ngo['personRole'] != null 
        ? ngo['personRole'] is String 
            ? ngo['personRole'] as String 
            : ngo['personRole'].toString()
        : 'Member';
        
    final ngoId = ngo.id;
    
    // Get logo URL
    final logoUrl = ngo['logoUrl'] != null 
        ? ngo['logoUrl'] as String 
        : null;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(25, 30, 25, 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Logo and name
                  Row(
                    children: [
                      // Use actual logo if available
                      Container(
                        width: 60,
                        height: 60,
                        padding: logoUrl == null ? const EdgeInsets.all(15) : EdgeInsets.zero,
                        decoration: BoxDecoration(
                          color: logoUrl == null ? const Color(0xFF00A86B).withOpacity(0.1) : null,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: logoUrl != null ? [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              spreadRadius: 1,
                            ),
                          ] : null,
                        ),
                        child: logoUrl != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: CachedNetworkImage(
                                imageUrl: logoUrl,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => const Center(
                                  child: SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Color(0xFF00A86B),
                                    ),
                                  ),
                                ),
                                errorWidget: (context, url, error) => const Icon(
                                  Icons.handshake_outlined,
                                  color: Color(0xFF00A86B),
                                  size: 30,
                                ),
                              ),
                            )
                          : const Icon(
                              Icons.handshake_outlined,
                              color: Color(0xFF00A86B),
                              size: 30,
                            ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Text(
                          name,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  
                  // Information section
                  _buildDetailSection('Sector', sector),
                  _buildDetailSection('Accepted Donations', acceptedDonations),
                  _buildDetailSection('Registered By', registeredBy),
                  _buildDetailSection('Registrar Role', registrarRole),
                  
                  // Description
                  const SizedBox(height: 20),
                  const Text(
                    'About',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF00A86B),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey.shade700,
                      height: 1.5,
                    ),
                  ),
                  
                  // People joined
                  const SizedBox(height: 25),
                  FutureBuilder<QuerySnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('ngo_join_requests')
                        .where('ngoId', isEqualTo: ngoId)
                        .get(),
                    builder: (context, requestSnapshot) {
                      if (!requestSnapshot.hasData) {
                        return const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Color(0xFF00A86B),
                          ),
                        );
                      }
                      final count = requestSnapshot.data!.docs.length;
                      return Container(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.group,
                              size: 22,
                              color: Color(0xFF00A86B),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              "$count people have joined this NGO",
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  
                  // Join button
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () {
                        _sendJoinRequest(ngoId);
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00A86B),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Text(
                        'JOIN NOW',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailSection(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              title,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to get NGO icon based on sector
  IconData _getNGOIcon(String sector) {
    switch (sector.toLowerCase()) {
      case 'education':
        return Icons.school;
      case 'healthcare':
        return Icons.medical_services;
      case 'environment':
        return Icons.eco;
      case 'animal welfare':
        return Icons.pets;
      case 'poverty alleviation':
        return Icons.home;
      case 'children & youth':
        return Icons.child_care;
      case 'disaster relief':
        return Icons.warning;
      case 'human rights':
        return Icons.people;
      default:
        return Icons.handshake_outlined;
    }
  }

  // Helper method to get color for NGO icon based on sector
  Color _getNGOIconColor(String sector) {
    switch (sector.toLowerCase()) {
      case 'education':
        return const Color(0xFF4C51BF); // Indigo
      case 'healthcare':
        return const Color(0xFFE53E3E); // Red
      case 'environment':
        return const Color(0xFF38A169); // Green
      case 'animal welfare':
        return const Color(0xFFDD6B20); // Orange
      case 'poverty alleviation':
        return const Color(0xFF805AD5); // Purple
      case 'children & youth':
        return const Color(0xFF3182CE); // Blue
      case 'disaster relief':
        return const Color(0xFFD69E2E); // Yellow
      case 'human rights':
        return const Color(0xFF718096); // Gray
      default:
        return const Color(0xFF00A86B); // Default Green
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            // Header with gradient background
            Container(
              height: screenSize.height * 0.22,
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
              child: const SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Explore NGOs',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Find and join organizations making a difference',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // Search Bar with Filter
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 20, 25, 10),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: TextField(
                        style: const TextStyle(fontSize: 16),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(vertical: 20),
                          border: InputBorder.none,
                          hintText: 'Search NGOs...',
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Color(0xFF00A86B),
                          ),
                          hintStyle: TextStyle(color: Colors.grey.shade700),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _searchText = value.trim().toLowerCase();
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  InkWell(
                    onTap: _showFilterDialog,
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: const Color(0xFF00A86B),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF00A86B).withOpacity(0.3),
                            blurRadius: 10,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.filter_list,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Selected filter indicator
            if (_selectedSector != 'All Sectors')
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                child: Row(
                  children: [
                    const Text(
                      'Filtered by: ',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF00A86B),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF00A86B).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Text(
                            _selectedSector!,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF00A86B),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 5),
                          InkWell(
                            onTap: () {
                              setState(() {
                                _selectedSector = 'All Sectors';
                              });
                            },
                            child: const Icon(
                              Icons.close,
                              color: Color(0xFF00A86B),
                              size: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            
            // NGO Grid
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('ngos')
                    .where('approved', isEqualTo: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF00A86B),
                      ),
                    );
                  }

                  final ngos = snapshot.data!.docs.where((doc) {
                    final name = doc['name'].toString().toLowerCase();
                    final sector = doc['sector']?.toString() ?? '';
                    
                    // Filter by search text
                    final matchesSearch = name.contains(_searchText);
                    
                    // Filter by sector if not "All Sectors"
                    final matchesSector = _selectedSector == 'All Sectors' || 
                                          sector == _selectedSector;
                    
                    return matchesSearch && matchesSector;
                  }).toList();

                  if (ngos.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 70,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 15),
                          Text(
                            "No NGOs found",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "Try different search terms",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  // Use GridView.builder instead of ListView.builder
                  return GridView.builder(
                    padding: const EdgeInsets.all(20),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.0,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: ngos.length,
                    itemBuilder: (context, index) {
                      final ngo = ngos[index];
                      final name = ngo['name'];
                      final sector = ngo['sector'] ?? 'Not specified';
                      final iconData = _getNGOIcon(sector);
                      final iconColor = _getNGOIconColor(sector);
                      
                      // Get logo URL if available
                      final logoUrl = ngo['logoUrl'] as String?;

                      // Create square tile
                      return InkWell(
                        onTap: () => _showNGODetails(ngo),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // NGO logo (use actual image if available, or icon as fallback)
                              Expanded(
                                flex: 3,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: logoUrl != null && logoUrl.isNotEmpty
                                    ? Center(
                                        child: Container(
                                          width: 90,
                                          height: 90,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(15),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(0.05),
                                                blurRadius: 5,
                                                spreadRadius: 1,
                                              ),
                                            ],
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(15),
                                            child: CachedNetworkImage(
                                              imageUrl: logoUrl,
                                              fit: BoxFit.cover,
                                              placeholder: (context, url) => Container(
                                                color: Colors.grey.shade100,
                                                child: const Center(
                                                  child: SizedBox(
                                                    width: 20,
                                                    height: 20,
                                                    child: CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                      color: Color(0xFF00A86B),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              errorWidget: (context, url, error) => Container(
                                                padding: const EdgeInsets.all(20),
                                                decoration: BoxDecoration(
                                                  color: iconColor.withOpacity(0.1),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Icon(
                                                  iconData,
                                                  color: iconColor,
                                                  size: 40,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container(
                                        margin: const EdgeInsets.symmetric(horizontal: 25),
                                        padding: const EdgeInsets.all(20),
                                        decoration: BoxDecoration(
                                          color: iconColor.withOpacity(0.1),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          iconData,
                                          color: iconColor,
                                          size: 40,
                                        ),
                                      ),
                                ),
                              ),
                              // NGO name
                              Expanded(
                                flex: 2,
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 5),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: iconColor.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          sector,
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: iconColor,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
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
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _sendJoinRequest(String ngoId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(
          color: Color(0xFF00A86B),
        ),
      ),
    );

    try {
      final query = await FirebaseFirestore.instance
          .collection('ngo_join_requests')
          .where('userId', isEqualTo: user.uid)
          .where('ngoId', isEqualTo: ngoId)
          .get();

      // Close loading dialog
      Navigator.pop(context);

      if (query.docs.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("You already requested to join this NGO"),
            backgroundColor: Color(0xFF00A86B),
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }

      await FirebaseFirestore.instance.collection('ngo_join_requests').add({
        'userId': user.uid,
        'ngoId': ngoId,
        'status': 'pending',
        'requestedAt': Timestamp.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Join request sent successfully!"),
          backgroundColor: Color(0xFF00A86B),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      // Close loading dialog
      Navigator.pop(context);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: ${e.toString()}"),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}