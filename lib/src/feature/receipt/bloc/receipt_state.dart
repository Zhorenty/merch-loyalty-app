import 'package:merch/src/core/model/models.dart';

sealed class ReceiptState {
  const ReceiptState({
    this.quote,
    this.error,
    this.offline = false,
    this.amountRub,
  });

  final QuoteResult? quote;
  final Object? error;
  final bool offline;

  /// Receipt amount the current [quote] was calculated for.
  final int? amountRub;

  bool get isQuoting => this is ReceiptState$Quoting;

  bool get isCommitting => this is ReceiptState$Committing;

  const factory ReceiptState.idle({
    QuoteResult? quote,
    Object? error,
    bool offline,
    int? amountRub,
  }) = ReceiptState$Idle;

  const factory ReceiptState.quoting({QuoteResult? quote, int? amountRub}) =
      ReceiptState$Quoting;

  const factory ReceiptState.committing({QuoteResult? quote, int? amountRub}) =
      ReceiptState$Committing;
}

final class ReceiptState$Idle extends ReceiptState {
  const ReceiptState$Idle({
    super.quote,
    super.error,
    super.offline,
    super.amountRub,
  });
}

final class ReceiptState$Quoting extends ReceiptState {
  const ReceiptState$Quoting({super.quote, super.amountRub});
}

final class ReceiptState$Committing extends ReceiptState {
  const ReceiptState$Committing({super.quote, super.amountRub});
}
