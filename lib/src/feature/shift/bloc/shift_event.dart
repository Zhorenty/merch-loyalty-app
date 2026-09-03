sealed class ShiftEvent {
  const ShiftEvent();

  const factory ShiftEvent.started() = ShiftEvent$Started;

  const factory ShiftEvent.refunded({
    required String receiptId,
    required void Function() onSuccess,
    required void Function(Object error) onError,
  }) = ShiftEvent$Refunded;
}

final class ShiftEvent$Started extends ShiftEvent {
  const ShiftEvent$Started();
}

final class ShiftEvent$Refunded extends ShiftEvent {
  const ShiftEvent$Refunded({
    required this.receiptId,
    required this.onSuccess,
    required this.onError,
  });

  final String receiptId;
  final void Function() onSuccess;
  final void Function(Object error) onError;
}
