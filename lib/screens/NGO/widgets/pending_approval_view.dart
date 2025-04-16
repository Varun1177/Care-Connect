import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PendingApprovalView extends StatelessWidget {
  final DocumentSnapshot pendingData;

  const PendingApprovalView({
    Key? key,
    required this.pendingData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Extract data
    final name = pendingData['name'] ?? 'Your NGO';
    final submittedAt = pendingData['submittedAt'] as Timestamp?;
    final logoUrl = pendingData['logoUrl'];

    // Calculate days since submission
    int daysSinceSubmission = 0;
    if (submittedAt != null) {
      final difference = DateTime.now().difference(submittedAt.toDate());
      daysSinceSubmission = difference.inDays;
    }

    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Header with logo
            _buildHeader(context, name, logoUrl),
      
            const SizedBox(height: 20),
      
            // Status card
            _buildStatusCard(context, daysSinceSubmission),
      
            const SizedBox(height: 20),
      
            // What to expect section
            _buildWhatToExpectSection(context),
      
            const SizedBox(height: 20),
      
            // Contact section
            _buildContactSection(context),

            const SizedBox(height: 20),

          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String name, String? logoUrl) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Color(0xFF00A86B),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(50),
          bottomRight: Radius.circular(50),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 25),

          // Logo
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.white,
            backgroundImage: logoUrl != null ? NetworkImage(logoUrl) : null,
            child: logoUrl == null
                ? const Icon(Icons.business, size: 50, color: Colors.grey)
                : null,
          ),
          const SizedBox(height: 16),

          // NGO Name
          Text(
            name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              decoration: TextDecoration.none,
            ),
          ),
          const SizedBox(height: 8),

          // Status Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.hourglass_top, size: 16, color: Colors.white),
                SizedBox(width: 4),
                Text(
                  "Pending Approval",
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.none,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard(BuildContext context, int daysSinceSubmission) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text(
                "Application Status",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // Status Timeline
              _buildStatusTimeline(context),

              const SizedBox(height: 16),

              // Time indicator
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "Submitted $daysSinceSubmission days ago",
                  style: TextStyle(
                    color: Colors.orange.shade800,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Estimated Time
              const Text(
                "Estimated approval time: 5-7 business days",
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusTimeline(BuildContext context) {
    return Row(
      children: [
        _buildTimelineStep(
          context,
          title: "Submitted",
          isCompleted: true,
          isActive: false,
        ),
        _buildTimelineLine(context, isActive: false),
        _buildTimelineStep(
          context,
          title: "Under Review",
          isCompleted: false,
          isActive: true,
        ),
        _buildTimelineLine(context, isActive: false),
        _buildTimelineStep(
          context,
          title: "Approved",
          isCompleted: false,
          isActive: false,
        ),
      ],
    );
  }

  Widget _buildTimelineStep(
    BuildContext context, {
    required String title,
    required bool isCompleted,
    required bool isActive,
  }) {
    Color circleColor;
    IconData icon;

    if (isCompleted) {
      circleColor = Colors.green;
      icon = Icons.check;
    } else if (isActive) {
      circleColor = Colors.orange;
      icon = Icons.hourglass_top;
    } else {
      circleColor = Colors.grey.shade300;
      icon = Icons.circle;
    }

    return Expanded(
      child: Column(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: circleColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              color: isActive ? Colors.orange : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineLine(BuildContext context, {required bool isActive}) {
    return Expanded(
      child: Container(
        height: 2,
        color: isActive ? Colors.orange : Colors.grey.shade300,
      ),
    );
  }

  Widget _buildWhatToExpectSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue),
                  SizedBox(width: 8),
                  Text(
                    "What to Expect",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const Divider(),
              const SizedBox(height: 8),
              _buildExpectationItem(
                context,
                icon: Icons.email,
                text:
                    "You will receive an email notification once your application is approved",
              ),
              const SizedBox(height: 12),
              _buildExpectationItem(
                context,
                icon: Icons.verified_user,
                text: "Our team will verify your registration documents",
              ),
              const SizedBox(height: 12),
              _buildExpectationItem(
                context,
                icon: Icons.access_time,
                text: "The approval process typically takes 5-7 business days",
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExpectationItem(
    BuildContext context, {
    required IconData icon,
    required String text,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 16, color: Colors.blue),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContactSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text(
                "Need Help?",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  // TODO: Implement contact support
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Contacting support...")),
                  );
                },
                icon: const Icon(Icons.support_agent),
                label: const Text("Contact Support"),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue,
                  minimumSize: const Size(double.infinity, 45),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
