import 'package:flutter/material.dart';
import 'package:messenger/core/theme/app_colors.dart';

class EmptyTrashState extends StatelessWidget {
  const EmptyTrashState({super.key, required this.tt});

  final TextTheme tt;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.delete_outline_rounded,
            size: 56,
            color: AppColors.textMuted.withOpacity(0.35),
          ),
          const SizedBox(height: 12),
          Text(
            'Trash is empty',
            style: tt.titleMedium?.copyWith(color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}
