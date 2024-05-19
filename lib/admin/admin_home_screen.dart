import 'package:flutter/material.dart';
import 'package:pizzeria1/admin/addPizza.dart';
import 'package:pizzeria1/admin/edit_pizza_screen.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pizza Admin Dashboard'),
      ),
      body: Stack(
        // Use a Stack widget for layering
        children: [
          // Background image container
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'images/adminBackground.jpg'), // Replace with your image path
                fit: BoxFit.cover, // Adjust fit as needed (cover, fill, etc.)
              ),
            ),
          ),

          ListView(
            padding: const EdgeInsets.all(20.0),
            children: [
              // Manage Users card
              Card(
                elevation: 4.0, // Add some elevation
                child: ListTile(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AdminPanel()),
                  ),
                  leading: const Icon(Icons.person_add, size: 30),
                  title: Text(
                    'Add Pizza',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              const SizedBox(height: 20), // Add spacing between cards

              // Edit Pizzas card
              Card(
                elevation: 4.0,
                child: ListTile(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const EditPizzaScreen()),
                  ),
                  leading: const Icon(Icons.edit, size: 30),
                  title: Text(
                    'Edit Pizzas',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              const SizedBox(height: 20), // Add spacing between cards

              // Add more cards for additional functionalities
            ],
          ),
        ],
      ),
    );
  }
}
