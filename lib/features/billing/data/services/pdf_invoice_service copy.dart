// import 'dart:io';
// import 'dart:typed_data';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import '../../../../core/utils/currency_formatter.dart';
// import '../../../../core/utils/date_formatter.dart';
// import '../../domain/entities/sale_entity.dart';

// class PdfInvoiceService {
//   Future<Uint8List> generateInvoice({
//     required SaleEntity sale,
//     String? shopName,
//     String? logoPath,
//   }) async {
//     final pdf = pw.Document();

//     pw.ImageProvider? logoImage;
//     if (logoPath != null && logoPath.isNotEmpty) {
//       try {
//         final file = File(logoPath);
//         if (await file.exists()) {
//           final bytes = await file.readAsBytes();
//           logoImage = pw.MemoryImage(bytes);
//         }
//       } catch (_) {}
//     }

//     pdf.addPage(
//       pw.Page(
//         pageFormat: PdfPageFormat.a4,
//         margin: const pw.EdgeInsets.all(32),
//         build: (pw.Context context) {
//           return pw.Column(
//             crossAxisAlignment: pw.CrossAxisAlignment.start,
//             children: [
//               // Header
//               pw.Row(
//                 mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                 crossAxisAlignment: pw.CrossAxisAlignment.center,
//                 children: [
//                   pw.Column(
//                     crossAxisAlignment: pw.CrossAxisAlignment.start,
//                     children: [
//                       pw.Text(
//                         shopName ?? 'Naga Bakes',
//                         style: pw.TextStyle(
//                           fontSize: 24,
//                           fontWeight: pw.FontWeight.bold,
//                           color: PdfColors.blue900,
//                         ),
//                       ),
//                       pw.SizedBox(height: 4),
//                       pw.Text('BILLING INVOICE', style: const pw.TextStyle(fontSize: 12, color: PdfColors.grey700)),
//                     ],
//                   ),
//                   if (logoImage != null)
//                     pw.Container(
//                       width: 60,
//                       height: 60,
//                       child: pw.Image(logoImage),
//                     ),
//                 ],
//               ),
//               pw.SizedBox(height: 16),
//               pw.Divider(thickness: 2, color: PdfColors.blue900),
//               pw.SizedBox(height: 16),

//               // Details
//               pw.Row(
//                 mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                 children: [
//                   pw.Text('Invoice #: ${sale.invoiceNumber}', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
//                   pw.Text('Date: ${DateFormatter.formatDateTime(sale.timestamp)}', style: const pw.TextStyle(fontSize: 12)),
//                 ],
//               ),
//               pw.SizedBox(height: 20),

//               // Items Table
//               pw.TableHelper.fromTextArray(
//                 border: pw.TableBorder.all(color: PdfColors.grey300),
//                 headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white),
//                 headerDecoration: const pw.BoxDecoration(color: PdfColors.blue900),
//                 cellHeight: 30,
//                 cellAlignments: {
//                   0: pw.Alignment.centerLeft,
//                   1: pw.Alignment.center,
//                   2: pw.Alignment.centerRight,
//                   3: pw.Alignment.centerRight,
//                 },
//                 headers: ['ITEM', 'QTY', 'PRICE EACH', 'SUBTOTAL'],
//                 data: sale.items.map((item) {
//                   return [
//                     item.name,
//                     '${item.qty}',
//                     CurrencyFormatter.format(item.priceEach),
//                     CurrencyFormatter.format(item.subtotal),
//                   ];
//                 }).toList(),
//               ),
//               pw.SizedBox(height: 20),

//               // Grand Total
//               pw.Row(
//                 mainAxisAlignment: pw.MainAxisAlignment.end,
//                 children: [
//                   pw.Container(
//                     padding: const pw.EdgeInsets.all(12),
//                     decoration: pw.BoxDecoration(
//                       color: PdfColors.grey100,
//                       borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
//                       border: pw.Border.all(color: PdfColors.blue900, width: 1.5),
//                     ),
//                     child: pw.Row(
//                       mainAxisSize: pw.MainAxisSize.min,
//                       children: [
//                         pw.Text('TOTAL AMOUNT:  ', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
//                         pw.Text(
//                           CurrencyFormatter.format(sale.totalAmount),
//                           style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold, color: PdfColors.green800),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),

//               pw.Spacer(),

//               // Footer
//               pw.Center(
//                 child: pw.Text(
//                   'Thank You! Visit Naga Bakes Again!',
//                   style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: PdfColors.grey700),
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );

//     return pdf.save();
//   }
// }
