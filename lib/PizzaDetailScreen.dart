import 'package:flutter/material.dart';
import 'package:pizzeria1/cart/CartService.dart';
import 'package:provider/provider.dart';
import 'admin/pizza.dart';

class PizzaDetailScreen extends StatefulWidget {
  final Pizza pizza;

  const PizzaDetailScreen({required this.pizza, Key? key}) : super(key: key);

  @override
  _PizzaDetailScreenState createState() => _PizzaDetailScreenState();
}

class _PizzaDetailScreenState extends State<PizzaDetailScreen> {
  bool extraCheese = false;
  bool extraMeat = false;
  String size = 'regular';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pizza.name),
        backgroundColor: Colors.redAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: widget.pizza.imageUrl.isNotEmpty
                  ? Image.network(
                      widget.pizza.imageUrl,
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
              widget.pizza.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.pizza.description,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '\RM ${widget.pizza.price.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: Text('Extra Cheese'),
              value: extraCheese,
              onChanged: (bool value) {
                setState(() {
                  extraCheese = value;
                });
              },
            ),
            SwitchListTile(
              title: Text('Extra Meat'),
              value: extraMeat,
              onChanged: (bool value) {
                setState(() {
                  extraMeat = value;
                });
              },
            ),
            DropdownButton<String>(
              value: size,
              items: ['personal', 'regular', 'large'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  size = newValue!;
                });
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Provider.of<CartService>(context, listen: false).addToCart(
                  widget.pizza,
                  extraCheese: extraCheese,
                  extraMeat: extraMeat,
                  size: size,
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${widget.pizza.name} added to cart!'),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Text('Add to Cart'),
            ),
          ],
        ),
      ),
    );
  }
}
