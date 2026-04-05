import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/shared/constants/app_routes.dart';
import '../provider/drafts_provider.dart';
import 'email_list_tile.dart';

class DraftsScreen extends ConsumerWidget {
  const DraftsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draftsAsync = ref.watch(draftsProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          draftsAsync.when(
            loading: () => const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, _) => SliverFillRemaining(
              child: Center(
                child: Text(
                  'Failed to load drafts\n$e',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            data: (emails) => emails.isEmpty
                ? const SliverFillRemaining(
                    child: Center(child: Text('No drafts')),
                  )
                : SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final email = emails[index];
                        return EmailListTile(
                          email: email,
                          onTap: () => context.push(
                            AppRoutes.compose,
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
