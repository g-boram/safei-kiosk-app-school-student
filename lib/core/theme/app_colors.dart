import 'package:flutter/material.dart';

/// ====================================================================================
///
/// 피그마 색상표와 1:1로 맞춘 컬러 토큰 파일입니다.
///
/// 화면에서는 AppColors를 직접 사용하지 않고,
/// 반드시 context.colors.primary500 형태로 사용합니다.
///
/// 예시:
/// Container(color: context.colors.primary100)
/// Text('제목', style: Typo.bodyMBold.copyWith(color: context.colors.textPrimary))
///
/// ====================================================================================
abstract class AppColors {
  // Primary
  Color get primary0;
  Color get primary100;
  Color get primary200;
  Color get primary300;
  Color get primary400;
  Color get primary500;
  Color get primary600;
  Color get primary700;
  Color get primary800;
  Color get primary900;

  // Gray
  Color get gray0;
  Color get gray100;
  Color get gray200;
  Color get gray300;
  Color get gray400;
  Color get gray500;
  Color get gray600;
  Color get gray700;
  Color get gray800;
  Color get gray900;

  // System
  Color get alert;

  // Semantic
  Color get bg;
  Color get surface;
  Color get textPrimary;
  Color get textSecondary;
  Color get border;

  Color get homeBgTop;
  Color get homeBgBottom;

  LinearGradient get homeBgGradient;
}

class LightAppColors extends AppColors {
  @override
  Color get primary0 => const Color(0xFFF8F9FB);
  @override
  Color get primary100 => const Color(0xFFEEF3FF);
  @override
  Color get primary200 => const Color(0xFFD8E4FF);
  @override
  Color get primary300 => const Color(0xFFABC0FA);
  @override
  Color get primary400 => const Color(0xFF6F85F4);
  @override
  Color get primary500 => const Color(0xFF4C4CD6);
  @override
  Color get primary600 => const Color(0xFF3535B9);
  @override
  Color get primary700 => const Color(0xFF2525A5);
  @override
  Color get primary800 => const Color(0xFF000080);
  @override
  Color get primary900 => const Color(0xFF01015C);

  @override
  Color get gray0 => const Color(0xFFFFFFFF);
  @override
  Color get gray100 => const Color(0xFFF5F5F5);
  @override
  Color get gray200 => const Color(0xFFEAEAEA);
  @override
  Color get gray300 => const Color(0xFFD2D2D2);
  @override
  Color get gray400 => const Color(0xFFBBBBBB);
  @override
  Color get gray500 => const Color(0xFF999999);
  @override
  Color get gray600 => const Color(0xFF666666);
  @override
  Color get gray700 => const Color(0xFF484848);
  @override
  Color get gray800 => const Color(0xFF333333);
  @override
  Color get gray900 => const Color(0xFF000000);

  @override
  Color get alert => const Color(0xFFFF547F);

  @override
  Color get bg => gray0;
  @override
  Color get surface => gray0;
  @override
  Color get textPrimary => gray800;
  @override
  Color get textSecondary => gray600;
  @override
  Color get border => gray300;

  @override
  Color get homeBgTop => primary200;
  @override
  Color get homeBgBottom => gray100;

  @override
  LinearGradient get homeBgGradient => LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [homeBgTop, homeBgBottom],
  );
}

class DarkAppColors extends AppColors {
  @override
  Color get primary0 => const Color(0xFF151624);
  @override
  Color get primary100 => const Color(0xFF20223A);
  @override
  Color get primary200 => const Color(0xFF2B2E52);
  @override
  Color get primary300 => const Color(0xFF3D4480);
  @override
  Color get primary400 => const Color(0xFF6F85F4);
  @override
  Color get primary500 => const Color(0xFF7C80FF);
  @override
  Color get primary600 => const Color(0xFF9EA2FF);
  @override
  Color get primary700 => const Color(0xFFBFC2FF);
  @override
  Color get primary800 => const Color(0xFFDADCAFF);
  @override
  Color get primary900 => const Color(0xFFF0F1FF);

  @override
  Color get gray0 => const Color(0xFF121212);
  @override
  Color get gray100 => const Color(0xFF1E1E1E);
  @override
  Color get gray200 => const Color(0xFF2A2A2A);
  @override
  Color get gray300 => const Color(0xFF3A3A3A);
  @override
  Color get gray400 => const Color(0xFF555555);
  @override
  Color get gray500 => const Color(0xFF777777);
  @override
  Color get gray600 => const Color(0xFF999999);
  @override
  Color get gray700 => const Color(0xFFBBBBBB);
  @override
  Color get gray800 => const Color(0xFFEAEAEA);
  @override
  Color get gray900 => const Color(0xFFFFFFFF);

  @override
  Color get alert => const Color(0xFFFF6B8F);

  @override
  Color get bg => gray0;
  @override
  Color get surface => gray100;
  @override
  Color get textPrimary => gray900;
  @override
  Color get textSecondary => gray700;
  @override
  Color get border => gray300;

  @override
  Color get homeBgTop => const Color(0xFF181A2A);
  @override
  Color get homeBgBottom => gray0;

  @override
  LinearGradient get homeBgGradient => LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [homeBgTop, homeBgBottom],
  );
}
