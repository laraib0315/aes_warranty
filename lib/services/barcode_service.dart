import 'package:barcode/barcode.dart';
import 'package:flutter/material.dart';

class BarcodeService {
  // Generate CODE128 barcode as Widget
  static Widget generateBarcodeWidget(String data,
      {double width = 100, double height = 40}) {
    final barcode = Barcode.code128();
    final _ = barcode.toSvg(data, width: width, height: height);

    // Convert SVG to Image widget (simplified - returns placeholder)
    // For production, use flutter_svg to render
    return Container(
      width: width,
      height: height,
      color: Colors.white,
      child: Center(
        child: Text(
          data,
          style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
          maxLines: 1,
        ),
      ),
    );
  }

  // Generate barcode as SVG string (for PDF)
  static String generateBarcodeSvg(String data,
      {double width = 80, double height = 30}) {
    final barcode = Barcode.code128();
    return barcode.toSvg(data, width: width, height: height);
  }

  // Validate barcode data
  static bool isValidBarcodeData(String data) {
    return data.startsWith('AES-') && data.length == 14;
  }
}
