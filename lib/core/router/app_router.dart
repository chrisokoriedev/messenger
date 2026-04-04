import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../shared/constants/app_routes.dart';
import '../shared/theme/app_colors.dart';
import '../../features/auth/provider/auth_provider.dart';
import '../../features/auth/provider/auth_state.dart';
import '../../features/auth/domain/user.dart';
import '../../features/auth/view/sign_in_screen.dart';
import '../../features/inbox/view/inbox_screen.dart';
import '../../features/inbox/view/sent_screen.dart';
import '../../features/inbox/view/drafts_screen.dart';
import '../../features/inbox/view/email_detail_screen.dart';
import '../../features/compose/view/compose_screen.dart';
import '../../features/profile/view/profile_screen.dart';
import '../../core/domain/email.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Router Provider
// ─────────────────────────────────────────────────────────────────────────────

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

// ─────────────────────────────────────────────────────────────────────────────
// Router Notifier — triggers GoRouter refresh on auth state changes
// ─────────────────────────────────────────────────────────────────────────────

class _RouterNotifier extends ChangeNotifier {
  _RouterNotifier(this._ref) {
    _ref.listen<AuthState>(authProvider, (_, __) => notifyListeners());
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
  // ── Auth ──────────────────────────────────────────────────────────────────
  GoRoute(
    path: AppRoutes.signIn,
    name: AppRouteNames.signIn,
    builder: (context, state) => const SignInScreen(),
  ),

  // Redirect bare shell path → inbox
  GoRoute(path: AppRoutes.shell, redirect: (_, _) => AppRoutes.inbox),

  // ── App Shell (bottom nav) ─────────────────────────────────────────────────
  StatefulShellRoute.indexedStack(
    builder: (context, state, shell) => _AppShell(navigationShell: shell),
    branches: [
      // Tab 0 — Inbox
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: AppRoutes.inbox,
            name: AppRouteNames.inbox,
            builder: (context, state) => const InboxScreen(),
            // Email detail is a child so it keeps the shell alive
            routes: [
              GoRoute(
                path: 'detail',
                name: AppRouteNames.emailDetail,
                builder: (context, state) {
                  final email = state.extra as Email;
                  return EmailDetailScreen(email: email);
                },
              ),
            ],
          ),
        ],
      ),

      // Tab 1 — Sent
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: AppRoutes.sent,
            name: AppRouteNames.sent,
            builder: (context, state) => const SentScreen(),
          ),
        ],
      ),

      // Tab 2 — Drafts
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: AppRoutes.drafts,
            name: AppRouteNames.drafts,
            builder: (context, state) => const DraftsScreen(),
          ),
        ],
      ),

      // Tab 3 — Profile
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: AppRoutes.profile,
            name: AppRouteNames.profile,
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
    ],
  ),

  // ── Compose — full-screen modal (no bottom nav) ────────────────────────────
  GoRoute(
    path: AppRoutes.compose,
    name: AppRouteNames.compose,
    pageBuilder: (context, state) => CustomTransitionPage(
      key: state.pageKey,
      child: const ComposeScreen(),
      transitionsBuilder: (context, animation, _, child) => SlideTransition(
        position: Tween(begin: const Offset(0, 1), end: Offset.zero).animate(
          CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
        ),
        child: child,
      ),
    ),
  ),
];

// ─────────────────────────────────────────────────────────────────────────────
// App Shell
// ─────────────────────────────────────────────────────────────────────────────

class _AppShell extends ConsumerWidget {
  const _AppShell({required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  static const _titles = ['Inbox', 'Sent', 'Drafts', 'Profile'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user ?? User.mock;
    final currentIndex = navigationShell.currentIndex;
    final tt = Theme.of(context).textTheme;

    void switchTo(int index) {
      Navigator.of(context).pop();
      navigationShell.goBranch(index, initialLocation: index == currentIndex);
    }

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBackground,
        surfaceTintColor: AppColors.transparent,
        elevation: 0,
        title: Text(
          _titles[currentIndex],
          style: tt.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        actions: [
          if (currentIndex == 0)
            IconButton(
              icon: const Icon(Icons.search_rounded),
              onPressed: () {},
            ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: AppColors.white,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(20, 28, 20, 28),
                color: AppColors.brandNavy,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundColor: AppColors.white16,
                      child: Text(
                        user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                        style: tt.titleMedium?.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      user.name,
                      style: tt.titleSmall?.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      user.email,
                      style: tt.bodySmall?.copyWith(color: AppColors.white70),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              _DrawerTile(
                icon: Icons.inbox_rounded,
                label: 'Inbox',
                selected: currentIndex == 0,
                onTap: () => switchTo(0),
              ),
              _DrawerTile(
                icon: Icons.send_rounded,
                label: 'Sent',
                selected: currentIndex == 1,
                onTap: () => switchTo(1),
              ),
              _DrawerTile(
                icon: Icons.drafts_rounded,
                label: 'Drafts',
                selected: currentIndex == 2,
                onTap: () => switchTo(2),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Divider(height: 1, indent: 16, endIndent: 16),
              ),
              _DrawerTile(
                icon: Icons.person_outline_rounded,
                label: 'Profile',
                selected: currentIndex == 3,
                onTap: () => switchTo(3),
              ),
            ],
          ),
        ),
      ),
      body: navigationShell,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Drawer tile
// ─────────────────────────────────────────────────────────────────────────────

class _DrawerTile extends StatelessWidget {
  const _DrawerTile({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return ListTile(
      leading: Icon(
        icon,
        color: selected ? AppColors.brandNavy : AppColors.textSecondary,
      ),
      title: Text(
        label,
        style: tt.bodyMedium?.copyWith(
          fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          color: selected ? AppColors.brandNavy : AppColors.textPrimary,
        ),
      ),
      selected: selected,
      selectedTileColor: AppColors.backgroundBlue,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      onTap: onTap,
    );
  }
}
