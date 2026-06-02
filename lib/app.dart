import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'common/theme/app_colors.dart';
import 'common/theme/app_typography.dart';
import 'core/auth/auth_controller.dart';
import 'core/router/app_router.dart';

final lightTheme = ThemeData(
  useMaterial3: true,
  colorScheme: AppColors.lightScheme(),
  fontFamily: 'Pretendard',
  extensions: [AppTypography.basic(color: AppColors.gray700)],
);

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ✔️ 앱 시작 시 로그인 상태 초기화/복원
    ref.watch(authControllerProvider);
    // ✔️ 라우팅
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      theme: lightTheme,
      debugShowCheckedModeBanner: false,
      routerConfig: router,

      // ✔️ 다국어
      locale: context.locale,
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,

      builder: (context, child) {
        return child ?? const SizedBox.shrink();
      },
    );
  }
}
