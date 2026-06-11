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

@HiveType(typeId: 7)
class WarrantyModel {
  @HiveField(0)
  final String id; // UUID

  @HiveField(1)
  String uid; // Unique ID from QR/barcode (e.g., AES-UID-12345)

  @HiveField(2)
  CustomerModel customer;

  @HiveField(3)
  ProductModel product;

  @HiveField(4)
  DateTime saleDate;

  @HiveField(5)
  double? sellingPrice; // actual price paid by customer

  @HiveField(6)
  DateTime motorExpiryDate; // for fans, otherwise same as board

  @HiveField(7)
  DateTime boardExpiryDate; // for fans, otherwise same as motor

  @HiveField(8)
  WarrantyStatus status;

  @HiveField(9)
  bool isDeleted;

  // Payment tracking
  @HiveField(10)
  double totalPaid; // total amount paid so far

  @HiveField(11)
  double totalAmount; // total bill amount

  @HiveField(12)
  bool isFullyPaid; // if totalPaid >= totalAmount

  @HiveField(13)
  List<PaymentModel> payments; // list of payment installments

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
    );
  }
}
