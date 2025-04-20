import 'package:care__connect/screens/NGO/ngo_dashboard.dart';
import 'package:care__connect/screens/User/main_screen.dart';
import 'package:care__connect/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:care__connect/services/auth_service.dart';
import 'Admin/admin_dashboard.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  _loginScreenState createState() => _loginScreenState();
}

class _loginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool _obscureText = true;
  bool _rememberMe = true;
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
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);

      //store in users collection
      print('User ID: ${_auth.currentUser!.uid}');
      await FirebaseFirestore.instance
              .collection('users')
              .doc(_auth.currentUser!.uid)
              .set({
                'email': _auth.currentUser!.email,
                'role': 'user',
                'uid': _auth.currentUser!.uid,
              }, SetOptions(merge: true));
      // Check user role
      print('success');

      String? role = (await AuthService().getUserRole(_auth.currentUser!.uid));

      if (role == 'admin') {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AdminDashboard()));
      } else if (role == 'user') {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainScreen()));
      } else if (role == 'ngo') {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NGODashboard()));
      } else if (role == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error: User role not found')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google Sign-In Failed: ${e.toString()}')),
      );
    }
  }

  Future<void> _signInWithEmail(BuildContext context) async {
    if (_emailController.text.trim().isEmpty || _passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    try {
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      String? role = (await AuthService().getUserRole(_auth.currentUser!.uid));

      Navigator.pop(context); // Close loading dialog

      if (role == 'admin') {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AdminDashboard()));
      } else if (role == 'user') {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainScreen()));
      } else if (role == 'ngo') {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NGODashboard()));
      } else if (role == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error: User role not found')),
        );
      }
      

    } catch (e) {
      Navigator.of(context).pop(); // Close loading dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login Failed: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              Stack(
                alignment: Alignment.bottomCenter,
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: screenSize.height * 0.38,
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
                    child: const Stack(
                      children: [
                        Positioned(
                          top: 90,
                          left: 0,
                          right: 0,
                          child: Column(
                            children: [
                              Text(
                                'Welcome To',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 35,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              //SizedBox(height: 5),
                              Text(
                                'Care Connect',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 35,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 0),
                              Text(
                                'Sign in to continue',
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
                  ),
                  Positioned(
                    bottom: -40,
                    child: Hero(
                      tag: 'logo',
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Image.asset(
                          'lib/assets/login.png',
                          height: 100,
                          width: 100,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 60),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildInputField(
                      controller: _emailController,
                      label: 'Email',
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 20),
                    buildPasswordField(),
                    buildRememberForgotRow(),
                    const SizedBox(height: 25),
                    buildLoginButton(),
                    const SizedBox(height: 20),
                    buildDividerOr(),
                    const SizedBox(height: 20),
                    buildSocialButtons(),
                    const SizedBox(height: 25),
                    buildSignUpRow(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(fontSize: 16),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 20),
          border: InputBorder.none,
          hintText: label,
          prefixIcon: Icon(
            icon,
            color: const Color(0xFF00A86B),
          ),
          hintStyle: TextStyle(color: Colors.grey.shade700),
        ),
      ),
    );
  }

  Widget buildPasswordField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        controller: _passwordController,
        obscureText: _obscureText,
        style: const TextStyle(fontSize: 16),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 20),
          border: InputBorder.none,
          hintText: 'Password',
          prefixIcon: const Icon(
            Icons.lock_outline,
            color: Color(0xFF00A86B),
          ),
          suffixIcon: IconButton(
            icon: Icon(
              _obscureText ? Icons.visibility_off : Icons.visibility,
              color: Colors.grey.shade700,
            ),
            onPressed: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
          ),
          hintStyle: TextStyle(color: Colors.grey.shade700),
        ),
      ),
    );
  }

  Widget buildRememberForgotRow() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SizedBox(
                height: 24,
                width: 24,
                child: Checkbox(
                  value: _rememberMe,
                  activeColor: const Color(0xFF00A86B),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _rememberMe = value!;
                    });
                  },
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Remember me',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
          TextButton(
            onPressed: () {},
            child: const Text(
              'Forgot Password?',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color:  Color(0xFF00A86B),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: () => _signInWithEmail(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF00A86B),
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: const Text(
          'LOGIN',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget buildDividerOr() {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: Colors.grey.shade400,
            thickness: 1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Text(
            'OR',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: Colors.grey.shade400,
            thickness: 1,
          ),
        ),
      ],
    );
  }

  Widget buildSocialButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildSocialButton(
          icon: FontAwesomeIcons.facebook,
          color: Colors.blue,
          onPressed: () {},
        ),
        const SizedBox(width: 20),
        buildSocialButton(
          icon: FontAwesomeIcons.google,
          color: Colors.redAccent,
          onPressed: () => _signInWithGoogle(context),
        ),
        const SizedBox(width: 20),
        buildSocialButton(
          icon: FontAwesomeIcons.twitter,
          color: Colors.lightBlue,
          onPressed: () {},
        ),
      ],
    );
  }

  Widget buildSocialButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(
          icon,
          color: color,
          size: 25,
        ),
        onPressed: onPressed,
      ),
    );
  }

  Widget buildSignUpRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Don’t have an account?',
          style: TextStyle(
            color: Colors.grey.shade700,
            fontSize: 14,
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SplashScreen()),
            );
          },
          child: const Text(
            'Register here',
            style: TextStyle(
              color: Color(0xFF00A86B),
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}
