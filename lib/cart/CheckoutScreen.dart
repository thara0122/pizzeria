import 'package:flutter/material.dart';
import 'package:pizzeria1/admin/PizzaOrders.dart';
import 'package:pizzeria1/cart/addon.dart';
import 'package:provider/provider.dart';
import 'package:pizzeria1/cart/CartService.dart';
import 'package:pizzeria1/admin/pizza_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CheckoutScreen extends StatefulWidget {
  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final List<AddOn> availableAddOns = [
    AddOn(name: 'Garlic Bread', price: 5.0),
    AddOn(name: 'Creamy Mushroom Soup', price: 4.9),
    AddOn(name: 'Mamamia Meatballs', price: 17.9),
    AddOn(name: 'Cheesy Wedges', price: 3.5),
  ];

  final _addressController = TextEditingController();

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartService = Provider.of<CartService>(context);
    final cartItems = cartService.cart;

    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your basket',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final item = cartItems[index];
                  return Card(
                    child: ListTile(
                      //  leading: Image.asset('assets/images/${item.pizza.image}'), // Ensure you have pizza images in your assets
                      title: Text(item.pizza.name),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Quantity: ${item.quantity}, Extra Cheese: ${item.extraCheese}, Extra Meat: ${item.extraMeat}, Size: ${item.size}',
                          ),
                          Text(
                            'Add-Ons: ${item.addOns.map((addOn) => addOn.name).join(', ')}',
                          ),
                        ],
                      ),
                      trailing: Text(
                        '\RM ${(item.pizza.price * item.quantity + item.addOns.fold(0, (sum, addOn) => sum + addOn.price)).toStringAsFixed(2)}',
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            Text(
              'You may also like',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: availableAddOns.length,
                itemBuilder: (context, index) {
                  final addOn = availableAddOns[index];
                  return Card(
                    child: Container(
                      width: 120,
                      child: Column(
                        children: [
                          //Image.asset('assets/images/${addOn.image}'), // Ensure you have add-on images in your assets
                          Text(addOn.name),
                          Text('\RM ${addOn.price.toStringAsFixed(2)}'),
                          ElevatedButton(
                            onPressed: () {
                              if (cartItems.isNotEmpty) {
                                cartService.addAddOnToCartItem(0, addOn);
                              }
                            },
                            child: Text('Add'),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _addressController,
              decoration: InputDecoration(
                labelText: 'Enter your address',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final totalPrice = cartItems.fold(
                  0.0,
                  (total, current) =>
                      total +
                      current.pizza.price * current.quantity +
                      current.addOns.fold(
                          0.0, (addOnTotal, addOn) => addOnTotal + addOn.price),
                );

                final user = FirebaseAuth.instance.currentUser;
                if (user == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          Text('You need to be logged in to place an order.'),
                    ),
                  );
                  return;
                }
                final userId = user.uid;

                final order = PizzaOrder(
                  id: '',
                  address: _addressController.text,
                  totalPrice: totalPrice,
                  items: cartItems,
                  timestamp: DateTime.now(),
                  status: 'Pending',
                  userId: userId,
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
            SizedBox(height: 20),
            Text(
              'Order Summary',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Subtotal: \RM ${cartService.subtotal.toStringAsFixed(2)}',
            ),
            Divider(),
            Text(
              'Total: \RM ${cartService.total.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
