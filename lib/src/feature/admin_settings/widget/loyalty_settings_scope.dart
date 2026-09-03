import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:merch/src/core/utils/extensions/context_extension.dart';
import 'package:merch/src/feature/admin_settings/bloc/loyalty_settings_bloc.dart';
import 'package:merch/src/feature/admin_settings/bloc/loyalty_settings_event.dart';
import 'package:merch/src/feature/admin_settings/bloc/loyalty_settings_state.dart';
import 'package:merch/src/feature/initialization/widget/dependencies_scope.dart';

abstract interface class LoyaltySettingsController {
  LoyaltySettingsState get state;

  void refresh();

  void save({
    required Map<String, String> settings,
    required void Function() onSuccess,
    required void Function(Object error) onError,
  });
}

class LoyaltySettingsScope extends StatefulWidget {
  const LoyaltySettingsScope({required this.child, super.key});

  final Widget child;

  static LoyaltySettingsController of(
    BuildContext context, {
    bool listen = true,
  }) => context.inhOf<_LoyaltyInherited>(listen: listen).controller;

  @override
  State<LoyaltySettingsScope> createState() => _LoyaltySettingsScopeState();
}

class _LoyaltySettingsScopeState extends State<LoyaltySettingsScope>
    implements LoyaltySettingsController {
  late final LoyaltySettingsBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = LoyaltySettingsBloc(
      repository: DependenciesScope.of(context).loyaltySettingsRepository,
    )..add(const LoyaltySettingsEvent.started());
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  LoyaltySettingsState get state => _bloc.state;

  @override
  void refresh() => _bloc.add(const LoyaltySettingsEvent.started());

  @override
  void save({
    required Map<String, String> settings,
    required void Function() onSuccess,
    required void Function(Object error) onError,
  }) => _bloc.add(
    LoyaltySettingsEvent.saved(
      settings: settings,
      onSuccess: onSuccess,
      onError: onError,
    ),
  );

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<LoyaltySettingsBloc, LoyaltySettingsState>(
        bloc: _bloc,
        builder: (context, state) => _LoyaltyInherited(
          controller: this,
          state: state,
          child: widget.child,
        ),
      );
}

final class _LoyaltyInherited extends InheritedWidget {
  const _LoyaltyInherited({
    required super.child,
    required this.controller,
    required this.state,
  });

  final LoyaltySettingsController controller;
  final LoyaltySettingsState state;

  @override
  bool updateShouldNotify(covariant _LoyaltyInherited oldWidget) =>
      state != oldWidget.state;
}
