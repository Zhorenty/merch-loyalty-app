import 'dart:async';

abstract interface class AuthorizationClient<T> {
  Future<bool> isRefreshTokenValid(T token);

  Future<bool> isAccessTokenValid(T token);

  Future<T> refresh(T token);
}

class RevokeTokenException implements Exception {
  const RevokeTokenException(this.message);

  final String message;

  @override
  String toString() => 'RevokeTokenException: $message';
}
