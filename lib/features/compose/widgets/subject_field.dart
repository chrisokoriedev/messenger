import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:messenger/core/theme/app_colors.dart';

class SubjectField extends StatelessWidget {
  const SubjectField({
    super.key,
    required this.controller,
    required this.hasError,
    required this.onChanged,
  });

  final TextEditingController controller;
  final bool hasError;
  final void Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return SizedBox(
      height: 52,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Row(
          children: [
            Text(
              'Subject',
              style: tt.bodySmall?.copyWith(
                color: hasError ? Colors.red.shade600 : AppColors.textMuted,
                fontWeight: FontWeight.w500,
                fontSize: 13,
              ),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: TextField(
                controller: controller,
                textInputAction: TextInputAction.next,
                style: tt.bodyMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
                decoration: InputDecoration(
                  hintText: hasError ? 'Required' : 'Add a subject',
                  hintStyle: TextStyle(
                    color: hasError ? Colors.red.shade400 : AppColors.textMuted,
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                  isDense: true,
                  filled: false,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
                onChanged: onChanged,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
