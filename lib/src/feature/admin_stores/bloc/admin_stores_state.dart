import 'package:merch/src/core/model/models.dart';

sealed class AdminStoresState {
  const AdminStoresState();

  const factory AdminStoresState.processing() = AdminStoresState$Processing;

  const factory AdminStoresState.idle({required List<StoreLocation> stores}) =
      AdminStoresState$Idle;

  const factory AdminStoresState.error({required Object error}) =
      AdminStoresState$Error;

  bool get isProcessing => this is AdminStoresState$Processing;

  List<StoreLocation> get stores => switch (this) {
    final AdminStoresState$Idle s => s.stores,
    _ => const [],
  };

  Object? get error => switch (this) {
    final AdminStoresState$Error e => e.error,
    _ => null,
  };
}

final class AdminStoresState$Processing extends AdminStoresState {
  const AdminStoresState$Processing();
}

final class AdminStoresState$Idle extends AdminStoresState {
  const AdminStoresState$Idle({required this.stores});

  @override
  final List<StoreLocation> stores;
}

final class AdminStoresState$Error extends AdminStoresState {
  const AdminStoresState$Error({required this.error});

  @override
  final Object error;
}
