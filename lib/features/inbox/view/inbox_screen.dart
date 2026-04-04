import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:messenger/core/theme/app_colors.dart';

import '../../../core/shared/constants/app_routes.dart';
import '../provider/inbox_provider.dart';
import 'email_list_tile.dart';

class InboxScreen extends ConsumerWidget {
  const InboxScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inboxAsync = ref.watch(inboxProvider);

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.compose),
        backgroundColor: AppColors.brandNavy,
        foregroundColor: AppColors.white,
        elevation: 2,
        icon: const Icon(Icons.edit_outlined),
        label: const Text('Compose'),
      ),
      body: CustomScrollView(
        slivers: [
          inboxAsync.when(
            loading: () => const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, _) => SliverFillRemaining(
              child: Center(
                child: Text(
                  'Failed to load inbox\n$e',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            data: (emails) => emails.isEmpty
                ? const SliverFillRemaining(
                    child: Center(child: Text('Your inbox is empty')),
                  )
                : SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final email = emails[index];
                      return EmailListTile(
                        email: email,
                        onTap: () {
                          ref.read(inboxProvider.notifier).markRead(email.id);
                          context.go(AppRoutes.emailDetail, extra: email);
                        },
                      );
                    }, childCount: emails.length),
                  ),
          ),
        ],
      ),
    );
  }
}
