import 'package:flutter/material.dart';

class GradientHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onBack;

  const GradientHeader({
    Key? key,
    required this.title,
    required this.subtitle,
    this.onBack,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.25,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF00A86B), Color(0xFF009160)],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Stack(
        children: [
          if (onBack != null)
            Positioned(
              top: 50,
              left: 20,
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                onPressed: onBack!,
              ),
            ),
          const Positioned(
            top: 60,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Text(
                  'Make a Difference',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Your donation matters',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}