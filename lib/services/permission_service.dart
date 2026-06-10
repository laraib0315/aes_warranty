import '../models/user_model.dart';

class PermissionService {
  // Check if user can view/access a feature
  static bool canView(UserRole? role, String feature) {
    if (role == null) return false;
    if (role == UserRole.superAdmin || role == UserRole.admin) return true;

    switch (feature) {
      case 'dashboard':
        return true;
      case 'reports':
        return true;
      case 'customers':
        return role == UserRole.staff || role == UserRole.viewOnly;
      case 'add_warranty':
        return role == UserRole.staff;
      case 'edit_warranty':
        return role == UserRole.admin || role == UserRole.superAdmin;
      case 'delete_warranty':
        return role == UserRole.admin || role == UserRole.superAdmin;
      case 'products':
        return role == UserRole.staff || role == UserRole.viewOnly;
      case 'add_product':
        return role == UserRole.admin || role == UserRole.superAdmin;
      case 'edit_product':
        return role == UserRole.admin || role == UserRole.superAdmin;
      case 'delete_product':
        return role == UserRole.admin || role == UserRole.superAdmin;
      case 'qr_generation':
        return role == UserRole.staff || role == UserRole.admin;
      case 'user_management':
        return role == UserRole.admin || role == UserRole.superAdmin;
      case 'audit_log':
        return role == UserRole.admin || role == UserRole.superAdmin;
      case 'settings':
        return true;
      default:
        return false;
    }
  }

  // Check if user can edit specific resource
  static bool canEdit(
      UserRole? role, String resourceOwnerId, String currentUserId) {
    if (role == null) return false;
    if (role == UserRole.superAdmin) return true;
    if (role == UserRole.admin) return true;
    if (role == UserRole.staff && resourceOwnerId == currentUserId) return true;
    return false;
  }

  // Check if user can delete
  static bool canDelete(
      UserRole? role, String resourceOwnerId, String currentUserId) {
    if (role == null) return false;
    if (role == UserRole.superAdmin) return true;
    if (role == UserRole.admin) return true;
    return false;
  }

  // Get user friendly role name
  static String getRoleName(UserRole role) {
    switch (role) {
      case UserRole.superAdmin:
        return 'Super Admin';
      case UserRole.admin:
        return 'Admin';
      case UserRole.staff:
        return 'Staff';
      case UserRole.viewOnly:
        return 'View Only';
    }
  }
}
