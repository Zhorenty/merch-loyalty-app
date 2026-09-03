import 'dart:async';

abstract interface class TokenStorage<T> {
  Future<T?> load();

  Future<void> save(T tokenPair);

  Future<void> clear();

  Stream<T?> getStream();

  Future<void> close();
}
