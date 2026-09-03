sealed class AdminStoresEvent {
  const AdminStoresEvent();

  const factory AdminStoresEvent.started() = AdminStoresEvent$Started;

  const factory AdminStoresEvent.saved({
    String? id,
    required String name,
    required String address,
    required void Function() onSuccess,
    required void Function(Object error) onError,
  }) = AdminStoresEvent$Saved;

  const factory AdminStoresEvent.deleted({
    required String id,
    required void Function() onSuccess,
    required void Function(Object error) onError,
  }) = AdminStoresEvent$Deleted;
}

final class AdminStoresEvent$Started extends AdminStoresEvent {
  const AdminStoresEvent$Started();
}

final class AdminStoresEvent$Saved extends AdminStoresEvent {
  const AdminStoresEvent$Saved({
    this.id,
    required this.name,
    required this.address,
    required this.onSuccess,
    required this.onError,
  });

  final String? id;
  final String name;
  final String address;
  final void Function() onSuccess;
  final void Function(Object error) onError;
}

final class AdminStoresEvent$Deleted extends AdminStoresEvent {
  const AdminStoresEvent$Deleted({
    required this.id,
    required this.onSuccess,
    required this.onError,
  });

  final String id;
  final void Function() onSuccess;
  final void Function(Object error) onError;
}
