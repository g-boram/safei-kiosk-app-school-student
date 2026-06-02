import 'package:flutter/material.dart';

/// 디자인 시스템 공통 색상 팔레트
/// (필요하면 숫자/헥사 수정해서 쓰세요)
class AppColors {
  // ── Primary (Brand) ────────────────────────────────────────────────
  static const primary0 = Color(0xFFF8F9FB);
  static const primary100 = Color(0xFFEEF3FF);
  static const primary200 = Color(0xFFD8E4FF);
  static const primary300 = Color(0xFFABC0FA);
  static const primary400 = Color(0xFF6F85F4);
  static const primary500 = Color(0xFF4C4CD6); // 메인 브랜드
  static const primary600 = Color(0xFF3535B9);
  static const primary700 = Color(0xFF2525A5);
  static const primary800 = Color(0xFF000080);
  static const primary900 = Color(0xFF01015C);

  /// MaterialColor (필요시 primarySwatch 등에 사용)
  static const MaterialColor primarySwatch = MaterialColor(
    0xFF4C4CD6,
    <int, Color>{
      50: primary0,
      100: primary100,
      200: primary200,
      300: primary300,
      400: primary400,
      500: primary500,
      600: primary600,
      700: primary700,
      800: primary800,
      900: primary900,
    },
  );

  // ── Grayscale ─────────────────────────────────────────────────────
  static const gray0 = Color(0xFFFFFFFF);
  static const gray100 = Color(0xFFF5F5F5);
  static const gray200 = Color(0xFFEAEAEA);
  static const gray300 = Color(0xFFD2D2D2);
  static const gray400 = Color(0xFFBBBBBB);
  static const gray500 = Color(0xFF999999);
  static const gray600 = Color(0xFF666666);
  static const gray700 = Color(0xFF484848);
  static const gray800 = Color(0xFF333333);
  static const gray900 = Color(0xFF000000);

  // ── System ────────────────────────────────────────────────────────
  static const alert = Color(0xFFFF547F);

  // ── Semantic colors: 화면/컴포넌트용 커스텀 색상 ────────────────────────

  // 홈 배경에 쓰고 싶은 톤을 명시적으로 고정
  static const homeBgTop = Color(0xFFD8E4FF);
  static const homeBgBottom = Color(0xFFF5F5F5);

  // ── Gradients (전역 재사용용) ──────────────────────────────

  // 홈 배경 (위→아래)
  static const LinearGradient homeBgGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: <Color>[homeBgTop, homeBgBottom],
  );

  // 편의 alias
  static const bg = gray0;
  static const textPrimary = Color(0xFF333333);
  static const textSecondary = Color(0xFF666666);

  // ── ColorScheme (라이트 테마) ──────────────────────────────────────
  static ColorScheme lightScheme() {
    // seed 기반으로 머티리얼 톤 생성 후 회색/알림 일부 보정
    final base = ColorScheme.fromSeed(
      seedColor: primary500,
      brightness: Brightness.light,
    );
    return base.copyWith(
      primary: primary500,
      onPrimary: gray0,
      surface: gray0,
      onSurface: textPrimary,
      secondary: primary400,
      onSecondary: gray0,
      background: gray0,
      onBackground: textPrimary,
      error: alert,
      onError: gray0,
      outline: gray300,
      surfaceContainerHighest: gray100, // 카드 배경 등에 사용해도 좋아요
    );
  }
}

/// BuildContext에서 간단히 접근하고 싶으면 이 확장도 함께 사용하세요.
extension AppColorX on BuildContext {
  ColorScheme get colors => Theme.of(this).colorScheme;
}
