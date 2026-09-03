import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:merch/src/core/utils/extensions/context_extension.dart';
import 'package:merch/src/feature/admin_staff/bloc/admin_staff_bloc.dart';
import 'package:merch/src/feature/admin_staff/bloc/admin_staff_event.dart';
import 'package:merch/src/feature/admin_staff/bloc/admin_staff_state.dart';
import 'package:merch/src/feature/initialization/widget/dependencies_scope.dart';

abstract interface class AdminStaffController {
  AdminStaffState get state;

  void refresh();

  void create({
    required String login,
    required String name,
    required String password,
    required String role,
    required void Function() onSuccess,
    required void Function(Object error) onError,
  });

  void update({
    required String id,
    required String login,
    required String name,
    required String password,
    required String role,
    required bool active,
    required void Function() onSuccess,
    required void Function(Object error) onError,
  });
}

class AdminStaffScope extends StatefulWidget {
  const AdminStaffScope({
    required this.child,
    this.autoload = true,
    super.key,
  });

  final Widget child;
  final bool autoload;

  static AdminStaffController of(BuildContext context, {bool listen = true}) =>
      context.inhOf<_AdminStaffInherited>(listen: listen).controller;

  @override
  State<AdminStaffScope> createState() => _AdminStaffScopeState();
}

class _AdminStaffScopeState extends State<AdminStaffScope>
    implements AdminStaffController {
  late final AdminStaffBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = AdminStaffBloc(
      repository: DependenciesScope.of(context).adminStaffRepository,
    );
    if (widget.autoload) {
      _bloc.add(const AdminStaffEvent.started());
    }
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  AdminStaffState get state => _bloc.state;

  @override
  void refresh() => _bloc.add(const AdminStaffEvent.started());

  @override
  void create({
    required String login,
    required String name,
    required String password,
    required String role,
    required void Function() onSuccess,
    required void Function(Object error) onError,
  }) => _bloc.add(
    AdminStaffEvent.created(
      login: login,
      name: name,
      password: password,
      role: role,
      onSuccess: onSuccess,
      onError: onError,
    ),
  );

  @override
  void update({
    required String id,
    required String login,
    required String name,
    required String password,
    required String role,
    required bool active,
    required void Function() onSuccess,
    required void Function(Object error) onError,
  }) => _bloc.add(
    AdminStaffEvent.updated(
      id: id,
      login: login,
      name: name,
      password: password,
      role: role,
      active: active,
      onSuccess: onSuccess,
      onError: onError,
    ),
  );

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<AdminStaffBloc, AdminStaffState>(
        bloc: _bloc,
        builder: (context, state) => _AdminStaffInherited(
          controller: this,
          state: state,
          child: widget.child,
        ),
      );
}

final class _AdminStaffInherited extends InheritedWidget {
  const _AdminStaffInherited({
    required super.child,
    required this.controller,
    required this.state,
  });

  final AdminStaffController controller;
  final AdminStaffState state;

  @override
  bool updateShouldNotify(covariant _AdminStaffInherited oldWidget) =>
      state != oldWidget.state;
}
