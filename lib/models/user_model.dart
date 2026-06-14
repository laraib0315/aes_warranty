import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
enum UserRole {
  @HiveField(0)
  superAdmin,
  @HiveField(1)
  admin,
  @HiveField(2)
  staff,
  @HiveField(3)
  viewOnly,
}

@HiveType(typeId: 1)
class UserModel {
  @HiveField(0)
  final String id; // UUID

  @HiveField(1)
  final String username;

  @HiveField(2)
  final String email;

  @HiveField(3)
  final UserRole role;

  @HiveField(4)
  final DateTime createdAt;

  @HiveField(5)
  String? photoUrl; // Google profile photo (optional)

  @HiveField(6)
  bool isActive; // account active or disabled

  @HiveField(7)
  bool isApproved;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.role,
    required this.createdAt,
    this.photoUrl,
    this.isActive = true,
    this.isApproved = false,
  });

  // Copy with method (for updates)
  UserModel copyWith({
    String? id,
    String? username,
    String? email,
    UserRole? role,
    DateTime? createdAt,
    String? photoUrl,
    bool? isActive,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      photoUrl: photoUrl ?? this.photoUrl,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  String toString() => 'UserModel($username, $email, $role)';
}
