import 'package:flutter/material.dart';

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
