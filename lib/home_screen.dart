import 'package:pizzeria1/auth/auth_service.dart';
import 'package:pizzeria1/auth/login_screen.dart';
import 'package:pizzeria1/auth/profile_screen.dart';
import 'package:pizzeria1/widgets/button.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = AuthService();
    final currentIndex = 0; // Assuming initial tab is the first one

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        // Use Center for better alignment
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center, // Center content vertically
          children: [
            // Add image container
            SizedBox(
              height: 200, // Adjust image height as needed
              width: MediaQuery.of(context).size.width, // Match screen width
              child: Image.asset(
                'images/pizzaDoddleLogo.png', // Replace with your image path
                //fit: BoxFit.cover, // Ensure image covers the container
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Welcome To Pizzeria " + "\n   Coming Hot Soon",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 20),
            CustomButton(
              label: "Sign Out",
              onPressed: () async {
                await auth.signout();
                goToLogin(context);
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Use fixed for 3-5 items
        currentIndex: currentIndex,
        onTap: (index) {
          // Handle navigation based on tapped index
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfileScreen()),
            );
          } else {
            // Handle other navigation if needed
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
}
