import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/domain/email.dart';
import '../../../core/providers/main_provider.dart';

class InboxNotifier extends AsyncNotifier<List<Email>> {
  @override
  Future<List<Email>> build() =>
      ref.read(inboxDatasourceProvider).getInbox();

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(inboxDatasourceProvider).getInbox(),
    );
  }

  Future<void> toggleRead(String id) async {
    final emails = state.valueOrNull;
    if (emails == null) return;
    final target = emails.firstWhere((e) => e.id == id);
    final updated = await ref
        .read(inboxDatasourceProvider)
        .markRead(id: id, isRead: !target.isRead);
    state = AsyncData([for (final e in emails) if (e.id == id) updated else e]);
  }

  Future<void> markRead(String id) async {
    final emails = state.valueOrNull;
    if (emails == null) return;
    final updated = await ref
        .read(inboxDatasourceProvider)
        .markRead(id: id, isRead: true);
    state = AsyncData([for (final e in emails) if (e.id == id) updated else e]);
  }

  Future<void> deleteEmail(String id) async {
    await ref.read(inboxDatasourceProvider).deleteEmail(id);
    final emails = state.valueOrNull ?? [];
    state = AsyncData(emails.where((e) => e.id != id).toList());
  }
}

final inboxProvider =
    AsyncNotifierProvider<InboxNotifier, List<Email>>(InboxNotifier.new);
