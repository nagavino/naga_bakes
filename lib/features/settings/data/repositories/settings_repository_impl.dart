import '../../../../core/error/failure.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/settings_entity.dart';
import '../../domain/repositories/settings_repository.dart';
import '../datasources/hive_settings_data_source.dart';
import '../models/settings_model.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final HiveSettingsDataSource dataSource;

  SettingsRepositoryImpl(this.dataSource);

  @override
  Future<Result<SettingsEntity>> getSettings() async {
    try {
      final model = await dataSource.getSettings();
      return Success(model.toEntity());
    } catch (e) {
      return const ErrorResult(StorageFailure('Could not retrieve settings'));
    }
  }

  @override
  Future<Result<void>> updateSettings(SettingsEntity settings) async {
    try {
      final model = SettingsModel.fromEntity(settings);
      await dataSource.saveSettings(model);
      return const Success(null);
    } catch (e) {
      return const ErrorResult(StorageFailure('Could not update settings'));
    }
  }
}
