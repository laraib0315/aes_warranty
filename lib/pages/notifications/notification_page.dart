import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/notification_provider.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<NotificationProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          IconButton(
            icon: const Icon(Icons.checklist),
            onPressed: () => provider.markAllAsRead(),
            tooltip: 'Mark all as read',
          ),
        ],
      ),
      body: provider.notifications.isEmpty
          ? const Center(child: Text('No notifications'))
          : ListView.builder(
              itemCount: provider.notifications.length,
              itemBuilder: (context, index) {
                final notification = provider.notifications[index];
                return ListTile(
                  leading: Icon(
                    notification.isRead
                        ? Icons.notifications_none
                        : Icons.notifications_active,
                    color: notification.isRead
                        ? Colors.grey
                        : const Color(0xFFE7712D),
                  ),
                  title: Text(notification.title),
                  subtitle: Text(notification.body),
                  trailing: Text(
                    _formatTime(notification.timestamp),
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  onTap: () {
                    provider.markAsRead(notification.id);
                    if (notification.relatedId != null) {
                      // Navigate to related item (warranty, product, etc.)
                    }
                  },
                );
              },
            ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);
    if (diff.inDays > 0) return '${diff.inDays}d ago';
    if (diff.inHours > 0) return '${diff.inHours}h ago';
    if (diff.inMinutes > 0) return '${diff.inMinutes}m ago';
    return 'Just now';
  }
}
