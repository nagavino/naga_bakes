import '../../../../core/utils/result.dart';
import '../entities/settings_entity.dart';

abstract class SettingsRepository {
  Future<Result<SettingsEntity>> getSettings();
  Future<Result<void>> updateSettings(SettingsEntity settings);
}
