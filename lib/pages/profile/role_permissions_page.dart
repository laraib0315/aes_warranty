import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/user_model.dart';

class RolePermissionsPage extends StatefulWidget {
  const RolePermissionsPage({super.key});

  @override
  State<RolePermissionsPage> createState() => _RolePermissionsPageState();
}

class _RolePermissionsPageState extends State<RolePermissionsPage> {
  late Future<List<UserModel>> _usersFuture;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  void _loadUsers() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final db = authProvider.db;
    _usersFuture = Future.value(db.userBox.values.toList());
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final currentUser = authProvider.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text('Role & Permissions')),
      body: FutureBuilder<List<UserModel>>(
        future: _usersFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final users = snapshot.data!;
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              final canEdit = currentUser?.role == UserRole.superAdmin ||
                  (currentUser?.role == UserRole.admin &&
                      user.role != UserRole.superAdmin);
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: ListTile(
                  title: Text(user.username),
                  subtitle: Text(user.email),
                  trailing: canEdit
                      ? DropdownButton<UserRole>(
                          value: user.role,
                          items: UserRole.values.map((role) {
                            return DropdownMenuItem(
                              value: role,
                              child: Text(role.name),
                            );
                          }).toList(),
                          onChanged: (newRole) async {
                            if (newRole != null && newRole != user.role) {
                              await authProvider.updateUserRole(
                                  user.id, newRole);
                              if (!mounted) return; // ✅ Added
                              setState(() {});
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        '${user.username} role updated to ${newRole.name}')),
                              );
                            }
                          },
                        )
                      : Chip(label: Text(user.role.name)),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
