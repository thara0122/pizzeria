// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// //import 'package:pizzeria1/admin/order.dart' as customOrder;
// import 'package:intl/intl.dart';

// class OrderListScreen extends StatelessWidget {
//   const OrderListScreen({Key? key}) : super(key: key);

//   Future<List<customOrder.Order>> _fetchOrders() async {
//     try {
//       final snapshot =
//           await FirebaseFirestore.instance.collection('orders').get();
//       return snapshot.docs
//           .map((doc) => customOrder.Order.fromFirestore(doc))
//           .toList();
//     } catch (e) {
//       print('Error fetching orders: $e');
//       rethrow;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Orders'),
//         backgroundColor: Colors.redAccent,
//       ),
//       body: FutureBuilder<List<customOrder.Order>>(
//         future: _fetchOrders(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }
//           if (snapshot.hasError) {
//             return Center(
//                 child: Text('Error fetching orders: ${snapshot.error}'));
//           }
//           if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return Center(child: Text('No orders found'));
//           }
//           final orders = snapshot.data!;
//           return ListView.builder(
//             itemCount: orders.length,
//             itemBuilder: (context, index) {
//               final order = orders[index];
//               return ListTile(
//                 title: Text('Order ${order.id}'),
//                 subtitle:
//                     Text('Total: \RM ${order.totalPrice.toStringAsFixed(2)}'),
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => OrderDetailScreen(order: order),
//                     ),
//                   );
//                 },
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

// class OrderDetailScreen extends StatelessWidget {
//   final customOrder.Order order;

//   const OrderDetailScreen({Key? key, required this.order}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Order Details'),
//         backgroundColor: Colors.redAccent,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Order ID: ${order.id}',
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 10),
//             Text(
//               'Address: ${order.address}',
//               style: TextStyle(fontSize: 16),
//             ),
//             SizedBox(height: 10),
//             Text(
//               'Order Time: ${DateFormat.yMMMd().add_jm().format(order.orderTime)}',
//               style: TextStyle(fontSize: 16),
//             ),
//             SizedBox(height: 10),
//             Text(
//               'Total Price: \RM ${order.totalPrice.toStringAsFixed(2)}',
//               style: TextStyle(fontSize: 16),
//             ),
//             SizedBox(height: 20),
//             Text(
//               'Items:',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 10),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: order.items.length,
//                 itemBuilder: (context, index) {
//                   final item = order.items[index];
//                   return ListTile(
//                     title: Text(item.pizza.name),
//                     subtitle: Text(
//                       'Quantity: ${item.quantity}\nPrice: \RM ${item.pizza.price.toStringAsFixed(2)}',
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
