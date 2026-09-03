import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:merch/src/core/utils/set_state_mixin.dart';
import 'package:merch/src/feature/shift/bloc/shift_event.dart';
import 'package:merch/src/feature/shift/bloc/shift_state.dart';
import 'package:merch/src/feature/shift/data/shift_repository.dart';

final class ShiftBloc extends Bloc<ShiftEvent, ShiftState> with SetStateMixin {
  ShiftBloc({required ShiftRepository shiftRepository})
    : _shiftRepository = shiftRepository,
      super(const ShiftState.processing()) {
    on<ShiftEvent>(
      (event, emit) => switch (event) {
        final ShiftEvent$Started _ => _load(emit),
        final ShiftEvent$Refunded e => _refund(e, emit),
      },
    );
  }

  final ShiftRepository _shiftRepository;

  Future<void> _load(Emitter<ShiftState> emit) async {
    emit(const ShiftState.processing());
    try {
      final receipts = await _shiftRepository.listReceipts();
      emit(
        ShiftState.idle(
          receipts: receipts,
          unavailable: receipts == null,
        ),
      );
    } on Object catch (e, stackTrace) {
      emit(ShiftState.error(error: e));
      onError(e, stackTrace);
    }
  }

  Future<void> _refund(
    ShiftEvent$Refunded event,
    Emitter<ShiftState> emit,
  ) async {
    try {
      await _shiftRepository.refund(event.receiptId);
      event.onSuccess();
      await _load(emit);
    } on Object catch (e, stackTrace) {
      event.onError(e);
      onError(e, stackTrace);
    }
  }
}
