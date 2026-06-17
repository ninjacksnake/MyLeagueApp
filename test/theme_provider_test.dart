import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_league/providers/theme_provider.dart';
import 'package:my_league/theme/theme.dart';

void main() {
  group('ThemeNotifier Tests', () {
    test('default theme is dark mode', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(container.read(themeProvider), ThemeMode.dark);
      expect(AppTheme.isDarkMode, true);
    });

    test('toggleTheme switches from dark to light and back', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(themeProvider.notifier);

      // Toggle from dark to light
      notifier.toggleTheme();
      expect(container.read(themeProvider), ThemeMode.light);
      expect(AppTheme.isDarkMode, false);

      // Toggle from light to dark
      notifier.toggleTheme();
      expect(container.read(themeProvider), ThemeMode.dark);
      expect(AppTheme.isDarkMode, true);
    });

    test('setThemeMode updates state and AppTheme.isDarkMode', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(themeProvider.notifier);

      notifier.setThemeMode(ThemeMode.light);
      expect(container.read(themeProvider), ThemeMode.light);
      expect(AppTheme.isDarkMode, false);

      notifier.setThemeMode(ThemeMode.dark);
      expect(container.read(themeProvider), ThemeMode.dark);
      expect(AppTheme.isDarkMode, true);
    });
  });
}
