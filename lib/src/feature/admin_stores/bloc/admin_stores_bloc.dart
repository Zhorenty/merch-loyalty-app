import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:merch/src/core/utils/set_state_mixin.dart';
import 'package:merch/src/feature/admin_stores/bloc/admin_stores_event.dart';
import 'package:merch/src/feature/admin_stores/bloc/admin_stores_state.dart';
import 'package:merch/src/feature/admin_stores/data/admin_stores_repository.dart';

final class AdminStoresBloc extends Bloc<AdminStoresEvent, AdminStoresState>
    with SetStateMixin {
  AdminStoresBloc({required AdminStoresRepository repository})
    : _repository = repository,
      super(const AdminStoresState.processing()) {
    on<AdminStoresEvent>(
      (event, emit) => switch (event) {
        final AdminStoresEvent$Started _ => _load(emit),
        final AdminStoresEvent$Saved e => _save(e),
        final AdminStoresEvent$Deleted e => _delete(e),
      },
    );
  }

  final AdminStoresRepository _repository;

  Future<void> _load(Emitter<AdminStoresState> emit) async {
    emit(const AdminStoresState.processing());
    try {
      final stores = await _repository.list();
      emit(AdminStoresState.idle(stores: stores));
    } on Object catch (e, stackTrace) {
      emit(AdminStoresState.error(error: e));
      onError(e, stackTrace);
    }
  }

  Future<void> _save(AdminStoresEvent$Saved event) async {
    try {
      if (event.id == null) {
        await _repository.create(name: event.name, address: event.address);
      } else {
        await _repository.patch(
          event.id!,
          name: event.name,
          address: event.address,
        );
      }
      event.onSuccess();
    } on Object catch (e, stackTrace) {
      event.onError(e);
      onError(e, stackTrace);
    }
  }

  Future<void> _delete(AdminStoresEvent$Deleted event) async {
    try {
      await _repository.delete(event.id);
      event.onSuccess();
    } on Object catch (e, stackTrace) {
      event.onError(e);
      onError(e, stackTrace);
    }
  }
}
