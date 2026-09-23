import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:merch/src/core/constant/config.dart';
import 'package:merch/src/core/constant/localization/generated/l10n.dart';
import 'package:merch/src/core/constant/localization/localization.dart';
import 'package:merch/src/core/model/models.dart';
import 'package:merch/src/core/theme/theme.dart';
import 'package:merch/src/core/utils/extensions/context_extension.dart';
import 'package:merch/src/feature/auth/bloc/auth_bloc.dart';
import 'package:merch/src/feature/auth/bloc/auth_state.dart';
import 'package:merch/src/feature/auth/data/auth_repository.dart';
import 'package:merch/src/feature/admin_customers/data/admin_customers_repository.dart';
import 'package:merch/src/feature/admin_settings/data/loyalty_settings_repository.dart';
import 'package:merch/src/feature/admin_staff/data/admin_staff_repository.dart';
import 'package:merch/src/feature/admin_stores/data/admin_stores_repository.dart';
import 'package:merch/src/feature/auth/widget/auth_scope.dart';
import 'package:merch/src/feature/customer/widget/customer_card_screen.dart';
import 'package:merch/src/feature/enroll/data/enroll_repository.dart';
import 'package:merch/src/feature/shift/data/shift_repository.dart';
import 'package:merch/src/feature/enroll/widget/enroll_scope.dart';
import 'package:merch/src/feature/enroll/widget/enroll_screen.dart';
import 'package:merch/src/feature/initialization/model/dependencies.dart';
import 'package:merch/src/feature/initialization/widget/dependencies_scope.dart';
import 'package:merch/src/feature/receipt/data/receipt_repository.dart';
import 'package:merch/src/feature/receipt/widget/receipt_scope.dart';
import 'package:merch/src/feature/receipt/widget/receipt_screen.dart';
import 'package:merch/src/feature/scan/data/scan_repository.dart';
import 'package:qr_flutter/qr_flutter.dart';

/// Renders store listing frames from the real screens.
///
/// ```sh
/// flutter test --update-goldens --dart-define=STORE_SHOTS=true test/store/store_screenshots_test.dart
/// ```
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('store screenshots', (tester) async {
    const enabled = bool.fromEnvironment('STORE_SHOTS');
    if (!enabled) return;

    debugDisableShadows = false;
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await _loadRoboto();

    final deps = _dependencies();
    addTearDown(deps.authBloc.close);

    final shots = <_Shot>[
      _Shot(
        file: '01_scan',
        title: 'QR карты\nна кассе',
        subtitle: 'Наведите камеру — код уходит на сервер, кадр нет',
        build: () => const _ScanPreview(),
      ),
      _Shot(
        file: '02_customer',
        title: 'Баланс\nсразу на экране',
        subtitle: 'Имя, код карты и сколько баллов можно списать',
        build: () => CustomerCardScreen(customer: _customer),
      ),
      _Shot(
        file: '03_receipt',
        title: 'Чек\nза пару нажатий',
        subtitle: 'Списание, начисление и сумма к оплате',
        build: () => ReceiptScope(child: ReceiptScreen(customer: _customer)),
        prepare: (tester) async {
          final fields = find.byType(TextField, skipOffstage: false);
          await tester.enterText(fields.at(0), '2450');
          await tester.enterText(fields.at(1), '300');
          await tester.pump();
          await tester.tap(find.text('Рассчитать'));
          await tester.pump();
          await tester.pump(const Duration(milliseconds: 50));
        },
      ),
      _Shot(
        file: '04_done',
        title: 'Баллы\nуже на карте',
        subtitle: 'После чека кассир видит новый баланс',
        build: () => const ReceiptSuccessScreen(
          result: CommitResult(
            receiptId: 'rcpt-1',
            customerId: 'cust-1',
            barcode: 'MCH-10428',
            points: 1088,
            earnPoints: 108,
            redeemPoints: 300,
            idempotentReplay: false,
          ),
        ),
      ),
      _Shot(
        file: '05_enroll',
        title: 'Новая карта\nза минуту',
        subtitle: 'Покажите QR — клиент сохранит карту себе',
        build: () => const EnrollScope(child: EnrollScreen()),
        prepare: (tester) async {
          final name = find.byType(TextField, skipOffstage: false);
          if (name.evaluate().isEmpty) return;
          await tester.enterText(name.first, 'Мария');
          await tester.tap(find.widgetWithText(ElevatedButton, 'Выдать карту'));
          await tester.pump();
          await tester.pump(const Duration(milliseconds: 50));
        },
      ),
    ];

    for (final shot in shots) {
      await _shoot(
        tester,
        logical: const Size(390, 844),
        golden: '../../store/goldens/${shot.file}.png',
        child: _app(deps, shot.build()),
        prepare: shot.prepare,
      );

      for (final target in _targets) {
        await _shoot(
          tester,
          logical: target.logical,
          golden: '../../${target.dir}/${shot.file}.png',
          child: _Poster(
            title: shot.title,
            subtitle: shot.subtitle,
            screen: _app(deps, shot.build()),
          ),
          prepare: shot.prepare,
        );
      }
    }
    debugDisableShadows = true;
  });
}

const _customer = LookupCustomer(
  customerId: 'cust-1',
  name: 'Анна Соколова',
  points: 1280,
  redeemMin: 100,
  redeemRate: 1,
  canRedeem: true,
  barcode: 'MCH-10428',
);

class _Shot {
  const _Shot({
    required this.file,
    required this.title,
    required this.subtitle,
    required this.build,
    this.prepare,
  });

  final String file;
  final String title;
  final String subtitle;
  final Widget Function() build;
  final Future<void> Function(WidgetTester tester)? prepare;
}

class _Target {
  const _Target(this.dir, this.logical);

  final String dir;
  final Size logical;
}

// Golden capture is 1:1 with the surface size.
const _targets = [
  _Target('store/appstore/iphone-6.7', Size(1290, 2796)),
  _Target('store/appstore/iphone-6.5', Size(1284, 2778)),
  _Target('store/play', Size(1080, 1920)),
];

Future<void> _shoot(
  WidgetTester tester, {
  required Size logical,
  required String golden,
  required Widget child,
  Future<void> Function(WidgetTester tester)? prepare,
}) async {
  await tester.binding.setSurfaceSize(logical);
  await tester.pumpWidget(
    RepaintBoundary(
      key: const Key('shot'),
      child: child,
    ),
  );
  await tester.pump();
  final context = tester.element(find.byKey(const Key('shot')));
  await tester.runAsync(
    () => precacheImage(
      const AssetImage('assets/images/merch-logo.png'),
      context,
    ),
  );
  await tester.pump();
  if (prepare != null) await prepare(tester);
  FocusManager.instance.primaryFocus?.unfocus();
  await tester.pump(const Duration(milliseconds: 500));
  await expectLater(find.byKey(const Key('shot')), matchesGoldenFile(golden));
}

Widget _app(Dependencies deps, Widget child) => DependenciesScope(
  dependencies: deps,
  child: AuthScope(
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: _storeTheme(),
      locale: const Locale('ru'),
      supportedLocales: AppLocalizations.delegate.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: child,
    ),
  ),
);

Dependencies _dependencies() => Dependencies(
  config: const Config(),
  authBloc: AuthBloc(
    const AuthState.idle(status: AuthenticationStatus.unauthenticated),
    authRepository: _AuthRepository(),
  ),
  scanRepository: _ScanRepository(),
  receiptRepository: _ReceiptRepository(),
  enrollRepository: _EnrollRepository(),
  shiftRepository: _ShiftRepository(),
  loyaltySettingsRepository: _LoyaltyRepository(),
  adminCustomersRepository: _CustomersRepository(),
  adminStaffRepository: _StaffRepository(),
  adminStoresRepository: _StoresRepository(),
);

Future<void> _loadRoboto() async {
  final roboto = FontLoader('Roboto')
    ..addFont(rootBundle.load('assets/fonts/Roboto-Regular.ttf'))
    ..addFont(rootBundle.load('assets/fonts/Roboto-Medium.ttf'))
    ..addFont(rootBundle.load('assets/fonts/Roboto-Bold.ttf'));
  final mono = FontLoader('monospace')
    ..addFont(rootBundle.load('assets/fonts/Roboto-Regular.ttf'));
  final icons = FontLoader('MaterialIcons')
    ..addFont(rootBundle.load('assets/fonts/MaterialIcons-Regular.otf'));
  await Future.wait([roboto.load(), mono.load(), icons.load()]);
}

ThemeData _storeTheme() {
  const family = 'Roboto';
  final base = $lightThemeData;
  final text = base.textTheme.apply(fontFamily: family);
  final button = text.labelLarge?.copyWith(
    fontFamily: family,
    fontWeight: FontWeight.w600,
    fontSize: 16,
  );
  return base.copyWith(
    textTheme: text,
    primaryTextTheme: base.primaryTextTheme.apply(fontFamily: family),
    appBarTheme: base.appBarTheme.copyWith(
      titleTextStyle: base.appBarTheme.titleTextStyle?.copyWith(
        fontFamily: family,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: base.elevatedButtonTheme.style?.copyWith(
        textStyle: WidgetStatePropertyAll(button),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: base.outlinedButtonTheme.style?.copyWith(
        textStyle: WidgetStatePropertyAll(button?.copyWith(color: null)),
      ),
    ),
    bottomNavigationBarTheme: base.bottomNavigationBarTheme.copyWith(
      selectedLabelStyle: const TextStyle(
        fontFamily: family,
        fontSize: 11,
        fontWeight: FontWeight.w500,
      ),
      unselectedLabelStyle: const TextStyle(
        fontFamily: family,
        fontSize: 11,
        fontWeight: FontWeight.w500,
      ),
    ),
  );
}

class _Poster extends StatelessWidget {
  const _Poster({
    required this.screen,
    required this.title,
    required this.subtitle,
  });

  final Widget screen;
  final String title;
  final String subtitle;

  static const _navy = Color(0xFF12164A);
  static const _navySoft = Color(0xFF1B2160);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: ColoredBox(
      color: _navy,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final titleSize = width * 0.078;
          return Stack(
            children: [
              Positioned(
                right: -width * 0.18,
                bottom: width * 0.05,
                child: Container(
                  width: width * 0.95,
                  height: width * 0.95,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: _navySoft,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  width * 0.075,
                  width * 0.09,
                  width * 0.075,
                  width * 0.06,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(width * 0.03),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: width * 0.03,
                          vertical: width * 0.015,
                        ),
                        child: Image.asset(
                          'assets/images/merch-logo.png',
                          height: width * 0.055,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    SizedBox(height: width * 0.045),
                    Text(
                      title,
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        color: Colors.white,
                        fontSize: titleSize,
                        height: 1.02,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -1,
                      ),
                    ),
                    SizedBox(height: width * 0.025),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        color: Colors.white.withValues(alpha: 0.78),
                        fontSize: width * 0.032,
                        height: 1.25,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: width * 0.05),
                    Expanded(
                      child: Center(
                        child: AspectRatio(
                          aspectRatio: 390 / 844,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(width * 0.045),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.28),
                                  blurRadius: width * 0.04,
                                  offset: Offset(0, width * 0.015),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(width * 0.012),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  width * 0.036,
                                ),
                                child: FittedBox(
                                  child: SizedBox(
                                    width: 390,
                                    height: 844,
                                    child: screen,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      ),
    );
  }
}

class _ScanPreview extends StatelessWidget {
  const _ScanPreview();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          const ColoredBox(color: Color(0xFF101218)),
          Center(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: EdgeInsets.all(12),
                child: QrImageView(
                  data: 'MCH-10428',
                  size: 216,
                  backgroundColor: Colors.white,
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 16),
                Text(
                  l10n.scanHint,
                  style: context.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    _RoundAction(icon: Icons.flash_off),
                    SizedBox(width: 24),
                    _RoundAction(icon: Icons.keyboard_alt_outlined),
                  ],
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const _CashierBar(index: 2),
    );
  }
}

class _RoundAction extends StatelessWidget {
  const _RoundAction({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.white.withValues(alpha: 0.15),
    shape: const CircleBorder(),
    child: Padding(
      padding: const EdgeInsets.all(14),
      child: Icon(icon, color: Colors.white),
    ),
  );
}

class _CashierBar extends StatelessWidget {
  const _CashierBar({required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return DecoratedBox(
      position: DecorationPosition.foreground,
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: context.colorScheme.outline)),
      ),
      child: BottomNavigationBar(
        currentIndex: index,
        iconSize: 28,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.receipt_long_outlined),
            label: l10n.tabShift,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.card_membership_outlined),
            label: l10n.tabCard,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.qr_code_scanner, size: 32),
            label: l10n.tabScan,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.search),
            label: l10n.tabReceipts,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person_outline),
            label: l10n.tabProfile,
          ),
        ],
      ),
    );
  }
}

final class _AuthRepository implements AuthRepository {
  @override
  Stream<AuthenticationStatus> get authStatus => const Stream.empty();

  @override
  Session? get session => null;

  @override
  Future<Session?> restore() async => null;

  @override
  Future<void> signIn({required String login, required String secret}) async {}

  @override
  Future<void> signOut() async {}
}

final class _ScanRepository implements ScanRepository {
  @override
  Future<LookupCustomer> lookup(String barcode) async => _customer;
}

final class _ReceiptRepository implements ReceiptRepository {
  @override
  Future<QuoteResult> quote({
    required String barcode,
    required int amountRub,
    required int requestedPoints,
  }) async {
    final redeem = requestedPoints > 0 ? requestedPoints : 300;
    return QuoteResult(
      allowed: true,
      requestedPoints: redeem,
      maxPoints: 1280,
      redeemPoints: redeem,
      redeemRub: redeem,
      earnPoints: 108,
      payableRub: amountRub - redeem,
      currentPoints: 1280,
    );
  }

  @override
  Future<CommitResult> commit({
    required String receiptId,
    required String barcode,
    required int amountRub,
    required int redeemPoints,
  }) async => const CommitResult(
    receiptId: 'rcpt-1',
    customerId: 'cust-1',
    barcode: 'MCH-10428',
    points: 1088,
    earnPoints: 108,
    redeemPoints: 300,
    idempotentReplay: false,
  );
}

final class _EnrollRepository implements EnrollRepository {
  @override
  Future<EnrollResult> enroll({String? name, String? phone}) async =>
      const EnrollResult(
        customerId: 'cust-2',
        barcode: 'MCH-7F3A',
        addPage: 'https://merch.store/card/MCH-7F3A',
        created: true,
      );
}

final class _ShiftRepository implements ShiftRepository {
  @override
  Future<List<ReceiptRow>?> listReceipts() async => const [];

  @override
  Future<int> refund(String receiptId) async => 0;
}

final class _LoyaltyRepository implements LoyaltySettingsRepository {
  @override
  Future<Map<String, String>> fetch() async => const {};

  @override
  Future<Map<String, String>> save(Map<String, String> settings) async =>
      settings;
}

final class _CustomersRepository implements AdminCustomersRepository {
  @override
  Future<int> adjust({
    required String barcode,
    required int delta,
    required String reason,
  }) async => 0;

  @override
  Future<void> block(String id) async {}

  @override
  Future<List<AdminCustomer>> search(String query) async => const [];

  @override
  Future<void> unblock(String id) async {}
}

final class _StaffRepository implements AdminStaffRepository {
  @override
  Future<StaffRow> create({
    required String login,
    required String name,
    required String password,
    required String role,
  }) => throw UnimplementedError();

  @override
  Future<List<StaffRow>> list() async => const [];

  @override
  Future<StaffRow> patch(
    String id, {
    String? login,
    String? name,
    String? password,
    String? role,
    bool? active,
  }) => throw UnimplementedError();
}

final class _StoresRepository implements AdminStoresRepository {
  @override
  Future<StoreLocation> create({required String name, String? address}) =>
      throw UnimplementedError();

  @override
  Future<void> delete(String id) async {}

  @override
  Future<List<StoreLocation>> list() async => const [];

  @override
  Future<StoreLocation> patch(String id, {String? name, String? address}) =>
      throw UnimplementedError();
}
