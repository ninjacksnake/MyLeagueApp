import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/locale_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/league_provider.dart';
import '../theme/theme.dart';
import '../widgets/glass_card.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLanguage = ref.watch(localeProvider);
    final currentThemeMode = ref.watch(themeProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(ref.tr('settings').toUpperCase()),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                ref.tr('settings'),
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontSize: 28,
                    ),
              ),
              const SizedBox(height: 24),

              // Language Card
              GlassCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.language,
                          color: AppTheme.highlight,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          ref.tr('language'),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const Divider(color: Color(0xFF222F47), height: 32),
                    _buildLanguageOption(
                      context,
                      ref,
                      language: AppLanguage.en,
                      title: ref.tr('english'),
                      isSelected: currentLanguage == AppLanguage.en,
                      flag: '🇺🇸',
                    ),
                    const SizedBox(height: 12),
                    _buildLanguageOption(
                      context,
                      ref,
                      language: AppLanguage.es,
                      title: ref.tr('spanish'),
                      isSelected: currentLanguage == AppLanguage.es,
                      flag: '🇪🇸',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Theme Selector Card
              GlassCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          currentThemeMode == ThemeMode.dark
                              ? Icons.dark_mode_outlined
                              : Icons.light_mode_outlined,
                          color: AppTheme.highlight,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          ref.tr('theme'),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const Divider(color: Color(0xFF222F47), height: 32),
                    _buildThemeOption(
                      context,
                      ref,
                      mode: ThemeMode.light,
                      title: ref.tr('light_mode'),
                      isSelected: currentThemeMode == ThemeMode.light,
                      icon: Icons.light_mode,
                    ),
                    const SizedBox(height: 12),
                    _buildThemeOption(
                      context,
                      ref,
                      mode: ThemeMode.dark,
                      title: ref.tr('dark_mode'),
                      isSelected: currentThemeMode == ThemeMode.dark,
                      icon: Icons.dark_mode,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Danger Zone Card
              GlassCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.warning_amber_rounded,
                          color: AppTheme.statusRed,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          ref.tr('danger_zone'),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.statusRed,
                          ),
                        ),
                      ],
                    ),
                    const Divider(color: Color(0xFF222F47), height: 32),
                    Text(
                      ref.tr('delete_all_data_confirm_desc'),
                      style: TextStyle(
                        fontSize: 13,
                        color: AppTheme.textSecondary,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => const _DeleteDataDialog(),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.statusRed.withOpacity(0.15),
                          foregroundColor: AppTheme.statusRed,
                          elevation: 0,
                          side: BorderSide(color: AppTheme.statusRed.withOpacity(0.5)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          ref.tr('delete_all_data').toUpperCase(),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThemeOption(
    BuildContext context,
    WidgetRef ref, {
    required ThemeMode mode,
    required String title,
    required bool isSelected,
    required IconData icon,
  }) {
    return GestureDetector(
      onTap: () {
        ref.read(themeProvider.notifier).setThemeMode(mode);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppTheme.highlight.withOpacity(0.6)
                : (AppTheme.isDarkMode
                    ? const Color(0xFF222F47)
                    : const Color(0xFFCBD5E1)),
            width: 1,
          ),
          color: isSelected ? AppTheme.highlight.withOpacity(0.12) : Colors.transparent,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? AppTheme.highlight : AppTheme.textSecondary,
              size: 20,
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? AppTheme.textPrimary : AppTheme.textSecondary,
              ),
            ),
            const Spacer(),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: AppTheme.highlight,
                size: 22,
              )
            else
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppTheme.isDarkMode
                        ? const Color(0xFF222F47)
                        : const Color(0xFFCBD5E1),
                    width: 1.5,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption(
    BuildContext context,
    WidgetRef ref, {
    required AppLanguage language,
    required String title,
    required bool isSelected,
    required String flag,
  }) {
    return GestureDetector(
      onTap: () {
        ref.read(localeProvider.notifier).setLanguage(language);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppTheme.highlight.withOpacity(0.6)
                : (AppTheme.isDarkMode
                    ? const Color(0xFF222F47)
                    : const Color(0xFFCBD5E1)),
            width: 1,
          ),
          color: isSelected ? AppTheme.highlight.withOpacity(0.12) : Colors.transparent,
        ),
        child: Row(
          children: [
            Text(
              flag,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? AppTheme.textPrimary : AppTheme.textSecondary,
              ),
            ),
            const Spacer(),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: AppTheme.highlight,
                size: 22,
              )
            else
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppTheme.isDarkMode
                        ? const Color(0xFF222F47)
                        : const Color(0xFFCBD5E1),
                    width: 1.5,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _DeleteDataDialog extends ConsumerStatefulWidget {
  const _DeleteDataDialog();

  @override
  ConsumerState<_DeleteDataDialog> createState() => _DeleteDataDialogState();
}

class _DeleteDataDialogState extends ConsumerState<_DeleteDataDialog> {
  final _passwordController = TextEditingController();
  bool _obscureText = true;
  String? _errorText;
  bool _isWiping = false;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _attemptWipe() async {
    final input = _passwordController.text;
    if (input.isEmpty) {
      setState(() {
        _errorText = ref.tr('password_empty_error');
      });
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final savedPassword = prefs.getString('app_deletion_password') ?? '';

    if (input != savedPassword) {
      setState(() {
        _errorText = ref.tr('incorrect_password');
      });
      return;
    }

    setState(() {
      _errorText = null;
      _isWiping = true;
    });

    // Clear DB
    ref.read(leaguesProvider.notifier).clearAllData();
    // Clear SharedPreferences
    await prefs.clear();

    // 1.5 seconds delay for premium wipe overlay feel
    await Future.delayed(const Duration(milliseconds: 1500));

    // Terminate application
    exit(0);
  }

  @override
  Widget build(BuildContext context) {
    if (_isWiping) {
      return PopScope(
        canPop: false,
        child: AlertDialog(
          backgroundColor: AppTheme.surface,
          content: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppTheme.statusRed),
                ),
                const SizedBox(height: 24),
                Text(
                  ref.tr('deleting_data'),
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return AlertDialog(
      backgroundColor: AppTheme.surface,
      title: Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: AppTheme.statusRed),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              ref.tr('delete_all_data_confirm_title'),
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              ref.tr('delete_all_data_confirm_desc'),
              style: TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 14,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _passwordController,
              obscureText: _obscureText,
              decoration: InputDecoration(
                labelText: ref.tr('password_label'),
                errorText: _errorText,
                prefixIcon: Icon(Icons.lock_outline, color: AppTheme.statusRed),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                    color: AppTheme.textSecondary,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            ref.tr('cancel'),
            style: TextStyle(color: AppTheme.textSecondary),
          ),
        ),
        ElevatedButton(
          onPressed: _attemptWipe,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.statusRed,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            ref.tr('delete'),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
