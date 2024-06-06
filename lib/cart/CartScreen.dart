import 'package:flutter/material.dart';
import 'package:pizzeria1/cart/CartService.dart';
import 'package:pizzeria1/cart/CheckoutScreen.dart';
import 'package:provider/provider.dart';
import 'package:pizzeria1/cart/cartitem.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cartService = Provider.of<CartService>(context);
    final cart = cartService.cart;

    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
        backgroundColor: Colors.redAccent,
      ),
      body: cart.isEmpty
          ? Center(child: Text('Your cart is empty'))
          : ListView.builder(
              itemCount: cart.length,
              itemBuilder: (context, index) {
                final cartItem = cart[index];
                return ListTile(
                  leading: cartItem.pizza.imageUrl.isNotEmpty
                      ? Image.network(cartItem.pizza.imageUrl, width: 50, height: 50)
                      : Image.network('https://via.placeholder.com/150', width: 50, height: 50),
                  title: Text(cartItem.pizza.name),
                  subtitle: Text('\RM ${cartItem.pizza.price.toStringAsFixed(2)}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () {
                          if (cartItem.quantity > 1) {
                            cartService.updateCartItemQuantity(cartItem.pizza, cartItem.quantity - 1);
                          } else {
                            cartService.removeFromCart(cartItem.pizza);
                          }
                        },
                      ),
                      Text(cartItem.quantity.toString()),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          cartService.updateCartItemQuantity(cartItem.pizza, cartItem.quantity + 1);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () {
                          cartService.removeFromCart(cartItem.pizza);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CheckoutScreen(),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: Text('Checkout'),
        ),
      ),
    );
  }
}
