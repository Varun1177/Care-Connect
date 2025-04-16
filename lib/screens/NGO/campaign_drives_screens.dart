import 'package:flutter/material.dart';

class CampaignDrivesScreen extends StatelessWidget {
  const CampaignDrivesScreen({super.key});
  
  // Dummy data for campaign drives.
  final List<Map<String, dynamic>> campaignDrives = const [
    {
      'title': 'Blood Donation Drive',
      'date': '2023-10-15',
      'volunteers': [
        {'name': 'Alice', 'email': 'alice@example.com'},
        {'name': 'Bob', 'email': 'bob@example.com'},
      ]
    },
    {
      'title': 'Food Collection Drive',
      'date': '2023-11-05',
      'volunteers': [
        {'name': 'Charlie', 'email': 'charlie@example.com'},
        {'name': 'Diana', 'email': 'diana@example.com'},
      ]
    },
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Campaign Drives'),
        backgroundColor: Colors.lightGreen.shade300,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: campaignDrives.length,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final drive = campaignDrives[index];
          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            elevation: 6,
            child: ListTile(
              title: Text(drive['title']),
              subtitle: Text('Date: ${drive['date']}'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CampaignDriveDetailScreen(
                      driveTitle: drive['title'],
                      volunteers: List<Map<String, String>>.from(drive['volunteers']),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class CampaignDriveDetailScreen extends StatefulWidget {
  final String driveTitle;
  final List<Map<String, String>> volunteers;
  const CampaignDriveDetailScreen({super.key, required this.driveTitle, required this.volunteers});
  
  @override
  _CampaignDriveDetailScreenState createState() => _CampaignDriveDetailScreenState();
}

class _CampaignDriveDetailScreenState extends State<CampaignDriveDetailScreen> {
  // Track volunteer status and ratings.
  late List<Map<String, dynamic>> volunteerStatus;
  
  @override
  void initState() {
    super.initState();
    volunteerStatus = widget.volunteers.map((vol) {
      return {
        'name': vol['name'],
        'email': vol['email'],
        'approved': false,
        'rating': 0, // Rating out of 5
      };
    }).toList();
  }
  
  void _approveVolunteer(int index) {
    setState(() {
      volunteerStatus[index]['approved'] = true;
    });
  }
  
  void _rejectVolunteer(int index) {
    setState(() {
      volunteerStatus[index]['approved'] = false;
    });
  }
  
  void _setRating(int index, int rating) {
    setState(() {
      volunteerStatus[index]['rating'] = rating;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.driveTitle),
        backgroundColor: Colors.lightGreen.shade300,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: volunteerStatus.length,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final vol = volunteerStatus[index];
          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(vol['name'],
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(vol['email']),
                  const SizedBox(height: 12),
                  // Approve/Reject buttons Row
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: vol['approved']
                                ? Colors.green
                                : Colors.green.shade300,
                            minimumSize: const Size(0, 36),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                          ),
                          onPressed: () => _approveVolunteer(index),
                          child: const Text('Approve', style: TextStyle(fontSize: 12)),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: !vol['approved']
                                ? Colors.red.shade100
                                : Colors.red.shade300,
                            minimumSize: const Size(0, 36),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                          ),
                          onPressed: () => _rejectVolunteer(index),
                          child: const Text('Reject', style: TextStyle(fontSize: 12)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Star Rating Row
                  Row(
                    children: List.generate(5, (starIndex) {
                      return GestureDetector(
                        onTap: () => _setRating(index, starIndex + 1),
                        child: Icon(
                          starIndex < vol['rating']
                              ? Icons.star
                              : Icons.star_border,
                          color: Colors.orange,
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}