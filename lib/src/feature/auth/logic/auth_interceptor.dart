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
    if (_shouldSignOut(err)) {
      _onUnauthorized();
    }
    handler.next(err);
  }

  /// A single 401 used to wipe the shift. Sign out only when the server
  /// rejected this session: the token is past [Session.expiresAt], or the
  /// session was revoked / the staff account is inactive.
  bool _shouldSignOut(DioException err) {
    if (err.response?.statusCode != 401) return false;
    final path = err.requestOptions.uri.path;
    if (path.endsWith('/login') || path.endsWith('/logout')) return false;
    final sent = err.requestOptions.headers['Authorization']?.toString() ?? '';
    if (!sent.startsWith('Bearer ') ||
        sent.trim().length <= 'Bearer '.length) {
      return false;
    }

    final message = _errorMessage(err.response?.data).toLowerCase();
    if (message.contains('отозван') ||
        message.contains('неактив') ||
        message.contains('удал')) {
      return true;
    }

    final expiresAt = _session?.expiresAt;
    if (expiresAt != null && expiresAt.isAfter(DateTime.now())) {
      return false;
    }
    return true;
  }

  String _errorMessage(Object? data) {
    if (data is Map) {
      final error = data['error'];
      if (error is Map && error['message'] is String) {
        return error['message'] as String;
      }
    }
    return '';
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
