import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:merch/src/core/utils/extensions/context_extension.dart';
import 'package:merch/src/feature/initialization/widget/dependencies_scope.dart';
import 'package:merch/src/feature/shift/bloc/shift_bloc.dart';
import 'package:merch/src/feature/shift/bloc/shift_event.dart';
import 'package:merch/src/feature/shift/bloc/shift_state.dart';

abstract interface class ShiftController {
  ShiftState get state;

  void refresh();

  void refund({
    required String receiptId,
    required void Function() onSuccess,
    required void Function(Object error) onError,
  });
}

class ShiftScope extends StatefulWidget {
  const ShiftScope({required this.child, super.key});

  final Widget child;

  static ShiftController of(BuildContext context, {bool listen = true}) =>
      context.inhOf<_ShiftInherited>(listen: listen).controller;

  @override
  State<ShiftScope> createState() => _ShiftScopeState();
}

class _ShiftScopeState extends State<ShiftScope> implements ShiftController {
  late final ShiftBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = ShiftBloc(
      shiftRepository: DependenciesScope.of(context).shiftRepository,
    )..add(const ShiftEvent.started());
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  ShiftState get state => _bloc.state;

  @override
  void refresh() => _bloc.add(const ShiftEvent.started());

  @override
  void refund({
    required String receiptId,
    required void Function() onSuccess,
    required void Function(Object error) onError,
  }) => _bloc.add(
    ShiftEvent.refunded(
      receiptId: receiptId,
      onSuccess: onSuccess,
      onError: onError,
    ),
  );

  @override
  Widget build(BuildContext context) => BlocBuilder<ShiftBloc, ShiftState>(
    bloc: _bloc,
    builder: (context, state) => _ShiftInherited(
      controller: this,
      state: state,
      child: widget.child,
    ),
  );
}

final class _ShiftInherited extends InheritedWidget {
  const _ShiftInherited({
    required super.child,
    required this.controller,
    required this.state,
  });

  final ShiftController controller;
  final ShiftState state;

  @override
  bool updateShouldNotify(covariant _ShiftInherited oldWidget) =>
      state != oldWidget.state;
}
