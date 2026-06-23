import 'package:flutter/material.dart';
import '../services/database_service.dart';
import '../models/warranty_model.dart';

class ReportProvider extends ChangeNotifier {
  final DatabaseService db = DatabaseService.instance;

  List<WarrantyModel> _warranties = [];
  Map<String, int> _bestProducts = {};
  Map<String, int> _customerGrowth = {};
  Map<String, int> _categoryDistribution = {};

  List<WarrantyModel> get warranties => _warranties;
  Map<String, int> get bestProducts => _bestProducts;
  Map<String, int> get customerGrowth => _customerGrowth;
  Map<String, int> get categoryDistribution => _categoryDistribution;

  ReportProvider() {
    refresh();
  }

  Future<void> refresh() async {
    _warranties = db.warrantyBox.values.where((w) => !w.isDeleted).toList();

    // Best selling products – iterate through all items
    _bestProducts = {};
    for (var w in _warranties) {
      for (var item in w.items) {
        final name = item.product.name;
        _bestProducts[name] = (_bestProducts[name] ?? 0) + 1;
      }
    }

    // Customer growth by month (by number of warranties)
    _customerGrowth = {};
    for (var w in _warranties) {
      final key = '${w.saleDate.month}/${w.saleDate.year}';
      _customerGrowth[key] = (_customerGrowth[key] ?? 0) + 1;
    }

    // Category distribution
    _categoryDistribution = {};
    for (var w in _warranties) {
      for (var item in w.items) {
        final name = item.product.category.name;
        _categoryDistribution[name] = (_categoryDistribution[name] ?? 0) + 1;
      }
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
        .fold<double>(0, (sum, w) => sum + w.totalAmount);
  }

  double getProfitByDateRange(DateTime start, DateTime end) {
    return getWarrantiesByDateRange(start, end).fold<double>(0, (sum, w) {
      final cost =
          w.items.fold<double>(0, (c, item) => c + item.product.costPrice);
      return sum + (w.totalAmount - cost);
    });
  }

  int getTotalWarranties() => _warranties.length;

  int getActiveWarranties() {
    return _warranties.where((w) => w.status == WarrantyStatus.active).length;
  }

  int getExpiredWarranties() {
    return _warranties.where((w) => w.status == WarrantyStatus.expired).length;
  }

  int getPendingPayments() {
    return _warranties.where((w) => !w.isFullyPaid).length;
  }
}
