import 'package:hive/hive.dart';
import 'category_model.dart';
import 'brand_model.dart';

part 'product_model.g.dart';

@HiveType(typeId: 4)
class ProductModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String sku; // Auto like AES-FAN-001

  @HiveField(3)
  BrandModel brand;

  @HiveField(4)
  CategoryModel category;

  @HiveField(5)
  double costPrice; // net price

  @HiveField(6)
  double? sellingPrice; // nullable – agar toggle off hai to null

  @HiveField(7)
  bool hasSellingPrice; // toggle switch ON/OFF

  @HiveField(8)
  int stock;

  @HiveField(9)
  int lowStockLimit; // alert threshold

  @HiveField(10)
  DateTime createdAt;

  @HiveField(11)
  DateTime lastUpdated;

  @HiveField(12)
  bool isDeleted;

  // Warranty periods (for fans) – for other items, we can use generic
  @HiveField(13)
  int motorWarrantyMonths; // default 12

  @HiveField(14)
  int boardWarrantyMonths; // default 24

  ProductModel({
    required this.id,
    required this.name,
    required this.sku,
    required this.brand,
    required this.category,
    required this.costPrice,
    this.sellingPrice,
    this.hasSellingPrice = false,
    required this.stock,
    this.lowStockLimit = 5,
    required this.createdAt,
    required this.lastUpdated,
    this.isDeleted = false,
    this.motorWarrantyMonths = 12,
    this.boardWarrantyMonths = 24,
  });

  ProductModel copyWith({
    String? name,
    String? sku,
    BrandModel? brand,
    CategoryModel? category,
    double? costPrice,
    double? sellingPrice,
    bool? hasSellingPrice,
    int? stock,
    int? lowStockLimit,
    DateTime? lastUpdated,
    bool? isDeleted,
    int? motorWarrantyMonths,
    int? boardWarrantyMonths,
  }) {
    return ProductModel(
      id: id,
      name: name ?? this.name,
      sku: sku ?? this.sku,
      brand: brand ?? this.brand,
      category: category ?? this.category,
      costPrice: costPrice ?? this.costPrice,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      hasSellingPrice: hasSellingPrice ?? this.hasSellingPrice,
      stock: stock ?? this.stock,
      lowStockLimit: lowStockLimit ?? this.lowStockLimit,
      createdAt: createdAt,
      lastUpdated: lastUpdated ?? DateTime.now(),
      isDeleted: isDeleted ?? this.isDeleted,
      motorWarrantyMonths: motorWarrantyMonths ?? this.motorWarrantyMonths,
      boardWarrantyMonths: boardWarrantyMonths ?? this.boardWarrantyMonths,
    );
  }
}
