import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:messenger/core/theme/app_colors.dart';
import 'package:messenger/features/compose/provider/compose_state.dart';

import '../../../core/shared/constants/app_routes.dart';
import '../../../core/shared/widgets/app_divider.dart';
import '../provider/compose_provider.dart';
import '../widgets/subject_field.dart';
import '../widgets/to_field.dart';

class ComposeScreen extends ConsumerStatefulWidget {
  const ComposeScreen({
    super.key,
    this.initialTo,
    this.initialSubject,
  });

  final String? initialTo;
  final String? initialSubject;

  @override
  ConsumerState<ComposeScreen> createState() => _ComposeScreenState();
}

class _ComposeScreenState extends ConsumerState<ComposeScreen> {
  final _subjectController = TextEditingController();
  final _bodyController = TextEditingController();
  final _toInputController = TextEditingController();
  final _toFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    if (widget.initialSubject != null) {
      _subjectController.text = widget.initialSubject!;
    }
    if (widget.initialTo != null && widget.initialTo!.isNotEmpty) {
      // Defer until first frame so the provider is ready
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(composeProvider.notifier).addRecipient(widget.initialTo!);
      });
    }
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _bodyController.dispose();
    _toInputController.dispose();
    _toFocusNode.dispose();
    super.dispose();
  }

  void _commitToInput() {
    final raw = _toInputController.text;
    if (raw.trim().isEmpty) return;
    ref.read(composeProvider.notifier).addRecipient(raw);
    _toInputController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final state = ref.watch(composeProvider);

    ref.listen<ComposeState>(composeProvider, (_, next) {
      if (next.sent) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Message sent'),
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 2),
          ),
        );
        if (context.canPop()) {
          context.pop();
        } else {
          context.go(AppRoutes.inbox);
        }
      }
      if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red.shade600,
          ),
        );
        ref.read(composeProvider.notifier).clearError();
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, size: 22),
          color: AppColors.textSecondary,
          onPressed: state.isSending
              ? null
              : () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go(AppRoutes.inbox);
                  }
                },
        ),
        title: Text(
          'New Message',
          style: tt.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          if (state.isSending)
            const Padding(
              padding: EdgeInsets.all(16),
              child: SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else
            Padding(
              padding: EdgeInsets.only(right: 8.w),
              child: IconButton(
                onPressed: () {
                  _commitToInput();
                  ref.read(composeProvider.notifier).send(
                        subject: _subjectController.text,
                        body: _bodyController.text,
                      );
                },
                icon: const Icon(Icons.send_rounded, size: 20),
                color: AppColors.brandNavy,
                tooltip: 'Send',
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          const AppDivider(),
          ToField(
            recipients: state.recipients,
            controller: _toInputController,
            focusNode: _toFocusNode,
            hasError: state.toError,
            onTyping: (v) {
              ref.read(composeProvider.notifier).clearToError();
              if (v.endsWith(',') || v.endsWith(' ')) _commitToInput();
            },
            onSubmit: _commitToInput,
            onRemove: ref.read(composeProvider.notifier).removeRecipient,
          ),
          const AppDivider(),
          SubjectField(
            controller: _subjectController,
            hasError: state.subjectError,
            onChanged: (_) {
              if (state.subjectError) {
                ref.read(composeProvider.notifier).send(
                      subject: _subjectController.text,
                      body: _bodyController.text,
                    );
              }
            },
          ),
          const AppDivider(),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: TextField(
                controller: _bodyController,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                style: tt.bodyMedium?.copyWith(
                  color: AppColors.textPrimary,
                  height: 1.65,
                  fontSize: 15,
                ),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(top: 14.h, bottom: 16.h),
                  hintText: state.bodyError
                      ? 'Please write a message'
                      : 'Compose email',
                  hintStyle: tt.bodyMedium?.copyWith(
                    color: state.bodyError
                        ? Colors.red.shade400
                        : AppColors.textMuted,
                    fontSize: 15,
                  ),
                  filled: false,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

