import 'package:merch/src/core/api/merch_api.dart';
import 'package:merch/src/core/model/models.dart';

abstract interface class ShiftDataSource {
  Future<List<ReceiptRow>?> listReceipts();

  Future<int> refund(String receiptId);
}

final class ShiftDataSourceNetwork implements ShiftDataSource {
  ShiftDataSourceNetwork({required MerchApi api}) : _api = api;

  final MerchApi _api;

  @override
  Future<List<ReceiptRow>?> listReceipts() => _api.listReceipts();

  @override
  Future<int> refund(String receiptId) => _api.refund(receiptId);
}
