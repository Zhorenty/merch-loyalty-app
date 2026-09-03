import 'package:merch/src/core/model/models.dart';
import 'package:merch/src/feature/receipt/data/receipt_data_source.dart';

abstract interface class ReceiptRepository {
  Future<QuoteResult> quote({
    required String barcode,
    required int amountRub,
    required int requestedPoints,
  });

  Future<CommitResult> commit({
    required String receiptId,
    required String barcode,
    required int amountRub,
    required int redeemPoints,
  });
}

final class ReceiptRepositoryImpl implements ReceiptRepository {
  ReceiptRepositoryImpl({required ReceiptDataSource dataSource})
    : _dataSource = dataSource;

  final ReceiptDataSource _dataSource;

  @override
  Future<QuoteResult> quote({
    required String barcode,
    required int amountRub,
    required int requestedPoints,
  }) => _dataSource.quote(
    barcode: barcode,
    amountRub: amountRub,
    requestedPoints: requestedPoints,
  );

  @override
  Future<CommitResult> commit({
    required String receiptId,
    required String barcode,
    required int amountRub,
    required int redeemPoints,
  }) => _dataSource.commit(
    receiptId: receiptId,
    barcode: barcode,
    amountRub: amountRub,
    redeemPoints: redeemPoints,
  );
}
