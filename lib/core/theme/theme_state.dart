// lib/core/theme/theme_state.dart

import 'package:flutter/material.dart';

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
