import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'common_header.dart';

class FoodDonationDetailScreen extends StatefulWidget {
  final String ngoName;

  const FoodDonationDetailScreen({Key? key, required this.ngoName}) : super(key: key);

  @override
  _FoodDonationDetailScreenState createState() => _FoodDonationDetailScreenState();
}

class _FoodDonationDetailScreenState extends State<FoodDonationDetailScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  String? _foodType;
  String? _quantity;
  DateTime? _expiryDate;
  bool? _isVegetarian;
  bool _hygieneStatus = false;
  bool _pickupNeeded = false;
  DateTime? _pickupDate;

  // Dropdown options for food types
  final List<String> foodTypes = ['Cooked', 'Packaged', 'Groceries', 'Perishables', 'Dry Ration'];

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

  Future<void> _selectExpiryDate(BuildContext context) async {
    final now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 1),
    );
    if (picked != null && picked != _expiryDate) {
      setState(() {
        _expiryDate = picked;
      });
    }
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
      print('Food Donation Data:');
      print('Type of Food: $_foodType');
      print('Quantity/Weight: $_quantity');
      print('Expiry Date: ${_expiryDate != null ? DateFormat.yMd().format(_expiryDate!) : "Not set"}');
      print('Is Vegetarian: $_isVegetarian');
      print('Hygiene Status: $_hygieneStatus');
      print('Pickup Needed: $_pickupNeeded');
      if (_pickupNeeded) {
        print('Pickup Date: ${_pickupDate != null ? DateFormat.yMd().format(_pickupDate!) : "Not selected"}');
      }
      // Process the submission.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
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
                        'Donate Food to ${widget.ngoName}',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF333333),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Food Type Dropdown
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(labelText: 'Type of Food'),
                        items: foodTypes
                            .map((type) => DropdownMenuItem<String>(
                                  value: type,
                                  child: Text(type),
                                ))
                            .toList(),
                        onChanged: (value) => setState(() {
                          _foodType = value;
                        }),
                        validator: (value) =>
                            value == null ? 'Please select a food type' : null,
                      ),
                      // Quantity/Weight
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Quantity/Weight'),
                        keyboardType: TextInputType.text,
                        validator: (value) =>
                            value == null || value.isEmpty ? 'Enter quantity/weight' : null,
                        onSaved: (value) => _quantity = value,
                      ),
                      // Expiry Date Picker
                      ListTile(
                        title: Text(
                          _expiryDate == null
                              ? 'Select Expiry Date'
                              : 'Expiry Date: ${DateFormat.yMd().format(_expiryDate!)}',
                        ),
                        trailing: const Icon(Icons.calendar_today),
                        onTap: () => _selectExpiryDate(context),
                      ),
                      // Is it Vegetarian? (Yes/No)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          children: [
                            const Text('Is it Vegetarian?'),
                            Radio<bool>(
                              value: true,
                              groupValue: _isVegetarian,
                              onChanged: (bool? value) =>
                                  setState(() => _isVegetarian = value),
                            ),
                            const Text('Yes'),
                            Radio<bool>(
                              value: false,
                              groupValue: _isVegetarian,
                              onChanged: (bool? value) =>
                                  setState(() => _isVegetarian = value),
                            ),
                            const Text('No'),
                          ],
                        ),
                      ),
                      // Hygiene Status Checkbox
                      CheckboxListTile(
                        title: const Text('Hygiene Status: Self-declared good hygiene'),
                        value: _hygieneStatus,
                        onChanged: (value) =>
                            setState(() => _hygieneStatus = value ?? false),
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
