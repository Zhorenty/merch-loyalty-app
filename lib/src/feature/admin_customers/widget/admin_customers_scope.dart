import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:merch/src/core/utils/extensions/context_extension.dart';
import 'package:merch/src/feature/admin_customers/bloc/admin_customers_bloc.dart';
import 'package:merch/src/feature/admin_customers/bloc/admin_customers_event.dart';
import 'package:merch/src/feature/admin_customers/bloc/admin_customers_state.dart';
import 'package:merch/src/feature/initialization/widget/dependencies_scope.dart';

abstract interface class AdminCustomersController {
  AdminCustomersState get state;

  void search(String query);

  void setBlocked({
    required String id,
    required bool blocked,
    required void Function() onSuccess,
    required void Function(Object error) onError,
  });

  void adjust({
    required String barcode,
    required int delta,
    required String reason,
    required void Function(int points) onSuccess,
    required void Function(Object error) onError,
  });
}

class AdminCustomersScope extends StatefulWidget {
  const AdminCustomersScope({
    required this.child,
    this.autoload = true,
    super.key,
  });

  final Widget child;
  final bool autoload;

  static AdminCustomersController of(
    BuildContext context, {
    bool listen = true,
  }) => context.inhOf<_AdminCustomersInherited>(listen: listen).controller;

  @override
  State<AdminCustomersScope> createState() => _AdminCustomersScopeState();
}

class _AdminCustomersScopeState extends State<AdminCustomersScope>
    implements AdminCustomersController {
  late final AdminCustomersBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = AdminCustomersBloc(
      repository: DependenciesScope.of(context).adminCustomersRepository,
    );
    if (widget.autoload) {
      _bloc.add(const AdminCustomersEvent.searched(''));
    }
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  AdminCustomersState get state => _bloc.state;

  @override
  void search(String query) =>
      _bloc.add(AdminCustomersEvent.searched(query));

  @override
  void setBlocked({
    required String id,
    required bool blocked,
    required void Function() onSuccess,
    required void Function(Object error) onError,
  }) => _bloc.add(
    AdminCustomersEvent.blocked(
      id: id,
      blocked: blocked,
      onSuccess: onSuccess,
      onError: onError,
    ),
  );

  @override
  void adjust({
    required String barcode,
    required int delta,
    required String reason,
    required void Function(int points) onSuccess,
    required void Function(Object error) onError,
  }) => _bloc.add(
    AdminCustomersEvent.adjusted(
      barcode: barcode,
      delta: delta,
      reason: reason,
      onSuccess: onSuccess,
      onError: onError,
    ),
  );

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<AdminCustomersBloc, AdminCustomersState>(
        bloc: _bloc,
        builder: (context, state) => _AdminCustomersInherited(
          controller: this,
          state: state,
          child: widget.child,
        ),
      );
}

final class _AdminCustomersInherited extends InheritedWidget {
  const _AdminCustomersInherited({
    required super.child,
    required this.controller,
    required this.state,
  });

  final AdminCustomersController controller;
  final AdminCustomersState state;

  @override
  bool updateShouldNotify(covariant _AdminCustomersInherited oldWidget) =>
      state != oldWidget.state;
}
