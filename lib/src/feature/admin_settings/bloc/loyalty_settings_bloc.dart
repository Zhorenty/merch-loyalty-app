import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:merch/src/core/utils/set_state_mixin.dart';
import 'package:merch/src/feature/admin_settings/bloc/loyalty_settings_event.dart';
import 'package:merch/src/feature/admin_settings/bloc/loyalty_settings_state.dart';
import 'package:merch/src/feature/admin_settings/data/loyalty_settings_repository.dart';

final class LoyaltySettingsBloc
    extends Bloc<LoyaltySettingsEvent, LoyaltySettingsState>
    with SetStateMixin {
  LoyaltySettingsBloc({required LoyaltySettingsRepository repository})
    : _repository = repository,
      super(const LoyaltySettingsState.processing()) {
    on<LoyaltySettingsEvent>(
      (event, emit) => switch (event) {
        final LoyaltySettingsEvent$Started _ => _load(emit),
        final LoyaltySettingsEvent$Saved e => _save(e, emit),
      },
    );
  }

  final LoyaltySettingsRepository _repository;

  Future<void> _load(Emitter<LoyaltySettingsState> emit) async {
    emit(const LoyaltySettingsState.processing());
    try {
      final settings = await _repository.fetch();
      emit(LoyaltySettingsState.idle(settings: settings));
    } on Object catch (e, stackTrace) {
      emit(LoyaltySettingsState.error(error: e));
      onError(e, stackTrace);
    }
  }

  Future<void> _save(
    LoyaltySettingsEvent$Saved event,
    Emitter<LoyaltySettingsState> emit,
  ) async {
    emit(LoyaltySettingsState.idle(settings: event.settings, saving: true));
    try {
      final settings = await _repository.save(event.settings);
      emit(LoyaltySettingsState.idle(settings: settings));
      event.onSuccess();
    } on Object catch (e, stackTrace) {
      emit(LoyaltySettingsState.idle(settings: event.settings));
      event.onError(e);
      onError(e, stackTrace);
    }
  }
}
