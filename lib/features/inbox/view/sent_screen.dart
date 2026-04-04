import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/shared/constants/app_routes.dart';
import '../../../core/shared/theme/app_colors.dart';
import '../provider/sent_provider.dart';
import 'email_list_tile.dart';

class SentScreen extends ConsumerWidget {
  const SentScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sentAsync = ref.watch(sentProvider);
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            backgroundColor: AppColors.scaffoldBackground,
            surfaceTintColor: AppColors.transparent,
            title: Text(
              'Sent',
              style: tt.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
          sentAsync.when(
            loading: () => const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, _) => SliverFillRemaining(
              child: Center(
                child: Text(
                  'Failed to load sent\n$e',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            data: (emails) => emails.isEmpty
                ? const SliverFillRemaining(
                    child: Center(child: Text('No sent emails')),
                  )
                : SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final email = emails[index];
                        return EmailListTile(
                          email: email,
                          onTap: () => context.go(
                            AppRoutes.emailDetail,
                            extra: email,
                          ),
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
