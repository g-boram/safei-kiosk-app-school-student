import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../storage/local_storage.dart';
import '../storage/storage_provider.dart';
import 'theme_state.dart';

final themeControllerProvider =
    StateNotifierProvider<ThemeController, ThemeState>((ref) {
      final localStorage = ref.watch(localStorageProvider);
      final controller = ThemeController(localStorage);

      controller.initialize();

      return controller;
    });

class ThemeController extends StateNotifier<ThemeState> {
  final LocalStorage _localStorage;

  ThemeController(this._localStorage) : super(ThemeState.light());

  Future<void> initialize() async {
    final savedTheme = await _localStorage.readThemeMode();

    if (!mounted) return;

    if (savedTheme == 'dark') {
      state = ThemeState.dark();
      return;
    }

    state = ThemeState.light();
  }

  Future<void> toggleTheme() async {
    if (state.isDark) {
      await setLightTheme();
    } else {
      await setDarkTheme();
    }
  }

  Future<void> setLightTheme() async {
    await _localStorage.writeThemeMode('light');

    if (!mounted) return;

    state = ThemeState.light();
  }

  Future<void> setDarkTheme() async {
    await _localStorage.writeThemeMode('dark');

    if (!mounted) return;

    state = ThemeState.dark();
  }
}
