import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(const MyApp());
}

//
// MAIN APP & FAKE DATA
//

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Care Connect',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
        scaffoldBackgroundColor: Colors.grey[100],
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontSize: 14, color: Colors.black87),
        ),
      ),
      // For demonstration, using a fake DocumentSnapshot
      home: ApprovedNGOView(
        ngoData: FakeDocumentSnapshot({
          'name': 'Hope Foundation',
          'sector': 'Health',
          'description': 'We provide healthcare and community services. Our mission is to support the underprivileged with accessible health solutions.',
          'logoUrl': '',
          'acceptedDonations': ['Money', 'Clothes', 'Food']
        }),
      ),
    );
  }
}

// A fake DocumentSnapshot for demonstration purposes.
class FakeDocumentSnapshot implements DocumentSnapshot {
  final Map<String, dynamic> _data;
  FakeDocumentSnapshot(this._data);
  @override
  dynamic data() => _data;
  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

//
// APPROVED NGO VIEW (Main Screen)
//

class ApprovedNGOView extends StatelessWidget {
  final DocumentSnapshot ngoData;
  const ApprovedNGOView({super.key, required this.ngoData});
  
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> data = ngoData.data() as Map<String, dynamic>;
    final String name = data['name'] ?? 'N/A';
    final String sector = data['sector'] ?? 'N/A';
    final String description = data['description'] ?? 'N/A';
    final String logoUrl = data['logoUrl'] ?? '';
    final List<dynamic> acceptedDonations = data['acceptedDonations'] ?? [];
    
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        elevation: 0,
        backgroundColor: Colors.lightGreen.shade300,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner Section
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.lightGreen.shade300, Colors.lightGreen.shade100],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      // NGO Logo
                      Container(
                        height: 70,
                        width: 70,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              spreadRadius: 1,
                            ),
                          ],
                          image: logoUrl.isNotEmpty
                              ? DecorationImage(
                                  image: NetworkImage(logoUrl),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: logoUrl.isEmpty
                            ? Icon(
                                Icons.business_rounded,
                                size: 35,
                                color: Colors.grey[400],
                              )
                            : null,
                      ),
                      const SizedBox(width: 16),
                      // NGO Name and Sector
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                sector,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Approval Badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade200,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.verified, color: Colors.white, size: 14),
                            SizedBox(width: 4),
                            Text("Approved", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Description
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      description,
                      style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.4),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Dashboard Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Dashboard", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.3,
                    children: [
                      DashboardCard(
                        title: "Donations",
                        value: "₹24,500",
                        icon: Icons.monetization_on_outlined,
                        color: Colors.blue,
                        onTap: () {},
                      ),
                      DashboardCard(
                        title: "Campaigns",
                        value: "4",
                        icon: Icons.campaign_outlined,
                        color: Colors.purple,
                        onTap: () {
                          // Navigate to Campaign Drives screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const CampaignDrivesScreen()),
                          );
                        },
                      ),
                      DashboardCard(
                        title: "Supporters",
                        value: "184",
                        icon: Icons.people_outline,
                        color: Colors.lightGreen,
                        onTap: () {},
                      ),
                      DashboardCard(
                        title: "Requests",
                        value: "12",
                        icon: Icons.inbox_outlined,
                        color: Colors.orange,
                        onTap: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Accepted Donations Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Accepted Donations", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: acceptedDonations.map<Widget>((type) {
                      IconData icon;
                      Color color;
                      switch (type) {
                        case 'Money':
                          icon = Icons.attach_money;
                          color = Colors.lightGreen;
                          break;
                        case 'Clothes':
                          icon = Icons.checkroom_outlined;
                          color = Colors.blue.shade300;
                          break;
                        case 'Books':
                          icon = Icons.book_outlined;
                          color = Colors.orange.shade300;
                          break;
                        case 'Food':
                          icon = Icons.fastfood_outlined;
                          color = Colors.red.shade300;
                          break;
                        default:
                          icon = Icons.volunteer_activism;
                          color = Colors.purple.shade300;
                      }
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: color.withOpacity(0.3)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(icon, size: 18, color: color),
                            const SizedBox(width: 6),
                            Text(type, style: TextStyle(color: color, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Quick Actions Section (Kept same as original)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Quick Actions", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildActionCard(
                          context,
                          "Create Campaign",
                          Icons.campaign_outlined,
                          Colors.blue,
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const CreateCampaignScreen()),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildActionCard(
                          context,
                          "Donation History",
                          Icons.history,
                          Colors.purple,
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const DonationHistoryScreen()),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildActionCard(
                          context,
                          "Edit Profile",
                          Icons.edit_outlined,
                          Colors.lightGreen,
                          () {
                            // Navigate to Edit Profile screen
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildActionCard(
                          context,
                          "Contact Support",
                          Icons.support_agent_outlined,
                          Colors.orange,
                          () {
                            // Navigate to Contact Support screen
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildActionCard(
                          context,
                          "Celebrity Feature",
                          Icons.star,
                          Colors.redAccent,
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const CelebrityFeatureScreen()),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
  
  // Original Quick Actions card UI.
  Widget _buildActionCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Ink(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.12),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey[800]),
            ),
          ],
        ),
      ),
    );
  }
}

//
// DASHBOARD CARD WIDGET
//

class DashboardCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  
  const DashboardCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Ink(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.12),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 4),
            Text(value, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 14)),
          ],
        ),
      ),
    );
  }
}

//
// ENHANCED CREATE CAMPAIGN SCREEN
//

class CreateCampaignScreen extends StatefulWidget {
  const CreateCampaignScreen({super.key});
  
  @override
  _CreateCampaignScreenState createState() => _CreateCampaignScreenState();
}

class _CreateCampaignScreenState extends State<CreateCampaignScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _selectedDate;
  final TextEditingController _purposeController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _volunteersController = TextEditingController();
  
  @override
  void dispose() {
    _purposeController.dispose();
    _descriptionController.dispose();
    _volunteersController.dispose();
    super.dispose();
  }
  
  Future<void> _pickDate() async {
    DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }
  
  void _submitCampaign() {
    if (_formKey.currentState!.validate() && _selectedDate != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Campaign Created Successfully')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Campaign'),
        backgroundColor: Colors.lightGreen.shade300,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.lightGreen.shade100, Colors.orange.shade50],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      ListTile(
                        leading: Icon(Icons.calendar_today, color: Colors.lightGreen.shade300),
                        title: Text(
                          _selectedDate == null
                              ? 'Select Date'
                              : 'Date: ${_selectedDate!.toLocal()}'.split(' ')[0],
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.lightGreen.shade300),
                        onTap: _pickDate,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _purposeController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.lightGreen.shade50,
                          labelText: 'Purpose',
                          prefixIcon: Icon(Icons.edit, color: Colors.lightGreen.shade300),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        validator: (value) => (value == null || value.isEmpty) ? 'Enter purpose' : null,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _descriptionController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.lightGreen.shade50,
                          labelText: 'Description',
                          prefixIcon: Icon(Icons.description, color: Colors.lightGreen.shade300),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        maxLines: 3,
                        validator: (value) => (value == null || value.isEmpty) ? 'Enter description' : null,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _volunteersController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.lightGreen.shade50,
                          labelText: 'No. of Volunteers Needed',
                          prefixIcon: Icon(Icons.group, color: Colors.lightGreen.shade300),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) => (value == null || value.isEmpty) ? 'Enter number of volunteers' : null,
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.lightGreen.shade300,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: _submitCampaign,
                        child: const Text('Create Campaign', style: TextStyle(fontSize: 16)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

//
// ENHANCED DONATION HISTORY & DETAIL SCREENS
//

class DonationHistoryScreen extends StatelessWidget {
  const DonationHistoryScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    final List<String> categories = ['Money', 'Clothes', 'Food', 'Other'];
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Donation History'),
        backgroundColor: Colors.lightGreen.shade300,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.lightGreen.shade100, Colors.orange.shade50],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView.separated(
            itemCount: categories.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final category = categories[index];
              return Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                elevation: 6,
                child: ListTile(
                  leading: Icon(Icons.category, color: Colors.lightGreen.shade300),
                  title: Text(category, style: const TextStyle(fontWeight: FontWeight.bold)),
                  trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.orange.shade300),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => DonationDetailScreen(category: category)),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class DonationDetailScreen extends StatelessWidget {
  final String category;
  const DonationDetailScreen({super.key, required this.category});
  
  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> donationData = [
      {
        'donor': 'Alice',
        'quantity': '100',
        'address': '123 Street, City',
        'coordinates': '12.9716° N, 77.5946° E',
      },
      {
        'donor': 'Bob',
        'quantity': '50',
        'address': '456 Avenue, City',
        'coordinates': '13.0827° N, 80.2707° E',
      },
    ];
    
    return Scaffold(
      appBar: AppBar(
        title: Text('$category Donations'),
        backgroundColor: Colors.lightGreen.shade300,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.lightGreen.shade100, Colors.orange.shade50],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: donationData.length,
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final donation = donationData[index];
            return Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              elevation: 6,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      donation['donor']!,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(Icons.inventory, size: 18, color: Colors.grey.shade700),
                        const SizedBox(width: 8),
                        Text('Quantity: ${donation['quantity']}'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 18, color: Colors.grey.shade700),
                        const SizedBox(width: 8),
                        Expanded(child: Text('Address: ${donation['address']}')),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.map, size: 18, color: Colors.grey.shade700),
                        const SizedBox(width: 8),
                        Expanded(child: Text('Coordinates: ${donation['coordinates']}')),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

//
// NEW: CAMPAIGN DRIVES & VOLUNTEER APPROVAL/ RATING
//

// Screen that lists all campaign drives.
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

// Detail screen for a specific campaign drive.
class CampaignDriveDetailScreen extends StatefulWidget {
  final String driveTitle;
  final List<Map<String, String>> volunteers;
  const CampaignDriveDetailScreen({super.key, required this.driveTitle, required this.volunteers});
  
  @override
  _CampaignDriveDetailScreenState createState() => _CampaignDriveDetailScreenState();
}

class _CampaignDriveDetailScreenState extends State<CampaignDriveDetailScreen> {
  // Keep track of volunteer status and rating.
  late List<Map<String, dynamic>> volunteerStatus;
  
  @override
  void initState() {
    super.initState();
    volunteerStatus = widget.volunteers.map((vol) {
      return {
        'name': vol['name'],
        'email': vol['email'],
        'approved': false,
        'rating': 0, // rating out of 5
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
                  Text(vol['name'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(vol['email']),
                  const SizedBox(height: 12),
                  // Buttons Row
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: vol['approved'] ? Colors.green : Colors.green.shade300,
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
                            backgroundColor: !vol['approved'] ? Colors.red.shade100 : Colors.red.shade300,
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


//
// NEW: CELEBRITY FEATURE SCREEN
//

class CelebrityFeatureScreen extends StatefulWidget {
  const CelebrityFeatureScreen({super.key});
  
  @override
  _CelebrityFeatureScreenState createState() => _CelebrityFeatureScreenState();
}

class _CelebrityFeatureScreenState extends State<CelebrityFeatureScreen> {
  // Dummy celebrity data.
  final List<Map<String, String>> celebrities = [
    {'name': 'John Doe', 'contact': 'john@example.com', 'cause': 'Health'},
    {'name': 'Jane Smith', 'contact': 'jane@example.com', 'cause': 'Education'},
    {'name': 'Alice Johnson', 'contact': 'alice@example.com', 'cause': 'Environment'},
    {'name': 'Bob Williams', 'contact': 'bob@example.com', 'cause': 'Animal Welfare'},
    {'name': 'Emma Brown', 'contact': 'emma@example.com', 'cause': 'Women Empowerment'},
  ];
  
  String selectedCause = 'Health';
  final List<String> causes = [
    'Health', 'Education', 'Environment', 'Animal Welfare',
    'Women Empowerment', 'Child Welfare', 'Disaster Relief', 'Poverty', 'Elderly Care'
  ];
  
  @override
  Widget build(BuildContext context) {
    final filteredCelebrities = celebrities.where((celeb) => celeb['cause'] == selectedCause).toList();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Celebrity Feature'),
        backgroundColor: Colors.lightGreen.shade300,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.lightGreen.shade100, Colors.orange.shade50],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Enhanced Dropdown filter
            Card(
              elevation: 6,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedCause,
                    icon: Icon(Icons.arrow_drop_down, color: Colors.lightGreen.shade300),
                    items: causes.map((cause) {
                      return DropdownMenuItem(
                        value: cause,
                        child: Text(cause, style: const TextStyle(fontWeight: FontWeight.w600)),
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
            const SizedBox(height: 20),
            // Enhanced Celebrity List
            Expanded(
              child: ListView.separated(
                itemCount: filteredCelebrities.length,
                separatorBuilder: (context, index) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final celeb = filteredCelebrities[index];
                  return Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    elevation: 6,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.lightGreen.shade50,
                        child: Text(celeb['name']!.substring(0, 1),
                            style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                      ),
                      title: Text(celeb['name']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('Contact: ${celeb['contact']}'),
                      trailing: Icon(Icons.arrow_forward_ios, color: Colors.orange.shade300, size: 16),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
