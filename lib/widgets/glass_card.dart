import 'package:flutter/material.dart';
import '../theme/theme.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final double? width;
  final double? height;
  final List<Color>? gradientColors;
  final Color? borderColor;
  final VoidCallback? onTap;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius,
    this.width,
    this.height,
    this.gradientColors,
    this.borderColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveRadius = borderRadius ?? BorderRadius.circular(16);
    final border = Border.all(
      color: borderColor ??
          (AppTheme.isDarkMode
              ? const Color(0xFF222F47).withOpacity(0.5)
              : const Color(0xFFCBD5E1).withOpacity(0.5)),
      width: 1,
    );

    final widget = Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: effectiveRadius,
        border: border,
        gradient: LinearGradient(
          colors: gradientColors ??
              [
                AppTheme.surface.withOpacity(0.8),
                AppTheme.isDarkMode
                    ? const Color(0xFF0F141C).withOpacity(0.9)
                    : const Color(0xFFE2E8F0).withOpacity(0.9),
              ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: effectiveRadius,
        child: Padding(
          padding: padding ?? const EdgeInsets.all(16.0),
          child: child,
        ),
      ),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: effectiveRadius,
        child: widget,
      );
    }

    return widget;
  }
}
