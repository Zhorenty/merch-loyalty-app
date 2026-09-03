import 'package:merch/src/core/model/models.dart';
import 'package:merch/src/feature/admin_stores/data/admin_stores_data_source.dart';

abstract interface class AdminStoresRepository {
  Future<List<StoreLocation>> list();

  Future<StoreLocation> create({required String name, String? address});

  Future<StoreLocation> patch(String id, {String? name, String? address});

  Future<void> delete(String id);
}

final class AdminStoresRepositoryImpl implements AdminStoresRepository {
  AdminStoresRepositoryImpl({required AdminStoresDataSource dataSource})
    : _dataSource = dataSource;

  final AdminStoresDataSource _dataSource;

  @override
  Future<List<StoreLocation>> list() => _dataSource.list();

  @override
  Future<StoreLocation> create({required String name, String? address}) =>
      _dataSource.create(name: name, address: address);

  @override
  Future<StoreLocation> patch(String id, {String? name, String? address}) =>
      _dataSource.patch(id, name: name, address: address);

  @override
  Future<void> delete(String id) => _dataSource.delete(id);
}
