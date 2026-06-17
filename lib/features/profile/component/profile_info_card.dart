// lib/features/profile/component/profile_info_card.dart

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../common/dialog/common_dim_dialog.dart';
import '../../../core/theme/app_color_extension.dart';
import '../../../core/theme/typography.dart';
import 'profile_icon_picker_dialog.dart';
import 'profile_qr_dialog.dart';

class ProfileInfoCard extends StatelessWidget {
  const ProfileInfoCard({
    super.key,
    required this.userName,
    required this.institutionName,
    required this.loginId,
    required this.selectedIconPath,
    required this.onIconSelected,
  });

  final String userName;
  final String institutionName;
  final String loginId;
  final String? selectedIconPath;
  final ValueChanged<String> onIconSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
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
                    : SvgPicture.asset(selectedIconPath!, fit: BoxFit.contain),
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
                        onSelected: onIconSelected,
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
                  userName,
                  style: Typo.bodyLBold.copyWith(
                    color: context.colors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  institutionName,
                  style: Typo.bodyS.copyWith(color: context.colors.textPrimary),
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
    );
  }
}
