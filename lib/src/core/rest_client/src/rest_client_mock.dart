import 'dart:math';

import '../../model/models.dart';
import '../rest_client.dart';

/// {@template rest_client_mock}
/// In-memory fake backend used to smoke-test the app without a real server.
///
/// Enable it with `--dart-define=USE_MOCK_API=true` (see [Config.useMockApi]).
/// It implements the same [RestClient] contract as [RestClientDio], so every
/// call made through [MerchApi] keeps working (including JSON parsing),
/// just against local in-memory data instead of the network.
/// {@endtemplate}
final class RestClientMock implements RestClient {
  RestClientMock() {
    _seed();
  }

  static const _latency = Duration(milliseconds: 350);
  final _random = Random();

  final Map<String, Map<String, Object?>> _customersByBarcode = {};
  final List<Map<String, Object?>> _receipts = [];
  final List<Map<String, Object?>> _staff = [];
  final List<Map<String, Object?>> _stores = [];
  final Map<String, String> _loyaltySettings = {
    'earn_percent': '5',
    'earn_round': 'down',
    'earn_base': 'after_store_discount_before_points',
    'earn_min_receipt': '0',
    'redeem_rate': '1',
    'redeem_min': '100',
    'redeem_max_share': '50',
    'expire_days': '',
  };

  String _cashierRole = staffRoleCashier;

  var _customerSeq = 1;
  var _staffSeq = 4;
  var _storeSeq = 3;
  var _receiptSeq = 1000;

  void _seed() {
    _stores.addAll([
      _storeRow(
        id: 'store-1',
        name: 'Магазин на Тверской',
        address: 'Тверская, 1',
      ),
      _storeRow(
        id: 'store-2',
        name: 'Магазин в Меге',
        address: 'ТЦ Мега, 2 этаж',
      ),
    ]);
    _staff.addAll([
      {
        'id': 'staff-1',
        'store_id': 'store-1',
        'login': 'admin',
        'name': 'Админ Админов',
        'role': staffRoleAdmin,
        'active': true,
      },
      {
        'id': 'staff-2',
        'store_id': 'store-1',
        'login': 'cashier',
        'name': 'Иван Кассиров',
        'role': staffRoleCashier,
        'active': true,
      },
      {
        'id': 'staff-3',
        'store_id': 'store-1',
        'login': 'lead',
        'name': 'Старший смены',
        'role': staffRoleShiftLead,
        'active': true,
      },
    ]);
    _seedCustomer(
      barcode: '1234567890123',
      name: 'Мария Смирнова',
      phone: '+79990001122',
      points: 340,
    );
    _seedCustomer(
      barcode: '2222222222222',
      name: 'Пётр Иванов',
      phone: '+79990002233',
      points: 60,
    );
  }

  void _seedCustomer({
    required String barcode,
    required String name,
    required String phone,
    required int points,
  }) {
    final id = 'cust-${_customerSeq++}';
    _customersByBarcode[barcode] = {
      'id': id,
      'barcode': barcode,
      'name': name,
      'phone': phone,
      'points': points,
      'blocked': false,
    };
  }

  @override
  Future<Map<String, Object?>?> get(
    String path, {
    Map<String, Object?>? headers,
    Map<String, String?>? queryParams,
  }) => _handle('GET', path, queryParams: queryParams);

  @override
  Future<Map<String, Object?>?> post(
    String path, {
    required Map<String, Object?> body,
    Map<String, Object?>? headers,
    Map<String, String?>? queryParams,
  }) => _handle('POST', path, body: body, queryParams: queryParams);

  @override
  Future<Map<String, Object?>?> put(
    String path, {
    required Map<String, Object?> body,
    Map<String, Object?>? headers,
    Map<String, String?>? queryParams,
  }) => _handle('PUT', path, body: body, queryParams: queryParams);

  @override
  Future<Map<String, Object?>?> patch(
    String path, {
    required Map<String, Object?> body,
    Map<String, Object?>? headers,
    Map<String, String?>? queryParams,
  }) => _handle('PATCH', path, body: body, queryParams: queryParams);

  @override
  Future<Map<String, Object?>?> delete(
    String path, {
    Map<String, Object?>? headers,
    Map<String, String?>? queryParams,
  }) => _handle('DELETE', path, queryParams: queryParams);

  Future<Map<String, Object?>?> _handle(
    String method,
    String rawPath, {
    Map<String, Object?>? body,
    Map<String, String?>? queryParams,
  }) async {
    await Future<void>.delayed(_latency);
    final path = rawPath.startsWith('/') ? rawPath.substring(1) : rawPath;
    final segments = path.split('/').where((s) => s.isNotEmpty).toList();
    final b = body ?? const <String, Object?>{};
    final q = queryParams ?? const <String, String?>{};

    if (_is(segments, ['cashier', 'login'])) return _cashierLogin(b);
    if (_is(segments, ['admin', 'login'])) return _adminLogin(b);
    if (_is(segments, ['cashier', 'logout'])) return {};
    if (_is(segments, ['admin', 'logout'])) return {};
    if (_is(segments, ['cashier', 'app-version'])) {
      return {'min_supported': '1.0.0', 'download_url': ''};
    }
    if (_is(segments, ['cashier', 'lookup'])) return _lookup(b);
    if (_is(segments, ['cashier', 'quote-redeem'])) return _quote(b);
    if (_is(segments, ['cashier', 'commit'])) return _commit(b);
    if (_is(segments, ['cashier', 'refund'])) return _refund(b);
    if (_is(segments, ['cashier', 'enroll'])) return _enroll(b);
    if (_is(segments, ['cashier', 'receipts'])) return _listReceipts(q);
    if (_is(segments, ['cashier', 'receipts', '*'])) {
      return _receiptById(segments[2]);
    }
    if (_is(segments, ['admin', 'customers'])) return _searchCustomers(q);
    if (_is(segments, ['admin', 'customers', '*', 'block'])) {
      return _setBlocked(segments[2], true);
    }
    if (_is(segments, ['admin', 'customers', '*', 'unblock'])) {
      return _setBlocked(segments[2], false);
    }
    if (_is(segments, ['admin', 'adjust'])) return _adjust(b);
    if (_is(segments, ['admin', 'staff'])) {
      return method == 'GET' ? _listStaff() : _createStaff(b);
    }
    if (_is(segments, ['admin', 'staff', '*'])) {
      return _patchStaff(segments[2], b);
    }
    if (_is(segments, ['admin', 'stores'])) {
      return method == 'GET' ? _listStores() : _createStore(b);
    }
    if (_is(segments, ['admin', 'stores', '*'])) {
      return method == 'DELETE'
          ? _deleteStore(segments[2])
          : _patchStore(segments[2], b);
    }
    if (_is(segments, ['admin', 'loyalty-settings'])) {
      return method == 'GET' ? _loyaltySettingsJson() : _saveLoyaltySettings(b);
    }

    throw ClientException(message: 'RestClientMock: unhandled $method /$path');
  }

  bool _is(List<String> segments, List<String> pattern) {
    if (segments.length != pattern.length) return false;
    for (var i = 0; i < pattern.length; i++) {
      if (pattern[i] != '*' && pattern[i] != segments[i]) return false;
    }
    return true;
  }

  // --- Auth ---------------------------------------------------------------

  Map<String, Object?> _cashierLogin(Map<String, Object?> body) {
    final login = (body['login'] as String? ?? '').trim();
    final existing = _staff.firstWhere(
      (s) => (s['login'] as String).toLowerCase() == login.toLowerCase(),
      orElse: () => <String, Object?>{},
    );
    final isAdminLogin = existing.isNotEmpty
        ? existing['role'] == staffRoleAdmin
        : login.toLowerCase().contains('admin');
    final staff = existing.isNotEmpty
        ? existing
        : {
            'id': 'staff-${_staffSeq++}',
            'store_id': 'store-1',
            'login': login.isEmpty ? 'cashier' : login,
            'name': isAdminLogin ? 'Админ Админов' : 'Иван Кассиров',
            'role': isAdminLogin ? staffRoleAdmin : staffRoleCashier,
            'active': true,
          };
    if (existing.isEmpty) _staff.add(staff);
    _cashierRole = staff['role'] as String? ?? staffRoleCashier;

    return {
      'token': 'mock-cashier-token-${DateTime.now().millisecondsSinceEpoch}',
      'expires_at': DateTime.now()
          .add(const Duration(hours: 12))
          .toIso8601String(),
      'staff': {
        'id': staff['id'],
        'name': staff['name'],
        'role': staff['role'],
        'store_id': staff['store_id'],
      },
    };
  }

  Map<String, Object?> _adminLogin(Map<String, Object?> body) => {
    'token': 'mock-admin-token-${DateTime.now().millisecondsSinceEpoch}',
  };

  // --- Cashier --------------------------------------------------------------

  Map<String, Object?> _lookup(Map<String, Object?> body) {
    final barcode = body['barcode'] as String? ?? '';
    final customer = _customerOrCreate(barcode);
    _rejectIfBlocked(customer);
    return {
      'customer_id': customer['id'],
      'name': customer['blocked'] == true ? '' : customer['name'],
      'points': customer['points'],
      'redeem_min': int.tryParse(_loyaltySettings['redeem_min'] ?? '') ?? 100,
      'redeem_rate': int.tryParse(_loyaltySettings['redeem_rate'] ?? '') ?? 1,
      'can_redeem':
          customer['blocked'] != true &&
          (customer['points'] as int) >=
              (int.tryParse(_loyaltySettings['redeem_min'] ?? '') ?? 100),
    };
  }

  Map<String, Object?> _quote(Map<String, Object?> body) {
    final barcode = body['barcode'] as String? ?? '';
    final amountRub = (body['receipt_amount_rub'] as num?)?.toInt() ?? 0;
    final requestedPoints = (body['requested_points'] as num?)?.toInt() ?? 0;
    final customer = _customerOrCreate(barcode);
    _rejectIfBlocked(customer);
    if (amountRub < 0 || requestedPoints < 0) {
      throw const StructuredBackendException(
        error: {
          'code': 'INVALID_REQUEST',
          'message': 'Сумма и баллы не могут быть отрицательными',
        },
        statusCode: 422,
      );
    }
    final currentPoints = customer['points'] as int;

    final earnPercent =
        int.tryParse(_loyaltySettings['earn_percent'] ?? '') ?? 5;
    final redeemMin = int.tryParse(_loyaltySettings['redeem_min'] ?? '') ?? 100;
    final redeemMaxShare =
        int.tryParse(_loyaltySettings['redeem_max_share'] ?? '') ?? 50;
    final redeemRate = int.tryParse(_loyaltySettings['redeem_rate'] ?? '') ?? 1;
    final maxByShare = redeemRate <= 0
        ? 0
        : (amountRub * redeemMaxShare / 100) ~/ redeemRate;
    var maxPoints = min(maxByShare, currentPoints);
    if (maxPoints < 0) maxPoints = 0;
    if (maxPoints < redeemMin) maxPoints = 0;

    String? code;
    String? reason;
    if (requestedPoints > 0 && requestedPoints < redeemMin) {
      code = 'BELOW_MIN_REDEEM';
      reason = 'Минимум для списания — $redeemMin баллов';
    } else if (requestedPoints > currentPoints) {
      code = 'INSUFFICIENT_POINTS';
      reason = 'Недостаточно баллов';
    } else if (requestedPoints * redeemRate >
        amountRub * redeemMaxShare ~/ 100) {
      code = 'EXCEEDS_RECEIPT_SHARE';
      reason = 'Нельзя списать больше $redeemMaxShare% суммы чека';
    }
    final allowed = code == null;
    final redeemPoints = allowed ? requestedPoints : 0;
    final redeemRub = redeemPoints * redeemRate;
    final payableRub = amountRub - redeemRub;
    final earnPoints = allowed
        ? _earnPoints(amountRub, redeemPoints, earnPercent, redeemRate)
        : 0;

    return {
      'allowed': allowed,
      'requested_points': requestedPoints,
      'max_points': maxPoints,
      'redeem_points': redeemPoints,
      'redeem_rub': redeemRub,
      'earn_points': earnPoints,
      'payable_rub': payableRub < 0 ? 0 : payableRub,
      'current_points': currentPoints,
      if (!allowed) 'code': code,
      if (!allowed) 'reason': reason,
    };
  }

  Map<String, Object?> _commit(Map<String, Object?> body) {
    final receiptId = body['receipt_id'] as String? ?? '';
    final barcode = body['barcode'] as String? ?? '';
    final amountRub = (body['receipt_amount_rub'] as num?)?.toInt() ?? 0;
    final redeemPoints = (body['redeem_points'] as num?)?.toInt() ?? 0;
    final storeId = (body['store_id'] as String?)?.isNotEmpty == true
        ? body['store_id'] as String
        : 'store-1';
    if (amountRub < 0 || redeemPoints < 0) {
      throw const StructuredBackendException(
        error: {
          'code': 'INVALID_REQUEST',
          'message': 'Сумма и баллы не могут быть отрицательными',
        },
        statusCode: 422,
      );
    }
    final existing = _receipts.firstWhere(
      (r) => r['receipt_id'] == receiptId,
      orElse: () => <String, Object?>{},
    );
    if (existing.isNotEmpty) {
      final same =
          existing['barcode'] == barcode &&
          existing['amount_rub'] == amountRub &&
          existing['redeem_points'] == redeemPoints;
      if (!same) {
        throw const StructuredBackendException(
          error: {
            'code': 'DUPLICATE_RECEIPT',
            'message': 'Чек уже проведён с другими данными',
          },
          statusCode: 409,
        );
      }
      return {
        'receipt_id': existing['receipt_id'],
        'customer_id': existing['customer_id'],
        'barcode': existing['barcode'],
        'points': existing['points_after'],
        'earn_points': existing['earn_points'],
        'redeem_points': existing['redeem_points'],
        'idempotent_replay': true,
      };
    }

    final customer = _customerOrCreate(barcode);
    _rejectIfBlocked(customer);
    final earnPercent =
        int.tryParse(_loyaltySettings['earn_percent'] ?? '') ?? 5;
    final redeemRate = int.tryParse(_loyaltySettings['redeem_rate'] ?? '') ?? 1;
    final earnPoints = _earnPoints(
      amountRub,
      redeemPoints,
      earnPercent,
      redeemRate,
    );
    final pointsAfter = (customer['points'] as int) - redeemPoints + earnPoints;
    customer['points'] = pointsAfter;

    final receipt = {
      'receipt_id': receiptId.isEmpty
          ? 'mock-receipt-${_receiptSeq++}'
          : receiptId,
      'created_at': DateTime.now().toUtc().toIso8601String(),
      'barcode': barcode,
      'customer_id': customer['id'],
      'name': customer['name'],
      'amount_rub': amountRub,
      'redeem_points': redeemPoints,
      'earn_points': earnPoints,
      'status': 'committed',
      'points_after': pointsAfter,
      'store_id': storeId,
    };
    _receipts.insert(0, receipt);

    return {
      'receipt_id': receipt['receipt_id'],
      'customer_id': customer['id'],
      'barcode': barcode,
      'points': pointsAfter,
      'earn_points': earnPoints,
      'redeem_points': redeemPoints,
      'idempotent_replay': false,
    };
  }

  Map<String, Object?> _refund(Map<String, Object?> body) {
    if (!canRefundRole(_cashierRole)) {
      throw const StructuredBackendException(
        error: {
          'code': 'STAFF_FORBIDDEN',
          'message': 'Возврат доступен старшему смены или админу',
        },
        statusCode: 403,
      );
    }
    final receiptId = body['receipt_id'] as String? ?? '';
    final receipt = _receipts.firstWhere(
      (r) => r['receipt_id'] == receiptId,
      orElse: () => <String, Object?>{},
    );
    if (receipt.isEmpty) {
      throw const StructuredBackendException(
        error: {'code': 'INVALID_REQUEST', 'message': 'Чек не найден'},
        statusCode: 422,
      );
    }
    final barcode = receipt['barcode'] as String;
    final customer = _customerOrCreate(barcode);
    final already = receipt['status'] == 'refunded';
    if (!already) {
      var points = customer['points'] as int;
      final earnPoints = receipt['earn_points'] as int;
      final redeemPoints = receipt['redeem_points'] as int;
      if (earnPoints > 0) {
        points -= earnPoints > points ? points : earnPoints;
      }
      if (redeemPoints > 0) points += redeemPoints;
      customer['points'] = points;
      receipt['status'] = 'refunded';
      receipt['points_after'] = points;
    }
    return {
      'receipt_id': receiptId,
      'customer_id': customer['id'],
      'points': receipt['points_after'],
      'idempotent_replay': already,
    };
  }

  Map<String, Object?> _enroll(Map<String, Object?> body) {
    final name = body['name'] as String?;
    final phone = body['phone'] as String?;
    final barcode = _generateBarcode();
    _seedCustomer(
      barcode: barcode,
      name: name ?? '',
      phone: phone ?? '',
      points: 0,
    );
    final customer = _customersByBarcode[barcode]!;
    final id = customer['id'] as String;
    return {
      'customer_id': id,
      'barcode': barcode,
      'apple_url': 'http://localhost:8080/public/passes/apple/$id.pkpass',
      'google_save_url': '',
      'add_page': 'http://localhost:8080/card/add/$id',
      'created': true,
    };
  }

  Map<String, Object?> _listReceipts(Map<String, String?> query) {
    final storeId = query['store_id'];
    final receipts = storeId == null || storeId.isEmpty
        ? _receipts
        : _receipts.where((r) => r['store_id'] == storeId).toList();
    return {'receipts': receipts};
  }

  Map<String, Object?>? _receiptById(String id) {
    final receipt = _receipts.firstWhere(
      (r) => r['receipt_id'] == id,
      orElse: () => <String, Object?>{},
    );
    if (receipt.isEmpty) {
      throw const StructuredBackendException(
        error: {'code': 'not_found', 'message': 'Чек не найден'},
        statusCode: 404,
      );
    }
    return receipt;
  }

  // --- Admin ----------------------------------------------------------------

  Map<String, Object?> _searchCustomers(Map<String, String?> query) {
    final q = (query['q'] ?? '').toLowerCase();
    final customers = _customersByBarcode.values.where((c) {
      if (q.isEmpty) return true;
      return (c['name'] as String).toLowerCase().contains(q) ||
          (c['barcode'] as String).toLowerCase().contains(q) ||
          (c['phone'] as String).toLowerCase().contains(q);
    }).toList();
    return {'customers': customers};
  }

  Map<String, Object?> _setBlocked(String id, bool blocked) {
    final customer = _customersByBarcode.values.firstWhere(
      (c) => c['id'] == id,
      orElse: () => <String, Object?>{},
    );
    if (customer.isNotEmpty) customer['blocked'] = blocked;
    return {'id': id, 'blocked': blocked};
  }

  Map<String, Object?> _adjust(Map<String, Object?> body) {
    final barcode = body['barcode'] as String? ?? '';
    final delta = (body['delta'] as num?)?.toInt() ?? 0;
    final customer = _customerOrCreate(barcode);
    final points = ((customer['points'] as int) + delta).clamp(0, 1 << 30);
    customer['points'] = points;
    return {
      'customer_id': customer['id'],
      'barcode': customer['barcode'],
      'points': points,
    };
  }

  Map<String, Object?> _listStaff() => {'staff': _staff};

  Map<String, Object?> _createStaff(Map<String, Object?> body) {
    final login = (body['login'] as String? ?? '').trim();
    final name = (body['name'] as String? ?? '').trim();
    final password = body['password'] as String? ?? '';
    final role = body['role'] as String? ?? '';
    if (login.isEmpty ||
        name.isEmpty ||
        password.isEmpty ||
        !staffRoles.contains(role)) {
      throw const StructuredBackendException(
        error: {
          'code': 'INVALID_REQUEST',
          'message': 'login, name, password и role обязательны',
        },
        statusCode: 422,
      );
    }
    final storeId = body['store_id'] as String?;
    final staff = {
      'id': 'staff-${_staffSeq++}',
      'store_id': storeId == null || storeId.isEmpty ? 'store-1' : storeId,
      'login': login,
      'name': name,
      'role': role,
      'active': body['active'] as bool? ?? true,
    };
    _staff.add(staff);
    return staff;
  }

  Map<String, Object?> _patchStaff(String id, Map<String, Object?> body) {
    _requireKnownStaffRole(body['role']);
    final staff = _staff.firstWhere(
      (s) => s['id'] == id,
      orElse: () => <String, Object?>{},
    );
    if (staff.isEmpty) {
      throw const StructuredBackendException(
        error: {'code': 'INVALID_REQUEST', 'message': 'Сотрудник не найден'},
        statusCode: 404,
      );
    }
    for (final key in ['login', 'name', 'role', 'store_id', 'active']) {
      if (body.containsKey(key)) staff[key] = body[key];
    }
    return staff;
  }

  Map<String, Object?> _listStores() => {'stores': _stores};

  Map<String, Object?> _createStore(Map<String, Object?> body) {
    final name = (body['name'] as String? ?? '').trim();
    if (name.isEmpty) {
      throw const StructuredBackendException(
        error: {'code': 'INVALID_REQUEST', 'message': 'name обязателен'},
        statusCode: 422,
      );
    }
    final store = _storeRow(
      id: 'store-${_storeSeq++}',
      name: name,
      address: body['address'] as String? ?? '',
    );
    _stores.add(store);
    return store;
  }

  Map<String, Object?> _patchStore(String id, Map<String, Object?> body) {
    final store = _stores.firstWhere(
      (s) => s['ID'] == id,
      orElse: () => <String, Object?>{},
    );
    if (store.isEmpty) {
      throw const StructuredBackendException(
        error: {'code': 'INVALID_REQUEST', 'message': 'Точка не найдена'},
        statusCode: 404,
      );
    }
    final name = body['name'] as String? ?? '';
    final address = body['address'] as String? ?? '';
    if (name.isNotEmpty) store['Name'] = name;
    if (address.isNotEmpty) store['Address'] = address;
    return store;
  }

  Map<String, Object?>? _deleteStore(String id) {
    final before = _stores.length;
    _stores.removeWhere((s) => s['ID'] == id);
    if (_stores.length == before) {
      throw const StructuredBackendException(
        error: {'code': 'INVALID_REQUEST', 'message': 'Точка не найдена'},
        statusCode: 404,
      );
    }
    return null;
  }

  Map<String, Object?> _loyaltySettingsJson() =>
      Map<String, Object?>.from(_loyaltySettings);

  Map<String, Object?> _saveLoyaltySettings(Map<String, Object?> body) {
    for (final entry in body.entries) {
      _loyaltySettings[entry.key] = entry.value?.toString() ?? '';
    }
    return Map<String, Object?>.from(_loyaltySettings);
  }

  void _requireKnownStaffRole(Object? role) {
    if (role is! String || role.isEmpty || staffRoles.contains(role)) return;
    throw const StructuredBackendException(
      error: {'code': 'INVALID_REQUEST', 'message': 'Неизвестная роль'},
      statusCode: 422,
    );
  }

  void _rejectIfBlocked(Map<String, Object?> customer) {
    if (customer['blocked'] == true) {
      throw const StructuredBackendException(
        error: {'code': 'CUSTOMER_BLOCKED', 'message': 'Карта заблокирована'},
        statusCode: 403,
      );
    }
  }

  int _earnPoints(int amountRub, int redeemPoints, int earnPercent, int rate) {
    final minReceipt =
        int.tryParse(_loyaltySettings['earn_min_receipt'] ?? '') ?? 0;
    if (amountRub < minReceipt) return 0;
    var base = amountRub - redeemPoints * rate;
    if (base < 0) base = 0;
    return base * earnPercent ~/ 100;
  }

  Map<String, Object?> _storeRow({
    required String id,
    required String name,
    required String address,
  }) => {
    'ID': id,
    'Name': name,
    'Address': address,
    'CreatedAt': DateTime.now().toUtc().toIso8601String(),
  };

  // --- Helpers ----------------------------------------------------------

  Map<String, Object?> _customerOrCreate(String barcode) {
    final existing = _customersByBarcode[barcode];
    if (existing != null) return existing;
    _seedCustomer(
      barcode: barcode,
      name:
          'Гость ${barcode.length >= 4 ? barcode.substring(barcode.length - 4) : barcode}',
      phone: '',
      points: 50 + _random.nextInt(450),
    );
    return _customersByBarcode[barcode]!;
  }

  String _generateBarcode() {
    final buffer = StringBuffer();
    for (var i = 0; i < 13; i++) {
      buffer.write(_random.nextInt(10));
    }
    return buffer.toString();
  }
}
