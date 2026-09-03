sealed class ScanState {
  const ScanState();

  const factory ScanState.idle() = ScanState$Idle;

  const factory ScanState.processing() = ScanState$Processing;

  const factory ScanState.error({required Object error}) = ScanState$Error;

  bool get isProcessing => this is ScanState$Processing;

  Object? get error => switch (this) {
    final ScanState$Error e => e.error,
    _ => null,
  };
}

final class ScanState$Idle extends ScanState {
  const ScanState$Idle();
}

final class ScanState$Processing extends ScanState {
  const ScanState$Processing();
}

final class ScanState$Error extends ScanState {
  const ScanState$Error({required this.error});

  @override
  final Object error;
}
