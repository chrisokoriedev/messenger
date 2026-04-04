import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/shared/constants/app_routes.dart';
import '../../core/shared/theme/app_colors.dart';
import 'email_list_tile.dart';
import 'inbox_provider.dart';

class InboxScreen extends ConsumerWidget {
  const InboxScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inboxAsync = ref.watch(inboxProvider);
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            backgroundColor: AppColors.scaffoldBackground,
            surfaceTintColor: AppColors.transparent,
            title: Text('Inbox',
                style: tt.titleLarge
                    ?.copyWith(fontWeight: FontWeight.w700)),
            actions: [
              IconButton(
                icon: const Icon(Icons.search_rounded),
                onPressed: () {},
              ),
            ],
          ),
          inboxAsync.when(
            loading: () => const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, _) => SliverFillRemaining(
              child: Center(
                  child: Text('Failed to load inbox\n$e',
                      textAlign: TextAlign.center)),
            ),
            data: (emails) => emails.isEmpty
                ? const SliverFillRemaining(
                    child: Center(child: Text('Your inbox is empty')),
                  )
                : SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final email = emails[index];
                        return EmailListTile(
                          email: email,
                          onTap: () {
                            ref
                                .read(inboxProvider.notifier)
                                .markRead(email.id);
                            context.go(AppRoutes.emailDetail,
                                extra: email.id);
                          },
                        );
                      },
                      childCount: emails.length,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
