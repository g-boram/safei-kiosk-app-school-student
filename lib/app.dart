import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/auth/auth_controller.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ✔️ 앱 시작 시 로그인 상태 초기화/복원
    ref.watch(authControllerProvider);
    // ✔️ 라우팅
    final router = ref.watch(appRouterProvider);
    // ✔️ 테마 설정
    final themeState = ref.watch(themeControllerProvider);

    return MaterialApp.router(
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeState.themeMode,
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
