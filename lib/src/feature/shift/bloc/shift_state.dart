import 'package:merch/src/core/model/models.dart';

sealed class ShiftState {
  const ShiftState();

  const factory ShiftState.processing() = ShiftState$Processing;

  const factory ShiftState.idle({
    required List<ReceiptRow>? receipts,
    bool unavailable,
  }) = ShiftState$Idle;

  const factory ShiftState.error({required Object error}) = ShiftState$Error;

  bool get isProcessing => this is ShiftState$Processing;

  List<ReceiptRow>? get receipts => switch (this) {
    final ShiftState$Idle s => s.receipts,
    _ => null,
  };

  bool get unavailable => switch (this) {
    final ShiftState$Idle s => s.unavailable,
    _ => false,
  };

  Object? get error => switch (this) {
    final ShiftState$Error e => e.error,
    _ => null,
  };
}

final class ShiftState$Processing extends ShiftState {
  const ShiftState$Processing();
}

final class ShiftState$Idle extends ShiftState {
  const ShiftState$Idle({required this.receipts, this.unavailable = false});

  @override
  final List<ReceiptRow>? receipts;

  @override
  final bool unavailable;
}

final class ShiftState$Error extends ShiftState {
  const ShiftState$Error({required this.error});

  @override
  final Object error;
}
