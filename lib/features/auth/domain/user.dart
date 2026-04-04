class User {
  final String id;
  final String name;
  final String email;

  const User({required this.id, required this.name, required this.email});

  static const mock = User(
    id: 'u1',
    name: 'Chris Okorie',
    email: 'chris@example.com',
  );
}
