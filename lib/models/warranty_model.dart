import 'package:hive/hive.dart';
import 'customer_model.dart';
import 'product_model.dart';
import 'payment_model.dart';

part 'warranty_model.g.dart';

@HiveType(typeId: 6)
enum WarrantyStatus {
  @HiveField(0)
  active,
  @HiveField(1)
  expired,
}

@HiveType(typeId: 16)
class ScrapInfo {
  @HiveField(0)
  final String metalType;
  @HiveField(1)
  final double weight;
  @HiveField(2)
  final String weightUnit;

  ScrapInfo({
    required this.metalType,
    required this.weight,
    required this.weightUnit,
  });
}

@HiveType(typeId: 17)
class WarrantyItem {
  @HiveField(0)
  final String uid;
  @HiveField(1)
  final ProductModel product;

  WarrantyItem({
    required this.uid,
    required this.product,
  });
}

@HiveType(typeId: 7)
class WarrantyModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String uid;

  @HiveField(2)
  CustomerModel customer;

  @HiveField(3)
  ProductModel product;

  @HiveField(4)
  DateTime saleDate;

  @HiveField(5)
  double? sellingPrice;

  @HiveField(6)
  DateTime motorExpiryDate;

  @HiveField(7)
  DateTime boardExpiryDate;

  @HiveField(8)
  WarrantyStatus status;

  @HiveField(9)
  bool isDeleted;

  @HiveField(10)
  double totalPaid;

  @HiveField(11)
  double totalAmount;

  @HiveField(12)
  bool isFullyPaid;

  @HiveField(13)
  List<PaymentModel> payments;

  @HiveField(14)
  List<WarrantyItem> items;

  @HiveField(15)
  ScrapInfo? scrapInfo;

  WarrantyModel({
    required this.id,
    required this.uid,
    required this.customer,
    required this.product,
    required this.saleDate,
    this.sellingPrice,
    required this.motorExpiryDate,
    required this.boardExpiryDate,
    required this.status,
    this.isDeleted = false,
    this.totalPaid = 0,
    required this.totalAmount,
    this.isFullyPaid = false,
    this.payments = const [],
    this.items = const [],
    this.scrapInfo,
  });

  WarrantyModel copyWith({
    String? uid,
    CustomerModel? customer,
    ProductModel? product,
    DateTime? saleDate,
    double? sellingPrice,
    DateTime? motorExpiryDate,
    DateTime? boardExpiryDate,
    WarrantyStatus? status,
    bool? isDeleted,
    double? totalPaid,
    double? totalAmount,
    bool? isFullyPaid,
    List<PaymentModel>? payments,
    List<WarrantyItem>? items,
    ScrapInfo? scrapInfo,
  }) {
    return WarrantyModel(
      id: id,
      uid: uid ?? this.uid,
      customer: customer ?? this.customer,
      product: product ?? this.product,
      saleDate: saleDate ?? this.saleDate,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      motorExpiryDate: motorExpiryDate ?? this.motorExpiryDate,
      boardExpiryDate: boardExpiryDate ?? this.boardExpiryDate,
      status: status ?? this.status,
      isDeleted: isDeleted ?? this.isDeleted,
      totalPaid: totalPaid ?? this.totalPaid,
      totalAmount: totalAmount ?? this.totalAmount,
      isFullyPaid: isFullyPaid ?? this.isFullyPaid,
      payments: payments ?? this.payments,
      items: items ?? this.items,
      scrapInfo: scrapInfo ?? this.scrapInfo,
    );
  }
}
