import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:messenger/features/auth/provider/auth_state.dart';

import '../../../core/providers/main_provider.dart';


class SignInNotifier extends Notifier<SignInState> {
  @override
  SignInState build() => const SignInState();

  Future<bool> signIn(String email, String password) async {
    state = const SignInState(isLoading: true);
    try {
      await ref
          .read(authDatasourceProvider)
          .signIn(email: email, password: password);
      state = const SignInState();
      return true;
    } catch (e) {
      state = SignInState(error: e.toString().replaceFirst('Exception: ', ''));
      return false;
    }
  }

  void clearError() => state = const SignInState();
}

final signInProvider =
    NotifierProvider<SignInNotifier, SignInState>(SignInNotifier.new);
