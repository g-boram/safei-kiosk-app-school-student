import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/theme/app_color_extension.dart';
import '../../../core/theme/typography.dart';
import '../model/profile_icon_assets.dart';

class ProfileIconPickerDialog extends StatelessWidget {
  final String? selectedIconPath;
  final ValueChanged<String> onSelected;

  const ProfileIconPickerDialog({
    super.key,
    required this.selectedIconPath,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(Icons.close, color: context.colors.textPrimary),
          ),
        ),

        Text(
          '프로필 아이콘 선택',
          style: Typo.bodyLBold.copyWith(color: context.colors.textPrimary),
        ),

        const SizedBox(height: 8),

        Text(
          '사용할 프로필 아이콘을 선택해주세요.',
          style: Typo.bodyS.copyWith(color: context.colors.textSecondary),
        ),

        const SizedBox(height: 24),

        GridView.builder(
          shrinkWrap: true,
          itemCount: ProfileIconAssets.icons.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
          ),
          itemBuilder: (context, index) {
            final iconPath = ProfileIconAssets.icons[index];
            final isSelected = selectedIconPath == iconPath;

            return InkWell(
              onTap: () {
                onSelected(iconPath);
                Navigator.of(context).pop();
              },
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? context.colors.primary100
                      : context.colors.gray100,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? context.colors.primary500
                        : context.colors.border,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: SvgPicture.asset(iconPath),
              ),
            );
          },
        ),

        const SizedBox(height: 30),
      ],
    );
  }
}
