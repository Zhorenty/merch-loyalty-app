import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:merch/src/core/utils/set_state_mixin.dart';
import 'package:merch/src/feature/admin_staff/bloc/admin_staff_event.dart';
import 'package:merch/src/feature/admin_staff/bloc/admin_staff_state.dart';
import 'package:merch/src/feature/admin_staff/data/admin_staff_repository.dart';

final class AdminStaffBloc extends Bloc<AdminStaffEvent, AdminStaffState>
    with SetStateMixin {
  AdminStaffBloc({required AdminStaffRepository repository})
    : _repository = repository,
      super(const AdminStaffState.processing()) {
    on<AdminStaffEvent>(
      (event, emit) => switch (event) {
        final AdminStaffEvent$Started _ => _load(emit),
        final AdminStaffEvent$Created e => _create(e),
        final AdminStaffEvent$Updated e => _update(e),
      },
    );
  }

  final AdminStaffRepository _repository;

  Future<void> _load(Emitter<AdminStaffState> emit) async {
    emit(const AdminStaffState.processing());
    try {
      final staff = await _repository.list();
      emit(AdminStaffState.idle(staff: staff));
    } on Object catch (e, stackTrace) {
      emit(AdminStaffState.error(error: e));
      onError(e, stackTrace);
    }
  }

  Future<void> _create(AdminStaffEvent$Created event) async {
    try {
      await _repository.create(
        login: event.login,
        name: event.name,
        password: event.password,
        role: event.role,
      );
      event.onSuccess();
    } on Object catch (e, stackTrace) {
      event.onError(e);
      onError(e, stackTrace);
    }
  }

  Future<void> _update(AdminStaffEvent$Updated event) async {
    try {
      await _repository.patch(
        event.id,
        login: event.login,
        name: event.name,
        password: event.password,
        role: event.role,
        active: event.active,
      );
      event.onSuccess();
    } on Object catch (e, stackTrace) {
      event.onError(e);
      onError(e, stackTrace);
    }
  }
}
