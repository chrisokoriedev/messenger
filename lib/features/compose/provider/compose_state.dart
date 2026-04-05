import 'package:flutter/foundation.dart';

@immutable
class ComposeState {
  final List<String> recipients;
  final bool isSending;
  final bool sent;
  final bool draftSaved;
  final String? error;

  const ComposeState({
    this.recipients = const [],
    this.isSending = false,
    this.sent = false,
    this.draftSaved = false,
    this.error,
  });

  ComposeState copyWith({
    List<String>? recipients,
    bool? isSending,
    bool? sent,
    bool? draftSaved,
    String? error,
    bool clearError = false,
  }) {
    return ComposeState(
      recipients: recipients ?? this.recipients,
      isSending: isSending ?? this.isSending,
      sent: sent ?? this.sent,
      draftSaved: draftSaved ?? this.draftSaved,
      error: clearError ? null : error ?? this.error,
    );
  }
}
