import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:messenger/core/theme/app_colors.dart';

import '../../../core/shared/constants/app_routes.dart';
import '../../../core/shared/widgets/app_text_field.dart';

class ComposeScreen extends StatefulWidget {
  const ComposeScreen({super.key});

  @override
  State<ComposeScreen> createState() => _ComposeScreenState();
}

class _ComposeScreenState extends State<ComposeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _toController = TextEditingController();
  final _subjectController = TextEditingController();
  final _bodyController = TextEditingController();

  @override
  void dispose() {
    _toController.dispose();
    _subjectController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  void _send() {
    if (!_formKey.currentState!.validate()) return;
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(AppRoutes.inbox);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        surfaceTintColor: AppColors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(AppRoutes.inbox);
            }
          },
        ),
        title: Text(
          'New Message',
          style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 12.w),
            child: TextButton.icon(
              onPressed: _send,
              icon: const Icon(Icons.send_rounded, size: 18),
              label: const Text('Send'),
              style: TextButton.styleFrom(foregroundColor: AppColors.brandNavy),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Container(height: 0.5, color: AppColors.borderLight),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                child: Column(
                  children: [
                    AppTextField(
                      label: 'To',
                      controller: _toController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      prefixIcon: Icons.person_outline_rounded,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return 'Enter a recipient';
                        }
                        if (!v.contains('@')) return 'Enter a valid email';
                        return null;
                      },
                    ),
                    16.verticalSpace,
                    AppTextField(
                      label: 'Subject',
                      controller: _subjectController,
                      textInputAction: TextInputAction.next,
                      prefixIcon: Icons.subject_rounded,
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Enter a subject'
                          : null,
                    ),
                    16.verticalSpace,
                    AppTextField(
                      label: 'Message',
                      controller: _bodyController,
                      textInputAction: TextInputAction.newline,
                      keyboardType: TextInputType.multiline,
                      maxLines: 14,
                      minLines: 8,
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Write your message'
                          : null,
                    ),
                    40.verticalSpace,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
