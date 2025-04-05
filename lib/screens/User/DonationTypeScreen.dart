// import 'package:flutter/material.dart';
// import 'NgoSelectionScreen.dart';
// import 'donate_screen.dart';

// class DonationTypeScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Choose Donation Type"), backgroundColor: Colors.orange),
//       body: GridView.count(
//         crossAxisCount: 2,
//         padding: EdgeInsets.all(20),
//         crossAxisSpacing: 20,
//         mainAxisSpacing: 20,
//         children: [
//           _buildDonationOption(context, "Food", Icons.fastfood, Colors.green),
//           _buildDonationOption(context, "Clothes", Icons.checkroom, Colors.blue),
//           _buildDonationOption(context, "Books", Icons.menu_book, Colors.purple),
//           _buildDonationOption(context, "Monetary", Icons.monetization_on, Colors.orange),
//         ],
//       ),
//     );
//   }

//   Widget _buildDonationOption(BuildContext context, String type, IconData icon, Color color) {
//     return GestureDetector(
//       onTap: () {
//         if (type == "Monetary") {
//           Navigator.push(context, MaterialPageRoute(builder: (context) => DonateScreen()));
//         } else {
//           Navigator.push(context, MaterialPageRoute(builder: (context) => NgoSelectionScreen(donationType: type)));
//         }
//       },
//       child: Container(
//         decoration: BoxDecoration(
//           color: color.withOpacity(0.2),
//           borderRadius: BorderRadius.circular(15),
//           border: Border.all(color: color, width: 2),
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(icon, size: 50, color: color),
//             const SizedBox(height: 10),
//             Text(type, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'NgoSelectionScreen.dart';
import 'donate_screen.dart';

class DonationTypeScreen extends StatefulWidget {
  @override
  _DonationTypeScreenState createState() => _DonationTypeScreenState();
}

class _DonationTypeScreenState extends State<DonationTypeScreen> with SingleTickerProviderStateMixin {
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
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30),
                    const Text(
                      'What would you like to donate?',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Choose a donation category to continue',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Expanded(
                      child: GridView.count(
                        crossAxisCount: 2,
                        childAspectRatio: screenSize.width > 600 ? 1.5 : 1.1,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                        children: [
                          _buildDonationOption(
                              context, "Food", Icons.fastfood, "Donate food items to those in need"),
                          _buildDonationOption(
                              context, "Clothes", Icons.checkroom, "Donate clothes to help others"),
                          _buildDonationOption(
                              context, "Books", Icons.menu_book, "Share knowledge through books"),
                          _buildDonationOption(
                              context, "Monetary", Icons.monetization_on, "Support with financial contribution"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
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
          Positioned(
            top: 50,
            left: 20,
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
              onPressed: () => Navigator.pop(context),
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

  Widget _buildDonationOption(BuildContext context, String type, IconData icon, String description) {
    return GestureDetector(
      onTap: () {
        if (type == "Monetary") {
          Navigator.push(context, MaterialPageRoute(builder: (context) => DonateScreen()));
        } else {
          Navigator.push(context, MaterialPageRoute(builder: (context) => NgoSelectionScreen(donationType: type)));
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 70,
              width: 70,
              decoration: BoxDecoration(
                color: const Color(0xFF00A86B).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 35,
                color: const Color(0xFF00A86B),
              ),
            ),
            const SizedBox(height: 15),
            Text(
              type,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
            ),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}