import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:pizzeria1/admin/PizzaOrders.dart';


class AdminUpdateOrderStatusScreen extends StatelessWidget {
  const AdminUpdateOrderStatusScreen({Key? key}) : super(key: key);

  Future<List<PizzaOrder>> _fetchOrders() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('orders').get();
      print('Fetched ${snapshot.docs.length} orders');
      return snapshot.docs
          .map((doc) {
            try {
              final order = PizzaOrder.fromFirestore(doc);
              print(
                  'Order Data: ${order.id}, ${order.address}, ${order.totalPrice}');
              return order;
            } catch (e) {
              print('Error parsing order data: $e');
              return null;
            }
          })
          .where((order) => order != null)
          .cast<PizzaOrder>()
          .toList();
    } catch (e) {
      print('Error fetching orders: $e');
      rethrow;
    }
  }

  Future<void> _updateOrderStatus(String orderId, String status) async {
    try {
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(orderId)
          .update({
        'status': status,
      });
    } catch (e) {
      print('Error updating order status: $e');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Order Status'),
        backgroundColor: Colors.redAccent,
      ),
      body: FutureBuilder<List<PizzaOrder>>(
        future: _fetchOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
                child: Text('Error fetching orders: ${snapshot.error}'));
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
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ExpansionTile(
                    title: Text(
                      'Order ${order.id}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                        'Status: ${order.status}\nTotal: RM ${order.totalPrice.toStringAsFixed(2)}'),
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: order.items.length,
                        itemBuilder: (context, itemIndex) {
                          final item = order.items[itemIndex];
                          return ListTile(
                            title: Text(item.pizza.name),
                            subtitle: Text(
                              'Quantity: ${item.quantity}\n'
                              'Price: RM ${(item.pizza.price * item.quantity).toStringAsFixed(2)}\n'
                              'Extra Cheese: ${item.extraCheese ? "Yes" : "No"}\n'
                              'Extra Meat: ${item.extraMeat ? "Yes" : "No"}\n'
                              'Size: ${item.size}',
                            ),
                          );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Update Status',
                          ),
                          value: order.status,
                          items: ['Pending', 'Confirmed', 'Preparing', 'Ready']
                              .map((status) => DropdownMenuItem(
                                    value: status,
                                    child: Text(status),
                                  ))
                              .toList(),
                          onChanged: (newStatus) {
                            if (newStatus != null) {
                              _updateOrderStatus(order.id, newStatus);
                            }
                          },
                        ),
                      ),
                    ],
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
