import 'dart:io';
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../domain/entities/sale_entity.dart';

class PdfInvoiceService {
  Future<Uint8List> generateInvoice({
    required SaleEntity sale,
    String? shopName,
    String? logoPath,
  }) async {
    final pdf = pw.Document();

    pw.ImageProvider? logoImage;
    if (logoPath != null && logoPath.isNotEmpty) {
      try {
        final file = File(logoPath);
        if (await file.exists()) {
          final bytes = await file.readAsBytes();
          logoImage = pw.MemoryImage(bytes);
        }
      } catch (_) {}
    }

    // Helper to format currency for PDF rendering (replace unicode Rupee symbol with Rs. fallback)
    String formatCurrency(double amount) {
      return CurrencyFormatter.format(amount).replaceAll('₹', 'Rs. ');
    }

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.symmetric(horizontal: 40, vertical: 42),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header Brand Row
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        shopName ?? 'Naga Bakes',
                        style: pw.TextStyle(
                          fontSize: 26,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColor.fromHex('#1a237e'), // Indigo900
                        ),
                      ),
                      pw.SizedBox(height: 4),
                      pw.Text(
                        'TAX INVOICE / RECEIPT',
                        style: pw.TextStyle(
                          fontSize: 10,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColor.fromHex('#5c6bc0'), // Indigo400
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                  if (logoImage != null)
                    pw.Container(
                      width: 52,
                      height: 52,
                      child: pw.ClipRRect(
                        horizontalRadius: 8,
                        verticalRadius: 8,
                        child: pw.Image(logoImage, fit: pw.BoxFit.cover),
                      ),
                    ),
                ],
              ),
              pw.SizedBox(height: 18),
              pw.Divider(thickness: 1.5, color: PdfColor.fromHex('#1a237e')),
              pw.SizedBox(height: 18),

              // Invoice Details Card
              pw.Container(
                padding: const pw.EdgeInsets.all(14),
                decoration: const pw.BoxDecoration(
                  color: PdfColors.grey100,
                  borderRadius: pw.BorderRadius.all(pw.Radius.circular(8)),
                ),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'INVOICE TO',
                          style: pw.TextStyle(
                            fontSize: 8.5,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.grey600,
                            letterSpacing: 0.5,
                          ),
                        ),
                        pw.SizedBox(height: 2),
                        pw.Text(
                          'Valued Customer',
                          style: pw.TextStyle(
                            fontSize: 12,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.grey900,
                          ),
                        ),
                        pw.SizedBox(height: 8),
                        pw.Text(
                          'PAYMENT METHOD',
                          style: pw.TextStyle(
                            fontSize: 8.5,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.grey600,
                            letterSpacing: 0.5,
                          ),
                        ),
                        pw.SizedBox(height: 2),
                        pw.Text(
                          'UPI / Cash',
                          style: pw.TextStyle(
                            fontSize: 11,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.grey800,
                          ),
                        ),
                      ],
                    ),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text(
                          'INVOICE NUMBER',
                          style: pw.TextStyle(
                            fontSize: 8.5,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.grey600,
                            letterSpacing: 0.5,
                          ),
                        ),
                        pw.SizedBox(height: 2),
                        pw.Text(
                          '#${sale.invoiceNumber}',
                          style: pw.TextStyle(
                            fontSize: 12,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColor.fromHex('#1a237e'),
                          ),
                        ),
                        pw.SizedBox(height: 8),
                        pw.Text(
                          'DATE & TIME',
                          style: pw.TextStyle(
                            fontSize: 8.5,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.grey600,
                            letterSpacing: 0.5,
                          ),
                        ),
                        pw.SizedBox(height: 2),
                        pw.Text(
                          DateFormatter.formatDateTime(sale.timestamp),
                          style: pw.TextStyle(
                            fontSize: 11,
                            color: PdfColors.grey800,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 24),

              // Items Table
              pw.Table(
                border: const pw.TableBorder(
                  horizontalInside: pw.BorderSide(color: PdfColors.grey200, width: 0.5),
                  bottom: pw.BorderSide(color: PdfColors.grey400, width: 1.5),
                ),
                columnWidths: {
                  0: const pw.FlexColumnWidth(3.2), // Item description
                  1: const pw.FlexColumnWidth(1),   // Qty
                  2: const pw.FlexColumnWidth(1.6), // Price each
                  3: const pw.FlexColumnWidth(1.6), // Subtotal
                },
                children: [
                  // Table Header Row
                  pw.TableRow(
                    decoration: pw.BoxDecoration(
                      color: PdfColor.fromHex('#1a237e'),
                      borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
                    ),
                    children: [
                      _buildHeaderCell('ITEM', pw.Alignment.centerLeft),
                      _buildHeaderCell('QTY', pw.Alignment.center),
                      _buildHeaderCell('PRICE EACH', pw.Alignment.centerRight),
                      _buildHeaderCell('SUBTOTAL', pw.Alignment.centerRight),
                    ],
                  ),
                  // Table Data Rows
                  ...sale.items.map((item) {
                    return pw.TableRow(
                      children: [
                        _buildDataCell(item.name, pw.Alignment.centerLeft, isBold: true),
                        _buildDataCell('${item.qty}', pw.Alignment.center),
                        _buildDataCell(formatCurrency(item.priceEach), pw.Alignment.centerRight),
                        _buildDataCell(formatCurrency(item.subtotal), pw.Alignment.centerRight, isBold: true),
                      ],
                    );
                  }),
                ],
              ),
              pw.SizedBox(height: 24),

              // Totals & Notes Section
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  // Left: Notes
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'Terms & Notes',
                        style: pw.TextStyle(
                          fontSize: 9.5,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.grey700,
                        ),
                      ),
                      pw.SizedBox(height: 4),
                      pw.Text(
                        '1. This is a computer-generated transaction receipt.\n2. Products sold are fresh and ready for consumption.\n3. Contact us for any queries or custom catering orders.',
                        style: pw.TextStyle(
                          fontSize: 8,
                          color: PdfColors.grey500,
                          lineSpacing: 1.3,
                        ),
                      ),
                    ],
                  ),
                  // Right: Total Calculation
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Row(
                        children: [
                          pw.Text('Subtotal:  ', style: const pw.TextStyle(fontSize: 10.5, color: PdfColors.grey700)),
                          pw.Text(
                            formatCurrency(sale.totalAmount),
                            style: pw.TextStyle(fontSize: 10.5, fontWeight: pw.FontWeight.bold, color: PdfColors.grey900),
                          ),
                        ],
                      ),
                      pw.SizedBox(height: 4),
                      pw.Row(
                        children: [
                          pw.Text('Tax (CGST/SGST 0%):  ', style: const pw.TextStyle(fontSize: 10.5, color: PdfColors.grey700)),
                          pw.Text(
                            formatCurrency(0.0),
                            style: pw.TextStyle(fontSize: 10.5, fontWeight: pw.FontWeight.bold, color: PdfColors.grey900),
                          ),
                        ],
                      ),
                      pw.SizedBox(height: 6),
                      pw.Container(
                        height: 0.8,
                        width: 150,
                        color: PdfColors.grey300,
                      ),
                      pw.SizedBox(height: 6),
                      pw.Container(
                        padding: const pw.EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: const pw.BoxDecoration(
                          color: PdfColors.green50,
                          borderRadius: pw.BorderRadius.all(pw.Radius.circular(6)),
                        ),
                        child: pw.Row(
                          children: [
                            pw.Text(
                              'TOTAL AMOUNT:  ',
                              style: pw.TextStyle(
                                fontSize: 12.5,
                                fontWeight: pw.FontWeight.bold,
                                color: PdfColors.green800,
                              ),
                            ),
                            pw.Text(
                              formatCurrency(sale.totalAmount),
                              style: pw.TextStyle(
                                fontSize: 16.5,
                                fontWeight: pw.FontWeight.bold,
                                color: PdfColors.green800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              pw.Spacer(),

              // Footer Bar
              pw.Divider(thickness: 1, color: PdfColors.grey300),
              pw.SizedBox(height: 8),
              pw.Center(
                child: pw.Text(
                  'Thank You! Visit Naga Bakes Again!',
                  style: pw.TextStyle(
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.grey700,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  pw.Widget _buildHeaderCell(String text, pw.Alignment alignment) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      alignment: alignment,
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontWeight: pw.FontWeight.bold,
          color: PdfColors.white,
          fontSize: 9.5,
        ),
      ),
    );
  }

  pw.Widget _buildDataCell(String text, pw.Alignment alignment, {bool isBold = false}) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      alignment: alignment,
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
          fontSize: 10.5,
          color: PdfColors.grey800,
        ),
      ),
    );
  }
}
