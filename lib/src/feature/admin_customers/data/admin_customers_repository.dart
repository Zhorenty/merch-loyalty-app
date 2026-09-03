import 'package:merch/src/core/model/models.dart';
import 'package:merch/src/feature/admin_customers/data/admin_customers_data_source.dart';

abstract interface class AdminCustomersRepository {
  Future<List<AdminCustomer>> search(String query);

  Future<void> block(String id);

  Future<void> unblock(String id);

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
  Future<List<AdminCustomer>> search(String query) => _dataSource.search(query);

  @override
  Future<void> block(String id) => _dataSource.block(id);

  @override
  Future<void> unblock(String id) => _dataSource.unblock(id);

  @override
  Future<int> adjust({
    required String barcode,
    required int delta,
    required String reason,
  }) => _dataSource.adjust(barcode: barcode, delta: delta, reason: reason);
}
