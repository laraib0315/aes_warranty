import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../services/database_service.dart';
import 'package:uuid/uuid.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? _currentUser;
  bool _isLoading = false;
  String? _approvalMessage;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get approvalMessage => _approvalMessage;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final DatabaseService db = DatabaseService.instance;

  AuthProvider() {
    _loadUserFromPrefs();
    _auth.authStateChanges().listen((User? firebaseUser) async {
      if (firebaseUser == null) {
        _currentUser = null;
        notifyListeners();
      } else {
        await _loadUserFromPrefs();
      }
    });
  }

  Future<void> _loadUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    if (userId != null) {
      _currentUser = db.userBox.get(userId);
      notifyListeners();
    }
  }

  // ✅ Google Sign-In (Web + Mobile)
  Future<bool> signInWithGoogle() async {
    _isLoading = true;
    _approvalMessage = null;
    notifyListeners();

    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      final User? firebaseUser = userCredential.user;
      if (firebaseUser == null) {
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // Check if user exists in Firestore
      final doc =
          await _firestore.collection('users').doc(firebaseUser.uid).get();
      bool isApproved = false;
      UserRole role = UserRole.staff;

      if (doc.exists) {
        isApproved = doc.data()?['isApproved'] ?? false;
        role = _stringToRole(doc.data()?['role'] ?? 'staff');
      } else {
        // New user
        await _firestore.collection('users').doc(firebaseUser.uid).set({
          'email': firebaseUser.email,
          'displayName': firebaseUser.displayName,
          'photoURL': firebaseUser.photoURL,
          'role': 'staff',
          'isApproved': false,
          'createdAt': FieldValue.serverTimestamp(),
        });
        isApproved = false;
        role = UserRole.staff;
      }

      if (!isApproved) {
        await _auth.signOut();
        await _googleSignIn.signOut();
        _isLoading = false;
        _approvalMessage =
            'Your account is pending approval by the Super Admin.';
        notifyListeners();
        return false;
      }

      // ✅ Success - save user to Hive
      UserModel? existingUser;
      for (var u in db.userBox.values) {
        if (u.email == firebaseUser.email) {
          existingUser = u;
          break;
        }
      }

      if (existingUser != null) {
        _currentUser = existingUser;
      } else {
        final newUser = UserModel(
          id: const Uuid().v4(),
          username:
              firebaseUser.displayName ?? firebaseUser.email!.split('@').first,
          email: firebaseUser.email!,
          role: role,
          createdAt: DateTime.now(),
          photoUrl: firebaseUser.photoURL,
          isActive: true,
          isApproved: true,
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
      debugPrint('❌ Google Sign-In error: $e');
      _isLoading = false;
      _approvalMessage = 'Login failed. Please try again.';
      notifyListeners();
      return false;
    }
  }

  // ✅ Email/Password Sign-Up
  Future<bool> signUpWithEmail(
      String email, String password, String username) async {
    _isLoading = true;
    _approvalMessage = null;
    notifyListeners();

    try {
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final User? user = userCredential.user;
      if (user == null) {
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // Create Firestore doc with isApproved = false
      await _firestore.collection('users').doc(user.uid).set({
        'email': email,
        'displayName': username,
        'photoURL': null,
        'role': 'staff',
        'isApproved': false,
        'createdAt': FieldValue.serverTimestamp(),
      });

      await _auth.signOut();
      _isLoading = false;
      _approvalMessage = 'Account created. Please wait for admin approval.';
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Sign-up error: $e');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // ✅ Email/Password Sign-In (only if approved)
  Future<bool> signInWithEmail(String email, String password) async {
    _isLoading = true;
    _approvalMessage = null;
    notifyListeners();

    try {
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final User? user = userCredential.user;
      if (user == null) {
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (!doc.exists || (doc.data()?['isApproved'] ?? false) == false) {
        await _auth.signOut();
        _isLoading = false;
        _approvalMessage = 'Your account is pending approval.';
        notifyListeners();
        return false;
      }

      // Approved – save to Hive
      final role = _stringToRole(doc.data()?['role'] ?? 'staff');
      UserModel? existingUser;
      for (var u in db.userBox.values) {
        if (u.email == email) {
          existingUser = u;
          break;
        }
      }

      if (existingUser != null) {
        _currentUser = existingUser;
      } else {
        final newUser = UserModel(
          id: const Uuid().v4(),
          username: doc.data()?['displayName'] ?? email.split('@').first,
          email: email,
          role: role,
          createdAt: DateTime.now(),
          isActive: true,
          isApproved: true,
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
      debugPrint('Sign-in error: $e');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // ✅ Sign Out
  Future<void> logout() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    _currentUser = null;
    _approvalMessage = null;
    notifyListeners();
  }

  // ✅ Update user role (used in role_permissions_page.dart)
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

  // ✅ Helper: Convert string to UserRole
  UserRole _stringToRole(String role) {
    switch (role) {
      case 'superAdmin':
        return UserRole.superAdmin;
      case 'admin':
        return UserRole.admin;
      case 'staff':
        return UserRole.staff;
      case 'viewOnly':
        return UserRole.viewOnly;
      default:
        return UserRole.staff;
    }
  }

  String _roleToString(UserRole role) {
    switch (role) {
      case UserRole.superAdmin:
        return 'superAdmin';
      case UserRole.admin:
        return 'admin';
      case UserRole.staff:
        return 'staff';
      case UserRole.viewOnly:
        return 'viewOnly';
    }
  }

  // ✅ For admin: get pending users from Firestore
  Stream<List<Map<String, dynamic>>> getPendingUsers() {
    return _firestore
        .collection('users')
        .where('isApproved', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              return {
                'uid': doc.id,
                'email': doc.data()['email'],
                'displayName': doc.data()['displayName'],
                'createdAt': (doc.data()['createdAt'] as Timestamp?)?.toDate(),
              };
            }).toList());
  }

  // ✅ Admin approve user
  Future<void> approveUser(String uid, UserRole role) async {
    await _firestore.collection('users').doc(uid).update({
      'isApproved': true,
      'role': _roleToString(role),
    });
  }

  // ✅ Admin deny/delete user
  Future<void> denyUser(String uid) async {
    await _firestore.collection('users').doc(uid).delete();
  }
}
