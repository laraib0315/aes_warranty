import 'package:flutter/material.dart';
import '../services/database_service.dart';

class FinanceProvider extends ChangeNotifier {
  final DatabaseService db = DatabaseService.instance;

  double _totalRevenue = 0;
  double _totalProfit = 0;
  double _totalPending = 0;
  double _todayCollection = 0;
  Map<int, double> _monthlyRevenue = {};

  double get totalRevenue => _totalRevenue;
  double get totalProfit => _totalProfit;
  double get totalPending => _totalPending;
  double get todayCollection => _todayCollection;
  Map<int, double> get monthlyRevenue => _monthlyRevenue;

  FinanceProvider() {
    refresh();
  }

  Future<void> refresh() async {
    final warranties =
        db.warrantyBox.values.where((w) => !w.isDeleted).toList();

    _totalRevenue =
        warranties.fold(0, (sum, w) => sum + (w.sellingPrice ?? w.totalAmount));
    _totalProfit = warranties.fold(
        0,
        (sum, w) =>
            sum + ((w.sellingPrice ?? w.totalAmount) - w.product.costPrice));
    _totalPending = warranties
        .where((w) => !w.isFullyPaid)
        .fold(0, (sum, w) => sum + (w.totalAmount - w.totalPaid));

    final today = DateTime.now();
    _todayCollection = warranties
        .where((w) =>
            w.saleDate.year == today.year &&
            w.saleDate.month == today.month &&
            w.saleDate.day == today.day)
        .fold(0, (sum, w) => sum + (w.sellingPrice ?? w.totalAmount));

    _monthlyRevenue = {};
    for (var w in warranties) {
      final key = w.saleDate.month;
      _monthlyRevenue[key] =
          (_monthlyRevenue[key] ?? 0) + (w.sellingPrice ?? w.totalAmount);
    }

    notifyListeners();
  }
}
