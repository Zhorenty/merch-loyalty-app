import 'package:merch/src/core/model/models.dart';
import 'package:merch/src/feature/auth/data/auth_repository.dart';

sealed class AuthState {
  const AuthState({required this.status, this.session});

  final AuthenticationStatus status;
  final Session? session;

  const factory AuthState.idle({
    required AuthenticationStatus status,
    Session? session,
  }) = _AuthStateIdle;

  const factory AuthState.processing({
    required AuthenticationStatus status,
    Session? session,
  }) = _AuthStateProcessing;

  const factory AuthState.error({
    required AuthenticationStatus status,
    required Object error,
    Session? session,
  }) = _AuthStateError;

  Object? get error => switch (this) {
    final _AuthStateError e => e.error,
    _ => null,
  };

  bool get isProcessing => this is _AuthStateProcessing;
}

final class _AuthStateIdle extends AuthState {
  const _AuthStateIdle({required super.status, super.session});

  @override
  bool operator ==(Object other) =>
      other is _AuthStateIdle &&
      other.status == status &&
      other.session == session;

  @override
  int get hashCode => Object.hash(status, session);
}

final class _AuthStateProcessing extends AuthState {
  const _AuthStateProcessing({required super.status, super.session});

  @override
  bool operator ==(Object other) =>
      other is _AuthStateProcessing &&
      other.status == status &&
      other.session == session;

  @override
  int get hashCode => Object.hash(status, session);
}

final class _AuthStateError extends AuthState {
  const _AuthStateError({
    required this.error,
    required super.status,
    super.session,
  });

  @override
  final Object error;

  @override
  bool operator ==(Object other) =>
      other is _AuthStateError &&
      other.status == status &&
      other.error == error &&
      other.session == session;

  @override
  int get hashCode => Object.hash(status, error, session);
}
