import 'package:merch/src/core/model/models.dart';
import 'package:merch/src/feature/shift/data/shift_data_source.dart';

abstract interface class ShiftRepository {
  Future<List<ReceiptRow>?> listReceipts();

  Future<int> refund(String receiptId);
}

final class ShiftRepositoryImpl implements ShiftRepository {
  ShiftRepositoryImpl({required ShiftDataSource dataSource})
    : _dataSource = dataSource;

  final ShiftDataSource _dataSource;

  @override
  Future<List<ReceiptRow>?> listReceipts() => _dataSource.listReceipts();

  @override
  Future<int> refund(String receiptId) => _dataSource.refund(receiptId);
}
