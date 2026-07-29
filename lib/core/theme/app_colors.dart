import 'package:flutter/material.dart';

class AppColors extends ThemeExtension<AppColors> {
  final Color primary;
  final Color secondary;
  final Color success;
  final Color danger;
  final Color warning;
  final Color background;
  final Color surface;
  final Color textPrimary;
  final Color textSecondary;
  final Color border;
  final Color cardBackground;
  final Color cardBorder;
  final Color keypadKeyBackground;
  final Color keypadKeyBorder;
  final Color inputHint;
  final Color divider;
  final Color textMuted;
  final bool isDarkMode;
  
  // Theme-adaptive UI alphas/colors to avoid isDarkMode checks in UI
  final double bottomNavShadowAlpha;
  final double cardActionOverlayAlpha;
  final double cardActionBorderAlpha;
  final Color themeToggleIconColor;
  final Color appearanceIconColor;

  const AppColors({
    required this.primary,
    required this.secondary,
    required this.success,
    required this.danger,
    required this.warning,
    required this.background,
    required this.surface,
    required this.textPrimary,
    required this.textSecondary,
    required this.border,
    required this.cardBackground,
    required this.cardBorder,
    required this.keypadKeyBackground,
    required this.keypadKeyBorder,
    required this.inputHint,
    required this.divider,
    required this.textMuted,
    required this.isDarkMode,
    required this.bottomNavShadowAlpha,
    required this.cardActionOverlayAlpha,
    required this.cardActionBorderAlpha,
    required this.themeToggleIconColor,
    required this.appearanceIconColor,
  });

  static const light = AppColors(
    primary: Color(0xFF4F46E5),        // Indigo
    secondary: Color(0xFF8B5CF6),      // Violet
    success: Color(0xFF10B981),        // Emerald Mint
    danger: Color(0xFFF43F5E),         // Rose Crimson
    warning: Color(0xFFF59E0B),        // Amber
    background: Color(0xFFF8FAFC),     // Ultra soft slate blue-tint white
    surface: Color(0xFFFFFFFF),        // Pure white
    textPrimary: Color(0xFF0F172A),    // Deep Navy
    textSecondary: Color(0xFF64748B),  // Muted Slate
    border: Color(0xFFE2E8F0),         // Light slate border
    cardBackground: Color(0xFFFFFFFF), // White
    cardBorder: Color(0xFFE2E8F0),
    keypadKeyBackground: Color(0xFFF8FAFC),
    keypadKeyBorder: Color(0xB2E2E8F0), // colors.border.withValues(alpha: 0.7)
    inputHint: Color(0x1F000000),      // Colors.black12
    divider: Color(0x80E2E8F0),        // colors.border.withValues(alpha: 0.5)
    textMuted: Color(0xFF94A3B8),      // Faded Slate
    isDarkMode: false,
    bottomNavShadowAlpha: 0.06,
    cardActionOverlayAlpha: 0.06,
    cardActionBorderAlpha: 0.25,
    themeToggleIconColor: Color(0xFF4F46E5), // Indigo (primary)
    appearanceIconColor: Color(0xFF8B5CF6),  // Violet (secondary)
  );

  static const dark = AppColors(
    primary: Color(0xFF6366F1),        // Electric Indigo
    secondary: Color(0xFFA78BFA),      // Electric Violet
    success: Color(0xFF34D399),        // Electric Emerald
    danger: Color(0xFFFB7185),         // Electric Rose
    warning: Color(0xFFFBBF24),        // Amber Glow
    background: Color(0xFF0F172A),     // Deep Obsidian Navy
    surface: Color(0xFF1E293B),        // Dark Slate Surface
    textPrimary: Color(0xFFF8FAFC),    // Pure Light
    textSecondary: Color(0xFF94A3B8),  // Muted Light Slate
    border: Color(0xFF334155),         // Slate Border
    cardBackground: Color(0xFF1E293B), // Dark Slate Card
    cardBorder: Color(0x0DFFFFFF),     // Colors.white.withValues(alpha: 0.05)
    keypadKeyBackground: Color(0xFF1E293B),
    keypadKeyBorder: Color(0x0DFFFFFF),
    inputHint: Color(0x33FFFFFF),      // Colors.white.withValues(alpha: 0.2)
    divider: Color(0x0FFFFFFF),        // Colors.white.withValues(alpha: 0.06)
    textMuted: Color(0xFF64748B),      // Faded Light Slate
    isDarkMode: true,
    bottomNavShadowAlpha: 0.3,
    cardActionOverlayAlpha: 0.15,
    cardActionBorderAlpha: 0.35,
    themeToggleIconColor: Color(0xFFFBBF24), // Amber (warning)
    appearanceIconColor: Color(0xFFFBBF24),  // Amber (warning)
  );

  static AppColors of(BuildContext context) {
    return Theme.of(context).extension<AppColors>() ?? light;
  }

  @override
  AppColors copyWith({
    Color? primary,
    Color? secondary,
    Color? success,
    Color? danger,
    Color? warning,
    Color? background,
    Color? surface,
    Color? textPrimary,
    Color? textSecondary,
    Color? border,
    Color? cardBackground,
    Color? cardBorder,
    Color? keypadKeyBackground,
    Color? keypadKeyBorder,
    Color? inputHint,
    Color? divider,
    Color? textMuted,
    bool? isDarkMode,
    double? bottomNavShadowAlpha,
    double? cardActionOverlayAlpha,
    double? cardActionBorderAlpha,
    Color? themeToggleIconColor,
    Color? appearanceIconColor,
  }) {
    return AppColors(
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      success: success ?? this.success,
      danger: danger ?? this.danger,
      warning: warning ?? this.warning,
      background: background ?? this.background,
      surface: surface ?? this.surface,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      border: border ?? this.border,
      cardBackground: cardBackground ?? this.cardBackground,
      cardBorder: cardBorder ?? this.cardBorder,
      keypadKeyBackground: keypadKeyBackground ?? this.keypadKeyBackground,
      keypadKeyBorder: keypadKeyBorder ?? this.keypadKeyBorder,
      inputHint: inputHint ?? this.inputHint,
      divider: divider ?? this.divider,
      textMuted: textMuted ?? this.textMuted,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      bottomNavShadowAlpha: bottomNavShadowAlpha ?? this.bottomNavShadowAlpha,
      cardActionOverlayAlpha: cardActionOverlayAlpha ?? this.cardActionOverlayAlpha,
      cardActionBorderAlpha: cardActionBorderAlpha ?? this.cardActionBorderAlpha,
      themeToggleIconColor: themeToggleIconColor ?? this.themeToggleIconColor,
      appearanceIconColor: appearanceIconColor ?? this.appearanceIconColor,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      primary: Color.lerp(primary, other.primary, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      success: Color.lerp(success, other.success, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      border: Color.lerp(border, other.border, t)!,
      cardBackground: Color.lerp(cardBackground, other.cardBackground, t)!,
      cardBorder: Color.lerp(cardBorder, other.cardBorder, t)!,
      keypadKeyBackground: Color.lerp(keypadKeyBackground, other.keypadKeyBackground, t)!,
      keypadKeyBorder: Color.lerp(keypadKeyBorder, other.keypadKeyBorder, t)!,
      inputHint: Color.lerp(inputHint, other.inputHint, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      isDarkMode: t < 0.5 ? isDarkMode : other.isDarkMode,
      bottomNavShadowAlpha: t < 0.5 ? bottomNavShadowAlpha : other.bottomNavShadowAlpha,
      cardActionOverlayAlpha: t < 0.5 ? cardActionOverlayAlpha : other.cardActionOverlayAlpha,
      cardActionBorderAlpha: t < 0.5 ? cardActionBorderAlpha : other.cardActionBorderAlpha,
      themeToggleIconColor: Color.lerp(themeToggleIconColor, other.themeToggleIconColor, t)!,
      appearanceIconColor: Color.lerp(appearanceIconColor, other.appearanceIconColor, t)!,
    );
  }
}
