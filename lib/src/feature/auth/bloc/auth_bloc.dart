import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:merch/src/core/utils/set_state_mixin.dart';
import 'package:merch/src/feature/auth/bloc/auth_event.dart';
import 'package:merch/src/feature/auth/bloc/auth_state.dart';
import 'package:merch/src/feature/auth/data/auth_repository.dart';

final class AuthBloc extends Bloc<AuthEvent, AuthState> with SetStateMixin {
  AuthBloc(super.initialState, {required AuthRepository authRepository})
    : _authRepository = authRepository {
    on<AuthEvent>(
      (event, emit) => switch (event) {
        final AuthEvent$SignIn e => _signIn(e, emit),
        final AuthEvent$SignOut e => _signOut(e, emit),
      },
    );

    authRepository.authStatus.listen((status) {
      final next = AuthState.idle(
        status: status,
        session: status == AuthenticationStatus.authenticated
            ? _authRepository.session
            : null,
      );
      if (next.status != state.status || next.session != state.session) {
        setState(next);
      }
    });
  }

  final AuthRepository _authRepository;

  Future<void> _signIn(AuthEvent$SignIn event, Emitter<AuthState> emit) async {
    emit(AuthState.processing(status: state.status, session: state.session));
    try {
      await _authRepository.signIn(login: event.login, secret: event.secret);
      emit(
        AuthState.idle(
          status: AuthenticationStatus.authenticated,
          session: _authRepository.session,
        ),
      );
    } on Object catch (e, stackTrace) {
      emit(
        AuthState.error(status: AuthenticationStatus.unauthenticated, error: e),
      );
      event.onError(e);
      onError(e, stackTrace);
    }
  }

  Future<void> _signOut(
    AuthEvent$SignOut event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthState.processing(status: state.status, session: state.session));
    try {
      await _authRepository.signOut();
    } on Object catch (e, stackTrace) {
      onError(e, stackTrace);
    }
    emit(const AuthState.idle(status: AuthenticationStatus.unauthenticated));
  }
}
