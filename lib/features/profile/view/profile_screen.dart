import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../common/dialog/common_dim_dialog.dart';
import '../../../core/auth/auth_controller.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_color_extension.dart';
import '../../../core/theme/typography.dart';
import '../component/profile_icon_picker_dialog.dart';
import '../component/profile_qr_dialog.dart';
import '../provider/profile_icon_controller.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  String? _initializedLoginId;

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final selectedIconPath = ref.watch(profileIconControllerProvider);

    final loginId = authState.email ?? authState.loginId ?? '';

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: context.colors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: context.colors.border),
            ),
            child: Row(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 88,
                      height: 88,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: context.colors.primary100,
                        shape: BoxShape.circle,
                      ),
                      child: selectedIconPath == null
                          ? Icon(
                              Icons.person,
                              size: 52,
                              color: context.colors.primary500,
                            )
                          : SvgPicture.asset(
                              selectedIconPath,
                              fit: BoxFit.contain,
                            ),
                    ),

                    Positioned(
                      right: -2,
                      bottom: -2,
                      child: InkWell(
                        onTap: () {
                          CommonDimDialog.show(
                            context: context,
                            width: 420,
                            child: ProfileIconPickerDialog(
                              selectedIconPath: selectedIconPath,
                              onSelected: (iconPath) {
                                ref
                                    .read(
                                      profileIconControllerProvider.notifier,
                                    )
                                    .selectIcon(iconPath);
                              },
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(999),
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: context.colors.primary500,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: context.colors.surface,
                              width: 2,
                            ),
                          ),
                          child: Icon(
                            Icons.edit,
                            size: 16,
                            color: context.colors.gray0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(width: 20),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        authState.userNm ?? '',
                        style: Typo.bodyLBold.copyWith(
                          color: context.colors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        authState.insttNm ?? '',
                        style: Typo.bodyS.copyWith(
                          color: context.colors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        loginId,
                        style: Typo.bodyS.copyWith(
                          color: context.colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 16),

                InkWell(
                  onTap: loginId.isEmpty
                      ? null
                      : () {
                          CommonDimDialog.show(
                            context: context,
                            width: 420,
                            child: ProfileQrDialog(loginId: loginId),
                          );
                        },
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: context.colors.primary100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.qr_code_2,
                      size: 36,
                      color: context.colors.primary500,
                    ),
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
