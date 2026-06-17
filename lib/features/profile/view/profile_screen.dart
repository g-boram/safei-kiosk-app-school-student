// lib/features/profile/view/profile_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/auth/auth_controller.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/typography.dart';
import '../component/profile_info_card.dart';
import '../provider/profile_icon_controller.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    final selectedIconPath = ref.watch(profileIconControllerProvider);

    final loginId = authState.email ?? authState.loginId ?? '';

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 프로필 카드 영역
          ProfileInfoCard(
            userName: authState.userNm ?? '',
            institutionName: authState.insttNm ?? '',
            loginId: loginId,
            selectedIconPath: selectedIconPath,
            onIconSelected: (iconPath) {
              ref
                  .read(profileIconControllerProvider.notifier)
                  .selectIcon(iconPath);
            },
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
              label: Text(
                '로그아웃',
                style: Typo.bodySBold.copyWith(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
