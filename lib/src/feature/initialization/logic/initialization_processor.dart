import 'package:dio/dio.dart';
import 'package:merch/src/core/api/merch_api.dart';
import 'package:merch/src/core/constant/config.dart';
import 'package:merch/src/core/model/models.dart';
import 'package:merch/src/core/rest_client/rest_client.dart';
import 'package:merch/src/core/utils/refined_logger.dart';
import 'package:merch/src/feature/admin_customers/data/admin_customers_data_source.dart';
import 'package:merch/src/feature/admin_customers/data/admin_customers_repository.dart';
import 'package:merch/src/feature/admin_settings/data/loyalty_settings_data_source.dart';
import 'package:merch/src/feature/admin_settings/data/loyalty_settings_repository.dart';
import 'package:merch/src/feature/admin_staff/data/admin_staff_data_source.dart';
import 'package:merch/src/feature/admin_staff/data/admin_staff_repository.dart';
import 'package:merch/src/feature/admin_stores/data/admin_stores_data_source.dart';
import 'package:merch/src/feature/admin_stores/data/admin_stores_repository.dart';
import 'package:merch/src/feature/auth/bloc/auth_bloc.dart';
import 'package:merch/src/feature/auth/bloc/auth_state.dart';
import 'package:merch/src/feature/auth/data/auth_data_source.dart';
import 'package:merch/src/feature/auth/data/auth_repository.dart';
import 'package:merch/src/feature/auth/data/session_storage.dart';
import 'package:merch/src/feature/auth/logic/auth_interceptor.dart';
import 'package:merch/src/feature/enroll/data/enroll_data_source.dart';
import 'package:merch/src/feature/enroll/data/enroll_repository.dart';
import 'package:merch/src/feature/receipt/data/receipt_data_source.dart';
import 'package:merch/src/feature/receipt/data/receipt_repository.dart';
import 'package:merch/src/feature/scan/data/scan_data_source.dart';
import 'package:merch/src/feature/scan/data/scan_repository.dart';
import 'package:merch/src/feature/shift/data/shift_data_source.dart';
import 'package:merch/src/feature/shift/data/shift_repository.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '/src/feature/initialization/model/dependencies.dart';

final class InitializationProcessor {
  const InitializationProcessor();

  Future<InitializationResult> initialize() async {
    final stopwatch = Stopwatch()..start();
    logger.info('Initializing dependencies...');
    final dependencies = await _initDependencies();
    logger.info('Dependencies initialized');
    stopwatch.stop();
    return InitializationResult(
      dependencies: dependencies,
      msSpent: stopwatch.elapsedMilliseconds,
    );
  }

  Future<Dependencies> _initDependencies() async {
    const config = Config();
    final storage = SessionStorage();
    final session = await storage.load();

    late final AuthRepositoryImpl authRepository;
    void onUnauthorized() => authRepository.signOut();

    final interceptor = AuthInterceptor(
      tokenStorage: storage,
      onUnauthorized: onUnauthorized,
    );
    await interceptor.preload();

    final dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 8),
        receiveTimeout: const Duration(seconds: 8),
        sendTimeout: const Duration(seconds: 8),
      ),
    )..interceptors.add(interceptor);

    final restClient = RestClientDio(baseUrl: config.baseUrl, dio: dio);
    final api = MerchApi(restClient);

    authRepository = AuthRepositoryImpl(
      dataSource: AuthDataSourceNetwork(api: api),
      storage: storage,
    );
    if (session != null) {
      await authRepository.restore();
    }

    final authBloc = AuthBloc(
      AuthState.idle(
        status: session != null
            ? AuthenticationStatus.authenticated
            : AuthenticationStatus.unauthenticated,
        session: session,
      ),
      authRepository: authRepository,
    );

    AppVersionInfo? version;
    var currentVersion = '1.0.0';
    try {
      final info = await PackageInfo.fromPlatform();
      currentVersion = info.version;
      version = await api.appVersion();
    } on Object catch (e, st) {
      logger.warn('App version check skipped', error: e, stackTrace: st);
    }

    return Dependencies(
      config: config,
      authBloc: authBloc,
      scanRepository: ScanRepositoryImpl(
        dataSource: ScanDataSourceNetwork(api: api),
      ),
      receiptRepository: ReceiptRepositoryImpl(
        dataSource: ReceiptDataSourceNetwork(api: api),
      ),
      enrollRepository: EnrollRepositoryImpl(
        dataSource: EnrollDataSourceNetwork(api: api),
      ),
      shiftRepository: ShiftRepositoryImpl(
        dataSource: ShiftDataSourceNetwork(api: api),
      ),
      loyaltySettingsRepository: LoyaltySettingsRepositoryImpl(
        dataSource: LoyaltySettingsDataSourceNetwork(api: api),
      ),
      adminCustomersRepository: AdminCustomersRepositoryImpl(
        dataSource: AdminCustomersDataSourceNetwork(api: api),
      ),
      adminStaffRepository: AdminStaffRepositoryImpl(
        dataSource: AdminStaffDataSourceNetwork(api: api),
      ),
      adminStoresRepository: AdminStoresRepositoryImpl(
        dataSource: AdminStoresDataSourceNetwork(api: api),
      ),
      appVersion: version,
      currentVersion: currentVersion,
    );
  }
}
