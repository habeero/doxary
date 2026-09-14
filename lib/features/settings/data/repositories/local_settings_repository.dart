import '../../../../core/database/app_database.dart';
import '../../domain/settings_repository.dart';

class LocalSettingsRepository implements SettingsRepository {
  LocalSettingsRepository(this._database);
  final AppDatabase _database;
  @override
  Future<String?> read(String key) async => (await (_database.select(
    _database.userSettings,
  )..where((row) => row.key.equals(key))).getSingleOrNull())?.value;
  @override
  Future<void> write(String key, String value) => _database
      .into(_database.userSettings)
      .insertOnConflictUpdate(
        UserSettingsCompanion.insert(
          key: key,
          value: value,
          updatedAt: DateTime.now(),
        ),
      );
}
