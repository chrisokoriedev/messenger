import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:messenger/core/theme/app_colors.dart';

import 'recipient_chip.dart';

class ToField extends StatelessWidget {
  const ToField({
    super.key,
    required this.recipients,
    required this.controller,
    required this.focusNode,
    required this.hasError,
    required this.onTyping,
    required this.onSubmit,
    required this.onRemove,
  });

  final List<String> recipients;
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool hasError;
  final void Function(String) onTyping;
  final VoidCallback onSubmit;
  final void Function(String) onRemove;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 52),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                'To',
                style: tt.bodySmall?.copyWith(
                  color: hasError ? Colors.red.shade600 : AppColors.textMuted,
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                ),
              ),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Wrap(
                spacing: 6,
                runSpacing: 4,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  for (final r in recipients)
                    RecipientChip(label: r, onDelete: () => onRemove(r)),
                  IntrinsicWidth(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(minWidth: 120),
                      child: TextField(
                        controller: controller,
                        focusNode: focusNode,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.done,
                        style: tt.bodyMedium?.copyWith(
                          color: AppColors.textPrimary,
                          fontSize: 15,
                        ),
                        decoration: InputDecoration(
                          hintText: recipients.isEmpty ? 'Add recipients' : '',
                          hintStyle: TextStyle(
                            color: hasError
                                ? Colors.red.shade400
                                : AppColors.textMuted,
                            fontSize: 15,
                          ),
                          isDense: true,
                          filled: false,
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 8),
                        ),
                        onChanged: onTyping,
                        onSubmitted: (_) => onSubmit(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
