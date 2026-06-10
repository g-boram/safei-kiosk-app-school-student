import 'package:flutter/material.dart';

/// 공통 스타일 팩토리
TextStyle _ts({
  required double size,
  required FontWeight weight,
  double height = 1.4, // 140%
  double letterSpacing = -1.5,
  String family = 'Pretendard',
  Color? color,
}) {
  return TextStyle(
    fontFamily: family,
    fontSize: size,
    fontWeight: weight,
    height: height,
    letterSpacing: letterSpacing,
    color: color,
  );
}

/// 디자인 토큰(스샷 기준 최소 셋) — TextTheme 매핑 없이 ThemeExtension로만 제공
class AppTypography extends ThemeExtension<AppTypography> {
  // style: context.titleL.copyWith(color: AppColors.gray800),\

  // Title
  final TextStyle titleXXL; // 80 / 700 / 140% / -1.2%
  final TextStyle titleL; // 64 / 700 / 140% / -1.5%
  final TextStyle titleM; // 52 / 700 / 140% / -1.5%
  final TextStyle titleS; // 44 / 400 / 140% / -1.5%
  final TextStyle titleSBold; // 44 / 700 / 140% / -1.5%

  // Body (Regular/Bold 둘 다 필요)
  final TextStyle bodyL; // 24 / 400 / 140% / -1.5%
  final TextStyle bodyLBold; // 24 / 700 / 140% / -1.5%
  final TextStyle bodyM; // 20 / 400 / 140% / -1.5%
  final TextStyle bodyMBold; // 20 / 700 / 140% / -1.5%
  final TextStyle bodyS; // 16 / 400 / 140% / -1.5%
  final TextStyle bodySBold; // 16 / 700 / 140% / -1.5%

  // Label (Large, 32 / 400,700)
  final TextStyle labelXL; // 40 / 400 / 140% / -1.5%
  final TextStyle labelL; // 32 / 400 / 140% / -1.5%
  final TextStyle labelLBold; // 32 / 700 / 140% / -1.5%

  // Detail (Medium, 12 / 400)
  final TextStyle detailM; // 12 / 400 / 140% / -1.5%

  const AppTypography({
    required this.titleXXL,
    required this.titleL,
    required this.titleM,
    required this.titleS,
    required this.titleSBold,
    required this.bodyL,
    required this.bodyLBold,
    required this.bodyM,
    required this.bodyMBold,
    required this.bodyS,
    required this.bodySBold,
    required this.labelXL,
    required this.labelL,
    required this.labelLBold,
    required this.detailM,
  });

  /// 기본(light) 팩토리
  factory AppTypography.basic({String family = 'Pretendard', Color? color}) {
    return AppTypography(
      // Title
      titleXXL: _ts(
        size: 80,
        weight: FontWeight.w700,
        family: family,
        color: color,
        letterSpacing: 1.2,
      ),
      titleL: _ts(
        size: 64,
        weight: FontWeight.w700,
        family: family,
        color: color,
      ),
      titleM: _ts(
        size: 52,
        weight: FontWeight.w700,
        family: family,
        color: color,
      ),
      titleS: _ts(
        size: 44,
        weight: FontWeight.w400,
        family: family,
        color: color,
      ),
      titleSBold: _ts(
        size: 44,
        weight: FontWeight.w700,
        family: family,
        color: color,
      ),

      // Body
      bodyL: _ts(
        size: 24,
        weight: FontWeight.w400,
        family: family,
        color: color,
      ),
      bodyLBold: _ts(
        size: 24,
        weight: FontWeight.w700,
        family: family,
        color: color,
      ),
      bodyM: _ts(
        size: 20,
        weight: FontWeight.w400,
        family: family,
        color: color,
      ),
      bodyMBold: _ts(
        size: 20,
        weight: FontWeight.w700,
        family: family,
        color: color,
      ),
      bodyS: _ts(
        size: 16,
        weight: FontWeight.w400,
        family: family,
        color: color,
      ),
      bodySBold: _ts(
        size: 16,
        weight: FontWeight.w700,
        family: family,
        color: color,
      ),

      // Label
      labelXL: _ts(
        size: 40,
        weight: FontWeight.w400,
        family: family,
        color: color,
      ),
      labelL: _ts(
        size: 32,
        weight: FontWeight.w400,
        family: family,
        color: color,
      ),
      labelLBold: _ts(
        size: 32,
        weight: FontWeight.w700,
        family: family,
        color: color,
      ),

      // Detail
      detailM: _ts(
        size: 12,
        weight: FontWeight.w400,
        family: family,
        color: color,
      ),
    );
  }

  @override
  AppTypography copyWith({
    TextStyle? titleXXL,
    TextStyle? titleL,
    TextStyle? titleM,
    TextStyle? titleS,
    TextStyle? titleSBold,
    TextStyle? bodyL,
    TextStyle? bodyLBold,
    TextStyle? bodyM,
    TextStyle? bodyMBold,
    TextStyle? bodyS,
    TextStyle? bodySBold,
    TextStyle? labelL,
    TextStyle? labelLBold,
    TextStyle? detailM,
  }) {
    return AppTypography(
      titleXXL: titleXXL ?? this.titleXXL,
      titleL: titleL ?? this.titleL,
      titleM: titleM ?? this.titleM,
      titleS: titleS ?? this.titleS,
      titleSBold: titleS ?? this.titleSBold,
      bodyL: bodyL ?? this.bodyL,
      bodyLBold: bodyLBold ?? this.bodyLBold,
      bodyM: bodyM ?? this.bodyM,
      bodyMBold: bodyMBold ?? this.bodyMBold,
      bodyS: bodyS ?? this.bodyS,
      bodySBold: bodySBold ?? this.bodySBold,
      labelXL: labelL ?? this.labelXL,
      labelL: labelL ?? this.labelL,
      labelLBold: labelLBold ?? this.labelLBold,
      detailM: detailM ?? this.detailM,
    );
  }

  @override
  ThemeExtension<AppTypography> lerp(
    ThemeExtension<AppTypography>? other,
    double t,
  ) => this;
}

/// BuildContext 헬퍼
extension AppTypographyX on BuildContext {
  AppTypography get typo => Theme.of(this).extension<AppTypography>()!;
}
