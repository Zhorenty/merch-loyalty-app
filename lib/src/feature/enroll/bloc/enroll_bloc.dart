import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:merch/src/core/utils/set_state_mixin.dart';
import 'package:merch/src/feature/enroll/bloc/enroll_event.dart';
import 'package:merch/src/feature/enroll/bloc/enroll_state.dart';
import 'package:merch/src/feature/enroll/data/enroll_repository.dart';

final class EnrollBloc extends Bloc<EnrollEvent, EnrollState>
    with SetStateMixin {
  EnrollBloc({required EnrollRepository enrollRepository})
    : _enrollRepository = enrollRepository,
      super(const EnrollState.idle()) {
    on<EnrollEvent>(
      (event, emit) => switch (event) {
        final EnrollEvent$Submit e => _submit(e, emit),
        final EnrollEvent$Reset _ => emit(const EnrollState.idle()),
      },
    );
  }

  final EnrollRepository _enrollRepository;

  Future<void> _submit(
    EnrollEvent$Submit event,
    Emitter<EnrollState> emit,
  ) async {
    emit(const EnrollState.processing());
    try {
      final result = await _enrollRepository.enroll(
        name: event.name,
        phone: event.phone,
      );
      emit(EnrollState.idle(result: result));
      event.onSuccess(result);
    } on Object catch (e, stackTrace) {
      emit(const EnrollState.idle());
      event.onError(e);
      onError(e, stackTrace);
    }
  }
}
