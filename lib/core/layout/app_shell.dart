// lib/core/layout/app_shell.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 24,
        title: Row(
          children: [Image.asset('assets/images/logo.png', height: 32)],
        ),
        actions: [
          IconButton(
            onPressed: () {
              // TODO: 테마 변경 연결
            },
            icon: const Icon(Icons.dark_mode),
          ),
          IconButton(
            onPressed: () {
              // TODO: 다국어 변경 연결
            },
            icon: const Icon(Icons.language),
          ),
          TextButton(
            onPressed: () async {
              if (isLoggedIn) {
                await ref.read(authControllerProvider.notifier).logout();

                if (context.mounted) {
                  context.go(AppPath.home);
                }

                return;
              }

              context.go(AppPath.login);
            },
            child: Text(isLoggedIn ? '로그아웃' : '로그인'),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _getCurrentIndex(context),
        onTap: (index) {
          switch (index) {
            case 0:
              context.go(AppPath.home);
              break;
            case 1:
              context.go(AppPath.login);
              break;
            case 2:
              context.go(AppPath.profile);
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.login), label: '로그인'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: '프로필'),
        ],
      ),
    );
  }

  int _getCurrentIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;

    if (location == AppPath.login) {
      return 1;
    }

    if (location == AppPath.profile) {
      return 2;
    }

    return 0;
  }
}
