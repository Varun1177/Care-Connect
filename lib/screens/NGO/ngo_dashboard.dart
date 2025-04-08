// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:care__connect/services/auth_service.dart';
// import 'package:care__connect/screens/login_screen.dart';
// import 'widgets/approved_ngo_view.dart';
// import 'widgets/pending_approval_view.dart';

// class NGODashboard extends StatelessWidget {
//   const NGODashboard({Key? key}) : super(key: key);

//   // Sign out using your AuthService.
//   void _signOut(BuildContext context) async {
//     await AuthService().signOut();
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (context) => const LoginScreen()),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     User? user = FirebaseAuth.instance.currentUser;

//     // If user is not logged in, display a not‑logged‑in view.
//     if (user == null) {
//       return _buildNotLoggedInView(context);
//     }

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           "NGO Dashboard",
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         elevation: 0,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.logout),
//             tooltip: "Logout",
//             onPressed: () => _signOut(context),
//           ),
//         ],
//       ),
//       body: _buildDashboardContent(context, user),
//     );
//   }

//   Widget _buildNotLoggedInView(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("NGO Dashboard"),
//         elevation: 0,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.logout),
//             onPressed: () => _signOut(context),
//           ),
//         ],
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.account_circle_outlined,
//                 size: 80,
//                 color: Theme.of(context).primaryColor.withOpacity(0.7)),
//             const SizedBox(height: 16),
//             const Text(
//               "Please log in to access your dashboard",
//               style: TextStyle(fontSize: 18),
//             ),
//             const SizedBox(height: 24),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(builder: (context) => const LoginScreen()),
//                 );
//               },
//               style: ElevatedButton.styleFrom(
//                 padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
//               ),
//               child: const Text("Go to Login", style: TextStyle(fontSize: 16)),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildDashboardContent(BuildContext context, User user) {
//     return StreamBuilder<QuerySnapshot>(
//       stream: FirebaseFirestore.instance
//           .collection('ngos')
//           .where('email', isEqualTo: user.email)
//           .snapshots(),
//       builder: (context, approvedSnapshot) {
//         return StreamBuilder<QuerySnapshot>(
//           stream: FirebaseFirestore.instance
//               .collection('pending_approvals')
//               .where('email', isEqualTo: user.email)
//               .snapshots(),
//           builder: (context, pendingSnapshot) {
//             // Show a loading spinner if any snapshot is still waiting.
//             if (approvedSnapshot.connectionState == ConnectionState.waiting ||
//                 pendingSnapshot.connectionState == ConnectionState.waiting) {
//               return const Center(child: CircularProgressIndicator());
//             }

//             // If NGO is approved, display the ApprovedNGOView.
//             if (approvedSnapshot.hasData &&
//                 approvedSnapshot.data!.docs.isNotEmpty) {
//               var ngoData = approvedSnapshot.data!.docs.first;
//               return ApprovedNGOView(ngoData: ngoData);
//             }

//             // If NGO is pending approval, navigate to the PendingApprovalView.
//             if (pendingSnapshot.hasData &&
//                 pendingSnapshot.data!.docs.isNotEmpty) {
//               var pendingData = pendingSnapshot.data!.docs.first;

//               // Use a microtask to push the PendingApprovalView once build is finished.
//               Future.microtask(() {
//                 Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) =>
//                         PendingApprovalView(pendingData: pendingData),
//                   ),
//                 );
//               });
//               return const Center(child: CircularProgressIndicator());
//             }

//             // If no NGO found, show a "No NGO found" view.
//             return _buildNoNGOFoundView(context);
//           },
//         );
//       },
//     );
//   }

//   Widget _buildNoNGOFoundView(BuildContext context) {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(24.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               padding: const EdgeInsets.all(24),
//               decoration: BoxDecoration(
//                 color: Colors.amber.withOpacity(0.2),
//                 borderRadius: BorderRadius.circular(100),
//               ),
//               child: const Icon(Icons.business_outlined,
//                   size: 80, color: Colors.amber),
//             ),
//             const SizedBox(height: 24),
//             const Text(
//               "No NGO found",
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 12),
//             const Text(
//               "It looks like you haven't registered your NGO yet. Please register first to access the dashboard features.",
//               textAlign: TextAlign.center,
//               style: TextStyle(fontSize: 16, color: Colors.black54),
//             ),
//             const SizedBox(height: 32),
//             ElevatedButton(
//               onPressed: () {
//                 // TODO: Navigate to NGO registration.
//                 Navigator.pop(context);
//               },
//               style: ElevatedButton.styleFrom(
//                 padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
//               ),
//               child: const Text("Register NGO", style: TextStyle(fontSize: 16)),
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

import 'package:care__connect/services/auth_service.dart';
import 'package:care__connect/screens/login_screen.dart';

import 'package:care__connect/screens/NGO/widgets/approved_ngo_view.dart'; // Corrected import
import 'widgets/pending_approval_view.dart';

class NGODashboard extends StatelessWidget {
  const NGODashboard({Key? key}) : super(key: key);

  void _signOut(BuildContext context) async {
    await AuthService().signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return _buildNotLoggedInView(context);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "NGO Dashboard",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: "Logout",
            onPressed: () => _signOut(context),
          ),
        ],
      ),
      body: _buildDashboardContent(context, user),
    );
  }

  Widget _buildNotLoggedInView(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("NGO Dashboard"),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _signOut(context),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.account_circle_outlined,
                size: 80,
                color: Theme.of(context).primaryColor.withOpacity(0.7)),
            const SizedBox(height: 16),
            const Text(
              "Please log in to access your dashboard",
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
              child: const Text("Go to Login", style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardContent(BuildContext context, User user) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('ngos')
          .where('email', isEqualTo: user.email)
          .snapshots(),
      builder: (context, approvedSnapshot) {
        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('pending_approvals')
              .where('email', isEqualTo: user.email)
              .snapshots(),
          builder: (context, pendingSnapshot) {
            if (approvedSnapshot.connectionState == ConnectionState.waiting ||
                pendingSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (approvedSnapshot.hasData &&
                approvedSnapshot.data!.docs.isNotEmpty) {
              var ngoData = approvedSnapshot.data!.docs.first;
              return ApprovedNGOView(ngoData: ngoData);
            }

            if (pendingSnapshot.hasData &&
                pendingSnapshot.data!.docs.isNotEmpty) {
              var pendingData = pendingSnapshot.data!.docs.first;

              Future.microtask(() {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        PendingApprovalView(pendingData: pendingData),
                  ),
                );
              });
              return const Center(child: CircularProgressIndicator());
            }

            return _buildNoNGOFoundView(context);
          },
        );
      },
    );
  }

  Widget _buildNoNGOFoundView(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.2),
                borderRadius: BorderRadius.circular(100),
              ),
              child: const Icon(Icons.business_outlined,
                  size: 80, color: Colors.amber),
            ),
            const SizedBox(height: 24),
            const Text(
              "No NGO found",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              "It looks like you haven't registered your NGO yet. Please register first to access the dashboard features.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // You can replace this with registration navigation
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              child: const Text("Register NGO", style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
