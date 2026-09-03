import 'dart:async';
import 'dart:convert';
import 'dart:isolate';

import 'package:meta/meta.dart';
import '/src/core/rest_client/rest_client.dart';

/// {@macro rest_client}
@immutable
abstract base class RestClientBase implements RestClient {
  RestClientBase({required String baseUrl}) : baseUri = Uri.parse(baseUrl);

  final Uri baseUri;

  static final _jsonUTF8 = json.fuse(utf8);

  Future<Map<String, Object?>?> send({
    required String path,
    required String method,
    Map<String, Object?>? body,
    Map<String, Object?>? headers,
    Map<String, String?>? queryParams,
  });

  @override
  Future<Map<String, Object?>?> delete(
    String path, {
    Map<String, Object?>? headers,
    Map<String, String?>? queryParams,
  }) => send(
    path: path,
    method: 'DELETE',
    headers: headers,
    queryParams: queryParams,
  );

  @override
  Future<Map<String, Object?>?> get(
    String path, {
    Map<String, Object?>? headers,
    Map<String, String?>? queryParams,
  }) => send(
    path: path,
    method: 'GET',
    headers: headers,
    queryParams: queryParams,
  );

  @override
  Future<Map<String, Object?>?> patch(
    String path, {
    required Map<String, Object?> body,
    Map<String, Object?>? headers,
    Map<String, String?>? queryParams,
  }) => send(
    path: path,
    method: 'PATCH',
    body: body,
    headers: headers,
    queryParams: queryParams,
  );

  @override
  Future<Map<String, Object?>?> post(
    String path, {
    required Map<String, Object?> body,
    Map<String, Object?>? headers,
    Map<String, String?>? queryParams,
  }) => send(
    path: path,
    method: 'POST',
    body: body,
    headers: headers,
    queryParams: queryParams,
  );

  @override
  Future<Map<String, Object?>?> put(
    String path, {
    required Map<String, Object?> body,
    Map<String, Object?>? headers,
    Map<String, String?>? queryParams,
  }) => send(
    path: path,
    method: 'PUT',
    body: body,
    headers: headers,
    queryParams: queryParams,
  );

  @protected
  @visibleForTesting
  List<int> encodeBody(Map<String, Object?> body) {
    try {
      return _jsonUTF8.encode(body);
    } on Object catch (e, stackTrace) {
      Error.throwWithStackTrace(
        ClientException(message: 'Error occured during encoding', cause: e),
        stackTrace,
      );
    }
  }

  @protected
  @visibleForTesting
  Uri buildUri({required String path, Map<String, String?>? queryParams}) {
    final normalizedPath = path.startsWith('/') ? path.substring(1) : path;
    final finalPath = [
      ...baseUri.pathSegments.where((s) => s.isNotEmpty),
      ...normalizedPath.split('/').where((s) => s.isNotEmpty),
    ].join('/');
    return baseUri.replace(
      path: '/$finalPath',
      queryParameters: {
        ...baseUri.queryParameters,
        if (queryParams != null)
          ...Map.fromEntries(queryParams.entries.where((e) => e.value != null)),
      },
    );
  }

  @protected
  @visibleForTesting
  Future<Map<String, Object?>?> decodeResponse(
    Object? body, {
    int? statusCode,
  }) async {
    if (body == null) return null;
    if (body is String && body.isEmpty) return null;

    assert(
      body is String || body is Map || body is List<int>,
      'Unexpected response body type: ${body.runtimeType}',
    );

    try {
      final Map<String, Object?>? decodedBody = switch (body) {
        final Map map => Map<String, Object?>.from(map),
        final String str => await _decodeString(str),
        final List<int> bytes => await _decodeBytes(bytes),
        _ => throw WrongResponseTypeException(
          message: 'Unexpected response body type: ${body.runtimeType}',
          statusCode: statusCode,
        ),
      };

      if (decodedBody case {'error': final Map<String, Object?> error}) {
        throw StructuredBackendException(error: error, statusCode: statusCode);
      }

      if (decodedBody case {'data': final Map<String, Object?> data}) {
        return data;
      }

      return decodedBody;
    } on RestClientException {
      rethrow;
    } on Object catch (e, stackTrace) {
      Error.throwWithStackTrace(
        ClientException(
          message: 'Error occured during decoding',
          statusCode: statusCode,
          cause: e,
        ),
        stackTrace,
      );
    }
  }

  Future<Map<String, Object?>?> _decodeString(String str) async {
    if (str.isEmpty) return null;
    if (str.length > 1000) {
      return Isolate.run(() => json.decode(str) as Map<String, Object?>);
    }
    return json.decode(str) as Map<String, Object?>;
  }

  Future<Map<String, Object?>?> _decodeBytes(List<int> bytes) async {
    if (bytes.isEmpty) return null;
    if (bytes.length > 1000) {
      return Isolate.run(
        () => _jsonUTF8.decode(bytes)! as Map<String, Object?>,
      );
    }
    return _jsonUTF8.decode(bytes)! as Map<String, Object?>;
  }
}
