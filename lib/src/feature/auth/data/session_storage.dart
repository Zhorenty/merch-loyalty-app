import 'dart:async';
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:merch/src/core/model/models.dart';
import 'package:merch/src/core/rest_client/rest_client.dart';

class SessionStorage implements TokenStorage<Session> {
  SessionStorage({FlutterSecureStorage? storage})
    : _storage = storage ?? _persistent,
      _legacy = storage == null ? _legacyStore : null;

  static const _key = 'merch.session';

  /// EncryptedSharedPreferences survives app updates. The default cipher
  /// loses the keystore key after backup restore and the next launch looks
  /// like a logout.
  static const _persistent = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  static const _legacyStore = FlutterSecureStorage();

  final FlutterSecureStorage _storage;
  final FlutterSecureStorage? _legacy;
  final _controller = StreamController<Session?>.broadcast();

  @override
  Future<Session?> load() async {
    final raw = await _read();
    final session = _decode(raw);
    if (session == null && raw != null && raw.isNotEmpty) {
      // Corrupt JSON only. A keystore error must not reach clear().
      await clear();
    }
    return session;
  }

  Future<String?> _read() async {
    try {
      final raw = await _storage.read(key: _key);
      if (raw != null && raw.isNotEmpty) return raw;
    } on Object {
      // New store failed; try the copy written by older builds.
    }
    final legacy = _legacy;
    if (legacy == null) return null;
    try {
      final raw = await legacy.read(key: _key);
      if (raw == null || raw.isEmpty) return null;
      try {
        await _storage.write(key: _key, value: raw);
        await legacy.delete(key: _key);
      } on Object {
        // Keep the old copy if the new store is not ready yet.
      }
      return raw;
    } on Object {
      return null;
    }
  }

  Session? _decode(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map) return null;
      return Session.fromJson(Map<String, dynamic>.from(decoded));
    } on Object {
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
    final legacy = _legacy;
    if (legacy != null) {
      try {
        await legacy.delete(key: _key);
      } on Object {
        // Legacy store may already be empty.
      }
    }
    _controller.add(null);
  }

  @override
  Stream<Session?> getStream() => _controller.stream;

  @override
  Future<void> close() async {
    await _controller.close();
  }
}
