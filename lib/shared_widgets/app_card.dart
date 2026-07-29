import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_radius.dart';
import '../core/theme/app_shadows.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final Gradient? gradient;
  final Border? border;
  final VoidCallback? onTap;
  final double? width;
  final double? height;
  final double borderRadius;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.backgroundColor,
    this.gradient,
    this.border,
    this.onTap,
    this.width,
    this.height,
    this.borderRadius = AppRadius.lg,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final cardBorder = border ??
        Border.all(
          color: isDark ? colors.border.withValues(alpha: 0.6) : colors.border,
          width: 1.0,
        );

    final cardDecoration = BoxDecoration(
      color: gradient == null ? (backgroundColor ?? colors.cardBackground) : null,
      gradient: gradient,
      borderRadius: BorderRadius.circular(borderRadius),
      border: cardBorder,
      boxShadow: AppShadows.cardShadow(context),
    );

    if (onTap != null) {
      return Container(
        width: width,
        height: height,
        decoration: cardDecoration,
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(borderRadius),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(borderRadius),
            splashColor: colors.primary.withValues(alpha: 0.08),
            highlightColor: colors.primary.withValues(alpha: 0.04),
            child: Padding(
              padding: padding ?? const EdgeInsets.all(16),
              child: child,
            ),
          ),
        ),
      );
    }

    return Container(
      width: width,
      height: height,
      padding: padding ?? const EdgeInsets.all(16),
      decoration: cardDecoration,
      child: child,
    );
  }
}
