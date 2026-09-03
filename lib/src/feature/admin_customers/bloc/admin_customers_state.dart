import 'package:merch/src/core/model/models.dart';

sealed class AdminCustomersState {
  const AdminCustomersState();

  const factory AdminCustomersState.processing() =
      AdminCustomersState$Processing;

  const factory AdminCustomersState.idle({
    required List<AdminCustomer> customers,
  }) = AdminCustomersState$Idle;

  const factory AdminCustomersState.error({required Object error}) =
      AdminCustomersState$Error;

  bool get isProcessing => this is AdminCustomersState$Processing;

  List<AdminCustomer> get customers => switch (this) {
    final AdminCustomersState$Idle s => s.customers,
    _ => const [],
  };

  Object? get error => switch (this) {
    final AdminCustomersState$Error e => e.error,
    _ => null,
  };
}

final class AdminCustomersState$Processing extends AdminCustomersState {
  const AdminCustomersState$Processing();
}

final class AdminCustomersState$Idle extends AdminCustomersState {
  const AdminCustomersState$Idle({required this.customers});

  @override
  final List<AdminCustomer> customers;
}

final class AdminCustomersState$Error extends AdminCustomersState {
  const AdminCustomersState$Error({required this.error});

  @override
  final Object error;
}
