import 'package:dio/dio.dart';
import '../rest_client.dart';

/// {@template rest_client_dio}
/// Rest client that uses [Dio] as HTTP library.
/// {@endtemplate}
final class RestClientDio extends RestClientBase {
  RestClientDio({required super.baseUrl, required Dio dio}) : _dio = dio;

  final Dio _dio;

  @override
  Future<Map<String, Object?>?> send({
    required String path,
    required String method,
    Map<String, Object?>? body,
    Map<String, Object?>? headers,
    Map<String, String?>? queryParams,
  }) async {
    try {
      final uri = buildUri(path: path, queryParams: queryParams);
      final options = Options(
        headers: headers,
        method: method,
        contentType: 'application/json',
        responseType: ResponseType.json,
      );

      final response = await _dio.request<Object>(
        uri.toString(),
        data: body,
        options: options,
      );

      return decodeResponse(response.data, statusCode: response.statusCode);
    } on RestClientException {
      rethrow;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        Error.throwWithStackTrace(
          ConnectionException(
            message: 'ConnectionException',
            statusCode: e.response?.statusCode,
            cause: e,
          ),
          e.stackTrace,
        );
      }
      if (e.response != null) {
        final result = await decodeResponse(
          e.response?.data,
          statusCode: e.response?.statusCode,
        );
        return result;
      }
      Error.throwWithStackTrace(
        ClientException(
          message: e.toString(),
          statusCode: e.response?.statusCode,
          cause: e,
        ),
        e.stackTrace,
      );
    } on Object catch (e, stack) {
      Error.throwWithStackTrace(
        ClientException(message: e.toString(), cause: e),
        stack,
      );
    }
  }
}
