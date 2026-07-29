import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/dependency_injection.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/settings_entity.dart';

final settingsProvider = StateNotifierProvider<SettingsNotifier, AsyncValue<SettingsEntity>>((ref) {
  return SettingsNotifier(ref);
});

class SettingsNotifier extends StateNotifier<AsyncValue<SettingsEntity>> {
  final Ref ref;

  SettingsNotifier(this.ref) : super(const AsyncValue.loading()) {
    loadSettings();
  }

  Future<void> loadSettings() async {
    state = const AsyncValue.loading();
    final repo = ref.read(settingsRepositoryProvider);
    final result = await repo.getSettings();
    result.when(
      success: (settings) {
        state = AsyncValue.data(settings);
        ref.read(themeModeProvider.notifier).state =
            settings.isDarkMode ? ThemeMode.dark : ThemeMode.light;
      },
      error: (failure) => state = AsyncValue.error(failure, StackTrace.current),
    );
  }

  Future<bool> updateShopName(String name) async {
    final current = state.valueOrNull ?? const SettingsEntity();
    final updated = current.copyWith(shopName: name);
    return _save(updated);
  }

  Future<bool> updateLogo(String logoPath) async {
    final current = state.valueOrNull ?? const SettingsEntity();
    final updated = current.copyWith(shopLogoPath: logoPath);
    return _save(updated);
  }

  Future<bool> updateQrCode(String qrPath) async {
    final current = state.valueOrNull ?? const SettingsEntity();
    final updated = current.copyWith(qrImagePath: qrPath);
    return _save(updated);
  }

  Future<bool> updateThemeMode(bool isDarkMode) async {
    final current = state.valueOrNull ?? const SettingsEntity();
    final updated = current.copyWith(isDarkMode: isDarkMode);
    return _save(updated);
  }

  Future<bool> _save(SettingsEntity settings) async {
    final repo = ref.read(settingsRepositoryProvider);
    final res = await repo.updateSettings(settings);
    if (res.isSuccess) {
      state = AsyncValue.data(settings);
      return true;
    }
    return false;
  }
}
