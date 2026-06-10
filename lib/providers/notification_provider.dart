import 'package:flutter/material.dart';
import '../services/database_service.dart';
import '../models/notification_model.dart';
import 'package:uuid/uuid.dart';

class NotificationProvider extends ChangeNotifier {
  final DatabaseService db = DatabaseService.instance;
  List<NotificationModel> _notifications = [];

  List<NotificationModel> get notifications => _notifications;

  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  NotificationProvider() {
    _loadNotifications();
  }

  void _loadNotifications() {
    _notifications = db.notificationBox.values.toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    notifyListeners();
  }

  Future<void> addNotification({
    required String title,
    required String body,
    String? relatedId,
  }) async {
    final notification = NotificationModel(
      id: const Uuid().v4(),
      title: title,
      body: body,
      timestamp: DateTime.now(),
      isRead: false,
      relatedId: relatedId,
    );
    await db.notificationBox.put(notification.id, notification);
    _notifications.insert(0, notification);
    notifyListeners();
  }

  Future<void> markAsRead(String id) async {
    final notification = db.notificationBox.get(id);
    if (notification != null && !notification.isRead) {
      final updated = notification.copyWith(isRead: true);
      await db.notificationBox.put(id, updated);
      final index = _notifications.indexWhere((n) => n.id == id);
      if (index != -1) _notifications[index] = updated;
      notifyListeners();
    }
  }

  Future<void> markAllAsRead() async {
    for (var n in _notifications) {
      if (!n.isRead) {
        final updated = n.copyWith(isRead: true);
        await db.notificationBox.put(n.id, updated);
      }
    }
    _loadNotifications();
  }
}
