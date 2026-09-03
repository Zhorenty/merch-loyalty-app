import 'package:merch/src/core/model/models.dart';

sealed class EnrollState {
  const EnrollState();

  const factory EnrollState.idle({EnrollResult? result}) = EnrollState$Idle;

  const factory EnrollState.processing() = EnrollState$Processing;

  bool get isProcessing => this is EnrollState$Processing;

  EnrollResult? get result => switch (this) {
    final EnrollState$Idle s => s.result,
    _ => null,
  };
}

final class EnrollState$Idle extends EnrollState {
  const EnrollState$Idle({this.result});

  @override
  final EnrollResult? result;
}

final class EnrollState$Processing extends EnrollState {
  const EnrollState$Processing();
}
