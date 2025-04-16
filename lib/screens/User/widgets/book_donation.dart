import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'common_header.dart';

class BooksDonationDetailScreen extends StatefulWidget {
  final String ngoName;

  const BooksDonationDetailScreen({Key? key, required this.ngoName}) : super(key: key);

  @override
  _BooksDonationDetailScreenState createState() => _BooksDonationDetailScreenState();
}

class _BooksDonationDetailScreenState extends State<BooksDonationDetailScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  String? _bookType;
  String? _subjectsGenres;
  int? _quantity;
  String? _condition;
  String? _language;
  bool _pickupNeeded = false;
  DateTime? _pickupDate;

  // Dropdown options
  final List<String> bookTypes = ['School', 'College', 'Novels', 'Kids', 'Reference'];
  final List<String> conditions = ['New', 'Used', 'Damaged'];

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
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _selectPickupDate(BuildContext context) async {
    final now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 1),
    );
    if (picked != null && picked != _pickupDate) {
      setState(() {
        _pickupDate = picked;
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Process submission here.
      print('Books Donation Data:');
      print('Type: $_bookType');
      print('Subjects/Genres: $_subjectsGenres');
      print('Quantity: $_quantity');
      print('Condition: $_condition');
      print('Language: $_language');
      print('Pickup Needed: $_pickupNeeded');
      if (_pickupNeeded) {
        print('Pickup Date: ${_pickupDate != null ? DateFormat.yMd().format(_pickupDate!) : "Not set"}');
      }
      // Add navigation or confirmation.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Common header with back button.
          GradientHeader(
            title: 'Make a Difference',
            subtitle: 'Your donation matters',
            onBack: () => Navigator.pop(context),
          ),
          Expanded(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Text(
                        'Donate Books to ${widget.ngoName}',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF333333),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Book Type Dropdown
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(labelText: 'Type of Books'),
                        items: bookTypes
                            .map((type) => DropdownMenuItem<String>(
                                  value: type,
                                  child: Text(type),
                                ))
                            .toList(),
                        onChanged: (value) => setState(() {
                          _bookType = value;
                        }),
                        validator: (value) => value == null ? 'Please select a book type' : null,
                      ),
                      // Subjects/Genres (optional)
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Subjects/Genres (Optional)'),
                        onSaved: (value) => _subjectsGenres = value,
                      ),
                      // Quantity
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Quantity'),
                        keyboardType: TextInputType.number,
                        validator: (value) =>
                            value == null || value.isEmpty ? 'Enter a quantity' : null,
                        onSaved: (value) => _quantity = int.tryParse(value!),
                      ),
                      // Condition Dropdown
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(labelText: 'Condition'),
                        items: conditions
                            .map((cond) => DropdownMenuItem<String>(
                                  value: cond,
                                  child: Text(cond),
                                ))
                            .toList(),
                        onChanged: (value) => setState(() {
                          _condition = value;
                        }),
                        validator: (value) => value == null ? 'Please select a condition' : null,
                      ),
                      // Language
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Language'),
                        validator: (value) =>
                            value == null || value.isEmpty ? 'Enter language' : null,
                        onSaved: (value) => _language = value,
                      ),
                      // Pickup Needed toggle
                      SwitchListTile(
                        title: const Text('Pickup Needed?'),
                        value: _pickupNeeded,
                        onChanged: (value) => setState(() {
                          _pickupNeeded = value;
                        }),
                      ),
                      if (_pickupNeeded)
                        ListTile(
                          title: Text(
                            _pickupDate == null
                                ? 'Select Preferred Pickup Date'
                                : 'Pickup Date: ${DateFormat.yMd().format(_pickupDate!)}',
                          ),
                          trailing: const Icon(Icons.calendar_today),
                          onTap: () => _selectPickupDate(context),
                        ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                        ),
                        child: const Text('Submit Donation'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}