import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../services/database_service.dart';
import 'package:uuid/uuid.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? _currentUser;
  bool _isLoading = false;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final DatabaseService db = DatabaseService.instance;

  AuthProvider() {
    _loadUserFromPrefs();
  }

  Future<void> _loadUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    if (userId != null) {
      _currentUser = db.userBox.get(userId);
      notifyListeners();
    }
  }

  Future<bool> signInWithGoogle() async {
    _isLoading = true;
    notifyListeners();

    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final email = googleUser.email;
      final username = googleUser.displayName ?? email.split('@').first;
      final photoUrl = googleUser.photoUrl;

      UserModel? existingUser;
      for (var user in db.userBox.values) {
        if (user.email == email) {
          existingUser = user;
          break;
        }
      }

      if (existingUser != null) {
        _currentUser = existingUser;
      } else {
        final newUser = UserModel(
          id: const Uuid().v4(),
          username: username,
          email: email,
          role: UserRole.staff,
          createdAt: DateTime.now(),
          photoUrl: photoUrl,
          isActive: true,
        );
        await db.userBox.put(newUser.id, newUser);
        _currentUser = newUser;
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userId', _currentUser!.id);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // ✅ Simplified – no delay, immediate return
  Future<bool> sendOtp(String email) async {
    debugPrint('OTP sent to $email (dummy)');
    return true;
  }

  Future<bool> verifyOtp(String email, String otp) async {
    if (otp == '123456') {
      UserModel? existingUser;
      for (var user in db.userBox.values) {
        if (user.email == email) {
          existingUser = user;
          break;
        }
      }

      if (existingUser != null) {
        _currentUser = existingUser;
      } else {
        final newUser = UserModel(
          id: const Uuid().v4(),
          username: email.split('@').first,
          email: email,
          role: UserRole.staff,
          createdAt: DateTime.now(),
          isActive: true,
        );
        await db.userBox.put(newUser.id, newUser);
        _currentUser = newUser;
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userId', _currentUser!.id);
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    await _googleSignIn.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    _currentUser = null;
    notifyListeners();
  }

  Future<void> updateUserRole(String userId, UserRole newRole) async {
    final user = db.userBox.get(userId);
    if (user != null) {
      final updated = user.copyWith(role: newRole);
      await db.userBox.put(userId, updated);
      if (_currentUser?.id == userId) {
        _currentUser = updated;
        notifyListeners();
      }
    }
  }
}
