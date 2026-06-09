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
    final authState = ref.watch(authControllerProvider);

    // 현재 앱에 적용된 테마 정보
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: theme.dividerColor),
            ),
            child: Row(
              children: [
                Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.person,
                    size: 52,
                    color: theme.colorScheme.primary,
                  ),
                ),

                const SizedBox(width: 20),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        authState.userNm ?? '',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        authState.insttNm ?? '',
                        style: TextStyle(
                          fontSize: 16,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        authState.email ?? authState.loginId ?? '',
                        style: TextStyle(
                          fontSize: 14,
                          color: theme.colorScheme.onSurface.withOpacity(0.75),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          SizedBox(
            height: 48,
            child: FilledButton.icon(
              onPressed: () async {
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
