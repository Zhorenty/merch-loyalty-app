import 'package:merch/src/core/api/merch_api.dart';

abstract interface class LoyaltySettingsDataSource {
  Future<Map<String, String>> fetch();

  Future<Map<String, String>> save(Map<String, String> settings);
}

final class LoyaltySettingsDataSourceNetwork
    implements LoyaltySettingsDataSource {
  LoyaltySettingsDataSourceNetwork({required MerchApi api}) : _api = api;

  final MerchApi _api;

  @override
  Future<Map<String, String>> fetch() => _api.loyaltySettings();

  @override
  Future<Map<String, String>> save(Map<String, String> settings) =>
      _api.putLoyaltySettings(settings);
}
