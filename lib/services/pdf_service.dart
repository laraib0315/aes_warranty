import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'barcode_service.dart';

class PdfService {
  // Generate PDF with 35 QR stickers per page (5x7 grid)
  static Future<Uint8List> generateQrStickers({
    required List<String> uids,
    required String purpose,
    double qrSize = 80,
    double barcodeHeight = 30,
  }) async {
    final pdf = pw.Document();
    const int perPage = 35; // 5 columns x 7 rows

    final pages = (uids.length / perPage).ceil();

    for (int pageIndex = 0; pageIndex < pages; pageIndex++) {
      final start = pageIndex * perPage;
      final end = (start + perPage).clamp(0, uids.length);
      final pageUids = uids.sublist(start, end);

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(20),
          build: (context) => [
            pw.GridView(
              crossAxisCount: 5,
              childAspectRatio: 1.2,
              children: pageUids.map((uid) {
                return pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  children: [
                    // QR Code
                    pw.Container(
                      height: qrSize,
                      width: qrSize,
                      child: pw.BarcodeWidget(
                        barcode: pw.Barcode.qrCode(),
                        data: 'https://aes-warranty.app/w/$uid',
                        drawText: false,
                      ),
                    ),
                    pw.SizedBox(height: 4),
                    // Barcode (only for Ceiling Fans)
                    if (purpose == 'Ceiling Fans')
                      pw.SvgImage(
                        svg: BarcodeService.generateBarcodeSvg(uid,
                            width: qrSize, height: barcodeHeight),
                      ),
                    pw.SizedBox(height: 2),
                    pw.Text(
                      uid,
                      style: const pw.TextStyle(fontSize: 8),
                      textAlign: pw.TextAlign.center,
                    ),
                    // Cutting line (dotted)
                    pw.Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: pw.Container(
                        height: 1,
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(
                            bottom: pw.BorderSide(
                              color: PdfColors.grey,
                              style: pw.BorderStyle.dotted,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      );
    }

    return pdf.save();
  }

  // Generate warranty card PDF for customer
  static Future<Uint8List> generateWarrantyCard({
    required String customerName,
    required String customerPhone,
    required String cuid,
    required String productName,
    required String saleDate,
    required String motorExpiry,
    required String boardExpiry,
    required double amount,
    required String status,
    required String uid,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a6,
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Center(
              child: pw.Text(
                'AES WARRANTY CARD',
                style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.orange),
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Text('Customer: $customerName'),
            pw.Text('Phone: $customerPhone'),
            pw.Text('CUID: $cuid'),
            pw.SizedBox(height: 10),
            pw.Text('Product: $productName'),
            pw.Text('Sale Date: $saleDate'),
            pw.Text('Motor Warranty: $motorExpiry'),
            pw.Text('Board Warranty: $boardExpiry'),
            pw.Text('Amount: PKR ${amount.toStringAsFixed(0)}'),
            pw.Text('Status: $status'),
            pw.SizedBox(height: 20),
            pw.Center(
              child: pw.BarcodeWidget(
                barcode: pw.Barcode.qrCode(),
                data: uid,
                width: 100,
                height: 100,
              ),
            ),
            pw.SizedBox(height: 10),
            pw.Center(
              child: pw.Text(
                'Scan to verify warranty',
                style: pw.TextStyle(fontSize: 10, color: PdfColors.grey),
              ),
            ),
          ],
        ),
      ),
    );

    return pdf.save();
  }
}
