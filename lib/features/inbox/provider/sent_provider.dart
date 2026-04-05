import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/domain/email.dart';
import '../../../core/providers/main_provider.dart';
import '../domain/email_storage_service.dart';

class SentNotifier extends AsyncNotifier<List<Email>> {
  @override
  Future<List<Email>> build() async {
    final stored = ref.read(emailStorageServiceProvider).loadSent();
    if (stored.isNotEmpty) return stored;
    // Fall back to mock data until user sends something
    return ref.read(inboxDatasourceProvider).getSent();
  }

  void addEmail(Email email) {
    final current = state.valueOrNull ?? [];
    final next = [email, ...current];
    state = AsyncData(next);
    ref.read(emailStorageServiceProvider).saveSent(next);
  }
}

final sentProvider =
    AsyncNotifierProvider<SentNotifier, List<Email>>(SentNotifier.new);
