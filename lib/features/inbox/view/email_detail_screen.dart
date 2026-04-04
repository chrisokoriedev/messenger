import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:messenger/core/theme/app_colors.dart';

import '../../../core/domain/email.dart';
import '../../../core/shared/app_extension.dart';
import '../../../core/shared/constants/app_routes.dart';
import '../provider/inbox_provider.dart';

class EmailDetailScreen extends ConsumerStatefulWidget {
  const EmailDetailScreen({super.key, required this.email});

  final Email email;

  @override
  ConsumerState<EmailDetailScreen> createState() => _EmailDetailScreenState();
}

class _EmailDetailScreenState extends ConsumerState<EmailDetailScreen> {
  late bool _isRead;

  @override
  void initState() {
    super.initState();
    _isRead = widget.email.isRead;
  }

  Future<void> _toggleRead() async {
    await ref.read(inboxProvider.notifier).toggleRead(widget.email.id);
    setState(() => _isRead = !_isRead);
  }

  Future<void> _delete() async {
    await ref.read(inboxProvider.notifier).deleteEmail(widget.email.id);
    if (mounted) context.pop();
  }

  void _reply() {
    final subject = widget.email.subject.startsWith('Re: ')
        ? widget.email.subject
        : 'Re: ${widget.email.subject}';
    context.push(AppRoutes.compose, extra: {
      'to': widget.email.senderEmail,
      'subject': subject,
    });
  }

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
            tooltip: _isRead ? 'Mark as unread' : 'Mark as read',
            icon: Icon(
              _isRead
                  ? Icons.mark_email_unread_outlined
                  : Icons.mark_email_read_outlined,
            ),
            onPressed: _toggleRead,
          ),
          IconButton(
            icon: const Icon(Icons.reply_outlined),
            onPressed: _reply,
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded),
            onPressed: _delete,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(24.w, 8.h, 24.w, 40.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.email.subject,
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
                    widget.email.sender.isNotEmpty
                        ? widget.email.sender[0].toUpperCase()
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
                        widget.email.sender,
                        style: tt.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        widget.email.senderEmail,
                        style: tt.bodySmall?.copyWith(
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  widget.email.timestamp.timeAgo,
                  style: tt.labelSmall?.copyWith(color: AppColors.textMuted),
                ),
              ],
            ),
            24.verticalSpace,
            Container(height: 0.5, color: AppColors.borderLight),
            24.verticalSpace,
            Text(
              widget.email.body,
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

