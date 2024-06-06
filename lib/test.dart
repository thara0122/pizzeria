import 'package:flutter/material.dart';
import 'package:pizzeria1/admin/AdminUpdateOrderStatusScreen.dart';
import 'package:pizzeria1/admin/addPizza.dart';
import 'package:pizzeria1/admin/edit_pizza_screen.dart';
import 'package:pizzeria1/auth/auth_service.dart';
import 'package:pizzeria1/auth/login_screen.dart';


class AdminHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = AuthService();
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Homepage'),
        backgroundColor: Colors.redAccent,
        actions: [
          TextButton(
            onPressed: () async {
              await auth.signout();
              goToLogin(context);
            },
            child: Text(
              'Sign Out',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'PIZZERIA',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.redAccent,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Welcome back,\nAdmin',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Text(
                'Admin Access',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                children: [
                  _buildMenuButton(
                    context,
                    icon: Icons.local_pizza_sharp,
                    label: 'Add Pizza',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AdminPanel()),
                    ),
                  ),
                  _buildMenuButton(
                    context,
                    icon: Icons.edit,
                    label: 'Edit Pizza',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const EditPizzaScreen()),
                    ),
                  ),
                  _buildMenuButton(
                    context,
                    icon: Icons.delete_outline,
                    label: 'Delete Pizza',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const EditPizzaScreen()),
                    ),
                  ),
                  _buildMenuButton(
                    context,
                    icon: Icons.manage_search,
                    label: 'Orders',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const AdminUpdateOrderStatusScreen()),
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

  Widget _buildMenuButton(BuildContext context,
      {required IconData icon,
      required String label,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.redAccent,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 50,
              color: Colors.white,
            ),
            SizedBox(height: 10),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void goToLogin(BuildContext context) => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
}
