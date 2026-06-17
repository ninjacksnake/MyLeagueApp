import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/locale_provider.dart';
import '../theme/theme.dart';
import '../widgets/glass_card.dart';
import 'dashboard_screen.dart';

class PasswordSetupScreen extends ConsumerStatefulWidget {
  const PasswordSetupScreen({super.key});

  @override
  ConsumerState<PasswordSetupScreen> createState() => _PasswordSetupScreenState();
}

class _PasswordSetupScreenState extends ConsumerState<PasswordSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isPasswordObscured = true;
  bool _isConfirmPasswordObscured = true;
  bool _isSaving = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _savePassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('app_deletion_password', _passwordController.text.trim());

    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const DashboardScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 600),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = AppTheme.isDarkMode;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    const Color(0xFF090D16),
                    const Color(0xFF0B1426),
                    const Color(0xFF070B12),
                  ]
                : [
                    const Color(0xFFF1F5F9),
                    const Color(0xFFE2E8F0),
                    const Color(0xFFCBD5E1),
                  ],
          ),
        ),
        child: Stack(
          children: [
            // Decorative background glowing circles
            Positioned(
              top: -100,
              right: -100,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.highlight.withOpacity(isDark ? 0.15 : 0.08),
                      blurRadius: 100,
                      spreadRadius: 50,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: -80,
              left: -80,
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.highlightAccent.withOpacity(isDark ? 0.12 : 0.06),
                      blurRadius: 80,
                      spreadRadius: 40,
                    ),
                  ],
                ),
              ),
            ),

            Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: GlassCard(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Shield Lock Icon
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppTheme.highlight.withOpacity(0.12),
                          ),
                          child: Icon(
                            Icons.admin_panel_settings,
                            size: 44,
                            color: AppTheme.highlight,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Title
                        Text(
                          ref.tr('create_password_title').toUpperCase(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Description
                        Text(
                          ref.tr('create_password_desc'),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            color: AppTheme.textSecondary,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Password Field
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _isPasswordObscured,
                          decoration: InputDecoration(
                            labelText: ref.tr('password_label'),
                            prefixIcon: Icon(Icons.lock_outline, color: AppTheme.highlight),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordObscured ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                color: AppTheme.textSecondary,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordObscured = !_isPasswordObscured;
                                });
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return ref.tr('password_empty_error');
                            }
                            if (value.length < 4) {
                              return ref.tr('password_length_error');
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),

                        // Confirm Password Field
                        TextFormField(
                          controller: _confirmPasswordController,
                          obscureText: _isConfirmPasswordObscured,
                          decoration: InputDecoration(
                            labelText: ref.tr('confirm_password_label'),
                            prefixIcon: Icon(Icons.lock_outline, color: AppTheme.highlight),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isConfirmPasswordObscured ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                color: AppTheme.textSecondary,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isConfirmPasswordObscured = !_isConfirmPasswordObscured;
                                });
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return ref.tr('password_empty_error');
                            }
                            if (value != _passwordController.text) {
                              return ref.tr('passwords_dont_match');
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 36),

                        // Submit Button
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: _isSaving ? null : _savePassword,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.highlight,
                              foregroundColor: isDark ? Colors.black : Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: _isSaving
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  )
                                : Text(
                                    ref.tr('save_and_continue').toUpperCase(),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
