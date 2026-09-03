import '/src/core/api/json.dart';
import '/src/core/model/models.dart';
import '/src/core/rest_client/rest_client.dart';

class MerchApi {
  MerchApi(this._client);

  final RestClient _client;

  Future<Session> cashierLogin({
    required String login,
    required String secret,
  }) async {
    final data = await _client.post(
      'cashier/login',
      body: {'login': login, 'password': secret, 'pin': secret},
    );
    return _sessionFromLogin(data!, login: login, adminToken: null);
  }

  Future<String> adminLogin({
    required String login,
    required String secret,
  }) async {
    final data = await _client.post(
      'admin/login',
      body: {'login': login, 'password': secret, 'pin': secret},
    );
    return asString(data?['token']);
  }

  Future<void> cashierLogout() async {
    try {
      await _client.post('cashier/logout', body: {});
    } on StructuredBackendException catch (e) {
      if (e.statusCode == 404) return;
      rethrow;
    } on ClientException {
      return;
    }
  }

  Future<void> adminLogout() async {
    try {
      await _client.post('admin/logout', body: {});
    } on StructuredBackendException catch (e) {
      if (e.statusCode == 404) return;
      rethrow;
    } on ClientException {
      return;
    }
  }

  Future<AppVersionInfo> appVersion() async {
    final data = await _client.get('cashier/app-version');
    return AppVersionInfo(
      minSupported: asString(data?['min_supported']),
      downloadUrl: asString(data?['download_url']),
    );
  }

  Future<LookupCustomer> lookup(String barcode) async {
    final data = await _client.post(
      'cashier/lookup',
      body: {'barcode': barcode},
    );
    return LookupCustomer(
      customerId: asString(data?['customer_id']),
      name: asString(data?['name']),
      points: asInt(data?['points']),
      redeemMin: asInt(data?['redeem_min']),
      redeemRate: asInt(data?['redeem_rate']),
      canRedeem: asBool(data?['can_redeem']),
      barcode: barcode,
    );
  }

  Future<QuoteResult> quote({
    required String barcode,
    required int amountRub,
    required int requestedPoints,
  }) async {
    final data = await _client.post(
      'cashier/quote-redeem',
      body: {
        'barcode': barcode,
        'receipt_amount_rub': amountRub,
        'requested_points': requestedPoints,
      },
    );
    return QuoteResult(
      allowed: asBool(data?['allowed']),
      requestedPoints: asInt(data?['requested_points']),
      maxPoints: asInt(data?['max_points']),
      redeemPoints: asInt(data?['redeem_points']),
      redeemRub: asInt(data?['redeem_rub']),
      earnPoints: asInt(data?['earn_points']),
      payableRub: asInt(data?['payable_rub']),
      currentPoints: asInt(data?['current_points']),
      code: data?['code'] as String?,
      reason: data?['reason'] as String?,
    );
  }

  Future<CommitResult> commit({
    required String receiptId,
    required String barcode,
    required int amountRub,
    required int redeemPoints,
    String? storeId,
  }) async {
    final data = await _client.post(
      'cashier/commit',
      body: {
        'receipt_id': receiptId,
        'barcode': barcode,
        'receipt_amount_rub': amountRub,
        'redeem_points': redeemPoints,
        if (storeId != null && storeId.isNotEmpty) 'store_id': storeId,
      },
    );
    return CommitResult(
      receiptId: asString(data?['receipt_id']),
      customerId: asString(data?['customer_id']),
      barcode: asString(data?['barcode']),
      points: asInt(data?['points']),
      earnPoints: asInt(data?['earn_points']),
      redeemPoints: asInt(data?['redeem_points']),
      idempotentReplay: asBool(data?['idempotent_replay']),
    );
  }

  Future<int> refund(String receiptId) async {
    final data = await _client.post(
      'cashier/refund',
      body: {'receipt_id': receiptId},
    );
    return asInt(data?['points']);
  }

  Future<EnrollResult> enroll({String? name, String? phone}) async {
    final data = await _client.post(
      'cashier/enroll',
      body: {
        if (name != null && name.isNotEmpty) 'name': name,
        if (phone != null && phone.isNotEmpty) 'phone': phone,
      },
    );
    return EnrollResult(
      customerId: asString(data?['customer_id']),
      barcode: asString(data?['barcode']),
      addPage: asString(data?['add_page']),
      created: asBool(data?['created']),
    );
  }

  Future<List<ReceiptRow>?> listReceipts({String? storeId}) async {
    try {
      final data = await _client.get(
        'cashier/receipts',
        queryParams: {'store_id': ?storeId},
      );
      return asList(data?['receipts']).map(_receiptFromJson).toList();
    } on StructuredBackendException catch (e) {
      if (e.statusCode == 404) return null;
      rethrow;
    }
  }

  Future<ReceiptRow?> receiptById(String id) async {
    try {
      final data = await _client.get('cashier/receipts/$id');
      if (data == null) return null;
      return _receiptFromJson(data);
    } on StructuredBackendException catch (e) {
      if (e.statusCode == 404) return null;
      rethrow;
    }
  }

  Future<List<AdminCustomer>> searchCustomers(String query) async {
    final data = await _client.get(
      'admin/customers',
      queryParams: {if (query.isNotEmpty) 'q': query},
    );
    return asList(data?['customers']).map(_customerFromJson).toList();
  }

  Future<void> blockCustomer(String id) async {
    await _client.post('admin/customers/$id/block', body: {});
  }

  Future<void> unblockCustomer(String id) async {
    await _client.post('admin/customers/$id/unblock', body: {});
  }

  Future<int> adjust({
    required String barcode,
    required int delta,
    required String reason,
  }) async {
    final data = await _client.post(
      'admin/adjust',
      body: {'barcode': barcode, 'delta': delta, 'reason': reason},
    );
    return asInt(data?['points']);
  }

  Future<List<StaffRow>> listStaff() async {
    final data = await _client.get('admin/staff');
    return asList(data?['staff']).map(_staffFromJson).toList();
  }

  Future<StaffRow> createStaff({
    required String login,
    required String name,
    required String password,
    required String role,
    String? storeId,
    String? pin,
  }) async {
    final data = await _client.post(
      'admin/staff',
      body: {
        'login': login,
        'name': name,
        'password': password,
        'role': role,
        if (storeId != null && storeId.isNotEmpty) 'store_id': storeId,
        if (pin != null && pin.isNotEmpty) 'pin': pin,
      },
    );
    return _staffFromJson(data);
  }

  Future<StaffRow> patchStaff(
    String id, {
    String? login,
    String? name,
    String? password,
    String? role,
    String? storeId,
    bool? active,
  }) async {
    final data = await _client.patch(
      'admin/staff/$id',
      body: {
        'login': ?login,
        'name': ?name,
        if (password != null && password.isNotEmpty) 'password': password,
        'role': ?role,
        'store_id': ?storeId,
        'active': ?active,
      },
    );
    return _staffFromJson(data);
  }

  Future<List<StoreLocation>> listStores() async {
    final data = await _client.get('admin/stores');
    return asList(data?['stores']).map(_storeFromJson).toList();
  }

  Future<StoreLocation> createStore({
    required String name,
    String? address,
  }) async {
    final data = await _client.post(
      'admin/stores',
      body: {'name': name, 'address': ?address},
    );
    return _storeFromJson(data);
  }

  Future<StoreLocation> patchStore(
    String id, {
    String? name,
    String? address,
  }) async {
    final data = await _client.patch(
      'admin/stores/$id',
      body: {
        'name': ?name,
        'address': ?address,
      },
    );
    return _storeFromJson(data);
  }

  Future<void> deleteStore(String id) async {
    await _client.delete('admin/stores/$id');
  }

  Future<Map<String, String>> loyaltySettings() async {
    final data = await _client.get('admin/loyalty-settings');
    return (data ?? {}).map((key, value) => MapEntry(key, asString(value)));
  }

  Future<Map<String, String>> putLoyaltySettings(
    Map<String, String> settings,
  ) async {
    final data = await _client.put(
      'admin/loyalty-settings',
      body: Map<String, Object?>.from(settings),
    );
    return (data ?? {}).map((key, value) => MapEntry(key, asString(value)));
  }

  Session _sessionFromLogin(
    Map<String, Object?> data, {
    required String login,
    required String? adminToken,
  }) {
    final staff = asMap(data['staff']);
    return Session(
      cashierToken: asString(data['token']),
      adminToken: adminToken,
      staffId: asString(staff['id']),
      staffName: asString(staff['name']),
      staffLogin: asString(staff['login']).isEmpty
          ? login
          : asString(staff['login']),
      staffRole: asString(staff['role']),
      storeId: asString(staff['store_id']),
      expiresAt:
          DateTime.tryParse(asString(data['expires_at'])) ??
          DateTime.now().add(const Duration(hours: 12)),
    );
  }

  ReceiptRow _receiptFromJson(Object? raw) {
    final json = asMap(raw);
    return ReceiptRow(
      receiptId: asString(json['receipt_id'] ?? json['id']),
      createdAt:
          DateTime.tryParse(asString(json['created_at'] ?? json['time'])) ??
          DateTime.fromMillisecondsSinceEpoch(0),
      barcode: asString(json['barcode']),
      customerName: asString(json['name'] ?? json['customer_name']),
      amountRub: asInt(json['amount_rub']),
      redeemPoints: asInt(json['redeem_points']),
      earnPoints: asInt(json['earn_points']),
      status: asString(json['status']),
      pointsAfter: asInt(json['points_after']),
    );
  }

  AdminCustomer _customerFromJson(Object? raw) {
    final json = asMap(raw);
    return AdminCustomer(
      id: asString(json['id']),
      barcode: asString(json['barcode']),
      name: asString(json['name']),
      phone: asString(json['phone']),
      points: asInt(json['points']),
      blocked: asBool(json['blocked']),
    );
  }

  StaffRow _staffFromJson(Object? raw) {
    final json = asMap(raw);
    return StaffRow(
      id: asString(json['id']),
      storeId: asString(json['store_id']),
      login: asString(json['login']),
      name: asString(json['name']),
      role: asString(json['role']),
      active: asBool(json['active']),
    );
  }

  StoreLocation _storeFromJson(Object? raw) {
    final json = asMap(raw);
    return StoreLocation(
      id: asString(json['id'] ?? json['ID']),
      name: asString(json['name'] ?? json['Name']),
      address: asString(json['address'] ?? json['Address']),
    );
  }
}
