import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/router/app_router.dart';
import 'core/shared/theme/app_theme.dart';

class MessengerApp extends ConsumerWidget {
  const MessengerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, _) {
        return MaterialApp.router(
          title: 'Messenger',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          routerConfig: router,
        );
      },
    );
  }
}
