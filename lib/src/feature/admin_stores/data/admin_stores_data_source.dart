import 'package:merch/src/core/api/merch_api.dart';
import 'package:merch/src/core/model/models.dart';

abstract interface class AdminStoresDataSource {
  Future<List<StoreLocation>> list();

  Future<StoreLocation> create({required String name, String? address});

  Future<StoreLocation> patch(String id, {String? name, String? address});

  Future<void> delete(String id);
}

final class AdminStoresDataSourceNetwork implements AdminStoresDataSource {
  AdminStoresDataSourceNetwork({required MerchApi api}) : _api = api;

  final MerchApi _api;

  @override
  Future<List<StoreLocation>> list() => _api.listStores();

  @override
  Future<StoreLocation> create({required String name, String? address}) =>
      _api.createStore(name: name, address: address);

  @override
  Future<StoreLocation> patch(String id, {String? name, String? address}) =>
      _api.patchStore(id, name: name, address: address);

  @override
  Future<void> delete(String id) => _api.deleteStore(id);
}
