import 'dart:async';
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:merch/src/core/model/models.dart';
import 'package:merch/src/core/rest_client/rest_client.dart';

class SessionStorage implements TokenStorage<Session> {
  SessionStorage({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  static const _key = 'merch.session';

  final FlutterSecureStorage _storage;
  final _controller = StreamController<Session?>.broadcast();

  @override
  Future<Session?> load() async {
    final raw = await _storage.read(key: _key);
    if (raw == null || raw.isEmpty) return null;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map) {
        await clear();
        return null;
      }
      return Session.fromJson(Map<String, dynamic>.from(decoded));
    } on Object {
      await clear();
      return null;
    }
  }

  @override
  Future<void> save(Session tokenPair) async {
    await _storage.write(key: _key, value: jsonEncode(tokenPair.toJson()));
    _controller.add(tokenPair);
  }

  @override
  Future<void> clear() async {
    await _storage.delete(key: _key);
    _controller.add(null);
  }

  @override
  Stream<Session?> getStream() => _controller.stream;

  @override
  Future<void> close() async {
    await _controller.close();
  }
}
