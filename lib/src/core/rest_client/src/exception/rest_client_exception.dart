import 'package:meta/meta.dart';

@immutable
abstract base class RestClientException implements Exception {
  const RestClientException({
    required this.message,
    this.statusCode,
    this.cause,
  });

  final String message;
  final int? statusCode;
  final Object? cause;
}

final class ClientException extends RestClientException {
  const ClientException({
    required super.message,
    super.statusCode,
    super.cause,
  });

  @override
  String toString() =>
      'ClientException(message: $message, statusCode: $statusCode, cause: $cause)';
}

final class StructuredBackendException extends RestClientException {
  const StructuredBackendException({required this.error, super.statusCode})
    : super(message: 'Backend returned structured error');

  final Map<String, Object?> error;

  String get code => error['code']?.toString() ?? '';

  String get backendMessage => error['message']?.toString() ?? 'Ошибка сервера';

  @override
  String toString() =>
      'StructuredBackendException(error: $error, statusCode: $statusCode)';
}

final class WrongResponseTypeException extends RestClientException {
  const WrongResponseTypeException({required super.message, super.statusCode});

  @override
  String toString() =>
      'WrongResponseTypeException(message: $message, statusCode: $statusCode)';
}

final class ConnectionException extends RestClientException {
  const ConnectionException({
    required super.message,
    super.statusCode,
    super.cause,
  });

  @override
  String toString() =>
      'ConnectionException(message: $message, statusCode: $statusCode)';
}

final class InternalServerException extends RestClientException {
  const InternalServerException({
    required super.message,
    super.statusCode,
    super.cause,
  });

  @override
  String toString() =>
      'InternalServerException(message: $message, statusCode: $statusCode)';
}
