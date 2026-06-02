// lib/core/layout/app_shell.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../router/app_routes.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 전역 상단 앱바
      appBar: AppBar(
        titleSpacing: 24,
        title: Row(
          children: [
            // 왼쪽 로고 영역
            Image.asset('assets/images/logo.png', height: 32),
            const SizedBox(width: 12),
            const Text('SAFE-i'),
          ],
        ),
        actions: [
          // 테마 버튼 예시
          IconButton(
            onPressed: () {
              // TODO: 테마 변경 연결
            },
            icon: const Icon(Icons.dark_mode),
          ),

          // 다국어 버튼 예시
          IconButton(
            onPressed: () {
              // TODO: 다국어 변경 연결
            },
            icon: const Icon(Icons.language),
          ),

          // 로그인 화면 이동 버튼
          TextButton(
            onPressed: () {
              context.go(AppPath.login);
            },
            child: const Text('로그인'),
          ),

          const SizedBox(width: 16),
        ],
      ),

      // 실제 페이지 화면
      body: child,

      // 전역 하단 네비게이션
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _getCurrentIndex(context),
        onTap: (index) {
          if (index == 0) {
            context.go(AppPath.home);
          }

          if (index == 1) {
            context.go(AppPath.login);
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.login), label: '로그인'),
        ],
      ),
    );
  }

  int _getCurrentIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;

    if (location == AppPath.login) {
      return 1;
    }

    return 0;
  }
}
