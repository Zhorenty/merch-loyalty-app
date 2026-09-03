import 'package:merch/src/core/model/models.dart';

sealed class ReceiptState {
  const ReceiptState({this.quote, this.error, this.offline = false});

  final QuoteResult? quote;
  final Object? error;
  final bool offline;

  bool get isQuoting => this is ReceiptState$Quoting;

  bool get isCommitting => this is ReceiptState$Committing;

  const factory ReceiptState.idle({
    QuoteResult? quote,
    Object? error,
    bool offline,
  }) = ReceiptState$Idle;

  const factory ReceiptState.quoting({QuoteResult? quote}) =
      ReceiptState$Quoting;

  const factory ReceiptState.committing({QuoteResult? quote}) =
      ReceiptState$Committing;
}

final class ReceiptState$Idle extends ReceiptState {
  const ReceiptState$Idle({super.quote, super.error, super.offline});
}

final class ReceiptState$Quoting extends ReceiptState {
  const ReceiptState$Quoting({super.quote});
}

final class ReceiptState$Committing extends ReceiptState {
  const ReceiptState$Committing({super.quote});
}
