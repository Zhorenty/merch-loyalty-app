import 'package:merch/src/core/model/models.dart';

sealed class ReceiptEvent {
  const ReceiptEvent();

  const factory ReceiptEvent.quote({
    required String barcode,
    required int amountRub,
    required int requestedPoints,
  }) = ReceiptEvent$Quote;

  const factory ReceiptEvent.commit({
    required String receiptId,
    required String barcode,
    required int amountRub,
    required int redeemPoints,
    required void Function(CommitResult result) onSuccess,
  }) = ReceiptEvent$Commit;
}

final class ReceiptEvent$Quote extends ReceiptEvent {
  const ReceiptEvent$Quote({
    required this.barcode,
    required this.amountRub,
    required this.requestedPoints,
  });

  final String barcode;
  final int amountRub;
  final int requestedPoints;
}

final class ReceiptEvent$Commit extends ReceiptEvent {
  const ReceiptEvent$Commit({
    required this.receiptId,
    required this.barcode,
    required this.amountRub,
    required this.redeemPoints,
    required this.onSuccess,
  });

  final String receiptId;
  final String barcode;
  final int amountRub;
  final int redeemPoints;
  final void Function(CommitResult result) onSuccess;
}
