import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_colors.dart';
import 'app_radius.dart';

final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.light);

final isDarkModeProvider = Provider<bool>((ref) {
  final themeMode = ref.watch(themeModeProvider);
  return themeMode == ThemeMode.dark;
});

class AppTheme {
  static ThemeData get lightTheme {
    const colors = AppColors.light;
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: colors.primary,
        secondary: colors.secondary,
        surface: colors.surface,
        error: colors.danger,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: colors.textPrimary,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: colors.background,
      cardTheme: CardThemeData(
        color: colors.cardBackground,
        elevation: 0,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.borderMd),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colors.surface,
        foregroundColor: colors.textPrimary,
        elevation: 0,
        centerTitle: true,
      ),
      extensions: const [colors],
    );
  }

  static ThemeData get darkTheme {
    const colors = AppColors.dark;
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: colors.primary,
        secondary: colors.secondary,
        surface: colors.surface,
        error: colors.danger,
        onPrimary: Colors.black,
        onSecondary: Colors.black,
        onSurface: colors.textPrimary,
        onError: Colors.black,
      ),
      scaffoldBackgroundColor: colors.background,
      cardTheme: CardThemeData(
        color: colors.cardBackground,
        elevation: 0,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.borderMd),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colors.surface,
        foregroundColor: colors.textPrimary,
        elevation: 0,
        centerTitle: true,
      ),
      extensions: const [colors],
    );
  }

  const AppTheme._();
}
