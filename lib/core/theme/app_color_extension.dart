import 'package:flutter/material.dart';

import 'app_colors.dart';

/// ===============================================================
///
/// 현재 ThemeMode에 맞는 AppColors를 꺼내 쓰기 위한 확장 파일입니다.
///
/// Light Mode일 때는 LightAppColors,
/// Dark Mode일 때는 DarkAppColors가 자동으로 적용됩니다.
///
/// 예시:
/// context.colors.primary500
/// context.colors.gray200
/// context.colors.textPrimary
///
/// ===============================================================

@immutable
class AppColorTheme extends ThemeExtension<AppColorTheme> {
  final AppColors colors;

  const AppColorTheme({required this.colors});

  @override
  AppColorTheme copyWith({AppColors? colors}) {
    return AppColorTheme(colors: colors ?? this.colors);
  }

  @override
  AppColorTheme lerp(covariant ThemeExtension<AppColorTheme>? other, double t) {
    return this;
  }
}

extension AppColorX on BuildContext {
  AppColors get colors {
    return Theme.of(this).extension<AppColorTheme>()!.colors;
  }
}
