import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pizzeria1/admin/PizzaOrders.dart';
import 'OrderDetailScreen.dart';

class OrderHistoryScreen extends StatelessWidget {
  Future<List<PizzaOrder>> _fetchOrders() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('orders')
          .where('userId',
              isEqualTo:
                  'eOCKTR6X7SZxpNBXMyW79VGtmoA2') // replace with actual user ID
          .get();
      return snapshot.docs.map((doc) => PizzaOrder.fromFirestore(doc)).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Tracker'),
      ),
      body: FutureBuilder<List<PizzaOrder>>(
        future: _fetchOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No orders found'));
          }
          final orders = snapshot.data!;
          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return Card(
                margin: EdgeInsets.all(10.0),
                child: ListTile(
                  title: Text('Order #${order.id}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(order.address),
                      Text(order.timestamp.toString()),
                      Text('TOTAL: RM ${order.totalPrice.toStringAsFixed(2)}'),
                    ],
                  ),
                  trailing: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              OrderDetailScreen(orderId: order.id),
                        ),
                      );
                    },
                    child: Text('View Detail'),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
