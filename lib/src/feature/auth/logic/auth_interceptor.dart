import 'package:dio/dio.dart';
import 'package:merch/src/core/model/models.dart';
import 'package:merch/src/core/rest_client/rest_client.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor({
    required TokenStorage<Session> tokenStorage,
    required void Function() onUnauthorized,
  }) : _tokenStorage = tokenStorage,
       _onUnauthorized = onUnauthorized;

  final TokenStorage<Session> _tokenStorage;
  final void Function() _onUnauthorized;
  Session? _session;

  Future<void> preload() async {
    _session = await _tokenStorage.load();
    _tokenStorage.getStream().listen((session) => _session = session);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final path = options.uri.path;
    final isLogin = path.endsWith('/login');
    if (!isLogin) {
      final token = _tokenFor(path);
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final status = err.response?.statusCode;
    final path = err.requestOptions.uri.path;
    if (status == 401 && !path.endsWith('/login')) {
      _onUnauthorized();
    }
    handler.next(err);
  }

  String? _tokenFor(String path) {
    final session = _session;
    if (session == null) return null;
    final isAdminPath =
        path.contains('/admin/') && !path.endsWith('/admin/login');
    if (isAdminPath) {
      return session.adminToken ?? session.cashierToken;
    }
    return session.cashierToken;
  }
}
