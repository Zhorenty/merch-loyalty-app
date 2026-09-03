import 'package:merch/src/core/model/models.dart';

sealed class AdminStaffState {
  const AdminStaffState();

  const factory AdminStaffState.processing() = AdminStaffState$Processing;

  const factory AdminStaffState.idle({required List<StaffRow> staff}) =
      AdminStaffState$Idle;

  const factory AdminStaffState.error({required Object error}) =
      AdminStaffState$Error;

  bool get isProcessing => this is AdminStaffState$Processing;

  List<StaffRow> get staff => switch (this) {
    final AdminStaffState$Idle s => s.staff,
    _ => const [],
  };

  Object? get error => switch (this) {
    final AdminStaffState$Error e => e.error,
    _ => null,
  };
}

final class AdminStaffState$Processing extends AdminStaffState {
  const AdminStaffState$Processing();
}

final class AdminStaffState$Idle extends AdminStaffState {
  const AdminStaffState$Idle({required this.staff});

  @override
  final List<StaffRow> staff;
}

final class AdminStaffState$Error extends AdminStaffState {
  const AdminStaffState$Error({required this.error});

  @override
  final Object error;
}
