enum AppRole { manager, admin }

AppRole mapStaffRole(String role) {
  switch (role) {
    case 'admin':
      return AppRole.admin;
    default:
      return AppRole.manager;
  }
}

class Session {
  const Session({
    required this.cashierToken,
    required this.staffId,
    required this.staffName,
    required this.staffLogin,
    required this.staffRole,
    required this.storeId,
    required this.expiresAt,
    this.adminToken,
    this.storeName,
  });

  final String cashierToken;
  final String? adminToken;
  final String staffId;
  final String staffName;
  final String staffLogin;
  final String staffRole;
  final String storeId;
  final String? storeName;
  final DateTime expiresAt;

  AppRole get appRole => mapStaffRole(staffRole);

  bool get isAdmin => appRole == AppRole.admin;

  String get roleLabel => isAdmin ? 'Админ' : 'Менеджер';

  Session copyWith({String? storeName, String? adminToken}) => Session(
    cashierToken: cashierToken,
    adminToken: adminToken ?? this.adminToken,
    staffId: staffId,
    staffName: staffName,
    staffLogin: staffLogin,
    staffRole: staffRole,
    storeId: storeId,
    storeName: storeName ?? this.storeName,
    expiresAt: expiresAt,
  );

  Map<String, Object?> toJson() => {
    'cashier_token': cashierToken,
    'admin_token': adminToken,
    'staff_id': staffId,
    'staff_name': staffName,
    'staff_login': staffLogin,
    'staff_role': staffRole,
    'store_id': storeId,
    'store_name': storeName,
    'expires_at': expiresAt.toIso8601String(),
  };

  factory Session.fromJson(Map<String, dynamic> json) => Session(
    cashierToken: json['cashier_token'] as String? ?? '',
    adminToken: json['admin_token'] as String?,
    staffId: json['staff_id'] as String? ?? '',
    staffName: json['staff_name'] as String? ?? '',
    staffLogin: json['staff_login'] as String? ?? '',
    staffRole: json['staff_role'] as String? ?? '',
    storeId: json['store_id'] as String? ?? '',
    storeName: json['store_name'] as String?,
    expiresAt:
        DateTime.tryParse(json['expires_at'] as String? ?? '') ??
        DateTime.fromMillisecondsSinceEpoch(0),
  );
}

class LookupCustomer {
  const LookupCustomer({
    required this.customerId,
    required this.name,
    required this.points,
    required this.redeemMin,
    required this.redeemRate,
    required this.canRedeem,
    required this.barcode,
  });

  final String customerId;
  final String name;
  final int points;
  final int redeemMin;
  final int redeemRate;
  final bool canRedeem;
  final String barcode;

  String get displayName => name.trim().isEmpty ? 'Гость' : name;
}

class QuoteResult {
  const QuoteResult({
    required this.allowed,
    required this.requestedPoints,
    required this.maxPoints,
    required this.redeemPoints,
    required this.redeemRub,
    required this.earnPoints,
    required this.payableRub,
    required this.currentPoints,
    this.code,
    this.reason,
  });

  final bool allowed;
  final int requestedPoints;
  final int maxPoints;
  final int redeemPoints;
  final int redeemRub;
  final int earnPoints;
  final int payableRub;
  final int currentPoints;
  final String? code;
  final String? reason;
}

class CommitResult {
  const CommitResult({
    required this.receiptId,
    required this.customerId,
    required this.barcode,
    required this.points,
    required this.earnPoints,
    required this.redeemPoints,
    required this.idempotentReplay,
  });

  final String receiptId;
  final String customerId;
  final String barcode;
  final int points;
  final int earnPoints;
  final int redeemPoints;
  final bool idempotentReplay;
}

class EnrollResult {
  const EnrollResult({
    required this.customerId,
    required this.barcode,
    required this.addPage,
    required this.created,
  });

  final String customerId;
  final String barcode;
  final String addPage;
  final bool created;
}

class ReceiptRow {
  const ReceiptRow({
    required this.receiptId,
    required this.createdAt,
    required this.barcode,
    required this.customerName,
    required this.amountRub,
    required this.redeemPoints,
    required this.earnPoints,
    required this.status,
    required this.pointsAfter,
  });

  final String receiptId;
  final DateTime createdAt;
  final String barcode;
  final String customerName;
  final int amountRub;
  final int redeemPoints;
  final int earnPoints;
  final String status;
  final int pointsAfter;

  bool get isRefunded => status == 'refunded';
}

class AdminCustomer {
  const AdminCustomer({
    required this.id,
    required this.barcode,
    required this.name,
    required this.phone,
    required this.points,
    required this.blocked,
  });

  final String id;
  final String barcode;
  final String name;
  final String phone;
  final int points;
  final bool blocked;

  String get displayName => name.trim().isEmpty ? 'Гость' : name;
}

class StaffRow {
  const StaffRow({
    required this.id,
    required this.storeId,
    required this.login,
    required this.name,
    required this.role,
    required this.active,
  });

  final String id;
  final String storeId;
  final String login;
  final String name;
  final String role;
  final bool active;

  String get roleLabel =>
      mapStaffRole(role) == AppRole.admin ? 'Админ' : 'Менеджер';
}

class StoreLocation {
  const StoreLocation({
    required this.id,
    required this.name,
    required this.address,
  });

  final String id;
  final String name;
  final String address;
}

class AppVersionInfo {
  const AppVersionInfo({required this.minSupported, required this.downloadUrl});

  final String minSupported;
  final String downloadUrl;
}
