import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:messenger/core/router/app_shell.dart';

import '../shared/constants/app_routes.dart';
import '../../features/auth/provider/auth_provider.dart';
import '../../features/auth/provider/auth_state.dart';
import '../../features/auth/view/sign_in_screen.dart';
import '../../features/inbox/view/inbox_screen.dart';
import '../../features/inbox/view/sent_screen.dart';
import '../../features/inbox/view/drafts_screen.dart';
import '../../features/inbox/view/email_detail_screen.dart';
import '../../features/compose/view/compose_screen.dart';
import '../../core/domain/email.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final notifier = _RouterNotifier(ref);
  ref.onDispose(notifier.dispose);

  return GoRouter(
    initialLocation: AppRoutes.signIn,
    debugLogDiagnostics: false,
    refreshListenable: notifier,
    redirect: notifier.redirect,
    routes: _routes,
  );
});

class _RouterNotifier extends ChangeNotifier {
  _RouterNotifier(this._ref) {
    _ref.listen<AuthState>(authProvider, (_, _) => notifyListeners());
  }

  final Ref _ref;

  String? redirect(BuildContext context, GoRouterState state) {
    final isAuth = _ref.read(authProvider).isAuthenticated;
    final onSignIn = state.matchedLocation == AppRoutes.signIn;
    if (!isAuth && !onSignIn) return AppRoutes.signIn;
    if (isAuth && onSignIn) return AppRoutes.inbox;
    return null;
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Routes
// ─────────────────────────────────────────────────────────────────────────────

final List<RouteBase> _routes = [
  GoRoute(
    path: AppRoutes.signIn,
    name: AppRouteNames.signIn,
    builder: (context, state) => const SignInScreen(),
  ),

  GoRoute(path: AppRoutes.shell, redirect: (_, _) => AppRoutes.inbox),

  StatefulShellRoute.indexedStack(
    builder: (context, state, shell) => AppShell(navigationShell: shell),
    branches: [
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: AppRoutes.inbox,
            name: AppRouteNames.inbox,
            builder: (context, state) => const InboxScreen(),
          ),
        ],
      ),

      StatefulShellBranch(
        routes: [
          GoRoute(
            path: AppRoutes.sent,
            name: AppRouteNames.sent,
            builder: (context, state) => const SentScreen(),
          ),
        ],
      ),

      StatefulShellBranch(
        routes: [
          GoRoute(
            path: AppRoutes.drafts,
            name: AppRouteNames.drafts,
            builder: (context, state) => const DraftsScreen(),
          ),
        ],
      ),

      
    ],
  ),
  GoRoute(
    path: AppRoutes.emailDetail,
    name: AppRouteNames.emailDetail,
    builder: (context, state) {
      final email = state.extra as Email;
      return EmailDetailScreen(email: email);
    },
  ),
  GoRoute(
    path: AppRoutes.compose,
    name: AppRouteNames.compose,
    pageBuilder: (context, state) => CustomTransitionPage(
      key: state.pageKey,
    child: ComposeScreen(
          initialTo: (state.extra as Map?)?['to'] as String?,
          initialSubject: (state.extra as Map?)?['subject'] as String?,
        ),
      transitionsBuilder: (context, animation, _, child) => SlideTransition(
        position: Tween(begin: const Offset(0, 1), end: Offset.zero).animate(
          CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
        ),
        child: child,
      ),
    ),
  ),
];
