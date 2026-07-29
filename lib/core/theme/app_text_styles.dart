import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles extends ThemeExtension<AppTextStyles> {
  final TextStyle display;
  final TextStyle headline;
  final TextStyle title;
  final TextStyle body;
  final TextStyle caption;
  final TextStyle label;

  const AppTextStyles({
    required this.display,
    required this.headline,
    required this.title,
    required this.body,
    required this.caption,
    required this.label,
  });

  static AppTextStyles of(BuildContext context) {
    final colors = AppColors.of(context);
    return AppTextStyles(
      display: TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.w800,
        color: colors.textPrimary,
        height: 1.2,
      ),
      headline: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: colors.textPrimary,
        height: 1.25,
      ),
      title: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: colors.textPrimary,
        height: 1.3,
      ),
      body: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: colors.textPrimary,
        height: 1.4,
      ),
      caption: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: colors.textSecondary,
        height: 1.35,
      ),
      label: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: colors.textSecondary,
        letterSpacing: 0.5,
      ),
    );
  }

  @override
  AppTextStyles copyWith({
    TextStyle? display,
    TextStyle? headline,
    TextStyle? title,
    TextStyle? body,
    TextStyle? caption,
    TextStyle? label,
  }) {
    return AppTextStyles(
      display: display ?? this.display,
      headline: headline ?? this.headline,
      title: title ?? this.title,
      body: body ?? this.body,
      caption: caption ?? this.caption,
      label: label ?? this.label,
    );
  }

  @override
  AppTextStyles lerp(ThemeExtension<AppTextStyles>? other, double t) {
    if (other is! AppTextStyles) return this;
    return AppTextStyles(
      display: TextStyle.lerp(display, other.display, t)!,
      headline: TextStyle.lerp(headline, other.headline, t)!,
      title: TextStyle.lerp(title, other.title, t)!,
      body: TextStyle.lerp(body, other.body, t)!,
      caption: TextStyle.lerp(caption, other.caption, t)!,
      label: TextStyle.lerp(label, other.label, t)!,
    );
  }
}

extension ThemeContextExtension on BuildContext {
  AppColors get colors => AppColors.of(this);
  AppTextStyles get textStyles => AppTextStyles.of(this);
  bool get isDarkMode => colors.isDarkMode;
}
