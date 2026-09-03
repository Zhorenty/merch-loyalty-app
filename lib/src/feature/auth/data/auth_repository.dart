import 'package:merch/src/core/model/models.dart';
import 'package:merch/src/core/rest_client/rest_client.dart';
import 'package:merch/src/feature/auth/data/auth_data_source.dart';

enum AuthenticationStatus { authenticated, unauthenticated }

abstract interface class AuthStatusSource {
  Stream<AuthenticationStatus> get authStatus;
}

abstract interface class AuthRepository implements AuthStatusSource {
  Session? get session;

  Future<Session?> restore();

  Future<void> signIn({required String login, required String secret});

  Future<void> signOut();
}

final class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required AuthDataSource dataSource,
    required TokenStorage<Session> storage,
  }) : _dataSource = dataSource,
       _storage = storage;

  final AuthDataSource _dataSource;
  final TokenStorage<Session> _storage;
  Session? _session;
  bool _signingOut = false;

  @override
  Session? get session => _session;

  @override
  Stream<AuthenticationStatus> get authStatus => _storage.getStream().map(
    (session) => session == null
        ? AuthenticationStatus.unauthenticated
        : AuthenticationStatus.authenticated,
  );

  @override
  Future<Session?> restore() async {
    _session = await _storage.load();
    return _session;
  }

  @override
  Future<void> signIn({required String login, required String secret}) async {
    var session = await _dataSource.cashierLogin(
      login: login,
      secret: secret,
    );
    if (session.isAdmin) {
      final adminToken = await _dataSource.adminLogin(
        login: login,
        secret: secret,
      );
      session = session.copyWith(adminToken: adminToken);
    }
    _session = session;
    await _storage.save(session);
    if (session.isAdmin) {
      try {
        final stores = await _dataSource.listStores();
        final match = stores.where((s) => s.id == session.storeId);
        if (match.isNotEmpty) {
          session = session.copyWith(storeName: match.first.name);
          _session = session;
          await _storage.save(session);
        }
      } on Object {
        // Store name is optional.
      }
    }
  }

  @override
  Future<void> signOut() async {
    if (_signingOut) return;
    _signingOut = true;
    try {
      await _dataSource.cashierLogout();
      if (_session?.adminToken != null) {
        await _dataSource.adminLogout();
      }
    } on Object {
      // Always clear local session.
    }
    _session = null;
    await _storage.clear();
    _signingOut = false;
  }
}
