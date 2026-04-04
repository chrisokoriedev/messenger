import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/domain/email.dart';
import '../../../core/providers/main_provider.dart';

class DraftsNotifier extends AsyncNotifier<List<Email>> {
  @override
  Future<List<Email>> build() =>
      ref.read(inboxDatasourceProvider).getDrafts();
}

final draftsProvider =
    AsyncNotifierProvider<DraftsNotifier, List<Email>>(DraftsNotifier.new);
