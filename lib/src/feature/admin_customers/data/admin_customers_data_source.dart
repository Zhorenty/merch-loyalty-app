import 'package:merch/src/core/api/merch_api.dart';
import 'package:merch/src/core/model/models.dart';

abstract interface class AdminCustomersDataSource {
  Future<List<AdminCustomer>> search(String query);

  Future<void> block(String id);

  Future<void> unblock(String id);

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
  Future<List<AdminCustomer>> search(String query) =>
      _api.searchCustomers(query);

  @override
  Future<void> block(String id) => _api.blockCustomer(id);

  @override
  Future<void> unblock(String id) => _api.unblockCustomer(id);

  @override
  Future<int> adjust({
    required String barcode,
    required int delta,
    required String reason,
  }) => _api.adjust(barcode: barcode, delta: delta, reason: reason);
}
