// import 'package:flutter/material.dart';
// import 'dart:ui';

// class CelebrityFeatureScreen extends StatefulWidget {
//   const CelebrityFeatureScreen({super.key});

//   @override
//   _CelebrityFeatureScreenState createState() => _CelebrityFeatureScreenState();
// }

// class _CelebrityFeatureScreenState extends State<CelebrityFeatureScreen> {
//   final List<Map<String, String>> celebrities = [
//     {'name': 'John Doe', 'contact': 'john@example.com', 'cause': 'Health'},
//     {'name': 'Jane Smith', 'contact': 'jane@example.com', 'cause': 'Education'},
//     {'name': 'Alice Johnson', 'contact': 'alice@example.com', 'cause': 'Environment'},
//     {'name': 'Bob Williams', 'contact': 'bob@example.com', 'cause': 'Animal Welfare'},
//     {'name': 'Emma Brown', 'contact': 'emma@example.com', 'cause': 'Women Empowerment'},
//   ];

//   String selectedCause = 'Health';
//   final List<String> causes = [
//     'Health',
//     'Education',
//     'Environment',
//     'Animal Welfare',
//     'Women Empowerment',
//     'Child Welfare',
//     'Disaster Relief',
//     'Poverty',
//     'Elderly Care'
//   ];

//   @override
//   Widget build(BuildContext context) {
//     final filteredCelebrities =
//         celebrities.where((celeb) => celeb['cause'] == selectedCause).toList();

//     return Scaffold(
//       extendBodyBehindAppBar: true,
//       appBar: AppBar(
//         title: const Text('Celebrity Supporters', style: TextStyle(fontWeight: FontWeight.bold)),
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         centerTitle: true,
//       ),
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Color(0xFFE0F7FA), Color(0xFFFFF3E0)],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//         ),
//         child: SafeArea(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//             child: Column(
//               children: [
//                 // Dropdown Filter with Glass Effect
//                 GlassCard(
//                   child: DropdownButtonHideUnderline(
//                     child: DropdownButton<String>(
//                       value: selectedCause,
//                       icon: const Icon(Icons.arrow_drop_down, color: Colors.teal),
//                       isExpanded: true,
//                       style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black),
//                       items: causes.map((cause) {
//                         return DropdownMenuItem(
//                           value: cause,
//                           child: Text(cause),
//                         );
//                       }).toList(),
//                       onChanged: (newValue) {
//                         setState(() {
//                           selectedCause = newValue!;
//                         });
//                       },
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 // Celebrity List
//                 Expanded(
//                   child: filteredCelebrities.isEmpty
//                       ? const Center(
//                           child: Text("No celebrities found for this cause.",
//                               style: TextStyle(color: Colors.black54)))
//                       : ListView.separated(
//                           itemCount: filteredCelebrities.length,
//                           separatorBuilder: (context, index) => const SizedBox(height: 16),
//                           itemBuilder: (context, index) {
//                             final celeb = filteredCelebrities[index];
//                             return GlassCard(
//                               padding: const EdgeInsets.all(16),
//                               child: Row(
//                                 children: [
//                                   CircleAvatar(
//                                     backgroundColor: Colors.teal.shade100,
//                                     child: Text(
//                                       celeb['name']!.substring(0, 1),
//                                       style: const TextStyle(
//                                           fontWeight: FontWeight.bold, color: Colors.black),
//                                     ),
//                                   ),
//                                   const SizedBox(width: 16),
//                                   Expanded(
//                                     child: Column(
//                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                       children: [
//                                         Text(celeb['name']!,
//                                             style: const TextStyle(
//                                                 fontWeight: FontWeight.bold, fontSize: 16)),
//                                         const SizedBox(height: 4),
//                                         Text('📧 ${celeb['contact']}',
//                                             style: const TextStyle(color: Colors.black54)),
//                                       ],
//                                     ),
//                                   ),
//                                   const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.teal),
//                                 ],
//                               ),
//                             );
//                           },
//                         ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// // GlassCard Widget for glassmorphic style
// class GlassCard extends StatelessWidget {
//   final Widget child;
//   final EdgeInsetsGeometry padding;

//   const GlassCard({super.key, required this.child, this.padding = const EdgeInsets.all(12)});

//   @override
//   Widget build(BuildContext context) {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(20),
//       child: BackdropFilter(
//         filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//         child: Container(
//           width: double.infinity,
//           padding: padding,
//           decoration: BoxDecoration(
//             color: Colors.white.withOpacity(0.4),
//             borderRadius: BorderRadius.circular(20),
//             border: Border.all(color: Colors.white.withOpacity(0.2)),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.05),
//                 blurRadius: 8,
//                 offset: const Offset(0, 4),
//               ),
//             ],
//           ),
//           child: child,
//         ),
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'dart:ui';

class CelebrityFeatureScreen extends StatefulWidget {
  const CelebrityFeatureScreen({super.key});

  @override
  _CelebrityFeatureScreenState createState() => _CelebrityFeatureScreenState();
}

class _CelebrityFeatureScreenState extends State<CelebrityFeatureScreen> with SingleTickerProviderStateMixin {
  // Enhanced celebrity data with more information
  final List<Map<String, dynamic>> celebrities = [
    {
      'name': 'John Doe', 
      'contact': 'john@example.com', 
      'cause': 'Health',
      'image': 'lib/assets/profile1.png',
      'followers': '2.5M',
      'campaigns': 5,
      'bio': 'Award-winning actor passionate about healthcare accessibility for all.'
    },
    {
      'name': 'Jane Smith', 
      'contact': 'jane@example.com', 
      'cause': 'Education',
      'image': 'lib/assets/profile2.png',
      'followers': '1.8M',
      'campaigns': 3,
      'bio': 'Renowned musician dedicated to equal education opportunities worldwide.'
    },
    {
      'name': 'Alice Johnson', 
      'contact': 'alice@example.com', 
      'cause': 'Environment',
      'image': 'lib/assets/profile3.png',
      'followers': '3.2M',
      'campaigns': 7,
      'bio': 'Environmental activist and filmmaker focused on climate change awareness.'
    },
    {
      'name': 'Bob Williams', 
      'contact': 'bob@example.com', 
      'cause': 'Animal Welfare',
      'image': 'lib/assets/profile4.png',
      'followers': '1.2M',
      'campaigns': 4,
      'bio': 'Professional athlete advocating for animal rights and welfare globally.'
    },
    {
      'name': 'Emma Brown', 
      'contact': 'emma@example.com', 
      'cause': 'Women Empowerment',
      'image': 'lib/assets/profile5.png',
      'followers': '4.1M',
      'campaigns': 8,
      'bio': 'Best-selling author championing gender equality and women\'s rights.'
    },
  ];

  String selectedCause = 'All Causes';
  final List<String> causes = [
    'All Causes',
    'Health',
    'Education',
    'Environment',
    'Animal Welfare',
    'Women Empowerment',
    'Child Welfare',
    'Disaster Relief',
    'Poverty',
    'Elderly Care'
  ];

  String searchQuery = '';
  bool isSearching = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
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
    _animationController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> getFilteredCelebrities() {
    return celebrities.where((celeb) {
      bool causeMatch = selectedCause == 'All Causes' || celeb['cause'] == selectedCause;
      bool searchMatch = searchQuery.isEmpty || 
          celeb['name'].toString().toLowerCase().contains(searchQuery.toLowerCase()) || 
          celeb['cause'].toString().toLowerCase().contains(searchQuery.toLowerCase()) ||
          celeb['bio'].toString().toLowerCase().contains(searchQuery.toLowerCase());
      return causeMatch && searchMatch;
    }).toList();
  }

  void _showCelebrityDetails(Map<String, dynamic> celebrity) {
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
        child: Column(
          children: [
            Container(
              height: 5,
              width: 40,
              margin: const EdgeInsets.only(top: 15, bottom: 15),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Column(
                        children: [
                          Hero(
                            tag: 'celebrity-${celebrity['name']}',
                            child: CircleAvatar(
                              radius: 60,
                              backgroundColor: const Color(0xFF00A86B).withOpacity(0.2),
                              child: Text(
                                celebrity['name'].substring(0, 1),
                                style: const TextStyle(
                                  fontSize: 50,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF00A86B),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          Text(
                            celebrity['name'],
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF00A86B).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              celebrity['cause'],
                              style: const TextStyle(
                                color: Color(0xFF00A86B),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    _buildInfoSection('Bio', celebrity['bio']),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStatCard('Followers', celebrity['followers']),
                        _buildStatCard('Campaigns', '${celebrity['campaigns']}'),
                      ],
                    ),
                    const SizedBox(height: 30),
                    _buildInfoSection('Contact', celebrity['contact']),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Request sent to connect with this celebrity!'),
                              backgroundColor: Color(0xFF00A86B),
                            ),
                          );
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00A86B),
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: const Text(
                          'REQUEST TO CONNECT',
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF00A86B),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          content,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.4,
      padding: const EdgeInsets.all(15),
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
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF00A86B),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredCelebrities = getFilteredCelebrities();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF00A86B),
        elevation: 0,
        title: !isSearching
            ? const Text(
                'Celebrity Supporters',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              )
            : TextField(
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Search celebrities...',
                  hintStyle: TextStyle(color: Colors.white70),
                  border: InputBorder.none,
                ),
                autofocus: true,
              ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                isSearching = !isSearching;
                if (!isSearching) {
                  searchQuery = '';
                }
              });
            },
            color: Colors.white,
          ),
        ],
      ),
      body: Column(
        children: [
          // Top Container with Gradient
          Container(
            width: double.infinity,
            height: 150,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF00A86B), Color(0xFF009160)],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Stack(
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Connect with Influencers',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Discover celebrities who support causes that matter to you',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: -15,
                  left: 20,
                  right: 20,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedCause,
                        icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF00A86B)),
                        isExpanded: true,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                          fontSize: 16,
                        ),
                        items: causes.map((cause) {
                          return DropdownMenuItem(
                            value: cause,
                            child: Text(cause),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            selectedCause = newValue!;
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 25),
          // Celebrity List
          Expanded(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: filteredCelebrities.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.person_off,
                            size: 70,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 15),
                          Text(
                            "No celebrities found",
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "Try another cause or search term",
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: filteredCelebrities.length,
                      itemBuilder: (context, index) {
                        final celebrity = filteredCelebrities[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: GestureDetector(
                            onTap: () => _showCelebrityDetails(celebrity),
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
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Hero(
                                      tag: 'celebrity-${celebrity['name']}',
                                      child: CircleAvatar(
                                        radius: 30,
                                        backgroundColor: const Color(0xFF00A86B).withOpacity(0.2),
                                        child: Text(
                                          celebrity['name'].substring(0, 1),
                                          style: const TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF00A86B),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 15),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                celebrity['name'],
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                              Container(
                                                padding: const EdgeInsets.symmetric(
                                                  horizontal: 10,
                                                  vertical: 5,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFF00A86B).withOpacity(0.1),
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                child: Text(
                                                  celebrity['cause'],
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xFF00A86B),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            celebrity['bio'],
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.grey.shade600,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.people,
                                                size: 14,
                                                color: Colors.grey.shade500,
                                              ),
                                              const SizedBox(width: 5),
                                              Text(
                                                celebrity['followers'],
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey.shade600,
                                                ),
                                              ),
                                              const SizedBox(width: 15),
                                              Icon(
                                                Icons.campaign,
                                                size: 14,
                                                color: Colors.grey.shade500,
                                              ),
                                              const SizedBox(width: 5),
                                              Text(
                                                '${celebrity['campaigns']} campaigns',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey.shade600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Icon(
                                      Icons.arrow_forward_ios,
                                      size: 16,
                                      color: Color(0xFF00A86B),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('You can suggest celebrities to add to our network!'),
              backgroundColor: Color(0xFF00A86B),
            ),
          );
        },
        backgroundColor: const Color(0xFF00A86B),
        child: const Icon(Icons.add),
      ),
    );
  }
}