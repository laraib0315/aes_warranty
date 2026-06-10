import 'package:hive/hive.dart';

part 'brand_model.g.dart';

@HiveType(typeId: 3)
class BrandModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final DateTime createdAt;

  @HiveField(3)
  bool isFilterEnabled; // toggle switch ON = filter bane ga

  @HiveField(4)
  bool isDeleted;

  BrandModel({
    required this.id,
    required this.name,
    required this.createdAt,
    this.isFilterEnabled = false,
    this.isDeleted = false,
  });

  BrandModel copyWith({String? name, bool? isFilterEnabled, bool? isDeleted}) {
    return BrandModel(
      id: id,
      name: name ?? this.name,
      createdAt: createdAt,
      isFilterEnabled: isFilterEnabled ?? this.isFilterEnabled,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }
}
