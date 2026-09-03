import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:merch/src/core/model/models.dart';
import 'package:merch/src/core/utils/extensions/context_extension.dart';
import 'package:merch/src/feature/initialization/widget/dependencies_scope.dart';
import 'package:merch/src/feature/receipt/bloc/receipt_bloc.dart';
import 'package:merch/src/feature/receipt/bloc/receipt_event.dart';
import 'package:merch/src/feature/receipt/bloc/receipt_state.dart';

abstract interface class ReceiptController {
  ReceiptState get state;

  void quote({
    required String barcode,
    required int amountRub,
    required int requestedPoints,
  });

  void commit({
    required String receiptId,
    required String barcode,
    required int amountRub,
    required int redeemPoints,
    required void Function(CommitResult result) onSuccess,
  });
}

class ReceiptScope extends StatefulWidget {
  const ReceiptScope({required this.child, super.key});

  final Widget child;

  static ReceiptController of(BuildContext context, {bool listen = true}) =>
      context.inhOf<_ReceiptInherited>(listen: listen).controller;

  @override
  State<ReceiptScope> createState() => _ReceiptScopeState();
}

class _ReceiptScopeState extends State<ReceiptScope>
    implements ReceiptController {
  late final ReceiptBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = ReceiptBloc(
      receiptRepository: DependenciesScope.of(context).receiptRepository,
    );
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  ReceiptState get state => _bloc.state;

  @override
  void quote({
    required String barcode,
    required int amountRub,
    required int requestedPoints,
  }) => _bloc.add(
    ReceiptEvent.quote(
      barcode: barcode,
      amountRub: amountRub,
      requestedPoints: requestedPoints,
    ),
  );

  @override
  void commit({
    required String receiptId,
    required String barcode,
    required int amountRub,
    required int redeemPoints,
    required void Function(CommitResult result) onSuccess,
  }) => _bloc.add(
    ReceiptEvent.commit(
      receiptId: receiptId,
      barcode: barcode,
      amountRub: amountRub,
      redeemPoints: redeemPoints,
      onSuccess: onSuccess,
    ),
  );

  @override
  Widget build(BuildContext context) => BlocBuilder<ReceiptBloc, ReceiptState>(
    bloc: _bloc,
    builder: (context, state) => _ReceiptInherited(
      controller: this,
      state: state,
      child: widget.child,
    ),
  );
}

final class _ReceiptInherited extends InheritedWidget {
  const _ReceiptInherited({
    required super.child,
    required this.controller,
    required this.state,
  });

  final ReceiptController controller;
  final ReceiptState state;

  @override
  bool updateShouldNotify(covariant _ReceiptInherited oldWidget) =>
      state != oldWidget.state;
}
