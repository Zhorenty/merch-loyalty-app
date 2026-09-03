import 'package:merch/src/core/model/models.dart';

sealed class ScanEvent {
  const ScanEvent();

  const factory ScanEvent.lookup({
    required String barcode,
    required void Function(LookupCustomer customer) onSuccess,
    required void Function(Object error) onError,
  }) = ScanEvent$Lookup;
}

final class ScanEvent$Lookup extends ScanEvent {
  const ScanEvent$Lookup({
    required this.barcode,
    required this.onSuccess,
    required this.onError,
  });

  final String barcode;
  final void Function(LookupCustomer customer) onSuccess;
  final void Function(Object error) onError;
}
