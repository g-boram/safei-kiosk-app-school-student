// lib/features/profile/view/profile_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/auth/auth_controller.dart';
import '../../../core/router/app_routes.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Profile Screen', style: TextStyle(fontSize: 24)),

          const SizedBox(height: 50),

          SizedBox(
            width: 320,
            child: FilledButton.icon(
              onPressed: () async {
                // 로그아웃하면 AuthStatus가 unauthenticated로 바뀜
                // 현재 위치가 /profile이면 라우터가 "로그인 필요 화면"으로 판단할 수 있음
                // 그래서 먼저 홈으로 이동시킨 뒤 로그아웃 처리
                context.go(AppPath.home);

                await ref.read(authControllerProvider.notifier).logout();
              },
              icon: const Icon(Icons.logout),
              label: const Text('로그아웃'),
            ),
          ),
        ],
      ),
    );
  }
}
