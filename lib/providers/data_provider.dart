import 'package:flutter/material.dart';
import '../services/database_service.dart';

class DataProvider extends ChangeNotifier {
  final DatabaseService db = DatabaseService.instance;

  DataProvider() {
    _init();
  }

  Future<void> _init() async {
    // Future initializations
    await Future.delayed(Duration.zero);
  }

  // TODO: Add all CRUD methods for products, customers, warranties, etc.
  // For now, just a placeholder
}
