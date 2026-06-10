import 'package:flutter/material.dart';

/// 프로젝트 전체에서 사용하는 고정 텍스트 스타일 토큰
///
///  ✔️ Title
//   titleXL  // 72 / 400 / 140% / -1.5%
//   titleXLBold  // 72 / 700 / 140% / -1.5%
//   titleL  // 64 / 700 / 140% / -1.5%
//   titleM  // 52 / 700 / 140% / -1.5%
//   titleS  // 44 / 400 / 140% / -1.5%
//   titleSBold // 44 / 700 / 140% / -1.5%
//   titleXS  // 40 / 400 / 140% / -1.5%
//
//   ✔️ Body
//   bodyXL  // 26 / 400 / 140% / -1.5%
//   bodyL  // 24 / 400 / 140% / -1.5%
//   bodyLBold  // 24 / 700 / 140% / -1.5%
//   bodyM  // 20 / 400 / 140% / -1.5%
//   bodyMBold  // 20 / 700 / 140% / -1.5%
//   bodyS  // 16 / 400 / 140% / -1.5%
//   bodySBold  // 16 / 700 / 140% / -1.5%
//
//   ✔️ Label
//   labelL  // 32 / 400 / 140% / -1.5%
//   labelLBold  // 32 / 700 / 140% / -1.5%
//
//   ✔️ Detail
//   detailM // 12 / 400 / 140% / -1.5%
///
class Typo {
  // ───────────── Title ─────────────

  // Title XLarge (72)
  static const TextStyle titleXL = TextStyle(
    fontSize: 72,
    fontWeight: FontWeight.w400,
    height: 1.4,
    letterSpacing: -0.96,
  );
  static const TextStyle titleXLBold = TextStyle(
    fontSize: 72,
    fontWeight: FontWeight.w700,
    height: 1.4,
    letterSpacing: -0.96,
  );
  // Title Large (64)
  static const TextStyle titleL = TextStyle(
    fontSize: 64,
    fontWeight: FontWeight.w400,
    height: 1.4,
    letterSpacing: -0.96,
  );
  static const TextStyle titleLBold = TextStyle(
    fontSize: 64,
    fontWeight: FontWeight.w700,
    height: 1.4,
    letterSpacing: -0.96,
  );

  // Title Medium (52)
  static const TextStyle titleM = TextStyle(
    fontSize: 52,
    fontWeight: FontWeight.w400,
    height: 1.4,
    letterSpacing: -0.78,
  );
  static const TextStyle titleMBold = TextStyle(
    fontSize: 52,
    fontWeight: FontWeight.w700,
    height: 1.4,
    letterSpacing: -0.78,
  );

  // Title Small (44)
  static const TextStyle titleS = TextStyle(
    fontSize: 44,
    fontWeight: FontWeight.w400,
    height: 1.4,
    letterSpacing: -0.66,
  );
  static const TextStyle titleSBold = TextStyle(
    fontSize: 44,
    fontWeight: FontWeight.w700,
    height: 1.4,
    letterSpacing: -0.66,
  );
  // Title XSmall (40)
  static const TextStyle titleXS = TextStyle(
    fontSize: 40,
    fontWeight: FontWeight.w400,
    height: 1.4,
    letterSpacing: -0.60,
  );

  // ───────────── Body ─────────────
  // Body Large (26)
  static const TextStyle bodyXL = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.w400,
    height: 1.4,
    letterSpacing: -0.36,
  );
  // Body Large (24)
  static const TextStyle bodyL = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w400,
    height: 1.4,
    letterSpacing: -0.36,
  );
  static const TextStyle bodyLBold = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 1.4,
    letterSpacing: -0.36,
  );

  // Body Medium (20)
  static const TextStyle bodyM = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w400,
    height: 1.4,
    letterSpacing: -0.30,
  );
  static const TextStyle bodyMBold = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    height: 1.4,
    letterSpacing: -0.30,
  );

  // Body Small (16)
  static const TextStyle bodyS = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.4,
    letterSpacing: -0.24,
  );
  static const TextStyle bodySBold = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    height: 1.4,
    letterSpacing: -0.24,
  );

  // ───────────── Label ─────────────

  // Label Large (32)
  static const TextStyle labelL = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w400,
    height: 1.4,
    letterSpacing: -0.48,
  );
  static const TextStyle labelLBold = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 1.4,
    letterSpacing: -0.48,
  );

  // ───────────── Detail ─────────────

  // Detail Medium (12)
  static const TextStyle detailM = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.4,
    letterSpacing: -0.18,
  );
  static const TextStyle detailMBold = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w700,
    height: 1.4,
    letterSpacing: -0.18,
  );
}
