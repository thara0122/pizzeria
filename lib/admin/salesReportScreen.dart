import 'package:flutter/material.dart';
import 'package:pizzeria1/admin/PizzaOrders.dart';
import 'package:pizzeria1/admin/pizza_service.dart';



class SalesReportScreen extends StatefulWidget {
  const SalesReportScreen({super.key});

  @override
  _SalesReportScreenState createState() => _SalesReportScreenState();
}

class _SalesReportScreenState extends State<SalesReportScreen> {
  final PizzaService _pizzaService = PizzaService();
  late Future<List<PizzaOrder>> _ordersFuture;

  @override
  void initState() {
    super.initState();
    _ordersFuture = _pizzaService.fetchOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sales Report'),
        backgroundColor: Colors.redAccent,
      ),
      body: FutureBuilder<List<PizzaOrder>>(
        future: _ordersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No sales data available.'));
          } else {
            final orders = snapshot.data!;
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Order ID')),
                    DataColumn(label: Text('Customer')),
                    DataColumn(label: Text('Total Price')),
                    DataColumn(label: Text('Items')),
                    DataColumn(label: Text('Timestamp')),
                    DataColumn(label: Text('Status')),
                  ],
                  rows: orders.map((order) {
                    return DataRow(cells: [
                      DataCell(Text(order.id)),
                      DataCell(Text(order.address)), // Assuming address is customer name
                      DataCell(Text('\$${order.totalPrice.toStringAsFixed(2)}')),
                      DataCell(Text(order.items.length.toString())), // Number of items
                      DataCell(Text(_formatDate(order.timestamp))),
                      DataCell(Text(order.status)),
                    ]);
                  }).toList(),
                ),
              ),
            );
          }
        },
      ),
    );
  }

  String _formatDate(DateTime timestamp) {
    return "${timestamp.year}-${timestamp.month.toString().padLeft(2, '0')}-${timestamp.day.toString().padLeft(2, '0')} ${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}:${timestamp.second.toString().padLeft(2, '0')}";
  }
}

  Future<void> _downloadSalesReport() async {
    if (download == null) return;

    final confirmation = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('download PDF'),
        content: const Text('Are you sure you want to downloaD PDF?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Download PDF'),
          ),
        ],
      ),
    );

    if (confirmation == true) {
      await _generateSalesReportPDF(salesReports);
    }
  }
