import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pizzeria1/admin/pizza.dart';

class PizzaService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addPizza(String name, String description, double price, {required String imageUrl}) async {
    final docRef = _firestore.collection('pizzas').doc(); // Create a new document
    await docRef.set({
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': '', // Optional: Add a field for image URL if you're using images
    });
    print('New pizza added: $name');
  }

  Future<List<Pizza>> fetchPizzas() async {
    final snapshot = await _firestore.collection('pizzas').get();
    return snapshot.docs.map((doc) => Pizza.fromFirestore(doc)).toList();
  }

  // Optional: Function to update pizza details (if needed)
  Future<void> updatePizza(String id, String name, String description, double price) async {
    final docRef = _firestore.collection('pizzas').doc(id);
    await docRef.update({
      'name': name,
      'description': description,
      'price': price,
    });
    print('Pizza with ID $id updated');
  }
}
