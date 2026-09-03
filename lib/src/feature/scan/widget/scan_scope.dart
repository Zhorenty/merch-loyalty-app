import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:merch/src/core/model/models.dart';
import 'package:merch/src/core/utils/extensions/context_extension.dart';
import 'package:merch/src/feature/initialization/widget/dependencies_scope.dart';
import 'package:merch/src/feature/scan/bloc/scan_bloc.dart';
import 'package:merch/src/feature/scan/bloc/scan_event.dart';
import 'package:merch/src/feature/scan/bloc/scan_state.dart';

abstract interface class ScanController {
  bool get isProcessing;

  void lookup({
    required String barcode,
    required void Function(LookupCustomer customer) onSuccess,
    required void Function(Object error) onError,
  });
}

class ScanScope extends StatefulWidget {
  const ScanScope({required this.child, super.key});

  final Widget child;

  static ScanController of(BuildContext context, {bool listen = true}) =>
      context.inhOf<_ScanInherited>(listen: listen).controller;

  @override
  State<ScanScope> createState() => _ScanScopeState();
}

class _ScanScopeState extends State<ScanScope> implements ScanController {
  late final ScanBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = ScanBloc(
      scanRepository: DependenciesScope.of(context).scanRepository,
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
  void lookup({
    required String barcode,
    required void Function(LookupCustomer customer) onSuccess,
    required void Function(Object error) onError,
  }) => _bloc.add(
    ScanEvent.lookup(
      barcode: barcode,
      onSuccess: onSuccess,
      onError: onError,
    ),
  );

  @override
  Widget build(BuildContext context) => BlocBuilder<ScanBloc, ScanState>(
    bloc: _bloc,
    builder: (context, state) => _ScanInherited(
      controller: this,
      state: state,
      child: widget.child,
    ),
  );
}

final class _ScanInherited extends InheritedWidget {
  const _ScanInherited({
    required super.child,
    required this.controller,
    required this.state,
  });

  final ScanController controller;
  final ScanState state;

  @override
  bool updateShouldNotify(covariant _ScanInherited oldWidget) =>
      state != oldWidget.state;
}
