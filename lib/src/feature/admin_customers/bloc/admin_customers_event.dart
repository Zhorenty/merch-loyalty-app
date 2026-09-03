sealed class AdminCustomersEvent {
  const AdminCustomersEvent();

  const factory AdminCustomersEvent.searched(String query) =
      AdminCustomersEvent$Searched;

  const factory AdminCustomersEvent.blocked({
    required String id,
    required bool blocked,
    required void Function() onSuccess,
    required void Function(Object error) onError,
  }) = AdminCustomersEvent$Blocked;

  const factory AdminCustomersEvent.adjusted({
    required String barcode,
    required int delta,
    required String reason,
    required void Function(int points) onSuccess,
    required void Function(Object error) onError,
  }) = AdminCustomersEvent$Adjusted;
}

final class AdminCustomersEvent$Searched extends AdminCustomersEvent {
  const AdminCustomersEvent$Searched(this.query);

  final String query;
}

final class AdminCustomersEvent$Blocked extends AdminCustomersEvent {
  const AdminCustomersEvent$Blocked({
    required this.id,
    required this.blocked,
    required this.onSuccess,
    required this.onError,
  });

  final String id;
  final bool blocked;
  final void Function() onSuccess;
  final void Function(Object error) onError;
}

final class AdminCustomersEvent$Adjusted extends AdminCustomersEvent {
  const AdminCustomersEvent$Adjusted({
    required this.barcode,
    required this.delta,
    required this.reason,
    required this.onSuccess,
    required this.onError,
  });

  final String barcode;
  final int delta;
  final String reason;
  final void Function(int points) onSuccess;
  final void Function(Object error) onError;
}
