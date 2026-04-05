import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/domain/email.dart';
import '../../../core/providers/main_provider.dart';
import '../domain/email_storage_service.dart';
import '../domain/inbox_datasource.dart';

class DraftsNotifier extends AsyncNotifier<List<Email>> {
  @override
  Future<List<Email>> build() async {
    final stored = ref.read(emailStorageServiceProvider).loadDrafts();
    if (stored.isNotEmpty) return stored;
    return ref.read(inboxDatasourceProvider).getDrafts();
  }

  void removeDraft(String id) {
    final current = state.valueOrNull ?? [];
    final next = current.where((e) => e.id != id).toList();
    state = AsyncData(next);
    ref.read(emailStorageServiceProvider).saveDrafts(next);
  }

  void saveDraft({
    required String id,
    required List<String> recipients,
    required String subject,
    required String body,
    required String senderEmail,
  }) {
    final current = state.valueOrNull ?? [];
    final now = DateTime.now();

    final updated = EmailModel(
      id: id,
      sender: 'Me',
      senderEmail: senderEmail,
      subject: subject.trim().isEmpty ? '(No subject)' : subject.trim(),
      preview: body.trim().length > 80
          ? '${body.trim().substring(0, 80)}…'
          : body.trim(),
      body: body.trim(),
      timestamp: now,
      isRead: true,
    );

    final idx = current.indexWhere((e) => e.id == id);
    final next = [...current];
    if (idx >= 0) {
      next[idx] = updated;
    } else {
      next.insert(0, updated);
    }
    state = AsyncData(next);
    ref.read(emailStorageServiceProvider).saveDrafts(next);
  }
}

final draftsProvider =
    AsyncNotifierProvider<DraftsNotifier, List<Email>>(DraftsNotifier.new);

