import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:messenger/core/shared/widgets/drawer_tile.dart';
import 'package:messenger/core/theme/app_colors.dart';

import '../../features/auth/provider/auth_provider.dart';
import '../../features/auth/domain/user.dart';
import '../../features/inbox/provider/inbox_provider.dart';
import '../../features/inbox/view/inbox_search_delegate.dart';

class AppShell extends ConsumerWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  static const _titles = ['Inbox', 'Sent', 'Drafts', 'Trash', 'Profile'];

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
              onPressed: () {
                final emails =
                    ref.read(inboxProvider).valueOrNull ?? [];
                showSearch(
                  context: context,
                  delegate: InboxSearchDelegate(emails),
                );
              },
            ),
        ],
      ),
      drawer: Drawer(
        width: MediaQuery.of(context).size.width * 0.6,
        backgroundColor: AppColors.white,
        surfaceTintColor: AppColors.transparent,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Header ──────────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'MESSENGER',
                      style: tt.labelSmall?.copyWith(
                        color: AppColors.textMuted,
                        letterSpacing: 1.6,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: AppColors.brandNavy,
                          child: Text(
                            user.name.isNotEmpty
                                ? user.name[0].toUpperCase()
                                : '?',
                            style: tt.titleSmall?.copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user.name,
                                style: tt.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              Text(
                                user.email,
                                style: tt.bodySmall?.copyWith(
                                  color: AppColors.textMuted,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, color: AppColors.borderLight),
              const SizedBox(height: 8),
              // ── Nav ─────────────────────────────────────────────────────────
              DrawerTile(
                icon: Icons.inbox_outlined,
                activeIcon: Icons.inbox_rounded,
                label: 'Inbox',
                selected: currentIndex == 0,
                onTap: () => switchTo(0),
              ),
              DrawerTile(
                icon: Icons.send_outlined,
                activeIcon: Icons.send_rounded,
                label: 'Sent',
                selected: currentIndex == 1,
                onTap: () => switchTo(1),
              ),
              DrawerTile(
                icon: Icons.drafts_outlined,
                activeIcon: Icons.drafts_rounded,
                label: 'Drafts',
                selected: currentIndex == 2,
                onTap: () => switchTo(2),
              ),
              DrawerTile(
                icon: Icons.delete_outline_rounded,
                activeIcon: Icons.delete_rounded,
                label: 'Trash',
                selected: currentIndex == 3,
                onTap: () => switchTo(3),
              ),
              const Spacer(),
              const Divider(height: 1, color: AppColors.borderLight),
              DrawerTile(
                icon: Icons.logout_rounded,
                activeIcon: Icons.logout_rounded,
                label: 'Sign out',
                selected: false,
                onTap: () {
                  Navigator.of(context).pop();
                  ref.read(authProvider.notifier).signOut();
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
      body: navigationShell,
    );
  }
}
