import 'package:merch/src/core/api/merch_api.dart';
import 'package:merch/src/core/model/models.dart';

abstract interface class AdminCustomersDataSource {
  Future<List<AdminCustomer>> search(String query, {String status = 'all'});

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

final class AdminCustomersDataSourceNetwork
    implements AdminCustomersDataSource {
  AdminCustomersDataSourceNetwork({required MerchApi api}) : _api = api;

  final MerchApi _api;

  @override
  Future<List<AdminCustomer>> search(String query, {String status = 'all'}) =>
      _api.searchCustomers(query, status: status);

  @override
  Future<void> block(String id) => _api.blockCustomer(id);

  @override
  Future<void> unblock(String id) => _api.unblockCustomer(id);

  @override
  Future<void> delete(String id) => _api.deleteCustomer(id);

  @override
  Future<void> restore(String id) => _api.restoreCustomer(id);

  @override
  Future<int> adjust({
    required String barcode,
    required int delta,
    required String reason,
  }) => _api.adjust(barcode: barcode, delta: delta, reason: reason);
}
