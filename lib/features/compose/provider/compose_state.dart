import 'package:flutter/foundation.dart';

@immutable
class ComposeState {
  final List<String> recipients;
  final bool isSending;
  final bool sent;
  final String? error;
  final bool toError;
  final bool subjectError;
  final bool bodyError;

  const ComposeState({
    this.recipients = const [],
    this.isSending = false,
    this.sent = false,
    this.error,
    this.toError = false,
    this.subjectError = false,
    this.bodyError = false,
  });

  ComposeState copyWith({
    List<String>? recipients,
    bool? isSending,
    bool? sent,
    String? error,
    bool clearError = false,
    bool? toError,
    bool? subjectError,
    bool? bodyError,
  }) {
    return ComposeState(
      recipients: recipients ?? this.recipients,
      isSending: isSending ?? this.isSending,
      sent: sent ?? this.sent,
      error: clearError ? null : error ?? this.error,
      toError: toError ?? this.toError,
      subjectError: subjectError ?? this.subjectError,
      bodyError: bodyError ?? this.bodyError,
    );
  }
}
