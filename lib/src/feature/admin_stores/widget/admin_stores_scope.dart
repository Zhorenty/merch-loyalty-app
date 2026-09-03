import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:merch/src/core/utils/extensions/context_extension.dart';
import 'package:merch/src/feature/admin_stores/bloc/admin_stores_bloc.dart';
import 'package:merch/src/feature/admin_stores/bloc/admin_stores_event.dart';
import 'package:merch/src/feature/admin_stores/bloc/admin_stores_state.dart';
import 'package:merch/src/feature/initialization/widget/dependencies_scope.dart';

abstract interface class AdminStoresController {
  AdminStoresState get state;

  void refresh();

  void save({
    String? id,
    required String name,
    required String address,
    required void Function() onSuccess,
    required void Function(Object error) onError,
  });

  void delete({
    required String id,
    required void Function() onSuccess,
    required void Function(Object error) onError,
  });
}

class AdminStoresScope extends StatefulWidget {
  const AdminStoresScope({
    required this.child,
    this.autoload = true,
    super.key,
  });

  final Widget child;
  final bool autoload;

  static AdminStoresController of(BuildContext context, {bool listen = true}) =>
      context.inhOf<_AdminStoresInherited>(listen: listen).controller;

  @override
  State<AdminStoresScope> createState() => _AdminStoresScopeState();
}

class _AdminStoresScopeState extends State<AdminStoresScope>
    implements AdminStoresController {
  late final AdminStoresBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = AdminStoresBloc(
      repository: DependenciesScope.of(context).adminStoresRepository,
    );
    if (widget.autoload) {
      _bloc.add(const AdminStoresEvent.started());
    }
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  AdminStoresState get state => _bloc.state;

  @override
  void refresh() => _bloc.add(const AdminStoresEvent.started());

  @override
  void save({
    String? id,
    required String name,
    required String address,
    required void Function() onSuccess,
    required void Function(Object error) onError,
  }) => _bloc.add(
    AdminStoresEvent.saved(
      id: id,
      name: name,
      address: address,
      onSuccess: onSuccess,
      onError: onError,
    ),
  );

  @override
  void delete({
    required String id,
    required void Function() onSuccess,
    required void Function(Object error) onError,
  }) => _bloc.add(
    AdminStoresEvent.deleted(id: id, onSuccess: onSuccess, onError: onError),
  );

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<AdminStoresBloc, AdminStoresState>(
        bloc: _bloc,
        builder: (context, state) => _AdminStoresInherited(
          controller: this,
          state: state,
          child: widget.child,
        ),
      );
}

final class _AdminStoresInherited extends InheritedWidget {
  const _AdminStoresInherited({
    required super.child,
    required this.controller,
    required this.state,
  });

  final AdminStoresController controller;
  final AdminStoresState state;

  @override
  bool updateShouldNotify(covariant _AdminStoresInherited oldWidget) =>
      state != oldWidget.state;
}
