import '../../../../core/utils/result.dart';
import '../entities/settings_entity.dart';
import '../repositories/settings_repository.dart';

class UpdateSettings {
  final SettingsRepository repository;
  const UpdateSettings(this.repository);

  Future<Result<void>> call(SettingsEntity settings) {
    return repository.updateSettings(settings);
  }
}
