
/// Route paths — used with `context.go(AppRoutes.x)`.
class AppRoutes {
  // Auth
  static const String signIn = '/sign-in';

  // Shell root
  static const String shell = '/app';

  // Bottom-nav tabs
  static const String inbox   = '/app/inbox';
  static const String sent    = '/app/sent';
  static const String drafts  = '/app/drafts';
  static const String trash   = '/app/trash';
  static const String profile = '/app/profile';

  // Full-screen flows
  static const String emailDetail = '/app/inbox/detail';
  static const String compose     = '/app/compose';
}

/// Named identifiers — used with `context.goNamed(AppRouteNames.x)`.
class AppRouteNames {
  static const String signIn      = 'sign-in';
  static const String inbox       = 'inbox';
  static const String sent        = 'sent';
  static const String drafts      = 'drafts';
  static const String trash       = 'trash';
  static const String profile     = 'profile';
  static const String emailDetail = 'email-detail';
  static const String compose     = 'compose';
}
