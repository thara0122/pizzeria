import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pizzeria1/cart/CartItem.dart';

class PizzaOrder {
  final String id;
  final String address;
  final double totalPrice;
  final List<CartItem> items;
  final DateTime timestamp;
  final String status;
  final String userId; // Add userId field

  PizzaOrder({
    required this.id,
    required this.address,
    required this.totalPrice,
    required this.items,
    required this.timestamp,
    required this.status,
    required this.userId, // Initialize userId
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
      status: data['status'] ?? 'Pending',
      userId: data['userId'], // Assign userId from Firestore data
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'address': address,
      'totalPrice': totalPrice,
      'items': items.map((item) => item.toMap()).toList(),
      'timestamp': timestamp,
      'status': status,
      'userId': userId, // Include userId in the Firestore document
    };
  }
}
