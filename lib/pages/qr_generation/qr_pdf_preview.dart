import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../services/barcode_service.dart';

class QrPdfPreviewPage extends StatelessWidget {
  final List<String> uids;
  final String purpose;

  const QrPdfPreviewPage({
    super.key,
    required this.uids,
    required this.purpose,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PDF Preview')),
      body: PdfPreview(
        maxPageWidth: PdfPageFormat.a4.width,
        build: (format) => _generatePdf(), // ✅ Return Future<Uint8List>
      ),
    );
  }

  Future<Uint8List> _generatePdf() async {
    final pdf = pw.Document();
    const int perPage = 35;
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
                  children: [
                    pw.Container(
                      height: 80,
                      width: 80,
                      child: pw.BarcodeWidget(
                        barcode: pw.Barcode.qrCode(),
                        data: 'https://aes-warranty.app/w/$uid',
                        drawText: false,
                      ),
                    ),
                    pw.SizedBox(height: 4),
                    if (purpose == 'Ceiling Fans')
                      pw.SvgImage(
                        svg: BarcodeService.generateBarcodeSvg(uid,
                            width: 80, height: 30),
                      ),
                    pw.SizedBox(height: 2),
                    pw.Text(uid, style: const pw.TextStyle(fontSize: 8)),
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
}
