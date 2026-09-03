import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:merch/src/core/router/redirect_builder.dart';
import 'package:merch/src/feature/auth/data/auth_repository.dart';
import 'package:merch/src/feature/auth/widget/auth_scope.dart';

final class RedirectIfAuthenticatedGuard extends Guard {
  @override
  Pattern get matchPattern => RegExp(r'^/auth$');

  @override
  String? redirect(BuildContext context, GoRouterState state) {
    final auth = AuthScope.of(context);
    if (auth.status == AuthenticationStatus.authenticated) {
      return auth.isAdmin ? '/admin/customers' : '/scan';
    }
    return null;
  }
}

final class RedirectIfUnauthenticatedGuard extends Guard {
  @override
  Pattern get matchPattern => RegExp(r'^/auth$');

  @override
  bool get invertRedirect => true;

  @override
  String? redirect(BuildContext context, GoRouterState state) {
    final auth = AuthScope.of(context);
    if (auth.status == AuthenticationStatus.unauthenticated) {
      return '/auth';
    }
    return null;
  }
}

final class RedirectIfNotAdminGuard extends Guard {
  @override
  Pattern get matchPattern => RegExp(r'^/admin');

  @override
  String? redirect(BuildContext context, GoRouterState state) {
    final auth = AuthScope.of(context);
    if (auth.status == AuthenticationStatus.authenticated && !auth.isAdmin) {
      return '/scan';
    }
    return null;
  }
}
