import 'package:flutter/material.dart';
import 'package:messenger/core/domain/email.dart';

import '../../core/shared/app_extension.dart';
import '../../core/shared/theme/app_colors.dart';

class EmailListTile extends StatelessWidget {
  const EmailListTile({
    super.key,
    required this.email,
    required this.onTap,
  });

  final Email email;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final unread = !email.isRead;

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: unread ? AppColors.backgroundBlueSoft : AppColors.white,
          border: const Border(
            bottom: BorderSide(color: AppColors.borderLight, width: 0.5),
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
                    color: AppColors.white, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(width: 14),
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
                            fontWeight: unread
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        email.timestamp.timeAgo,
                        style: tt.labelSmall?.copyWith(
                          color: unread
                              ? AppColors.brandNavy
                              : AppColors.textMuted,
                          fontWeight: unread
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
                      fontWeight:
                          unread ? FontWeight.w600 : FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    email.preview,
                    style:
                        tt.bodySmall?.copyWith(color: AppColors.textMuted),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (unread)
              Padding(
                padding: const EdgeInsets.only(top: 4, left: 6),
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.brandNavy,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
