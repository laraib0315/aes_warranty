import 'dart:math';
import 'package:intl/intl.dart';

class Helpers {
  // Generate unique UID for QR/Barcode (e.g., AES-UID-XXXXX)
  static String generateUID() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    String uid = 'AES-UID-';
    for (int i = 0; i < 8; i++) {
      uid += chars[random.nextInt(chars.length)];
    }
    return uid;
  }

  // Generate CUID for customer (e.g., CUST-001, auto increment)
  static String generateCUID(int lastSerial) {
    final serial = (lastSerial + 1).toString().padLeft(3, '0');
    return 'CUST-$serial';
  }

  // Format date to "dd MMM yyyy"
  static String formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  // Format date with time
  static String formatDateTime(DateTime date) {
    return DateFormat('dd MMM yyyy, hh:mm a').format(date);
  }

  // Format currency PKR
  static String formatCurrency(double amount) {
    final formatter = NumberFormat.currency(locale: 'en_PK', symbol: 'PKR ');
    return formatter.format(amount);
  }

  // Validate email
  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  // Validate phone (Pakistan)
  static bool isValidPhone(String phone) {
    return RegExp(r'^03[0-9]{9}$').hasMatch(phone);
  }
}
