import 'dart:math';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/material.dart';

class QrService {
  // Generate unique UID for QR code
  static String generateUID() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    String uid = 'AES-';
    for (int i = 0; i < 10; i++) {
      uid += chars[random.nextInt(chars.length)];
    }
    return uid;
  }

  // Generate multiple UIDs
  static List<String> generateBatchUIDs(int count) {
    final uids = <String>[];
    for (int i = 0; i < count; i++) {
      uids.add(generateUID());
    }
    return uids;
  }

  // Generate QR code as Widget
  static Widget generateQrWidget(String data, {double size = 80}) {
    return QrImageView(
      data: data,
      version: QrVersions.auto,
      size: size,
      gapless: false,
      embeddedImage: const AssetImage('assets/aes_logo.png'),
      embeddedImageStyle: const QrEmbeddedImageStyle(
        size: Size(20, 20), // ✅ Removed extra const
      ),
    );
  }

  // Generate full URL for warranty lookup
  static String getWarrantyUrl(String uid) {
    return 'https://aes-warranty.app/w/$uid';
  }

  // Validate UID format
  static bool isValidUid(String uid) {
    return RegExp(r'^AES-[A-Z0-9]{10}$').hasMatch(uid);
  }
}
