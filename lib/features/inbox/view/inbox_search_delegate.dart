import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:messenger/core/domain/email.dart';
import 'package:messenger/core/theme/app_colors.dart';

import '../../../core/shared/constants/app_routes.dart';
import 'email_list_tile.dart';

class InboxSearchDelegate extends SearchDelegate<Email?> {
  InboxSearchDelegate(this._emails);

  final List<Email> _emails;

  @override
  String get searchFieldLabel => 'Search emails…';

  @override
  TextStyle? get searchFieldStyle => const TextStyle(
        fontSize: 15,
        color: AppColors.textPrimary,
      );

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        iconTheme: IconThemeData(color: AppColors.textSecondary),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: InputBorder.none,
        filled: false,
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) => [
        if (query.isNotEmpty)
          IconButton(
            icon: const Icon(Icons.clear_rounded, size: 20),
            color: AppColors.textSecondary,
            onPressed: () => query = '',
          ),
      ];

  @override
  Widget buildLeading(BuildContext context) => IconButton(
        icon: const Icon(Icons.arrow_back_rounded, size: 22),
        color: AppColors.textSecondary,
        onPressed: () => close(context, null),
      );

  @override
  Widget buildResults(BuildContext context) => _buildList(context);

  @override
  Widget buildSuggestions(BuildContext context) => _buildList(context);

  Widget _buildList(BuildContext context) {
    final q = query.toLowerCase().trim();
    final results = q.isEmpty
        ? _emails
        : _emails.where((e) {
            return e.sender.toLowerCase().contains(q) ||
                e.subject.toLowerCase().contains(q) ||
                e.preview.toLowerCase().contains(q);
          }).toList();

    if (results.isEmpty) {
      return Center(
        child: Text(
          'No results for "$query"',
          style: const TextStyle(
            color: AppColors.textMuted,
            fontSize: 14,
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, i) {
        final email = results[i];
        return EmailListTile(
          email: email,
          onTap: () {
            close(context, email);
            context.push(AppRoutes.emailDetail, extra: email);
          },
        );
      },
    );
  }
}
