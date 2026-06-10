import 'package:hive/hive.dart';

part 'notification_model.g.dart';

@HiveType(typeId: 13)
class NotificationModel {
  @HiveField(0)
  final String id; // UUID

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String body;

  @HiveField(3)
  final DateTime timestamp;

  @HiveField(4)
  bool isRead;

  @HiveField(5)
  final String? relatedId; // warranty id, product id, etc.

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.timestamp,
    this.isRead = false,
    this.relatedId,
  });

  NotificationModel copyWith({bool? isRead}) {
    return NotificationModel(
      id: id,
      title: title,
      body: body,
      timestamp: timestamp,
      isRead: isRead ?? this.isRead,
      relatedId: relatedId,
    );
  }
}
