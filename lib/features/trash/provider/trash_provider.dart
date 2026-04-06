import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../inbox/domain/inbox_datasource.dart';
import '../domain/trash_storage_service.dart';

class TrashNotifier extends AsyncNotifier<List<EmailModel>> {
  @override
  Future<List<EmailModel>> build() async {
    final service = ref.read(trashStorageServiceProvider);
    await service.purgeExpired();
    return service.loadTrashed();
  }

  Future<void> moveToTrash(EmailModel email) async {
    final service = ref.read(trashStorageServiceProvider);
    await service.moveToTrash(email);
    state = AsyncData(service.loadTrashed());
  }

  Future<void> restoreEmail(String emailId) async {
    final service = ref.read(trashStorageServiceProvider);
    await service.restoreFromTrash(emailId);
    state = AsyncData(service.loadTrashed());
  }

  Future<void> deletePermanently(String emailId) async {
    final service = ref.read(trashStorageServiceProvider);
    await service.deletePermanently(emailId);
    state = AsyncData(service.loadTrashed());
  }

  Future<void> emptyTrash() async {
    final service = ref.read(trashStorageServiceProvider);
    await service.emptyTrash();
    state = const AsyncData([]);
  }
}

final trashProvider =
    AsyncNotifierProvider<TrashNotifier, List<EmailModel>>(TrashNotifier.new);
