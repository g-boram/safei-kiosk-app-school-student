import 'package:flutter/material.dart';

import 'app_color_extension.dart';
import 'app_colors.dart';

/// =======================================================
///
/// 앱 전체 ThemeData를 정의하는 파일입니다.
///
/// MaterialApp.router의 theme / darkTheme에 연결됩니다.
/// 기본 위젯(AppBar, Button, Card, Input 등)의 색상도
/// AppColors 토큰을 기준으로 설정합니다.
///
/// 화면별 커스텀 UI에서는 Theme.of(context).colorScheme보다
/// context.colors.xxx 사용을 권장합니다.
///
/// =======================================================
class AppTheme {
  static ThemeData get light {
    final colors = LightAppColors();

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: 'Pretendard',

      extensions: [AppColorTheme(colors: colors)],

      scaffoldBackgroundColor: colors.bg,

      colorScheme: ColorScheme.light(
        primary: colors.primary500,
        onPrimary: colors.gray0,
        secondary: colors.primary400,
        onSecondary: colors.gray0,
        surface: colors.surface,
        onSurface: colors.textPrimary,
        error: colors.alert,
        onError: colors.gray0,
        outline: colors.border,
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: colors.surface,
        foregroundColor: colors.textPrimary,
        elevation: 0,
        centerTitle: false,
      ),

      cardTheme: CardThemeData(
        color: colors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.surface,
        hintStyle: TextStyle(color: colors.textSecondary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.primary500, width: 2),
        ),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: colors.primary500,
          foregroundColor: colors.gray0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),

      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: colors.surface,
        selectedItemColor: colors.primary500,
        unselectedItemColor: colors.gray500,
      ),
    );
  }

  static ThemeData get dark {
    final colors = DarkAppColors();

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: 'Pretendard',

      extensions: [AppColorTheme(colors: colors)],

      scaffoldBackgroundColor: colors.bg,

      colorScheme: ColorScheme.dark(
        primary: colors.primary500,
        onPrimary: colors.gray900,
        secondary: colors.primary400,
        onSecondary: colors.gray900,
        surface: colors.surface,
        onSurface: colors.textPrimary,
        error: colors.alert,
        onError: colors.gray900,
        outline: colors.border,
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: colors.surface,
        foregroundColor: colors.textPrimary,
        elevation: 0,
        centerTitle: false,
      ),

      cardTheme: CardThemeData(
        color: colors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.surface,
        hintStyle: TextStyle(color: colors.textSecondary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.primary500, width: 2),
        ),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: colors.primary500,
          foregroundColor: colors.gray900,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),

      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: colors.surface,
        selectedItemColor: colors.primary500,
        unselectedItemColor: colors.gray500,
      ),
    );
  }
}
