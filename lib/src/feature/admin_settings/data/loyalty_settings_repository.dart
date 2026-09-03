import 'package:merch/src/feature/admin_settings/data/loyalty_settings_data_source.dart';

abstract interface class LoyaltySettingsRepository {
  Future<Map<String, String>> fetch();

  Future<Map<String, String>> save(Map<String, String> settings);
}

final class LoyaltySettingsRepositoryImpl implements LoyaltySettingsRepository {
  LoyaltySettingsRepositoryImpl({required LoyaltySettingsDataSource dataSource})
    : _dataSource = dataSource;

  final LoyaltySettingsDataSource _dataSource;

  @override
  Future<Map<String, String>> fetch() => _dataSource.fetch();

  @override
  Future<Map<String, String>> save(Map<String, String> settings) =>
      _dataSource.save(settings);
}
