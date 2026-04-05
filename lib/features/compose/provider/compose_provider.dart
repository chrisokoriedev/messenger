import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/main_provider.dart';
import '../../inbox/provider/drafts_provider.dart';
import '../../inbox/provider/sent_provider.dart';
import 'compose_state.dart';

class ComposeNotifier extends AutoDisposeNotifier<ComposeState> {
  static final _emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  @override
  ComposeState build() => const ComposeState();

  void addRecipient(String raw) {
    final email = raw.trim().replaceAll(',', '').replaceAll(' ', '');
    if (email.isEmpty || !_emailRegex.hasMatch(email)) return;
    if (state.recipients.contains(email)) return;
    state = state.copyWith(
      recipients: [...state.recipients, email],
      toError: false,
    );
  }

  void removeRecipient(String email) {
    state = state.copyWith(
      recipients: state.recipients.where((r) => r != email).toList(),
    );
  }

  void clearToError() {
    if (state.toError) state = state.copyWith(toError: false);
  }

  void saveDraft({
    required String draftId,
    required String subject,
    required String body,
  }) {
    ref.read(draftsProvider.notifier).saveDraft(
          id: draftId,
          recipients: state.recipients,
          subject: subject,
          body: body,
        );
    state = state.copyWith(draftSaved: true);
  }

  Future<void> send({
    required String subject,
    required String body,
    String? draftId,
  }) async {
    state = state.copyWith(
      toError: state.recipients.isEmpty,
      subjectError: subject.trim().isEmpty,
      bodyError: body.trim().isEmpty,
    );
    if (state.toError || state.subjectError || state.bodyError) return;

    state = state.copyWith(isSending: true);
    try {
      final email = await ref.read(composeDatasourceProvider).send(
            recipients: state.recipients,
            subject: subject.trim(),
            body: body.trim(),
          );
      ref.read(sentProvider.notifier).addEmail(email);
      // Remove draft if this was a draft being sent
      if (draftId != null) {
        ref.read(draftsProvider.notifier).removeDraft(draftId);
      }
      state = state.copyWith(isSending: false, sent: true);
    } catch (e) {
      state = state.copyWith(
        isSending: false,
        error: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  void clearError() => state = state.copyWith(clearError: true);
}

final composeProvider =
    AutoDisposeNotifierProvider<ComposeNotifier, ComposeState>(
  ComposeNotifier.new,
);
