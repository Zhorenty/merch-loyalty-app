import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:merch/src/core/model/models.dart';
import 'package:merch/src/core/utils/extensions/context_extension.dart';
import 'package:merch/src/feature/auth/bloc/auth_bloc.dart';
import 'package:merch/src/feature/auth/bloc/auth_event.dart';
import 'package:merch/src/feature/auth/bloc/auth_state.dart';
import 'package:merch/src/feature/auth/data/auth_repository.dart';
import 'package:merch/src/feature/initialization/widget/dependencies_scope.dart';

abstract interface class AuthController {
  AuthenticationStatus get status;

  Session? get session;

  bool get isAdmin;

  bool get isProcessing;

  Object? get error;

  void signIn({
    required String login,
    required String secret,
    required void Function(Object) onError,
  });

  void signOut();
}

class AuthScope extends StatefulWidget {
  const AuthScope({required this.child, super.key});

  final Widget child;

  static AuthController of(BuildContext context, {bool listen = true}) =>
      context.inhOf<_AuthInherited>(listen: listen).controller;

  @override
  State<AuthScope> createState() => _AuthScopeState();
}

class _AuthScopeState extends State<AuthScope> implements AuthController {
  late final AuthBloc _authBloc;
  late AuthState _state;

  @override
  void initState() {
    super.initState();
    _authBloc = DependenciesScope.of(context).authBloc;
    _state = _authBloc.state;
  }

  @override
  AuthenticationStatus get status => _state.status;

  @override
  Session? get session => _state.session;

  @override
  bool get isAdmin => _state.session?.isAdmin ?? false;

  @override
  bool get isProcessing => _state.isProcessing;

  @override
  Object? get error => _state.error;

  @override
  void signIn({
    required String login,
    required String secret,
    required void Function(Object) onError,
  }) => _authBloc.add(
    AuthEvent.signIn(login: login, secret: secret, onError: onError),
  );

  @override
  void signOut() => _authBloc.add(const AuthEvent.signOut());

  @override
  Widget build(BuildContext context) => BlocBuilder<AuthBloc, AuthState>(
    bloc: _authBloc,
    builder: (context, state) {
      _state = state;
      return _AuthInherited(
        controller: this,
        state: state,
        child: widget.child,
      );
    },
  );
}

final class _AuthInherited extends InheritedWidget {
  const _AuthInherited({
    required super.child,
    required this.controller,
    required this.state,
  });

  final AuthController controller;
  final AuthState state;

  @override
  bool updateShouldNotify(covariant _AuthInherited oldWidget) =>
      state != oldWidget.state;
}
