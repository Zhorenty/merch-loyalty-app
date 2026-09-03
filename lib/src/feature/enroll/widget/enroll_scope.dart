import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:merch/src/core/model/models.dart';
import 'package:merch/src/core/utils/extensions/context_extension.dart';
import 'package:merch/src/feature/enroll/bloc/enroll_bloc.dart';
import 'package:merch/src/feature/enroll/bloc/enroll_event.dart';
import 'package:merch/src/feature/enroll/bloc/enroll_state.dart';
import 'package:merch/src/feature/initialization/widget/dependencies_scope.dart';

abstract interface class EnrollController {
  bool get isProcessing;

  EnrollResult? get result;

  void submit({
    String? name,
    String? phone,
    required void Function(EnrollResult result) onSuccess,
    required void Function(Object error) onError,
  });

  void reset();
}

class EnrollScope extends StatefulWidget {
  const EnrollScope({required this.child, super.key});

  final Widget child;

  static EnrollController of(BuildContext context, {bool listen = true}) =>
      context.inhOf<_EnrollInherited>(listen: listen).controller;

  @override
  State<EnrollScope> createState() => _EnrollScopeState();
}

class _EnrollScopeState extends State<EnrollScope> implements EnrollController {
  late final EnrollBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = EnrollBloc(
      enrollRepository: DependenciesScope.of(context).enrollRepository,
    );
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  bool get isProcessing => _bloc.state.isProcessing;

  @override
  EnrollResult? get result => _bloc.state.result;

  @override
  void submit({
    String? name,
    String? phone,
    required void Function(EnrollResult result) onSuccess,
    required void Function(Object error) onError,
  }) => _bloc.add(
    EnrollEvent.submit(
      name: name,
      phone: phone,
      onSuccess: onSuccess,
      onError: onError,
    ),
  );

  @override
  void reset() => _bloc.add(const EnrollEvent.reset());

  @override
  Widget build(BuildContext context) => BlocBuilder<EnrollBloc, EnrollState>(
    bloc: _bloc,
    builder: (context, state) => _EnrollInherited(
      controller: this,
      state: state,
      child: widget.child,
    ),
  );
}

final class _EnrollInherited extends InheritedWidget {
  const _EnrollInherited({
    required super.child,
    required this.controller,
    required this.state,
  });

  final EnrollController controller;
  final EnrollState state;

  @override
  bool updateShouldNotify(covariant _EnrollInherited oldWidget) =>
      state != oldWidget.state;
}
