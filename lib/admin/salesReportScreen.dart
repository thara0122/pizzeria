import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pizzeria1/admin/PizzaOrders.dart';
import 'package:pizzeria1/admin/pizza_service.dart';
import 'package:printing/printing.dart';
import 'package:flutter/material.dart';

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

  Future<void> _generatePdf(List<PizzaOrder> orders) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Text('Pizzeria Sales Report', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              pw.Table.fromTextArray(
                context: context,
                data: <List<String>>[
                  <String>['Order ID', 'Customer', 'Total Price', 'Items', 'Timestamp', 'Status'],
                  ...orders.map((order) => [
                        order.id,
                        order.address,
                        '\$${order.totalPrice.toStringAsFixed(2)}',
                        order.items.length.toString(),
                        _formatDate(order.timestamp),
                        order.status,
                      ])
                ],
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
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
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
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
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () => _generatePdf(orders),
                    child: const Text('Generate PDF'),
                  ),
                ),
              ],
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
