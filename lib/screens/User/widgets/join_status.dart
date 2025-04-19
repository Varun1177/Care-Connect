// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class JoinStatusScreen extends StatelessWidget {
//   const JoinStatusScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final String userId = FirebaseAuth.instance.currentUser!.uid;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("My NGO Requests"),
//         backgroundColor: Colors.teal,
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('ngo_join_requests')
//             .where('userId', isEqualTo: userId)
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           final requests = snapshot.data?.docs ?? [];

//           if (requests.isEmpty) {
//             return const Center(
//               child: Text("No join requests found."),
//             );
//           }

//           return ListView.builder(
//             itemCount: requests.length,
//             itemBuilder: (context, index) {
//               final request = requests[index];
//               final ngoId = request['ngoId'];
//               final status = request['status'];

//               return FutureBuilder<DocumentSnapshot>(
//                 future: FirebaseFirestore.instance.collection('ngos').doc(ngoId).get(),
//                 builder: (context, ngoSnapshot) {
//                   if (!ngoSnapshot.hasData) {
//                     return const ListTile(title: Text("Loading NGO..."));
//                   }

//                   final ngoData = ngoSnapshot.data!.data() as Map<String, dynamic>?;

//                   return Card(
//                     margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                     child: ListTile(
//                       title: Text(ngoData?['name'] ?? 'Unknown NGO'),
//                       subtitle: Text('Status: ${status.toUpperCase()}'),
//                       trailing: status == 'pending'
//                           ? const Icon(Icons.hourglass_top, color: Colors.orange)
//                           : status == 'approved'
//                               ? const Icon(Icons.check_circle, color: Colors.green)
//                               : const Icon(Icons.cancel, color: Colors.red),
//                     ),
//                   );
//                 },
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }



import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class JoinStatusScreen extends StatefulWidget {
  const JoinStatusScreen({super.key});

  @override
  State<JoinStatusScreen> createState() => _JoinStatusScreenState();
}

class _JoinStatusScreenState extends State<JoinStatusScreen> with SingleTickerProviderStateMixin {
  final String userId = FirebaseAuth.instance.currentUser!.uid;
  String _selectedFilter = 'All';
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
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _showLeaveConfirmationDialog(BuildContext context, String requestId, String ngoName) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text('Confirm Action'),
        content: Text('Are you sure you want to leave or withdraw your request from $ngoName?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel', style: TextStyle(color: Colors.grey.shade700)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              try {
                await FirebaseFirestore.instance
                    .collection('ngo_join_requests')
                    .doc(requestId)
                    .delete();
                
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Request removed successfully'),
                    backgroundColor: Color(0xFF00A86B),
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error: ${e.toString()}'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00A86B),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Confirm', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            _buildHeader(),
            _buildFilterChips(),
            Expanded(
              child: _buildRequestsList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 180,
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                ),
                const Text(
                  'My NGO Requests',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Track your NGO join requests',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildFilterChip('All'),
          const SizedBox(width: 10),
          _buildFilterChip('Pending'),
          const SizedBox(width: 10),
          _buildFilterChip('Approved'),
          const SizedBox(width: 10),
          _buildFilterChip('Rejected'),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _selectedFilter == label;
    
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      showCheckmark: false,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : const Color(0xFF00A86B),
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      backgroundColor: Colors.grey.shade100,
      selectedColor: const Color(0xFF00A86B),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(
          color: isSelected ? Colors.transparent : const Color(0xFF00A86B),
          width: 1,
        ),
      ),
      onSelected: (selected) {
        setState(() {
          _selectedFilter = label;
        });
      },
    );
  }

  Widget _buildRequestsList() {
    Query query = FirebaseFirestore.instance
        .collection('ngo_join_requests')
        .where('userId', isEqualTo: userId);

    if (_selectedFilter != 'All') {
      query = query.where('status', isEqualTo: _selectedFilter.toLowerCase());
    }

    return StreamBuilder<QuerySnapshot>(
      stream: query.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF00A86B),
            ),
          );
        }

        final requests = snapshot.data?.docs ?? [];

        if (requests.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search_off,
                  size: 70,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 16),
                Text(
                  "No ${_selectedFilter.toLowerCase()} requests found",
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: requests.length,
          itemBuilder: (context, index) {
            final request = requests[index];
            final requestId = request.id;
            final ngoId = request['ngoId'];
            final status = request['status'];
            final requestDate = (request['requestedAt'] as Timestamp?)?.toDate() ?? DateTime.now();

            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance.collection('ngos').doc(ngoId).get(),
              builder: (context, ngoSnapshot) {
                if (!ngoSnapshot.hasData) {
                  return _buildSkeletonCard();
                }

                final ngoData = ngoSnapshot.data!.data() as Map<String, dynamic>?;
                final ngoName = ngoData?['name'] ?? 'Unknown NGO';

                return GestureDetector(
                  onTap: () {
                    _showLeaveConfirmationDialog(context, requestId, ngoName);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                status == 'pending' ? Colors.orange.shade300 : 
                                status == 'approved' ? const Color(0xFF00A86B) : Colors.red.shade300,
                                status == 'pending' ? Colors.orange.shade400 : 
                                status == 'approved' ? const Color(0xFF009160) : Colors.red.shade400,
                              ],
                            ),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  ngoName,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Text(
                                  status.toUpperCase(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.calendar_today,
                                    size: 16,
                                    color: Color(0xFF00A86B),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Requested on: ${requestDate.day}/${requestDate.month}/${requestDate.year}',
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  status == 'pending'
                                      ? const Icon(Icons.hourglass_top, color: Colors.orange)
                                      : status == 'approved'
                                          ? const Icon(Icons.check_circle, color: Color(0xFF00A86B))
                                          : const Icon(Icons.cancel, color: Colors.red),
                                  const SizedBox(width: 8),
                                  Text(
                                    status == 'pending'
                                        ? 'Your request is being reviewed'
                                        : status == 'approved'
                                            ? 'You are a member of this NGO'
                                            : 'Your request was declined',
                                    style: TextStyle(
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Text(
                                  'Tap to view options',
                                  style: TextStyle(
                                    color: Colors.grey.shade400,
                                    fontSize: 12,
                                    fontStyle: FontStyle.italic,
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
              },
            );
          },
        );
      },
    );
  }

  Widget _buildSkeletonCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      height: 140,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.grey.shade300),
        ),
      ),
    );
  }
}