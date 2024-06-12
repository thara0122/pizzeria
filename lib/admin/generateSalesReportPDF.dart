import 'dart:io';

import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class SalesReport {
  final String orderID;
  final String customer;
 
  SalesReport(this.orderID, this.customer);
}

Future<void> generateSalesReportPDF(List<SalesReport> salesReports) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
        return pw.Column(
          children: [
            pw.Text('Sales Report', style: pw.TextStyle(fontSize: 24)),
            pw.SizedBox(height: 20),
            pw.Table.fromTextArray(
              data: <List<String>>[
                <String>['OrderID', 'Customer'],
                ...salesReports.map((item) => [
                      item.orderID,
                      item.customer,  
                    ])
              ],
            ),
          ],
        );
      },
    ),
  );

  final output = await getTemporaryDirectory();
  final file = File("${output.path}/sales_report.pdf");
  await file.writeAsBytes(await pdf.save());
  OpenFile.open(file.path);
}

@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sales Report'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            generateSalesReportPDF(salesReports);
          },
          child: Text('Download Sales Report'),
        ),
      ),
    );
  }

void main() {
  runApp(MaterialApp(
    home: SalesReportScreen(),
  ));
}
