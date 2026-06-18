// lib/features/setting/component/setting_theme_tile.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/theme_controller.dart';

/// 다크/라이트 모드 변경 항목
///
/// ThemeController를 통해 앱 전역 테마를 변경합니다.
class SettingThemeTile extends ConsumerWidget {
  const SettingThemeTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeControllerProvider);
    final isDark = themeState.isDark;

    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      secondary: Icon(isDark ? Icons.dark_mode : Icons.light_mode),
      title: const Text('다크 모드'),
      subtitle: Text(isDark ? '어두운 화면으로 사용 중' : '밝은 화면으로 사용 중'),
      value: isDark,
      onChanged: (_) {
        ref.read(themeControllerProvider.notifier).toggleTheme();
      },
    );
  }
}
