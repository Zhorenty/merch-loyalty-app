import 'package:merch/src/core/api/merch_api.dart';
import 'package:merch/src/core/model/models.dart';

abstract interface class AuthDataSource {
  Future<Session> cashierLogin({
    required String login,
    required String secret,
  });

  Future<String> adminLogin({required String login, required String secret});

  Future<void> cashierLogout();

  Future<void> adminLogout();

  Future<List<StoreLocation>> listStores();
}

final class AuthDataSourceNetwork implements AuthDataSource {
  AuthDataSourceNetwork({required MerchApi api}) : _api = api;

  final MerchApi _api;

  @override
  Future<Session> cashierLogin({
    required String login,
    required String secret,
  }) => _api.cashierLogin(login: login, secret: secret);

  @override
  Future<String> adminLogin({
    required String login,
    required String secret,
  }) => _api.adminLogin(login: login, secret: secret);

  @override
  Future<void> cashierLogout() => _api.cashierLogout();

  @override
  Future<void> adminLogout() => _api.adminLogout();

  @override
  Future<List<StoreLocation>> listStores() => _api.listStores();
}
