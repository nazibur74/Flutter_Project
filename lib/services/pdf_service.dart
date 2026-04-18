import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/cart_item.dart';
import 'package:pdf/pdf.dart';

class PDFService {
  static Future<void> generateBill(
    String customerName,
    String phone,
    List<CartItem> cart,
    double total,
  ) async {
    final pdf = pw.Document();

    // 🔢 GENERATE INVOICE NUMBER
    final invoiceNo = DateTime.now().millisecondsSinceEpoch;

    pdf.addPage(
      pw.Page(
        margin: pw.EdgeInsets.all(20),
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // 🟣 SHOP HEADER
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    "Zstore",
                    style: pw.TextStyle(
                      fontSize: 22,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Text("Daffodil Smart City, Bangladesh"),
                  pw.Text("Email: help.zstore@gmail.com"),
                  pw.Text("Phone: 01797971474"),
                ],
              ),

              pw.SizedBox(height: 10),
              pw.Divider(),

              // 📄 INVOICE TITLE + INFO
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    "INVOICE",
                    style: pw.TextStyle(
                      fontSize: 20,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),

                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text("Invoice No: $invoiceNo"),
                      pw.Text(
                        "Date: ${DateTime.now().toString().substring(0, 19)}",
                      ),
                    ],
                  ),
                ],
              ),

              pw.SizedBox(height: 10),

              // 👤 CUSTOMER INFO
              pw.Text("Customer: $customerName"),
              pw.Text("Phone: $phone"),

              pw.SizedBox(height: 15),

              // 📊 TABLE
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey),
                columnWidths: {
                  0: pw.FlexColumnWidth(3),
                  1: pw.FlexColumnWidth(1),
                  2: pw.FlexColumnWidth(2),
                  3: pw.FlexColumnWidth(2),
                },
                children: [
                  // HEADER
                  pw.TableRow(
                    decoration: pw.BoxDecoration(color: PdfColors.grey300),
                    children: [
                      pw.Padding(
                        padding: pw.EdgeInsets.all(8),
                        child: pw.Text(
                          "Product",
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                      ),
                      pw.Padding(
                        padding: pw.EdgeInsets.all(8),
                        child: pw.Text(
                          "Quantity",
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                      ),
                      pw.Padding(
                        padding: pw.EdgeInsets.all(8),
                        child: pw.Text(
                          "Price",
                          textAlign: pw.TextAlign.right,
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                      ),
                      pw.Padding(
                        padding: pw.EdgeInsets.all(8),
                        child: pw.Text(
                          "Total",
                          textAlign: pw.TextAlign.right,
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                      ),
                    ],
                  ),

                  // DATA ROWS
                  ...cart.map((item) {
                    final itemTotal = item.product.price * item.quantity;

                    return pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: pw.EdgeInsets.all(8),
                          child: pw.Text(item.product.name),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.all(8),
                          child: pw.Text(
                            "${item.quantity}",
                            textAlign: pw.TextAlign.center,
                          ),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.all(8),
                          child: pw.Text(
                            " ${item.product.price.toStringAsFixed(2)}",
                            textAlign: pw.TextAlign.right,
                          ),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.all(8),
                          child: pw.Text(
                            " ${itemTotal.toStringAsFixed(2)}",
                            textAlign: pw.TextAlign.right,
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ],
              ),

              pw.SizedBox(height: 10),
              pw.Divider(),

              // 💰 TOTAL
              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Text(
                  "Total: ${total.toStringAsFixed(2)}",
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),

              pw.SizedBox(height: 20),

              // 🧾 FOOTER
              pw.Center(
                child: pw.Text(
                  "Thank you for shopping with Zstore!",
                  style: pw.TextStyle(fontSize: 12),
                ),
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }
}
