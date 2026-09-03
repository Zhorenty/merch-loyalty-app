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
    on<ReceiptEvent>(
      (event, emit) => switch (event) {
        final ReceiptEvent$Quote e => _quote(e, emit),
        final ReceiptEvent$Commit e => _commit(e, emit),
      },
    );
  }

  final ReceiptRepository _receiptRepository;

  Future<void> _quote(
    ReceiptEvent$Quote event,
    Emitter<ReceiptState> emit,
  ) async {
    if (event.amountRub <= 0) {
      emit(const ReceiptState.idle());
      return;
    }
    emit(ReceiptState.quoting(quote: state.quote));
    try {
      final quote = await _receiptRepository.quote(
        barcode: event.barcode,
        amountRub: event.amountRub,
        requestedPoints: event.requestedPoints,
      );
      emit(ReceiptState.idle(quote: quote));
    } on Object catch (e, stackTrace) {
      emit(
        ReceiptState.idle(error: e, offline: e is ConnectionException),
      );
      onError(e, stackTrace);
    }
  }

  Future<void> _commit(
    ReceiptEvent$Commit event,
    Emitter<ReceiptState> emit,
  ) async {
    emit(ReceiptState.committing(quote: state.quote));
    try {
      final result = await _receiptRepository.commit(
        receiptId: event.receiptId,
        barcode: event.barcode,
        amountRub: event.amountRub,
        redeemPoints: event.redeemPoints,
      );
      emit(ReceiptState.idle(quote: state.quote));
      event.onSuccess(result);
    } on Object catch (e, stackTrace) {
      emit(
        ReceiptState.idle(
          quote: state.quote,
          error: e,
          offline: e is ConnectionException,
        ),
      );
      onError(e, stackTrace);
    }
  }
}
