import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:merch/src/core/utils/set_state_mixin.dart';
import 'package:merch/src/feature/admin_customers/bloc/admin_customers_event.dart';
import 'package:merch/src/feature/admin_customers/bloc/admin_customers_state.dart';
import 'package:merch/src/feature/admin_customers/data/admin_customers_repository.dart';

final class AdminCustomersBloc
    extends Bloc<AdminCustomersEvent, AdminCustomersState>
    with SetStateMixin {
  AdminCustomersBloc({required AdminCustomersRepository repository})
    : _repository = repository,
      super(const AdminCustomersState.processing()) {
    on<AdminCustomersEvent>(
      (event, emit) => switch (event) {
        final AdminCustomersEvent$Searched e => _search(e, emit),
        final AdminCustomersEvent$Blocked e => _block(e),
        final AdminCustomersEvent$Adjusted e => _adjust(e),
      },
    );
  }

  final AdminCustomersRepository _repository;

  Future<void> _search(
    AdminCustomersEvent$Searched event,
    Emitter<AdminCustomersState> emit,
  ) async {
    emit(const AdminCustomersState.processing());
    try {
      final customers = await _repository.search(event.query);
      emit(AdminCustomersState.idle(customers: customers));
    } on Object catch (e, stackTrace) {
      emit(AdminCustomersState.error(error: e));
      onError(e, stackTrace);
    }
  }

  Future<void> _block(AdminCustomersEvent$Blocked event) async {
    try {
      if (event.blocked) {
        await _repository.block(event.id);
      } else {
        await _repository.unblock(event.id);
      }
      event.onSuccess();
    } on Object catch (e, stackTrace) {
      event.onError(e);
      onError(e, stackTrace);
    }
  }

  Future<void> _adjust(AdminCustomersEvent$Adjusted event) async {
    try {
      final points = await _repository.adjust(
        barcode: event.barcode,
        delta: event.delta,
        reason: event.reason,
      );
      event.onSuccess(points);
    } on Object catch (e, stackTrace) {
      event.onError(e);
      onError(e, stackTrace);
    }
  }
}
