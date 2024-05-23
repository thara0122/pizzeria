import 'package:flutter/material.dart';
import 'package:pizzeria1/admin/pizza.dart';

class PizzaDetailScreen extends StatelessWidget {
  final Pizza pizza;

  const PizzaDetailScreen({required this.pizza, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pizza.name),
        backgroundColor: Colors.redAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: pizza.imageUrl.isNotEmpty
                  ? Image.network(
                      pizza.imageUrl,
                      height: 200,
                      fit: BoxFit.cover,
                    )
                  : Image.network(
                      'https://via.placeholder.com/150',
                      height: 200,
                      fit: BoxFit.cover,
                    ),
            ),
            const SizedBox(height: 16),
            Text(
              pizza.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              pizza.description,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '\RM ${pizza.price.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
