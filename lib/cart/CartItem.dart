import 'package:pizzeria1/admin/pizza.dart';

class CartItem {
  final Pizza pizza;
  int quantity;

  CartItem({required this.pizza, this.quantity = 1});

  factory CartItem.fromMap(Map<String, dynamic> data) {
    return CartItem(
      pizza: Pizza(
        id: data['id'],
        name: data['name'],
        description: data['description'] ?? '', // Ensure description is optional
        price: data['price'],
        imageUrl: data['imageUrl'] ?? '', // Ensure imageUrl is optional
      ),
      quantity: data['quantity'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': pizza.id,
      'name': pizza.name,
      'description': pizza.description,
      'price': pizza.price,
      'imageUrl': pizza.imageUrl,
      'quantity': quantity,
    };
  }
}
