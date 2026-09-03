sealed class AuthEvent {
  const AuthEvent();

  const factory AuthEvent.signIn({
    required String login,
    required String secret,
    required void Function(Object) onError,
  }) = AuthEvent$SignIn;

  const factory AuthEvent.signOut() = AuthEvent$SignOut;
}

final class AuthEvent$SignIn extends AuthEvent {
  const AuthEvent$SignIn({
    required this.login,
    required this.secret,
    required this.onError,
  });

  final String login;
  final String secret;
  final void Function(Object) onError;
}

final class AuthEvent$SignOut extends AuthEvent {
  const AuthEvent$SignOut();
}
