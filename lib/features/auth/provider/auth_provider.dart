import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/main_provider.dart';
import '../../../core/providers/shared_preferences_provider.dart';
import '../domain/user.dart';
import 'auth_state.dart';

class AuthNotifier extends Notifier<AuthState> {
  static const _kUserId    = 'auth_user_id';
  static const _kUserName  = 'auth_user_name';
  static const _kUserEmail = 'auth_user_email';

  @override
  AuthState build() {
    final prefs = ref.read(sharedPreferencesProvider);
    final id = prefs.getString(_kUserId);
    if (id != null) {
      return AuthState(
        user: User(
          id: id,
          name: prefs.getString(_kUserName) ?? '',
          email: prefs.getString(_kUserEmail) ?? '',
        ),
      );
    }
    return const AuthState();
  }

  Future<bool> signIn(String email, String password) async {
    state = const AuthState(isLoading: true);
    try {
      final user = await ref
          .read(authDatasourceProvider)
          .signIn(email: email, password: password);
      final prefs = ref.read(sharedPreferencesProvider);
      await prefs.setString(_kUserId, user.id);
      await prefs.setString(_kUserName, user.name);
      await prefs.setString(_kUserEmail, user.email);
      state = AuthState(user: user);
      return true;
    } catch (e) {
      state = AuthState(error: e.toString().replaceFirst('Exception: ', ''));
      return false;
    }
  }

  Future<void> signOut() async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.remove(_kUserId);
    await prefs.remove(_kUserName);
    await prefs.remove(_kUserEmail);
    state = const AuthState();
  }

  void clearError() => state = AuthState(user: state.user);
}

final authProvider =
    NotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);

