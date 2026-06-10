import 'package:flutter/material.dart';
import '../services/database_service.dart';
import '../models/draft_model.dart';
import 'package:uuid/uuid.dart';

class DraftProvider extends ChangeNotifier {
  final DatabaseService db = DatabaseService.instance;
  List<DraftModel> _drafts = [];

  List<DraftModel> get drafts => _drafts;

  DraftProvider() {
    _loadDrafts();
  }

  void _loadDrafts() {
    _drafts = db.draftBox.values.toList();
    // Auto delete drafts older than 3 days
    final now = DateTime.now();
    for (var draft in _drafts) {
      if (now.difference(draft.lastUpdated).inDays >= 3) {
        deleteDraft(draft.id);
      }
    }
    notifyListeners();
  }

  Future<void> saveDraft(DraftType type, Map<String, dynamic> data) async {
    final draft = DraftModel(
      id: const Uuid().v4(),
      type: type,
      data: data,
      createdAt: DateTime.now(),
      lastUpdated: DateTime.now(),
    );
    await db.draftBox.put(draft.id, draft);
    _drafts.insert(0, draft);
    notifyListeners();
  }

  Future<void> updateDraft(String id, Map<String, dynamic> data) async {
    final draft = db.draftBox.get(id);
    if (draft != null) {
      final updated = DraftModel(
        id: draft.id,
        type: draft.type,
        data: data,
        createdAt: draft.createdAt,
        lastUpdated: DateTime.now(),
      );
      await db.draftBox.put(id, updated);
      final index = _drafts.indexWhere((d) => d.id == id);
      if (index != -1) _drafts[index] = updated;
      notifyListeners();
    }
  }

  Future<void> deleteDraft(String id) async {
    await db.draftBox.delete(id);
    _drafts.removeWhere((d) => d.id == id);
    notifyListeners();
  }

  DraftModel? getDraftByType(DraftType type) {
    return _drafts.firstWhereOrNull((d) => d.type == type);
  }
}

extension FirstWhereOrNullExtension<T> on Iterable<T> {
  T? firstWhereOrNull(bool Function(T) test) {
    for (var element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}
