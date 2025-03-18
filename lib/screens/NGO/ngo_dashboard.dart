// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class NGODashboard extends StatefulWidget {
//   const NGODashboard({super.key});

//   @override
//   _NGODashboardState createState() => _NGODashboardState();
// }

// class _NGODashboardState extends State<NGODashboard> {
//   String? userEmail;
//   DocumentSnapshot? ngoData;
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     fetchNGOData();
//   }

//   Future<void> fetchNGOData() async {
//     User? user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       userEmail = user.email;
//       try {
//         QuerySnapshot pendingQuery = await FirebaseFirestore.instance
//             .collection('pending_approvals')
//             .where('email', isEqualTo: userEmail)
//             .limit(1)
//             .get();

//         QuerySnapshot approvedQuery = await FirebaseFirestore.instance
//             .collection('approved_ngos')
//             .where('email', isEqualTo: userEmail)
//             .limit(1)
//             .get();

//         if (approvedQuery.docs.isNotEmpty) {
//           ngoData = approvedQuery.docs.first;
//         } else if (pendingQuery.docs.isNotEmpty) {
//           ngoData = pendingQuery.docs.first;
//         }

//       } catch (e) {
//         print("Error fetching NGO data: $e");
//       }
//     }

//     setState(() {
//       isLoading = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (isLoading) {
//       return Scaffold(
//         appBar: AppBar(title: const Text("NGO Dashboard")),
//         body: const Center(child: CircularProgressIndicator()),
//       );
//     }

//     if (ngoData == null) {
//       return Scaffold(
//         appBar: AppBar(title: const Text("NGO Dashboard")),
//         body: const Center(
//           child: Text("No NGO data found. Please register first."),
//         ),
//       );
//     }

//     bool isApproved = ngoData!.reference.parent.id == 'approved_ngos';

//     return Scaffold(
//       appBar: AppBar(title: const Text("NGO Dashboard")),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // NGO Logo
//             Center(
//               child: CircleAvatar(
//                 radius: 50,
//                 backgroundImage: ngoData!['logoUrl'] != null
//                     ? NetworkImage(ngoData!['logoUrl'])
//                     : null,
//                 child: ngoData!['logoUrl'] == null
//                     ? const Icon(Icons.image, size: 40)
//                     : null,
//               ),
//             ),
//             const SizedBox(height: 15),

//             // NGO Details
//             Text("NGO Name: ${ngoData!['ngoName']}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             Text("Sector: ${ngoData!['sector']}", style: const TextStyle(fontSize: 16)),
//             Text("Description: ${ngoData!['description']}", style: const TextStyle(fontSize: 16)),
//             const SizedBox(height: 20),

//             // Status Message
//             Center(
//               child: Text(
//                 isApproved
//                     ? "Your NGO is Approved! 🎉"
//                     : "Your NGO is Pending Approval 🚀",
//                 style: TextStyle(
//                   fontSize: 16,
//                   color: isApproved ? Colors.green : Colors.orange,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),

//             const SizedBox(height: 30),

//             // Locked Features Until Approval
//             ElevatedButton(
//               onPressed: isApproved ? () => navigateToFeature() : null,
//               style: ElevatedButton.styleFrom(
//                 minimumSize: const Size(double.infinity, 50),
//                 backgroundColor: isApproved ? Colors.blue : Colors.grey,
//               ),
//               child: Text(
//                 isApproved ? "Access NGO Features" : "Waiting for Approval...",
//                 style: const TextStyle(fontSize: 16),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void navigateToFeature() {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text("Navigating to NGO Features..."))
//     );
//     // Navigate to the actual NGO features screen here.
//   }
// }



import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NGODashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("NGO Dashboard")),
        body: const Center(child: Text("Please log in first.")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("NGO Dashboard")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('approved_ngos')
            .where('email', isEqualTo: user.email)
            .snapshots(), // 🔥 Listens for real-time updates!
        builder: (context, approvedSnapshot) {
          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('pending_approvals')
                .where('email', isEqualTo: user.email)
                .snapshots(), // 🔥 Listens for real-time updates!
            builder: (context, pendingSnapshot) {
              if (approvedSnapshot.connectionState == ConnectionState.waiting ||
                  pendingSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              // ✅ NGO is approved
              if (approvedSnapshot.hasData && approvedSnapshot.data!.docs.isNotEmpty) {
                var ngoData = approvedSnapshot.data!.docs.first;
                return NGOApprovedView(ngoData: ngoData);
              }

              // 🚀 NGO is pending approval
              if (pendingSnapshot.hasData && pendingSnapshot.data!.docs.isNotEmpty) {
                return PendingApprovalView();
              }

              // ❌ NGO not found
              return const Center(
                child: Text("No NGO data found. Please register first."),
              );
            },
          );
        },
      ),
    );
  }
}

class NGOApprovedView extends StatelessWidget {
  final DocumentSnapshot ngoData;

  const NGOApprovedView({required this.ngoData});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // NGO Logo
          Center(
            child: CircleAvatar(
              radius: 50,
              backgroundImage: ngoData['logoUrl'] != null
                  ? NetworkImage(ngoData['logoUrl'])
                  : null,
              child: ngoData['logoUrl'] == null
                  ? const Icon(Icons.image, size: 40)
                  : null,
            ),
          ),
          const SizedBox(height: 15),

          // NGO Details
          Text("NGO Name: ${ngoData['ngoName']}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text("Sector: ${ngoData['sector']}", style: const TextStyle(fontSize: 16)),
          Text("Description: ${ngoData['description']}", style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 20),

          // Status Message
          Center(
            child: Text(
              "Your NGO is Approved! 🎉",
              style: const TextStyle(fontSize: 16, color: Colors.green, fontWeight: FontWeight.bold),
            ),
          ),

          const SizedBox(height: 30),

          // Button to access NGO Features
          ElevatedButton(
            onPressed: () => navigateToFeature(context),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              backgroundColor: Colors.blue,
            ),
            child: const Text("Access NGO Features", style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }

  void navigateToFeature(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Navigating to NGO Features...")),
    );
    // TODO: Navigate to NGO feature screen
  }
}

class PendingApprovalView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Your NGO is Pending Approval 🚀",
        style: TextStyle(fontSize: 16, color: Colors.orange, fontWeight: FontWeight.bold),
      ),
    );
  }
}
