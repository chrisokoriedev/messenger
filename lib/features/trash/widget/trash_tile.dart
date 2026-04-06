import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:messenger/core/theme/app_colors.dart';

import '../../inbox/domain/inbox_datasource.dart';
import '../provider/trash_provider.dart';
class TrashTile extends ConsumerWidget {
  const TrashTile({super.key, required this.email});

  final EmailModel email;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tt = Theme.of(context).textTheme;
    final daysLeft = email.trashedAt != null
        ? 30 - DateTime.now().difference(email.trashedAt!).inDays
        : 30;
    final isExpiringSoon = daysLeft <= 5;

    return Dismissible(
      key: Key(email.id),
      // Swipe right → restore
      background: _swipeBg(
        color: AppColors.brandNavy.withOpacity(0.08),
        icon: Icons.restore_rounded,
        label: 'Restore',
        alignment: Alignment.centerLeft,
      ),
      // Swipe left → delete permanently
      secondaryBackground: _swipeBg(
        color: Colors.red.shade50,
        icon: Icons.delete_forever_rounded,
        label: 'Delete',
        alignment: Alignment.centerRight,
        iconColor: Colors.red.shade600,
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          await ref
              .read(trashProvider.notifier)
              .restoreEmail(email.id);
          _snack(context, 'Email restored');
          return true;
        } else {
          final ok = await _confirmDelete(context);
          if (ok) {
            await ref
                .read(trashProvider.notifier)
                .deletePermanently(email.id);
            _snack(context, 'Permanently deleted');
          }
          return ok;
        }
      },
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: const BoxDecoration(
          color: AppColors.white,
          border: Border(
            bottom:
                BorderSide(color: AppColors.borderLight, width: 0.5),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: AppColors.brandNavy,
              child: Text(
                email.sender.isNotEmpty
                    ? email.sender[0].toUpperCase()
                    : '?',
                style: tt.labelMedium?.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            14.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          email.sender,
                          style: tt.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '$daysLeft day${daysLeft == 1 ? '' : 's'} left',
                        style: tt.labelSmall?.copyWith(
                          color: isExpiringSoon
                              ? Colors.red.shade400
                              : AppColors.textMuted,
                          fontWeight: isExpiringSoon
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    email.subject,
                    style: tt.bodySmall?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 1),
                  Text(
                    email.preview,
                    style: tt.bodySmall
                        ?.copyWith(color: AppColors.textMuted),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // ── Context menu ─────────────────────────────────────────
            PopupMenuButton<_Action>(
              icon: Icon(Icons.more_vert_rounded,
                  size: 18, color: AppColors.textMuted),
              onSelected: (action) async {
                switch (action) {
                  case _Action.restore:
                    await ref
                        .read(trashProvider.notifier)
                        .restoreEmail(email.id);
                    _snack(context, 'Email restored');
                  case _Action.delete:
                    final ok = await _confirmDelete(context);
                    if (ok) {
                      await ref
                          .read(trashProvider.notifier)
                          .deletePermanently(email.id);
                      _snack(context, 'Permanently deleted');
                    }
                }
              },
              itemBuilder: (_) => [
                const PopupMenuItem(
                  value: _Action.restore,
                  child: Row(children: [
                    Icon(Icons.restore_rounded, size: 18),
                    SizedBox(width: 8),
                    Text('Restore'),
                  ]),
                ),
                PopupMenuItem(
                  value: _Action.delete,
                  child: Row(children: [
                    Icon(Icons.delete_forever_rounded,
                        size: 18, color: Colors.red),
                    const SizedBox(width: 8),
                    Text('Delete permanently',
                        style: const TextStyle(color: Colors.red)),
                  ]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _swipeBg({
    required Color color,
    required IconData icon,
    required String label,
    required Alignment alignment,
    Color? iconColor,
  }) {
    final c = iconColor ?? AppColors.brandNavy;
    return Container(
      color: color,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      alignment: alignment,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: c, size: 22),
          const SizedBox(width: 6),
          Text(label,
              style: TextStyle(
                  color: c, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Future<bool> _confirmDelete(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Delete permanently?'),
            content:
                const Text('This email will be deleted forever.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: Text('Delete',
                    style: TextStyle(color: Colors.red.shade600)),
              ),
            ],
          ),
        ) ??
        false;
  }

  void _snack(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
enum _Action { restore, delete }