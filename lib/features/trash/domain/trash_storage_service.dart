import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/providers/shared_preferences_provider.dart';
import '../../inbox/domain/inbox_datasource.dart';

class TrashStorageService {
  static const _trashKey = 'trash_emails_v1';

  const TrashStorageService(this._prefs);

  final SharedPreferences _prefs;

  List<EmailModel> loadTrashed() => _load();

  Future<void> moveToTrash(EmailModel email) async {
    final existing = _load();
    if (existing.any((e) => e.id == email.id)) return;
    final trashed = email.copyWithTrashed(
      isTrashed: true,
      trashedAt: DateTime.now(),
    );
    final updated = [...existing, trashed];
    await _persist(updated);
  }

  Future<void> restoreFromTrash(String emailId) async {
    final updated = _load().where((e) => e.id != emailId).toList();
    await _persist(updated);
  }

  Future<void> deletePermanently(String emailId) async {
    final updated = _load().where((e) => e.id != emailId).toList();
    await _persist(updated);
  }

  Future<void> emptyTrash() async {
    await _prefs.remove(_trashKey);
  }

  /// Removes emails trashed more than 30 days ago.
  Future<void> purgeExpired() async {
    final cutoff = DateTime.now().subtract(const Duration(days: 30));
    final updated = _load().where((e) {
      final t = e.trashedAt;
      return t == null || t.isAfter(cutoff);
    }).toList();
    await _persist(updated);
  }

  List<EmailModel> _load() {
    final raw = _prefs.getString(_trashKey);
    if (raw == null) return [];
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return (list
          .map((e) => EmailModel.fromJson(e as Map<String, dynamic>))
          .toList())
        ..sort((a, b) => (b.trashedAt ?? b.timestamp)
            .compareTo(a.trashedAt ?? a.timestamp));
    } catch (_) {
      return [];
    }
  }

  Future<void> _persist(List<EmailModel> emails) async {
    await _prefs.setString(
      _trashKey,
      jsonEncode(emails.map((e) => e.toJson()).toList()),
    );
  }
}

final trashStorageServiceProvider = Provider<TrashStorageService>((ref) {
  return TrashStorageService(ref.read(sharedPreferencesProvider));
});
