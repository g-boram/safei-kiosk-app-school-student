// lib/core/layout/app_shell.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:safei_kiosk_app_school_student/core/theme/theme_controller.dart';

import '../auth/auth_controller.dart';
import '../auth/auth_state.dart';
import '../dialog/global_alert_dialog.dart';
import '../dialog/global_dialog_controller.dart';
import '../router/app_routes.dart';

class AppShell extends ConsumerWidget {
  const AppShell({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    final themeState = ref.watch(themeControllerProvider);
    final isDark = themeState.isDark;

    // 로그인 성공 여부
    final isLoggedIn = authState.status == AuthStatus.authenticated;

    ref.listen(globalDialogControllerProvider, (previous, next) {
      if (next == null) return;

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return GlobalAlertDialog(
            title: next.title,
            message: next.message,
            confirmText: next.confirmText,
            onConfirm: () {
              Navigator.of(context).pop();

              ref.read(globalDialogControllerProvider.notifier).clear();

              if (next.type == GlobalDialogType.loginRequired) {
                context.go(AppPath.login);
              }
            },
          );
        },
      );
    });

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 24,
          title: Row(
            children: [Image.asset('assets/images/logo.png', height: 32)],
          ),
          actions: [
            IconButton(
              tooltip: isDark ? '라이트 모드' : '다크 모드',
              onPressed: () {
                ref.read(themeControllerProvider.notifier).toggleTheme();
              },
              icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            ),

            IconButton(
              onPressed: () {
                // TODO: 다국어 변경 연결
              },
              icon: const Icon(Icons.language),
            ),

            // 로그인 상태에 따라 상단 버튼 변경
            if (isLoggedIn)
              IconButton(
                tooltip: '프로필',
                onPressed: () {
                  context.go(AppPath.profile);
                },
                icon: const Icon(Icons.person),
              )
            else
              TextButton(
                onPressed: () {
                  context.go(AppPath.login);
                },
                child: const Text('로그인'),
              ),

            const SizedBox(width: 16),
          ],
        ),

        body: child,

        // 하단 영역은 홈만 표시
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: 0,
          onTap: (index) {
            context.go(AppPath.home);
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
            BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
            BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
          ],
        ),
      ),
    );
  }
}
