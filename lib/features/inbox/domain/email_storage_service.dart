import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/domain/email.dart';
import '../../../core/providers/shared_preferences_provider.dart';
import 'inbox_datasource.dart';

class EmailStorageService {
  static const _sentKey = 'sent_emails_v1';
  static const _draftsKey = 'draft_emails_v1';

  const EmailStorageService(this._prefs);

  final SharedPreferences _prefs;

  List<EmailModel> loadSent() => _load(_sentKey);
  List<EmailModel> loadDrafts() => _load(_draftsKey);

  Future<void> saveSent(List<Email> emails) => _save(_sentKey, emails);
  Future<void> saveDrafts(List<Email> emails) => _save(_draftsKey, emails);

  List<EmailModel> _load(String key) {
    final raw = _prefs.getString(key);
    if (raw == null) return [];
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return list
          .map((e) => EmailModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> _save(String key, List<Email> emails) async {
    final list =
        emails.whereType<EmailModel>().map((e) => e.toJson()).toList();
    await _prefs.setString(key, jsonEncode(list));
  }
}

final emailStorageServiceProvider = Provider<EmailStorageService>((ref) {
  return EmailStorageService(ref.read(sharedPreferencesProvider));
});
