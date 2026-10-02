import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:merch/src/core/rest_client/rest_client.dart';
import 'package:merch/src/core/utils/set_state_mixin.dart';
import 'package:merch/src/feature/receipt/bloc/receipt_event.dart';
import 'package:merch/src/feature/receipt/bloc/receipt_state.dart';
import 'package:merch/src/feature/receipt/data/receipt_repository.dart';

final class ReceiptBloc extends Bloc<ReceiptEvent, ReceiptState>
    with SetStateMixin {
  ReceiptBloc({required ReceiptRepository receiptRepository})
    : _receiptRepository = receiptRepository,
      super(const ReceiptState.idle()) {
    on<ReceiptEvent$Quote>(_quote, transformer: restartable());
    on<ReceiptEvent$Commit>(_commit);
  }

  final ReceiptRepository _receiptRepository;
  var _quoteSerial = 0;

  Future<void> _quote(
    ReceiptEvent$Quote event,
    Emitter<ReceiptState> emit,
  ) async {
    if (state.isCommitting) return;
    final serial = ++_quoteSerial;
    if (event.amountRub <= 0) {
      emit(const ReceiptState.idle());
      return;
    }
    emit(ReceiptState.quoting(quote: state.quote, amountRub: state.amountRub));
    try {
      final quote = await _receiptRepository.quote(
        barcode: event.barcode,
        amountRub: event.amountRub,
        requestedPoints: event.requestedPoints,
      );
      if (emit.isDone || serial != _quoteSerial || state.isCommitting) return;
      emit(ReceiptState.idle(quote: quote, amountRub: event.amountRub));
    } on Object catch (e, stackTrace) {
      if (emit.isDone || serial != _quoteSerial) return;
      emit(
        ReceiptState.idle(
          quote: state.quote,
          amountRub: state.amountRub,
          error: e,
          offline: e is ConnectionException,
        ),
      );
      onError(e, stackTrace);
    }
  }

  Future<void> _commit(
    ReceiptEvent$Commit event,
    Emitter<ReceiptState> emit,
  ) async {
    _quoteSerial++;
    emit(
      ReceiptState.committing(quote: state.quote, amountRub: state.amountRub),
    );
    try {
      final result = await _receiptRepository.commit(
        receiptId: event.receiptId,
        barcode: event.barcode,
        amountRub: event.amountRub,
        redeemPoints: event.redeemPoints,
      );
      emit(ReceiptState.idle(quote: state.quote, amountRub: state.amountRub));
      event.onSuccess(result);
    } on Object catch (e, stackTrace) {
      emit(
        ReceiptState.idle(
          quote: state.quote,
          amountRub: state.amountRub,
          error: e,
          offline: e is ConnectionException,
        ),
      );
      onError(e, stackTrace);
    }
  }
}
