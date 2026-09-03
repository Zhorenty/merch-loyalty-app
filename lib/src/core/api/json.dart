import '/src/core/rest_client/rest_client.dart';

String apiMessage(Object error) {
  if (error is ConnectionException) {
    return 'Нет связи. Проверь интернет и попробуй снова.';
  }
  if (error is StructuredBackendException) {
    return error.backendMessage;
  }
  if (error is RestClientException) {
    return error.message;
  }
  return 'Что-то пошло не так. Попробуй ещё раз.';
}

int asInt(Object? value) => switch (value) {
  final int i => i,
  final num n => n.toInt(),
  final String s => int.tryParse(s) ?? 0,
  _ => 0,
};

bool asBool(Object? value) => value == true;

String asString(Object? value) => value?.toString() ?? '';

Map<String, Object?> asMap(Object? value) {
  if (value is Map<String, Object?>) return value;
  if (value is Map) {
    return value.map((key, val) => MapEntry(key.toString(), val));
  }
  return {};
}

List<Object?> asList(Object? value) {
  if (value is List<Object?>) return value;
  if (value is List) return List<Object?>.from(value);
  return const [];
}
