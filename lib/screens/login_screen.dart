import 'package:care__connect/screens/NGO/ngo_dashboard.dart';
import 'package:care__connect/screens/User/main_screen.dart';
import 'package:care__connect/screens/splash_screen.dart';
import 'package:care__connect/screens/User/user_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dashboard_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:care__connect/services/auth_service.dart';
import 'Admin/admin_dashboard.dart';
import 'package:care__connect/screens/User/home_screen.dart';

class LoginScreen extends StatefulWidget{
  const LoginScreen({super.key});
  @override
  _loginScreenState createState() => _loginScreenState();
}
class _loginScreenState extends State<LoginScreen>{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool _obscureText = true;

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

      String ? role = (await AuthService().getUserRole(_auth.currentUser!.uid));

      print("User UID: ${_auth.currentUser!.uid}");
      print("Fetched Role: $role");


      if(role == 'admin'){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AdminDashboard()));
      }else if(role == 'user'){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainScreen()));
      }else if(role == 'ngo'){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>  NGODashboard()));
      }
      else if(role == null){
        print("Error: User role not found.");
        return;
      }
    } catch (e) {
      print('Error signing in with Google: $e');
    }
  }

  Future<void> _signInWithEmail(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      Navigator.pop(context);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => DashboardScreen(),
        ),
      );
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login Failed: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.45,
              decoration: const BoxDecoration(
                color: Color(0xFF00A86B),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Image.asset('lib/assets/login.png', height: 250),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      'Login to your account',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF212121),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _passwordController,
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                      labelText: 'Password',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Checkbox(value: true, onChanged: (_) {}),
                          const Text('Remember me'),
                        ],
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text('Forgot Password?'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => _signInWithEmail(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00A86B),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Center(
                      child: Text(
                        'LOGIN',
                        style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Don’t have an account?'),
                      const SizedBox(width: 5),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const SplashScreen()),
                          );
                        },
                        child: const Text(
                          'Register here',
                          style: TextStyle(color: Color(0xFF00A86B), fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(FontAwesomeIcons.facebook, color: Colors.blue),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(FontAwesomeIcons.twitter, color: Colors.blueAccent),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(FontAwesomeIcons.google, color: Colors.redAccent),
                        onPressed: () => _signInWithGoogle(context),
                      ),
                    ],
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


// import 'package:care__connect/screens/splash_screen.dart';
// import 'package:care__connect/screens/User/user_dashboard.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:care__connect/screens/Admin/admin_dashboard.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final GoogleSignIn _googleSignIn = GoogleSignIn();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   bool _obscureText = true;

//   Future<void> _signInWithGoogle(BuildContext context) async {
//     try {
//       final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
//       if (googleUser == null) return;

//       final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

//       final OAuthCredential credential = GoogleAuthProvider.credential(
//         accessToken: googleAuth.accessToken,
//         idToken: googleAuth.idToken,
//       );

//       final UserCredential userCredential = await _auth.signInWithCredential(credential);
//       final User? user = userCredential.user;

//       if (user != null) {
//         // Fetch admin email from Firestore
//         DocumentSnapshot adminDoc = await FirebaseFirestore.instance.collection('admin').doc('adminEmails').get();
//         List<dynamic> adminEmails = adminDoc.exists ? adminDoc['emails'] : [];

//         if (adminEmails.contains(user.email)) {
//           // Redirect to Admin Dashboard
//           Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AdminDashboard()));
//         } else {
//           // Redirect to User/NGO Dashboard
//           Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const UserDashboardScreen(role: "user")));
//         }
//       }
//     } catch (e) {
//       print('Error signing in with Google: $e');
//     }
//   }

//   Future<void> _signInWithEmail(BuildContext context) async {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => const Center(child: CircularProgressIndicator()),
//     );

//     try {
//       final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
//         email: _emailController.text.trim(),
//         password: _passwordController.text.trim(),
//       );

//       final User? user = userCredential.user;
//       Navigator.pop(context);

//       if (user != null) {
//         // Fetch admin email from Firestore
//         DocumentSnapshot adminDoc = await FirebaseFirestore.instance.collection('admin').doc('adminEmails').get();
//         List<dynamic> adminEmails = adminDoc.exists ? adminDoc['emails'] : [];

//         if (adminEmails.contains(user.email)) {
//           // Redirect to Admin Dashboard
//           Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AdminDashboard()));
//         } else {
//           // Redirect to User/NGO Dashboard
//           Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const UserDashboardScreen(role: "user")));
//         }
//       }
//     } catch (e) {
//       Navigator.pop(context);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Login Failed: ${e.toString()}')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Container(
//               height: MediaQuery.of(context).size.height * 0.45,
//               decoration: const BoxDecoration(
//                 color: Color(0xFF00A86B),
//                 borderRadius: BorderRadius.only(
//                   bottomLeft: Radius.circular(30),
//                   bottomRight: Radius.circular(30),
//                 ),
//               ),
//               child: Center(
//                 child: Padding(
//                   padding: const EdgeInsets.all(20.0),
//                   child: Image.asset('lib/assets/globe.png', height: 350),
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Center(
//                     child: Text(
//                       'Login to your account',
//                       style: TextStyle(
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                         color: Color(0xFF212121),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   TextField(
//                     controller: _emailController,
//                     decoration: InputDecoration(
//                       labelText: 'Email',
//                       border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   TextField(
//                     controller: _passwordController,
//                     obscureText: _obscureText,
//                     decoration: InputDecoration(
//                       suffixIcon: IconButton(
//                         icon: Icon(
//                           _obscureText ? Icons.visibility_off : Icons.visibility,
//                         ),
//                         onPressed: () {
//                           setState(() {
//                             _obscureText = !_obscureText;
//                           });
//                         },
//                       ),
//                       labelText: 'Password',
//                       border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Row(
//                         children: [
//                           Checkbox(value: true, onChanged: (_) {}),
//                           const Text('Remember me'),
//                         ],
//                       ),
//                       TextButton(
//                         onPressed: () {},
//                         child: const Text('Forgot Password?'),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 20),
//                   ElevatedButton(
//                     onPressed: () => _signInWithEmail(context),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xFF00A86B),
//                       padding: const EdgeInsets.symmetric(vertical: 15),
//                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                     ),
//                     child: const Center(
//                       child: Text(
//                         'LOGIN',
//                         style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const Text('Don’t have an account?'),
//                       const SizedBox(width: 5),
//                       GestureDetector(
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(builder: (context) => const SplashScreen()),
//                           );
//                         },
//                         child: const Text(
//                           'Register here',
//                           style: TextStyle(color: Color(0xFF00A86B), fontWeight: FontWeight.bold),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 30),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       IconButton(
//                         icon: const Icon(FontAwesomeIcons.facebook, color: Colors.blue),
//                         onPressed: () {},
//                       ),
//                       IconButton(
//                         icon: const Icon(FontAwesomeIcons.twitter, color: Colors.blueAccent),
//                         onPressed: () {},
//                       ),
//                       IconButton(
//                         icon: const Icon(FontAwesomeIcons.google, color: Colors.redAccent),
//                         onPressed: () => _signInWithGoogle(context),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
