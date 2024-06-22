import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderDetailScreen extends StatelessWidget {
  final String orderId;

  const OrderDetailScreen({Key? key, required this.orderId}) : super(key: key);

  Future<Map<String, dynamic>> _fetchOrderDetails() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('orders')
          .doc(orderId)
          .get();
      return doc.data()!;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Status'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _fetchOrderDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return Center(child: Text('Order not found'));
          }
          final orderData = snapshot.data!;
          final status = orderData['status'];
          final timestamp = (orderData['timestamp'] as Timestamp).toDate();

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  'THANKS FOR YOUR ORDER !',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                Text(
                  'The estimated time of delivery for your order #$orderId is:',
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                Text(
                  '${timestamp.toLocal()}',
                  style: TextStyle(fontSize: 20, color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                _buildStatusWidget(status),
                SizedBox(height: 16), // Added spacing
                Text(
                  'Current Status: $status',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                Spacer(),
                Text(
                  'Order Summary',
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                  'RM ${orderData['totalPrice'].toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 18),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Back to home'),
                ),
                SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatusWidget(String status) {
    const statusIcons = {
      'Pending': Icons.pending,
      'Confirmed': Icons.microwave,
      'Preparing': Icons.fastfood,
      'Ready': Icons.check_circle,
    };

    const statusSteps = [
      'Pending',
      'Confirmed',
      'Preparing',
      'Ready',
    ];

    final statusIndex = statusSteps.indexOf(status);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(statusSteps.length, (index) {
        return Column(
          children: [
            Icon(
              statusIcons[statusSteps[index]],
              color: index <= statusIndex ? Colors.redAccent : Colors.grey,
            ),
            if (index < statusSteps.length - 1)
              Container(
                width: 50,
                height: 2,
                color: index < statusIndex ? Colors.green : Colors.grey,
              ),
          ],
        );
      }),
    );
  }
}
