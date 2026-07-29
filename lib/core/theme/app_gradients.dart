import 'package:flutter/material.dart';

class AppGradients {
  static LinearGradient primary(BuildContext context) {
    return const LinearGradient(
      colors: [Color(0xFF4F46E5), Color(0xFF6366F1)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  static LinearGradient success(BuildContext context) {
    return const LinearGradient(
      colors: [Color(0xFF059669), Color(0xFF10B981)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  static LinearGradient danger(BuildContext context) {
    return const LinearGradient(
      colors: [Color(0xFFE11D48), Color(0xFFF43F5E)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  static LinearGradient secondary(BuildContext context) {
    return const LinearGradient(
      colors: [Color(0xFF7C3AED), Color(0xFF8B5CF6)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  static LinearGradient amber(BuildContext context) {
    return const LinearGradient(
      colors: [Color(0xFFD97706), Color(0xFFF59E0B)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  static LinearGradient glassCard(BuildContext context, {bool isDark = false}) {
    if (isDark) {
      return LinearGradient(
        colors: [
          const Color(0xFF1E293B).withValues(alpha: 0.9),
          const Color(0xFF0F172A).withValues(alpha: 0.7),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    }
    return LinearGradient(
      colors: [
        Colors.white.withValues(alpha: 0.95),
        const Color(0xFFF1F5F9).withValues(alpha: 0.85),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  const AppGradients._();
}
