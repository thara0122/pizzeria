import 'package:flutter/material.dart';
import 'package:pizzeria1/cart/cart/CartService.dart';
import 'package:provider/provider.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class CheckoutScreen extends StatefulWidget {
  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _addressController = TextEditingController();

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _placeOrder(BuildContext context) async {
    final cartService = Provider.of<CartService>(context, listen: false);
    final cart = cartService.cart;

    if (cart.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Your cart is empty!')),
      );
      return;
    }

    if (_addressController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter your address!')),
      );
      return;
    }

    try {
      // Create an order object
      final order = {
        'items': cart.map((cartItem) => {
              'id': cartItem.pizza.id,
              'name': cartItem.pizza.name,
              'price': cartItem.pizza.price,
              'quantity': cartItem.quantity,
            }).toList(),
        'address': _addressController.text,
        'totalPrice': cart.fold(0.0, (sum, item) => sum + (item.pizza.price * item.quantity)),
        'timestamp': FieldValue.serverTimestamp(),
      };

      // Save the order to Firestore
      await FirebaseFirestore.instance.collection('orders').add(order);

      // Clear the cart
      cartService.clearCart();

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Order placed successfully!')),
      );

      // Navigate back to the home screen or order confirmation screen
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to place order: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartService = Provider.of<CartService>(context);
    final cart = cartService.cart;

    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
        backgroundColor: Colors.redAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Order',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.redAccent,
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: cart.length,
                itemBuilder: (context, index) {
                  final cartItem = cart[index];
                  return ListTile(
                    leading: cartItem.pizza.imageUrl.isNotEmpty
                        ? Image.network(cartItem.pizza.imageUrl, width: 50, height: 50)
                        : Image.network('https://via.placeholder.com/150', width: 50, height: 50),
                    title: Text(cartItem.pizza.name),
                    subtitle: Text('Quantity: ${cartItem.quantity}'),
                    trailing: Text('\RM ${cartItem.pizza.price.toStringAsFixed(2)}'),
                  );
                },
              ),
            ),
            TextField(
              controller: _addressController,
              decoration: InputDecoration(
                hintText: 'Enter your address',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _placeOrder(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Text('Place Order'),
            ),
          ],
        ),
      ),
    );
  }
}
