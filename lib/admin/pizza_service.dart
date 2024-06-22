import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:pizzeria1/admin/PizzaOrders.dart';
import 'package:pizzeria1/admin/pizza.dart';

class PizzaService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> _uploadImage(File imageFile) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference ref = _storage.ref().child('pizza_images').child(fileName);
      UploadTask uploadTask = ref.putFile(imageFile);
      TaskSnapshot taskSnapshot = await uploadTask;
      return await taskSnapshot.ref.getDownloadURL();
    } catch (e) {
      throw Exception('Error uploading image: $e');
    }
  }

  Future<void> addPizza(String name, String description, double price,
      {File? imageFile}) async {
    try {
      String? imageUrl;
      if (imageFile != null) {
        imageUrl = await _uploadImage(imageFile);
      }

      final docRef =
          _firestore.collection('pizzas').doc(); // Create a new document
      await docRef.set({
        'name': name,
        'description': description,
        'price': price,
        'imageUrl': imageUrl ?? '', // Save the image URL if available
        'createdAt': FieldValue.serverTimestamp(),
      });
      print('New pizza added: $name');
    } catch (e) {
      throw Exception('Error adding pizza: $e');
    }
  }

  Future<List<Pizza>> fetchPizzas() async {
    final snapshot = await _firestore.collection('pizzas').get();
    return snapshot.docs.map((doc) => Pizza.fromFirestore(doc)).toList();
  }

  Future<void> updatePizza(Pizza pizza, {File? imageFile}) async {
    try {
      String? imageUrl = pizza.imageUrl;
      if (imageFile != null) {
        imageUrl = await _uploadImage(imageFile);
      }

      final docRef = _firestore.collection('pizzas').doc(pizza.id);
      await docRef.update({
        'name': pizza.name,
        'description': pizza.description,
        'price': pizza.price,
        'imageUrl': imageUrl,
      });
      print('Pizza with ID ${pizza.id} updated');
    } catch (e) {
      throw Exception('Error updating pizza: $e');
    }
  }

  Future<void> deletePizza(String id) async {
    final docRef = _firestore.collection('pizzas').doc(id);
    await docRef.delete();
    print('Pizza with ID $id deleted');
  }

  Future<void> addOrder(PizzaOrder order) async {
    try {
      final docRef = _firestore.collection('orders').doc(); // Create a new document
      await docRef.set(order.toMap()); // Use the toMap method to save the order
      print('Order added');
    } catch (e) {
      throw Exception('Error adding order: $e');
    }
  }

  Future<List<PizzaOrder>> fetchOrders() async {
    final snapshot = await _firestore.collection('orders').get();
    return snapshot.docs.map((doc) => PizzaOrder.fromFirestore(doc)).toList();
  }
}
