import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pizzeria1/admin/PizzaOrders.dart';

class UserOrderStatusScreen extends StatelessWidget {
  final String userId;

  UserOrderStatusScreen({Key? key, required this.userId}) : super(key: key);

  Future<List<PizzaOrder>> _fetchUserOrders() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('orders')
          .where('userId', isEqualTo: userId)
          .get();
      print('Fetched ${snapshot.docs.length} user orders');
      return snapshot.docs.map((doc) {
        try {
          final order = PizzaOrder.fromFirestore(doc);
          print('User Order Data: ${order.id}, ${order.address}, ${order.totalPrice}');
          return order;
        } catch (e) {
          print('Error parsing user order data: $e');
          return null;
        }
      }).where((order) => order != null).cast<PizzaOrder>().toList();
    } catch (e) {
      print('Error fetching user orders: $e');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Orders'),
        backgroundColor: Colors.redAccent,
      ),
      body: FutureBuilder<List<PizzaOrder>>(
        future: _fetchUserOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error fetching orders: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No orders found'));
          }
          final orders = snapshot.data!;
          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return ExpansionTile(
                title: Text('Order ${order.id}'),
                subtitle: Text('Status: ${order.status}\nTotal: RM ${order.totalPrice.toStringAsFixed(2)}'),
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: order.items.length,
                    itemBuilder: (context, itemIndex) {
                      final item = order.items[itemIndex];
                      return ListTile(
                        title: Text(item.pizza.name),
                        subtitle: Text('Quantity: ${item.quantity}\nPrice: RM ${item.pizza.price * item.quantity}'),
                      );
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
