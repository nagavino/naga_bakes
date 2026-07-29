import '../../../../core/utils/result.dart';
import '../entities/settings_entity.dart';
import '../repositories/settings_repository.dart';

class GetSettings {
  final SettingsRepository repository;
  const GetSettings(this.repository);

  Future<Result<SettingsEntity>> call() {
    return repository.getSettings();
  }
}
