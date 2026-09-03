import 'package:merch/src/core/api/merch_api.dart';
import 'package:merch/src/core/model/models.dart';

abstract interface class ReceiptDataSource {
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

final class ReceiptDataSourceNetwork implements ReceiptDataSource {
  ReceiptDataSourceNetwork({required MerchApi api}) : _api = api;

  final MerchApi _api;

  @override
  Future<QuoteResult> quote({
    required String barcode,
    required int amountRub,
    required int requestedPoints,
  }) => _api.quote(
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
  }) => _api.commit(
    receiptId: receiptId,
    barcode: barcode,
    amountRub: amountRub,
    redeemPoints: redeemPoints,
  );
}
