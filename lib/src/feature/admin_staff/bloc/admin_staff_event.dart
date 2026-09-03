sealed class AdminStaffEvent {
  const AdminStaffEvent();

  const factory AdminStaffEvent.started() = AdminStaffEvent$Started;

  const factory AdminStaffEvent.created({
    required String login,
    required String name,
    required String password,
    required String role,
    required void Function() onSuccess,
    required void Function(Object error) onError,
  }) = AdminStaffEvent$Created;

  const factory AdminStaffEvent.updated({
    required String id,
    required String login,
    required String name,
    required String password,
    required String role,
    required bool active,
    required void Function() onSuccess,
    required void Function(Object error) onError,
  }) = AdminStaffEvent$Updated;
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
    required this.onSuccess,
    required this.onError,
  });

  final String login;
  final String name;
  final String password;
  final String role;
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
    required this.active,
    required this.onSuccess,
    required this.onError,
  });

  final String id;
  final String login;
  final String name;
  final String password;
  final String role;
  final bool active;
  final void Function() onSuccess;
  final void Function(Object error) onError;
}
