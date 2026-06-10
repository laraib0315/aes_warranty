import 'package:flutter/material.dart';
import '../services/database_service.dart';
import '../models/product_model.dart';
import '../models/warranty_model.dart';
import '../models/customer_model.dart';

class TrashProvider extends ChangeNotifier {
  final DatabaseService db = DatabaseService.instance;

  List<ProductModel> get deletedProducts =>
      db.productBox.values.where((p) => p.isDeleted).toList();

  List<WarrantyModel> get deletedWarranties =>
      db.warrantyBox.values.where((w) => w.isDeleted).toList();

  List<CustomerModel> get deletedCustomers =>
      db.customerBox.values.where((c) => c.isDeleted).toList();

  Future<void> restoreProduct(String id) async {
    final product = db.productBox.get(id);
    if (product != null) {
      await db.productBox.put(id, product.copyWith(isDeleted: false));
      notifyListeners();
    }
  }

  Future<void> restoreWarranty(String id) async {
    final warranty = db.warrantyBox.get(id);
    if (warranty != null) {
      await db.warrantyBox.put(id, warranty.copyWith(isDeleted: false));
      notifyListeners();
    }
  }

  Future<void> restoreCustomer(String id) async {
    final customer = db.customerBox.get(id);
    if (customer != null) {
      await db.customerBox.put(id, customer.copyWith(isDeleted: false));
      notifyListeners();
    }
  }

  Future<void> permanentDeleteProduct(String id) async {
    await db.productBox.delete(id);
    notifyListeners();
  }

  Future<void> permanentDeleteWarranty(String id) async {
    await db.warrantyBox.delete(id);
    notifyListeners();
  }

  Future<void> permanentDeleteCustomer(String id) async {
    await db.customerBox.delete(id);
    notifyListeners();
  }

  void refresh() {
    notifyListeners();
  }
}
