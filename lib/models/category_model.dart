import 'package:hive/hive.dart';

part 'category_model.g.dart';

@HiveType(typeId: 2)
class CategoryModel {
  @HiveField(0)
  final String id; // UUID

  @HiveField(1)
  final String name; // e.g., "Ceiling Fans", "Pedestal Fans", "Lights"

  @HiveField(2)
  final DateTime createdAt;

  @HiveField(3)
  bool isDeleted; // soft delete for trash

  CategoryModel({
    required this.id,
    required this.name,
    required this.createdAt,
    this.isDeleted = false,
  });

  CategoryModel copyWith({String? name, bool? isDeleted}) {
    return CategoryModel(
      id: id,
      name: name ?? this.name,
      createdAt: createdAt,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }
}
