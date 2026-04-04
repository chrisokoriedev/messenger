import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/domain/email.dart';
import '../../../core/shared/app_extension.dart';
import '../../../core/shared/theme/app_colors.dart';

class EmailDetailScreen extends StatelessWidget {
  const EmailDetailScreen({super.key, required this.email});

  final Email email;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        surfaceTintColor: AppColors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.reply_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded),
            onPressed: () => context.pop(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(24.w, 8.h, 24.w, 40.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              email.subject,
              style: tt.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            20.verticalSpace,
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: AppColors.brandNavy,
                  child: Text(
                    email.sender.isNotEmpty
                        ? email.sender[0].toUpperCase()
                        : '?',
                    style: tt.titleMedium?.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                12.horizontalSpace,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        email.sender,
                        style: tt.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        email.senderEmail,
                        style:
                            tt.bodySmall?.copyWith(color: AppColors.textMuted),
                      ),
                    ],
                  ),
                ),
                Text(
                  email.timestamp.timeAgo,
                  style: tt.labelSmall?.copyWith(color: AppColors.textMuted),
                ),
              ],
            ),
            24.verticalSpace,
            Container(height: 0.5, color: AppColors.borderLight),
            24.verticalSpace,
            Text(
              email.body,
              style: tt.bodyMedium?.copyWith(
                color: AppColors.textPrimary,
                height: 1.7,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
