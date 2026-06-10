import 'package:hive/hive.dart';
import 'customer_model.dart';
import 'product_model.dart';

part 'warranty_model.g.dart';

@HiveType(typeId: 6)
enum WarrantyStatus {
  @HiveField(0)
  active,
  @HiveField(1)
  expired,
}

@HiveType(typeId: 10)
class ScrapInfo {
  @HiveField(0)
  final String metalType; // Copper or Silver
  
  @HiveField(1)
  final double weight;
  
  @HiveField(2)
  final String weightUnit; // kg or g

  ScrapInfo({required this.metalType, required this.weight, required this.weightUnit});
}

@HiveType(typeId: 11)
class WarrantyItem {
  @HiveField(0)
  final String uid; // From QR/Barcode
  
  @HiveField(1)
  final ProductModel product;

  WarrantyItem({required this.uid, required this.product});
}

@HiveType(typeId: 7)
class WarrantyModel {
  @HiveField(0)
  final String id; // UUID

  @HiveField(1)
  final CustomerModel customer;

  @HiveField(2)
  final List<WarrantyItem> items;

  @HiveField(3)
  final DateTime saleDate;

  @HiveField(4)
  final double totalAmount;

  @HiveField(5)
  final double paidAmount;

  @HiveField(6)
  final bool isPaid; // Toggle: Paid / Unpaid

  @HiveField(7)
  final ScrapInfo? scrapInfo; // Advance Option: Old fan exchange

  @HiveField(8)
  final WarrantyStatus status;

  @HiveField(9)
  final bool isDeleted;

  @HiveField(10)
  final String createdBy; // Username of employee

  WarrantyModel({
    required this.id,
    required this.customer,
    required this.items,
    required this.saleDate,
    required this.totalAmount,
    this.paidAmount = 0,
    this.isPaid = true,
    this.scrapInfo,
    this.status = WarrantyStatus.active,
    this.isDeleted = false,
    required this.createdBy,
  });
}
