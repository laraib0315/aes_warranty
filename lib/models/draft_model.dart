import 'package:hive/hive.dart';

part 'draft_model.g.dart';

@HiveType(typeId: 9)
enum DraftType {
  @HiveField(0)
  warranty,
  @HiveField(1)
  product,
  @HiveField(2)
  customer,
  @HiveField(3)
  qrBatch,
}

@HiveType(typeId: 10)
class DraftModel {
  @HiveField(0)
  final String id; // UUID

  @HiveField(1)
  final DraftType type;

  @HiveField(2)
  final Map<String, dynamic> data; // JSON data of the form

  @HiveField(3)
  final DateTime createdAt;

  @HiveField(4)
  DateTime lastUpdated;

  DraftModel({
    required this.id,
    required this.type,
    required this.data,
    required this.createdAt,
    required this.lastUpdated,
  });
}
