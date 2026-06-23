import 'package:flutter/material.dart';
import '../services/database_service.dart';
import '../models/product_model.dart';
import '../models/category_model.dart';
import '../models/brand_model.dart';
import '../models/customer_model.dart';
import '../models/warranty_model.dart';
import '../models/payment_model.dart';
import '../models/draft_model.dart';
import '../models/qr_batch_model.dart';

class DataProvider extends ChangeNotifier {
  final DatabaseService db = DatabaseService.instance;

  // ==================== PRODUCTS ====================
  List<ProductModel> getProducts({bool includeDeleted = false}) {
    final all = db.productBox.values.toList();
    return includeDeleted ? all : all.where((p) => !p.isDeleted).toList();
  }

  Future<void> addProduct(ProductModel product) async {
    await db.productBox.put(product.id, product);
    notifyListeners();
  }

  Future<void> updateProduct(ProductModel product) async {
    final updated = product.copyWith(lastUpdated: DateTime.now());
    await db.productBox.put(product.id, updated);
    notifyListeners();
  }

  Future<void> deleteProduct(String id) async {
    final product = db.productBox.get(id);
    if (product != null) {
      await db.productBox.put(id, product.copyWith(isDeleted: true));
      notifyListeners();
    }
  }

  Future<void> restoreProduct(String id) async {
    final product = db.productBox.get(id);
    if (product != null) {
      await db.productBox.put(id, product.copyWith(isDeleted: false));
      notifyListeners();
    }
  }

  Future<void> permanentDeleteProduct(String id) async {
    await db.productBox.delete(id);
    notifyListeners();
  }

  Future<void> updateProductStock(String id, int newStock) async {
    final product = db.productBox.get(id);
    if (product != null) {
      final updated = product.copyWith(stock: newStock);
      await db.productBox.put(id, updated);
      notifyListeners();
    }
  }

  // ==================== CATEGORIES ====================
  List<CategoryModel> getCategories({bool includeDeleted = false}) {
    final all = db.categoryBox.values.toList();
    return includeDeleted ? all : all.where((c) => !c.isDeleted).toList();
  }

  Future<void> addCategory(CategoryModel category) async {
    await db.categoryBox.put(category.id, category);
    notifyListeners();
  }

  Future<void> updateCategory(CategoryModel category) async {
    await db.categoryBox.put(category.id, category);
    notifyListeners();
  }

  Future<void> deleteCategory(String id) async {
    final category = db.categoryBox.get(id);
    if (category != null) {
      await db.categoryBox.put(id, category.copyWith(isDeleted: true));
      notifyListeners();
    }
  }

  Future<void> restoreCategory(String id) async {
    final category = db.categoryBox.get(id);
    if (category != null) {
      await db.categoryBox.put(id, category.copyWith(isDeleted: false));
      notifyListeners();
    }
  }

  // ==================== BRANDS ====================
  List<BrandModel> getBrands({bool includeDeleted = false}) {
    final all = db.brandBox.values.toList();
    return includeDeleted ? all : all.where((b) => !b.isDeleted).toList();
  }

  Future<void> addBrand(BrandModel brand) async {
    await db.brandBox.put(brand.id, brand);
    notifyListeners();
  }

  Future<void> updateBrand(BrandModel brand) async {
    await db.brandBox.put(brand.id, brand);
    notifyListeners();
  }

  Future<void> deleteBrand(String id) async {
    final brand = db.brandBox.get(id);
    if (brand != null) {
      await db.brandBox.put(id, brand.copyWith(isDeleted: true));
      notifyListeners();
    }
  }

  Future<void> restoreBrand(String id) async {
    final brand = db.brandBox.get(id);
    if (brand != null) {
      await db.brandBox.put(id, brand.copyWith(isDeleted: false));
      notifyListeners();
    }
  }

  // ==================== CUSTOMERS ====================
  List<CustomerModel> getCustomers({bool includeDeleted = false}) {
    final all = db.customerBox.values.toList();
    return includeDeleted ? all : all.where((c) => !c.isDeleted).toList();
  }

  Future<void> addCustomer(CustomerModel customer) async {
    await db.customerBox.put(customer.id, customer);
    notifyListeners();
  }

  Future<void> updateCustomer(CustomerModel customer) async {
    final updated = customer.copyWith(lastUpdated: DateTime.now());
    await db.customerBox.put(customer.id, updated);
    notifyListeners();
  }

  Future<void> deleteCustomer(String id) async {
    final customer = db.customerBox.get(id);
    if (customer != null) {
      await db.customerBox.put(id, customer.copyWith(isDeleted: true));
      notifyListeners();
    }
  }

  // ==================== WARRANTIES ====================
  List<WarrantyModel> getWarranties({bool includeDeleted = false}) {
    final all = db.warrantyBox.values.toList();
    return includeDeleted ? all : all.where((w) => !w.isDeleted).toList();
  }

  Future<void> addWarranty(WarrantyModel warranty) async {
    await db.warrantyBox.put(warranty.id, warranty);
    notifyListeners();
  }

  Future<void> updateWarranty(WarrantyModel warranty) async {
    await db.warrantyBox.put(warranty.id, warranty);
    notifyListeners();
  }

  Future<void> deleteWarranty(String id) async {
    final warranty = db.warrantyBox.get(id);
    if (warranty != null) {
      await db.warrantyBox.put(id, warranty.copyWith(isDeleted: true));
      notifyListeners();
    }
  }

  // ==================== QR BATCHES ====================
  List<QrBatchModel> getQrBatches() {
    return db.qrBatchBox.values.toList()
      ..sort((a, b) => b.generatedDate.compareTo(a.generatedDate));
  }

  Future<void> addQrBatch(QrBatchModel batch) async {
    await db.qrBatchBox.put(batch.id, batch);
    notifyListeners();
  }

  // ==================== PAYMENTS ====================
  Future<void> addPayment(PaymentModel payment) async {
    await db.paymentBox.put(payment.id, payment);
    notifyListeners();
  }

  // ==================== DRAFTS ====================
  Future<void> saveDraft(DraftModel draft) async {
    await db.draftBox.put(draft.id, draft);
    notifyListeners();
  }

  Future<void> deleteDraft(String id) async {
    await db.draftBox.delete(id);
    notifyListeners();
  }

  // ==================== HELPER ====================
  void refresh() => notifyListeners();
}
