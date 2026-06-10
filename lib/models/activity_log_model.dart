import 'package:hive/hive.dart';

part 'activity_log_model.g.dart';

@HiveType(typeId: 12)
class ActivityLogModel {
  @HiveField(0)
  final String id; // UUID

  @HiveField(1)
  final String userId; // who performed action

  @HiveField(2)
  final String username;

  @HiveField(3)
  final String action; // e.g., "ADD_WARRANTY", "DELETE_PRODUCT", "UPDATE_STOCK"

  @HiveField(4)
  final Map<String, dynamic> details; // extra info

  @HiveField(5)
  final DateTime timestamp;

  ActivityLogModel({
    required this.id,
    required this.userId,
    required this.username,
    required this.action,
    required this.details,
    required this.timestamp,
  });
}
