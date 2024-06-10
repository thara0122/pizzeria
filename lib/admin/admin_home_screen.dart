import 'package:flutter/material.dart';
import 'package:pizzeria1/admin/addPizza.dart';
import 'package:pizzeria1/admin/edit_pizza_screen.dart';
import 'package:pizzeria1/admin/salesReportScreen.dart';


class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pizza Admin Dashboard'),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/adminBackground.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          ListView(
            padding: const EdgeInsets.all(20.0),
            children: [
              Card(
                elevation: 4.0,
                child: ListTile(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AdminPanel()),
                  ),
                  leading: const Icon(Icons.person_add, size: 30),
                  title: const Text(
                    'Add Pizza',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Card(
                elevation: 4.0,
                child: ListTile(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const EditPizzaScreen()),
                  ),
                  leading: const Icon(Icons.edit, size: 30),
                  title: const Text(
                    'Edit Pizzas',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Card(
                elevation: 4.0,
                child: ListTile(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SalesReportScreen()), // Navigate to Sales Report
                  ),
                  leading: const Icon(Icons.bar_chart, size: 30),
                  title: const Text(
                    'View Sales Report',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
