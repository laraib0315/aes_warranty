import 'package:flutter/material.dart';
import '../services/database_service.dart';
import '../models/warranty_model.dart';

class ReportProvider extends ChangeNotifier {
  final DatabaseService db = DatabaseService.instance;

  List<WarrantyModel> _warranties = [];
  Map<String, int> _bestProducts = {};
  Map<String, int> _customerGrowth = {};

  List<WarrantyModel> get warranties => _warranties;
  Map<String, int> get bestProducts => _bestProducts;
  Map<String, int> get customerGrowth => _customerGrowth;

  ReportProvider() {
    refresh();
  }

  Future<void> refresh() async {
    _warranties = db.warrantyBox.values.where((w) => !w.isDeleted).toList();

    // Best selling products
    _bestProducts = {};
    for (var w in _warranties) {
      final name = w.product.name;
      _bestProducts[name] = (_bestProducts[name] ?? 0) + 1;
    }

    // Customer growth by month
    _customerGrowth = {};
    for (var w in _warranties) {
      final key = '${w.saleDate.month}/${w.saleDate.year}';
      _customerGrowth[key] = (_customerGrowth[key] ?? 0) + 1;
    }

    notifyListeners();
  }

  List<WarrantyModel> getWarrantiesByDateRange(DateTime start, DateTime end) {
    return _warranties
        .where((w) =>
            w.saleDate.isAfter(start.subtract(const Duration(days: 1))) &&
            w.saleDate.isBefore(end.add(const Duration(days: 1))))
        .toList();
  }

  double getRevenueByDateRange(DateTime start, DateTime end) {
    return getWarrantiesByDateRange(start, end)
        .fold(0, (sum, w) => sum + (w.sellingPrice ?? w.totalAmount));
  }

  double getProfitByDateRange(DateTime start, DateTime end) {
    return getWarrantiesByDateRange(start, end).fold(
        0,
        (sum, w) =>
            sum + ((w.sellingPrice ?? w.totalAmount) - w.product.costPrice));
  }
}
