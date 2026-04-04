import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../shared/constants/app_routes.dart';
import '../shared/theme/app_colors.dart';
import '../../features/auth/view/sign_in_screen.dart';
import '../../features/inbox/inbox_screen.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Router Provider
// ─────────────────────────────────────────────────────────────────────────────

final routerProvider = Provider<GoRouter>((ref) {
  // TODO: watch your auth provider and uncomment the redirect guard below.
  // final auth = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: AppRoutes.signIn,
    debugLogDiagnostics: false,

    // redirect: (context, state) {
    //   final loggedIn = auth.isAuthenticated;
    //   final onAuth  = state.matchedLocation == AppRoutes.signIn;
    //   if (!loggedIn && !onAuth) return AppRoutes.signIn;
    //   if (loggedIn  &&  onAuth) return AppRoutes.inbox;
    //   return null;
    // },
    routes: _routes,
  );
});

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
                  final emailId = state.extra as String? ?? '';
                  return _Placeholder('Email Detail — $emailId');
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
            builder: (context, state) => const _Placeholder('Sent'),
          ),
        ],
      ),

      // Tab 2 — Drafts
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: AppRoutes.drafts,
            name: AppRouteNames.drafts,
            builder: (context, state) => const _Placeholder('Drafts'),
          ),
        ],
      ),

      // Tab 3 — Profile
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: AppRoutes.profile,
            name: AppRouteNames.profile,
            builder: (context, state) => const _Placeholder('Profile'),
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
      child: const _Placeholder('Compose Email'),
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

class _AppShell extends StatelessWidget {
  const _AppShell({required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  static const _tabs = [
    (
      icon: Icons.inbox_outlined,
      activeIcon: Icons.inbox_rounded,
      label: 'Inbox',
    ),
    (icon: Icons.send_outlined, activeIcon: Icons.send_rounded, label: 'Sent'),
    (
      icon: Icons.drafts_outlined,
      activeIcon: Icons.drafts_rounded,
      label: 'Drafts',
    ),
    (
      icon: Icons.person_outline_rounded,
      activeIcon: Icons.person_rounded,
      label: 'Profile',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go(AppRoutes.compose),
        backgroundColor: AppColors.brandNavy,
        foregroundColor: AppColors.white,
        elevation: 2,
        child: const Icon(Icons.edit_outlined),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (i) => navigationShell.goBranch(
          i,
          initialLocation: i == navigationShell.currentIndex,
        ),
        backgroundColor: AppColors.white,
        surfaceTintColor: AppColors.transparent,
        shadowColor: AppColors.shadowOverlay,
        elevation: 0,
        indicatorColor: AppColors.backgroundBlue,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: [
          for (final tab in _tabs)
            NavigationDestination(
              icon: Icon(tab.icon, color: AppColors.textSecondary),
              selectedIcon: Icon(tab.activeIcon, color: AppColors.brandNavy),
              label: tab.label,
            ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Placeholder — swap in real screens as features are implemented
// ─────────────────────────────────────────────────────────────────────────────

class _Placeholder extends StatelessWidget {
  const _Placeholder(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: Center(
        child: Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(color: AppColors.textSecondary),
        ),
      ),
    );
  }
}
