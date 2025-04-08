import 'package:flutter/material.dart';

class CelebrityFeatureScreen extends StatefulWidget {
  const CelebrityFeatureScreen({super.key});
  
  @override
  _CelebrityFeatureScreenState createState() => _CelebrityFeatureScreenState();
}

class _CelebrityFeatureScreenState extends State<CelebrityFeatureScreen> {
  // Dummy celebrity data
  final List<Map<String, String>> celebrities = [
    {'name': 'John Doe', 'contact': 'john@example.com', 'cause': 'Health'},
    {'name': 'Jane Smith', 'contact': 'jane@example.com', 'cause': 'Education'},
    {'name': 'Alice Johnson', 'contact': 'alice@example.com', 'cause': 'Environment'},
    {'name': 'Bob Williams', 'contact': 'bob@example.com', 'cause': 'Animal Welfare'},
    {'name': 'Emma Brown', 'contact': 'emma@example.com', 'cause': 'Women Empowerment'},
  ];
  
  String selectedCause = 'Health';
  final List<String> causes = [
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
  
  @override
  Widget build(BuildContext context) {
    final filteredCelebrities = celebrities
        .where((celeb) => celeb['cause'] == selectedCause)
        .toList();
    
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
            // Dropdown Filter Card
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
            // Celebrity List
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
                        child: Text(
                          celeb['name']!.substring(0, 1),
                          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                        ),
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
