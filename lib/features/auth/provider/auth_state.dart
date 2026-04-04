import 'package:flutter/foundation.dart';

@immutable
class SignInState {
  final bool isLoading;
  final String? error;

  const SignInState({this.isLoading = false, this.error});
}
