sealed class AdminStaffEvent {
  const AdminStaffEvent();

  const factory AdminStaffEvent.started() = AdminStaffEvent$Started;

  const factory AdminStaffEvent.created({
    required String login,
    required String name,
    required String password,
    required String role,
    required String storeId,
    required void Function() onSuccess,
    required void Function(Object error) onError,
  }) = AdminStaffEvent$Created;

  const factory AdminStaffEvent.updated({
    required String id,
    required String login,
    required String name,
    required String password,
    required String role,
    required String storeId,
    required void Function() onSuccess,
    required void Function(Object error) onError,
  }) = AdminStaffEvent$Updated;

  const factory AdminStaffEvent.deleted({
    required String id,
    required void Function() onSuccess,
    required void Function(Object error) onError,
  }) = AdminStaffEvent$Deleted;
}

final class AdminStaffEvent$Started extends AdminStaffEvent {
  const AdminStaffEvent$Started();
}

final class AdminStaffEvent$Created extends AdminStaffEvent {
  const AdminStaffEvent$Created({
    required this.login,
    required this.name,
    required this.password,
    required this.role,
    required this.storeId,
    required this.onSuccess,
    required this.onError,
  });

  final String login;
  final String name;
  final String password;
  final String role;
  final String storeId;
  final void Function() onSuccess;
  final void Function(Object error) onError;
}

final class AdminStaffEvent$Updated extends AdminStaffEvent {
  const AdminStaffEvent$Updated({
    required this.id,
    required this.login,
    required this.name,
    required this.password,
    required this.role,
    required this.storeId,
    required this.onSuccess,
    required this.onError,
  });

  final String id;
  final String login;
  final String name;
  final String password;
  final String role;
  final String storeId;
  final void Function() onSuccess;
  final void Function(Object error) onError;
}

final class AdminStaffEvent$Deleted extends AdminStaffEvent {
  const AdminStaffEvent$Deleted({
    required this.id,
    required this.onSuccess,
    required this.onError,
  });

  final String id;
  final void Function() onSuccess;
  final void Function(Object error) onError;
}
