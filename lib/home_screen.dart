import 'package:flutter/material.dart';
import 'package:pizzeria1/ViewPizzaScreen.dart';
import 'package:pizzeria1/admin/admin_home_screen.dart';
import 'package:pizzeria1/auth/auth_service.dart';
import 'package:pizzeria1/auth/login_screen.dart';
import 'package:pizzeria1/auth/profile_screen.dart';
import 'package:pizzeria1/widgets/button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = AuthService();
    final currentIndex = 0; // Assuming initial tab is the first one

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Colors.redAccent, // Change the app bar color
        automaticallyImplyLeading: false, // Remove the back button
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.redAccent, Colors.black],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Add image container with new dimensions and styling
              SizedBox(
                height: 350,
                width: 500,
                child: Image.asset(
                  'images/pizzaBackground2.png', // Replace with your image path
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Welcome To Pizzeria\nCheck It Out",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 30),
              ModernButton(
                label: "Order Now",
                onPressed: () {
                  goToViewPizza(context);
                },
                color: Colors.white, // Update button color
                textColor: Colors.redAccent, // Update button text color
              ),
              const SizedBox(height: 10),
              ModernButton(
                label: "Sign Out",
                onPressed: () async {
                  try {
                    await auth.signout();
                    goToLogin(context);
                  } catch (e) {
                    print('Error signing out: $e');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error signing out: $e')),
                    );
                  }
                },
                color: Colors.white, // Update button color
                textColor: Colors.redAccent, // Update button text color
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        selectedItemColor: Colors.deepOrange, // Change selected item color
        unselectedItemColor: Colors.grey, // Change unselected item color
        onTap: (index) async {
          final user = await auth.getCurrentUser();
          if (user != null) {
            if (index == 0) {
              // Do nothing, user is already on Home screen
            } else if (index == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            } else if (index == 2 && user.isAdmin) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AdminDashboardScreen()),
              );
            }
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  void goToLogin(BuildContext context) => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );

  void goToViewPizza(BuildContext context) => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ViewPizza()),
      );
}

class ModernButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color color;
  final Color textColor;

  const ModernButton({
    required this.label,
    required this.onPressed,
    this.color = Colors.blue,
    this.textColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(color: textColor, fontSize: 16),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(home: HomeScreen()));
}
