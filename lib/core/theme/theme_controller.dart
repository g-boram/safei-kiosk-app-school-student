// lib/core/theme/theme_controller.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'theme_state.dart';

/// ==================================================================
///
/// 라이트 / 다크 테마 상태를 관리하는 Controller입니다.
///
/// FlutterSecureStorage에 사용자가 선택한 테마를 저장하고,
/// 앱 재실행 시 저장된 테마를 복원합니다.
///
/// 사용 예시:
/// ref.read(themeControllerProvider.notifier).toggleTheme();
/// ref.read(themeControllerProvider.notifier).setDarkTheme();
/// ref.read(themeControllerProvider.notifier).setLightTheme();
///
/// ==================================================================

final themeControllerProvider =
    StateNotifierProvider<ThemeController, ThemeState>((ref) {
      final controller = ThemeController();

      controller.initialize();

      return controller;
    });

class ThemeController extends StateNotifier<ThemeState> {
  ThemeController() : super(ThemeState.light());

  static const _storage = FlutterSecureStorage();

  static const _themeKey = 'APP_THEME_MODE';

  /// 앱 시작 시 저장된 테마 설정 복원
  Future<void> initialize() async {
    final savedTheme = await _storage.read(key: _themeKey);

    if (!mounted) return;

    if (savedTheme == 'dark') {
      state = ThemeState.dark();
      return;
    }

    state = ThemeState.light();
  }

  /// 라이트/다크 테마 전환
  Future<void> toggleTheme() async {
    if (state.isDark) {
      await setLightTheme();
    } else {
      await setDarkTheme();
    }
  }

  /// 라이트 테마 설정
  Future<void> setLightTheme() async {
    await _storage.write(key: _themeKey, value: 'light');

    if (!mounted) return;

    state = ThemeState.light();
  }

  /// 다크 테마 설정
  Future<void> setDarkTheme() async {
    await _storage.write(key: _themeKey, value: 'dark');

    if (!mounted) return;

    state = ThemeState.dark();
  }
}
