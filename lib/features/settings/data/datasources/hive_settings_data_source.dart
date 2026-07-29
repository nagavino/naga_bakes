import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/error/app_exception.dart';
import '../models/settings_model.dart';

class HiveSettingsDataSource {
  static const String boxName = 'settings';
  static const String keyName = 'shop_settings';

  Future<Box<Map>> _getBox() async {
    try {
      if (Hive.isBoxOpen(boxName)) {
        return Hive.box<Map>(boxName);
      }
      return await Hive.openBox<Map>(boxName);
    } catch (_) {
      // Silent auto-recovery on corruption
      await Hive.deleteBoxFromDisk(boxName);
      return await Hive.openBox<Map>(boxName);
    }
  }

  Future<SettingsModel> getSettings() async {
    try {
      final box = await _getBox();
      final val = box.get(keyName);
      if (val != null) {
        return SettingsModel.fromMap(val);
      }
      const defaultSettings = SettingsModel(shopName: 'Naga Bakes', invoiceCounter: 1);
      await box.put(keyName, defaultSettings.toMap());
      return defaultSettings;
    } catch (_) {
      return const SettingsModel(shopName: 'Naga Bakes', invoiceCounter: 1);
    }
  }

  Future<void> saveSettings(SettingsModel settings) async {
    try {
      final box = await _getBox();
      await box.put(keyName, settings.toMap());
    } catch (_) {
      throw const StorageException('Failed to save settings');
    }
  }
}
