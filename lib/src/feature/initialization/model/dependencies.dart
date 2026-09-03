import 'package:merch/src/core/constant/config.dart';
import 'package:merch/src/core/model/models.dart';
import 'package:merch/src/feature/admin_customers/data/admin_customers_repository.dart';
import 'package:merch/src/feature/admin_settings/data/loyalty_settings_repository.dart';
import 'package:merch/src/feature/admin_staff/data/admin_staff_repository.dart';
import 'package:merch/src/feature/admin_stores/data/admin_stores_repository.dart';
import 'package:merch/src/feature/auth/bloc/auth_bloc.dart';
import 'package:merch/src/feature/enroll/data/enroll_repository.dart';
import 'package:merch/src/feature/receipt/data/receipt_repository.dart';
import 'package:merch/src/feature/scan/data/scan_repository.dart';
import 'package:merch/src/feature/shift/data/shift_repository.dart';

base class Dependencies {
  const Dependencies({
    required this.config,
    required this.authBloc,
    required this.scanRepository,
    required this.receiptRepository,
    required this.enrollRepository,
    required this.shiftRepository,
    required this.loyaltySettingsRepository,
    required this.adminCustomersRepository,
    required this.adminStaffRepository,
    required this.adminStoresRepository,
    this.appVersion,
    this.currentVersion = '1.0.0',
  });

  final Config config;
  final AuthBloc authBloc;
  final ScanRepository scanRepository;
  final ReceiptRepository receiptRepository;
  final EnrollRepository enrollRepository;
  final ShiftRepository shiftRepository;
  final LoyaltySettingsRepository loyaltySettingsRepository;
  final AdminCustomersRepository adminCustomersRepository;
  final AdminStaffRepository adminStaffRepository;
  final AdminStoresRepository adminStoresRepository;
  final AppVersionInfo? appVersion;
  final String currentVersion;
}

final class InitializationResult {
  const InitializationResult({
    required this.dependencies,
    required this.msSpent,
  });

  final Dependencies dependencies;
  final int msSpent;
}
