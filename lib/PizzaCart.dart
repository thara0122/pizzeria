// pizza_card.dart

import 'package:flutter/material.dart';
import 'package:pizzeria1/admin/pizza.dart';

class PizzaCard extends StatelessWidget {
  final Pizza pizza;

  const PizzaCard({Key? key, required this.pizza}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            if (pizza.imageUrl.isNotEmpty) // Check if image URL exists
              Image.network(pizza.imageUrl, height: 100, width: 100),
            const SizedBox(height: 10),
            Text(pizza.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(pizza.description),
            Text('Price: \$ ${pizza.price.toStringAsFixed(2)}'), // Format price with 2 decimal places
          ],
        ),
      ),
    );
  }
}
