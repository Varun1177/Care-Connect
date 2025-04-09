import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'common_header.dart';

class ClothesDonationDetailScreen extends StatefulWidget {
  final String ngoName;

  const ClothesDonationDetailScreen({Key? key, required this.ngoName}) : super(key: key);

  @override
  _ClothesDonationDetailScreenState createState() => _ClothesDonationDetailScreenState();
}

class _ClothesDonationDetailScreenState extends State<ClothesDonationDetailScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  String? _clothesType;
  String? _quantity;
  String? _condition;
  String? _seasonal;
  String? _sizeInfo;
  String? _packingStatus;
  bool _pickupNeeded = false;
  DateTime? _pickupDate;

  // Dropdown options
  final List<String> clothesTypes = ['Men', 'Women', 'Kids', 'Mixed'];
  final List<String> conditions = ['New', 'Gently Used', 'Old but wearable'];
  final List<String> seasonalOptions = ['Winter', 'Summer', 'All-season'];
  final List<String> packingOptions = ['Packed', 'Unpacked'];

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
      print('Clothes Donation Data:');
      print('Type of Clothes: $_clothesType');
      print('Quantity: $_quantity');
      print('Condition: $_condition');
      print('Seasonal: $_seasonal');
      print('Size Info: $_sizeInfo');
      print('Packing Status: $_packingStatus');
      print('Pickup Needed: $_pickupNeeded');
      if (_pickupNeeded) {
        print('Pickup Date: ${_pickupDate != null ? DateFormat.yMd().format(_pickupDate!) : "Not selected"}');
      }
      // Process submission.
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
                        'Donate Clothes to ${widget.ngoName}',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF333333),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Type of Clothes Dropdown
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(labelText: 'Type of Clothes'),
                        items: clothesTypes
                            .map((type) => DropdownMenuItem<String>(
                                  value: type,
                                  child: Text(type),
                                ))
                            .toList(),
                        onChanged: (value) => setState(() => _clothesType = value),
                        validator: (value) => value == null ? 'Select a clothes type' : null,
                      ),
                      // Quantity
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Quantity'),
                        keyboardType: TextInputType.number,
                        validator: (value) =>
                            value == null || value.isEmpty ? 'Enter quantity' : null,
                        onSaved: (value) => _quantity = value,
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
                        onChanged: (value) => setState(() => _condition = value),
                        validator: (value) => value == null ? 'Select condition' : null,
                      ),
                      // Seasonal Dropdown
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(labelText: 'Seasonal'),
                        items: seasonalOptions
                            .map((option) => DropdownMenuItem<String>(
                                  value: option,
                                  child: Text(option),
                                ))
                            .toList(),
                        onChanged: (value) => setState(() => _seasonal = value),
                        validator: (value) => value == null ? 'Select seasonal option' : null,
                      ),
                      // Size Info (optional)
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Size Info (Optional)'),
                        onSaved: (value) => _sizeInfo = value,
                      ),
                      // Packing Status Dropdown
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(labelText: 'Packing Status'),
                        items: packingOptions
                            .map((option) => DropdownMenuItem<String>(
                                  value: option,
                                  child: Text(option),
                                ))
                            .toList(),
                        onChanged: (value) => setState(() => _packingStatus = value),
                        validator: (value) => value == null ? 'Select packing status' : null,
                      ),
                      // Pickup Needed toggle
                      SwitchListTile(
                        title: const Text('Pickup Needed?'),
                        value: _pickupNeeded,
                        onChanged: (value) => setState(() => _pickupNeeded = value),
                      ),
                      if (_pickupNeeded)
                        ListTile(
                          title: Text(
                            _pickupDate == null
                                ? 'Select Pickup Date'
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
