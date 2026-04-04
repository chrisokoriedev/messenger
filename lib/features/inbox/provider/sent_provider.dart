import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/domain/email.dart';
import '../../../core/providers/main_provider.dart';

class SentNotifier extends AsyncNotifier<List<Email>> {
  @override
  Future<List<Email>> build() =>
      ref.read(inboxDatasourceProvider).getSent();
}

final sentProvider =
    AsyncNotifierProvider<SentNotifier, List<Email>>(SentNotifier.new);
