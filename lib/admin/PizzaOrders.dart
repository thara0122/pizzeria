// order.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pizzeria1/cart/CartItem.dart';

class PizzaOrder {
  final String id;
  final String address;
  final double totalPrice;
  final List<CartItem> items;
  final DateTime timestamp;
  final String status; // Added status field

  PizzaOrder({
    required this.id,
    required this.address,
    required this.totalPrice,
    required this.items,
    required this.timestamp,
    required this.status, // Added status parameter
  });

  factory PizzaOrder.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PizzaOrder(
      id: doc.id,
      address: data['address'],
      totalPrice: data['totalPrice'],
      items: (data['items'] as List<dynamic>)
          .map((item) => CartItem.fromMap(item))
          .toList(),
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      status: data['status'] ?? 'Pending', // Default status
    );
  }
}
