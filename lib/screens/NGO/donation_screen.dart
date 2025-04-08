import 'package:flutter/material.dart';

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
