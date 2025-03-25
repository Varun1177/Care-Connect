import 'package:care__connect/screens/NGO/ngo_registration_screen.dart';
import 'package:care__connect/screens/User/signup_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
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
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            // Top gradient container
            Container(
              height: screenSize.height * 0.25,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF00A86B), Color(0xFF009160)],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Hero(
                        tag: 'logo',
                        child: Image.asset(
                          'lib/assets/login.png',
                          height: 80,
                          width: 80,
                        ),
                      ),
                      const SizedBox(height: 15),
                      // const Text(
                      //   'Welcome To',
                      //   style: TextStyle(
                      //     color: Colors.white,
                      //     fontSize: 30,
                      //     fontWeight: FontWeight.bold,
                      //   ),
                      // ),
                      const Text(
                        'Select Registration Type',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      //const SizedBox(height: 10),
                    ],
                  ),
                ],
              ),
            ),
            
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildRegistrationCard(
                      title: 'User Registration',
                      imagePath: 'lib/assets/add-user.png',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SignupScreen()),
                        );
                      },
                      description: 'Register as a user to donate and volunteer',
                      icon: Icons.person_add,
                    ),
                    
                    const SizedBox(height: 30),
                    
                    _buildRegistrationCard(
                      title: 'NGO Registration',
                      imagePath: 'lib/assets/add-NGO.png',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const NGORegistrationScreen()),
                        );
                      },
                      description: 'Register your organization to receive support',
                      icon: Icons.business,
                    ),
                  ],
                ),
              ),
            ),
            
            // Bottom text
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account? ',
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 14,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Login here',
                      style: TextStyle(
                        color: Color(0xFF00A86B),
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRegistrationCard({
    required String title,
    required String imagePath,
    required VoidCallback onTap,
    required String description,
    required IconData icon,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 15,
              spreadRadius: 2,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: const Color(0xFF00A86B).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                imagePath,
                height: 50,
                width: 80,
              ),
            ),
            const SizedBox(height: 15),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF00A86B),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
              decoration: BoxDecoration(
                color: const Color(0xFF00A86B),
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00A86B).withOpacity(0.3),
                    blurRadius: 8,
                    spreadRadius: 1,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icon,
                    color: Colors.white,
                    size: 16,
                  ),
                  const SizedBox(width: 5),
                  const Text(
                    'Register Now',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}