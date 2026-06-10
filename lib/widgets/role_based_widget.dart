import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../models/user_model.dart';

class RoleBasedWidget extends StatelessWidget {
  final List<UserRole> allowedRoles;
  final Widget child;

  const RoleBasedWidget({
    super.key,
    required this.allowedRoles,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final currentUser = authProvider.currentUser;
    if (currentUser == null) return const SizedBox.shrink();
    if (allowedRoles.contains(currentUser.role)) {
      return child;
    }
    return const SizedBox.shrink();
  }
}
