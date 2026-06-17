import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/theme.dart';

class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.dark) {
    AppTheme.isDarkMode = true;
  }

  void toggleTheme() {
    if (state == ThemeMode.dark) {
      state = ThemeMode.light;
      AppTheme.isDarkMode = false;
    } else {
      state = ThemeMode.dark;
      AppTheme.isDarkMode = true;
    }
  }

  void setThemeMode(ThemeMode mode) {
    state = mode;
    AppTheme.isDarkMode = mode == ThemeMode.dark;
  }
}

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  return ThemeNotifier();
});
