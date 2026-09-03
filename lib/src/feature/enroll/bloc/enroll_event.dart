import 'package:merch/src/core/model/models.dart';

sealed class EnrollEvent {
  const EnrollEvent();

  const factory EnrollEvent.submit({
    String? name,
    String? phone,
    required void Function(EnrollResult result) onSuccess,
    required void Function(Object error) onError,
  }) = EnrollEvent$Submit;

  const factory EnrollEvent.reset() = EnrollEvent$Reset;
}

final class EnrollEvent$Submit extends EnrollEvent {
  const EnrollEvent$Submit({
    this.name,
    this.phone,
    required this.onSuccess,
    required this.onError,
  });

  final String? name;
  final String? phone;
  final void Function(EnrollResult result) onSuccess;
  final void Function(Object error) onError;
}

final class EnrollEvent$Reset extends EnrollEvent {
  const EnrollEvent$Reset();
}
