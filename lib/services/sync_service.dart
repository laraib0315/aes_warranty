import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'database_service.dart';

class SyncService {
  final DatabaseService db = DatabaseService.instance;

  bool _isSyncing = false;
  bool get isSyncing => _isSyncing;

  // Future: This will be implemented with Firebase later
  // Currently just a placeholder that simulates sync

  Future<void> syncToCloud() async {
    if (_isSyncing) return;

    _isSyncing = true;
    debugPrint('Sync started...');

    // Simulate sync delay
    await Future.delayed(const Duration(seconds: 2));

    // Get all local data
    final warranties = db.warrantyBox.values.toList();
    final products = db.productBox.values.toList();
    final customers = db.customerBox.values.toList();

    debugPrint(
        'Syncing ${warranties.length} warranties, ${products.length} products, ${customers.length} customers');

    // Future: Send to Firebase/backend
    // For now, just mark last sync time
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('last_sync', DateTime.now().toIso8601String());

    _isSyncing = false;
    debugPrint('Sync completed');
  }

  Future<void> syncFromCloud() async {
    if (_isSyncing) return;

    _isSyncing = true;
    debugPrint('Downloading from cloud...');

    await Future.delayed(const Duration(seconds: 2));

    // Future: Fetch from Firebase and merge
    // For now, just placeholder

    _isSyncing = false;
    debugPrint('Download completed');
  }

  Future<DateTime?> getLastSyncTime() async {
    final prefs = await SharedPreferences.getInstance();
    final lastSync = prefs.getString('last_sync');
    if (lastSync != null) {
      return DateTime.parse(lastSync);
    }
    return null;
  }

  Future<bool> isOnline() async {
    // Future: Implement connectivity check
    // For now, assume online
    return true;
  }
}
