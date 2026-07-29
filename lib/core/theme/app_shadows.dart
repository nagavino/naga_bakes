import 'package:flutter/material.dart';

class AppShadows {
  static List<BoxShadow> cardShadow(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (isDark) {
      return [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.35),
          blurRadius: 16,
          offset: const Offset(0, 6),
        ),
      ];
    }
    return [
      BoxShadow(
        color: const Color(0xFF64748B).withValues(alpha: 0.08),
        blurRadius: 20,
        spreadRadius: 1,
        offset: const Offset(0, 8),
      ),
      BoxShadow(
        color: const Color(0xFF0F172A).withValues(alpha: 0.03),
        blurRadius: 4,
        offset: const Offset(0, 2),
      ),
    ];
  }

  static List<BoxShadow> buttonShadow(BuildContext context, Color color) {
    return [
      BoxShadow(
        color: color.withValues(alpha: 0.35),
        blurRadius: 14,
        offset: const Offset(0, 6),
      ),
    ];
  }

  static List<BoxShadow> glassShadow(BuildContext context) {
    return [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.12),
        blurRadius: 24,
        offset: const Offset(0, 10),
      ),
    ];
  }

  const AppShadows._();
}
