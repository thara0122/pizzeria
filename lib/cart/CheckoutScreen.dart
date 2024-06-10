import 'package:flutter/material.dart';
import 'package:pizzeria1/admin/PizzaOrders.dart';
import 'package:provider/provider.dart';
import 'package:pizzeria1/cart/CartService.dart';
import 'package:pizzeria1/admin/pizza_service.dart';

class CheckoutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cartService = Provider.of<CartService>(context);
    final cartItems = cartService.cart;

    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final item = cartItems[index];
                  return ListTile(
                    title: Text(item.pizza.name),
                    subtitle: Text(
                      'Quantity: ${item.quantity}, Extra Cheese: ${item.extraCheese}, Extra Meat: ${item.extraMeat}, Size: ${item.size}',
                    ),
                    trailing: Text('\RM ${item.pizza.price.toStringAsFixed(2)}'),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                final totalPrice = cartItems.fold(
                  0.0,
                  (total, current) => total + current.pizza.price * current.quantity,
                );

                final order = PizzaOrder(
                  id: '', // Firestore will generate this ID
                  address: 'Customer Address', // Replace with actual address input
                  totalPrice: totalPrice,
                  items: cartItems,
                  timestamp: DateTime.now(),
                  status: 'Pending',
                );

                try {
                  final pizzaService = PizzaService();
                  await pizzaService.addOrder(order);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Order placed successfully!'),
                    ),
                  );
                  cartService.clearCart();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error placing order: $e'),
                    ),
                  );
                }
              },
              child: Text('Place Order'),
            ),
          ],
        ),
      ),
    );
  }
}
