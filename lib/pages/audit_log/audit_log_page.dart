import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../services/database_service.dart';
import '../../models/activity_log_model.dart';
import '../../models/user_model.dart';

class AuditLogPage extends StatefulWidget {
  const AuditLogPage({super.key});

  @override
  State<AuditLogPage> createState() => _AuditLogPageState();
}

class _AuditLogPageState extends State<AuditLogPage> {
  late List<ActivityLogModel> _logs;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadLogs();
  }

  void _loadLogs() {
    final db = DatabaseService.instance;
    _logs = db.activityLogBox.values.toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  List<ActivityLogModel> get _filteredLogs {
    if (_searchQuery.isEmpty) return _logs;
    return _logs
        .where((log) =>
            log.username.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            log.action.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<AuthProvider>(context).currentUser;
    final isAdmin = currentUser?.role == UserRole.admin ||
        currentUser?.role == UserRole.superAdmin;

    if (!isAdmin) {
      return Scaffold(
        appBar: AppBar(title: const Text('Audit Log')),
        body: const Center(child: Text('Access denied. Admin only.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Audit Log'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => setState(() => _loadLogs()),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search by user or action',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (val) => setState(() => _searchQuery = val),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredLogs.length,
              itemBuilder: (context, index) {
                final log = _filteredLogs[index];
                return ListTile(
                  leading: const Icon(Icons.history),
                  title: Text('${log.username} - ${log.action}'),
                  subtitle: Text(log.details.toString()),
                  trailing: Text(
                    _formatTime(log.timestamp),
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.day}/${time.month}/${time.year} ${time.hour}:${time.minute}';
  }
}
