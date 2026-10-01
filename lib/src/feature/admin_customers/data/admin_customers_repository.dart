import 'package:merch/src/core/model/models.dart';
import 'package:merch/src/feature/admin_customers/data/admin_customers_data_source.dart';

abstract interface class AdminCustomersRepository {
  Future<List<AdminCustomer>> search(String query, {String status = 'active'});

  Future<void> block(String id);

  Future<void> unblock(String id);

  Future<void> delete(String id);

  Future<void> restore(String id);

  Future<int> adjust({
    required String barcode,
    required int delta,
    required String reason,
  });
}

final class AdminCustomersRepositoryImpl implements AdminCustomersRepository {
  AdminCustomersRepositoryImpl({required AdminCustomersDataSource dataSource})
    : _dataSource = dataSource;

  final AdminCustomersDataSource _dataSource;

  @override
  Future<List<AdminCustomer>> search(String query, {String status = 'active'}) =>
      _dataSource.search(query, status: status);

  @override
  Future<void> block(String id) => _dataSource.block(id);

  @override
  Future<void> unblock(String id) => _dataSource.unblock(id);

  @override
  Future<void> delete(String id) => _dataSource.delete(id);

  @override
  Future<void> restore(String id) => _dataSource.restore(id);

  @override
  Future<int> adjust({
    required String barcode,
    required int delta,
    required String reason,
  }) => _dataSource.adjust(barcode: barcode, delta: delta, reason: reason);
}
