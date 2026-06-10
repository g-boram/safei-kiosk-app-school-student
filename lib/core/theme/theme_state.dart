// lib/core/theme/theme_state.dart

import 'package:flutter/material.dart';

/// ======================================================
///
/// 현재 앱의 ThemeMode 상태를 표현하는 State입니다.
///
/// ThemeMode.light 또는 ThemeMode.dark 값을 가집니다.
/// MaterialApp.router의 themeMode에 연결됩니다.
///
/// ======================================================

class ThemeState {
  final ThemeMode themeMode;

  const ThemeState({required this.themeMode});

  factory ThemeState.light() {
    return const ThemeState(themeMode: ThemeMode.light);
  }

  factory ThemeState.dark() {
    return const ThemeState(themeMode: ThemeMode.dark);
  }

  bool get isDark => themeMode == ThemeMode.dark;
}
