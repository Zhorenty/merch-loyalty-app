import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:merch/src/core/utils/set_state_mixin.dart';
import 'package:merch/src/feature/scan/bloc/scan_event.dart';
import 'package:merch/src/feature/scan/bloc/scan_state.dart';
import 'package:merch/src/feature/scan/data/scan_repository.dart';

final class ScanBloc extends Bloc<ScanEvent, ScanState> with SetStateMixin {
  ScanBloc({required ScanRepository scanRepository})
    : _scanRepository = scanRepository,
      super(const ScanState.idle()) {
    on<ScanEvent>(
      (event, emit) => switch (event) {
        final ScanEvent$Lookup e => _lookup(e, emit),
      },
    );
  }

  final ScanRepository _scanRepository;

  Future<void> _lookup(
    ScanEvent$Lookup event,
    Emitter<ScanState> emit,
  ) async {
    emit(const ScanState.processing());
    try {
      final customer = await _scanRepository.lookup(event.barcode);
      emit(const ScanState.idle());
      event.onSuccess(customer);
    } on Object catch (e, stackTrace) {
      emit(ScanState.error(error: e));
      event.onError(e);
      onError(e, stackTrace);
    }
  }
}
