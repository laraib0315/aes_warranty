import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/user_model.dart';

class UserManagementPage extends StatefulWidget {
  const UserManagementPage({super.key});

  @override
  State<UserManagementPage> createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<UserManagementPage> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final currentUser = authProvider.currentUser;
    final isSuperAdmin = currentUser?.role == UserRole.superAdmin;

    if (!isSuperAdmin) {
      return Scaffold(
        appBar: AppBar(title: const Text('User Management')),
        body: const Center(child: Text('Access denied. Super Admin only.')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('User Management - Pending Approvals')),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: authProvider.getPendingUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No pending approvals.'));
          }
          final users = snapshot.data!;
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              UserRole selectedRole = UserRole.staff;
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: ListTile(
                  leading: const Icon(Icons.person_outline),
                  title: Text(user['displayName'] ?? user['email']),
                  subtitle: Text(user['email']),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DropdownButton<UserRole>(
                        value: selectedRole,
                        items: const [
                          DropdownMenuItem(
                              value: UserRole.staff, child: Text('Staff')),
                          DropdownMenuItem(
                              value: UserRole.admin, child: Text('Admin')),
                          DropdownMenuItem(
                              value: UserRole.viewOnly,
                              child: Text('View Only')),
                        ],
                        onChanged: (role) =>
                            setState(() => selectedRole = role!),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon:
                            const Icon(Icons.check_circle, color: Colors.green),
                        onPressed: () async {
                          await authProvider.approveUser(
                              user['uid'], selectedRole);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('User approved')),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.cancel, color: Colors.red),
                        onPressed: () async {
                          await authProvider.denyUser(user['uid']);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('User denied')),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
