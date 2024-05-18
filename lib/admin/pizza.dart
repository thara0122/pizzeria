import 'package:cloud_firestore/cloud_firestore.dart';

class Pizza {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl; // Optional: Add a field for image URL

  const Pizza({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.imageUrl = '', // Optional: Set a default empty string for imageUrl
  });

  factory Pizza.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    return Pizza(
      id: doc.id,
      name: doc.data()!['name'] as String,
      description: doc.data()!['description'] as String,
      price: double.parse(doc.data()!['price'].toString()),
      imageUrl: doc.data()!['imageUrl'] ?? '', // Optional: Handle potential missing imageUrl
    );
  }
}
