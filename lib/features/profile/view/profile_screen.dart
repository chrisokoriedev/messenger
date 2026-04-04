import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/shared/theme/app_colors.dart';
import '../../auth/domain/user.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const user = User.mock;
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            backgroundColor: AppColors.scaffoldBackground,
            surfaceTintColor: AppColors.transparent,
            title: Text(
              'Profile',
              style: tt.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                children: [
                  48.verticalSpace,
                  CircleAvatar(
                    radius: 44,
                    backgroundColor: AppColors.brandNavy,
                    child: Text(
                      user.name.isNotEmpty
                          ? user.name[0].toUpperCase()
                          : '?',
                      style: tt.headlineMedium?.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  20.verticalSpace,
                  Text(
                    user.name,
                    style: tt.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  6.verticalSpace,
                  Text(
                    user.email,
                    style:
                        tt.bodyMedium?.copyWith(color: AppColors.textSecondary),
                  ),
                  36.verticalSpace,
                  _ProfileTile(
                    icon: Icons.notifications_outlined,
                    label: 'Notifications',
                    onTap: () {},
                  ),
                  _ProfileTile(
                    icon: Icons.lock_outline_rounded,
                    label: 'Privacy & Security',
                    onTap: () {},
                  ),
                  _ProfileTile(
                    icon: Icons.help_outline_rounded,
                    label: 'Help & Support',
                    onTap: () {},
                  ),
                  8.verticalSpace,
                  _ProfileTile(
                    icon: Icons.logout_rounded,
                    label: 'Sign out',
                    onTap: () {},
                    isDestructive: true,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  const _ProfileTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDestructive = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final color =
        isDestructive ? Colors.red.shade600 : AppColors.textPrimary;

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(
          bottom: BorderSide(color: AppColors.borderLight, width: 0.5),
        ),
      ),
      child: ListTile(
        leading: Icon(icon, color: color, size: 22),
        title: Text(label, style: tt.bodyMedium?.copyWith(color: color)),
        trailing: isDestructive
            ? null
            : Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
        onTap: onTap,
      ),
    );
  }
}
