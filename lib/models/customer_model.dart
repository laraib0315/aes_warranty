import 'package:hive/hive.dart';

part 'customer_model.g.dart';

@HiveType(typeId: 5)
class CustomerModel {
  @HiveField(0)
  final String id; // UUID

  @HiveField(1)
  String name;

  @HiveField(2)
  String phone; // mobile number

  @HiveField(3)
  String cuid; // Customer Unique ID (e.g., CUST-001)

  @HiveField(4)
  DateTime createdAt;

  @HiveField(5)
  DateTime lastUpdated;

  @HiveField(6)
  bool isDeleted;

  CustomerModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.cuid,
    required this.createdAt,
    required this.lastUpdated,
    this.isDeleted = false,
  });

  CustomerModel copyWith({
    String? name,
    String? phone,
    String? cuid,
    DateTime? lastUpdated,
    bool? isDeleted,
  }) {
    return CustomerModel(
      id: id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      cuid: cuid ?? this.cuid,
      createdAt: createdAt,
      lastUpdated: lastUpdated ?? DateTime.now(),
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }
}
