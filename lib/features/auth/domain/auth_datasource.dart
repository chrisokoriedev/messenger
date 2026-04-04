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
    return User.mock;
  }
}
