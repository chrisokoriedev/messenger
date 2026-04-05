import 'user.dart';

class AuthDatasource {
  Future<User> signIn({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));
    if (email.isEmpty || password.length < 6) {
      throw Exception('Invalid email or password.');
    }
    // Derive display name from the local part of the email (before @)
    final localPart = email.split('@').first;
    final displayName = localPart
        .replaceAll(RegExp(r'[._\-]'), ' ')
        .split(' ')
        .map((w) => w.isEmpty ? '' : '${w[0].toUpperCase()}${w.substring(1)}')
        .join(' ');
    return User(
      id: 'u_${email.hashCode.abs()}',
      name: displayName,
      email: email,
    );
  }
}
