import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:merch/src/core/model/models.dart';
import 'package:merch/src/core/router/auth_guard.dart';
import 'package:merch/src/core/router/observer.dart';
import 'package:merch/src/core/router/redirect_builder.dart';
import 'package:merch/src/core/widget/custom_bottom_navigation_bar.dart';
import 'package:merch/src/feature/admin_customers/widget/admin_customers_scope.dart';
import 'package:merch/src/feature/admin_customers/widget/admin_customers_screen.dart';
import 'package:merch/src/feature/admin_settings/widget/admin_more_screen.dart';
import 'package:merch/src/feature/admin_staff/widget/admin_staff_scope.dart';
import 'package:merch/src/feature/admin_staff/widget/admin_staff_screen.dart';
import 'package:merch/src/feature/admin_stores/widget/admin_stores_scope.dart';
import 'package:merch/src/feature/admin_stores/widget/admin_stores_screen.dart';
import 'package:merch/src/feature/auth/widget/auth_screen.dart';
import 'package:merch/src/feature/customer/widget/customer_card_screen.dart';
import 'package:merch/src/feature/enroll/widget/enroll_scope.dart';
import 'package:merch/src/feature/enroll/widget/enroll_screen.dart';
import 'package:merch/src/feature/profile/widget/profile_screen.dart';
import 'package:merch/src/feature/receipt/widget/receipt_scope.dart';
import 'package:merch/src/feature/receipt/widget/receipt_screen.dart';
import 'package:merch/src/feature/scan/widget/scan_scope.dart';
import 'package:merch/src/feature/scan/widget/scan_screen.dart';
import 'package:merch/src/feature/shift/widget/shift_scope.dart';
import 'package:merch/src/feature/shift/widget/shift_screen.dart';

final _parentKey = GlobalKey<NavigatorState>();

GoRouter createRouter({required Listenable refreshListenable}) => GoRouter(
  initialLocation: '/auth',
  navigatorKey: _parentKey,
  observers: [RouterObserver()],
  refreshListenable: refreshListenable,
  redirect: RedirectBuilder({
    RedirectIfAuthenticatedGuard(),
    RedirectIfUnauthenticatedGuard(),
    RedirectIfNotAdminGuard(),
  }).call,
  routes: [
    GoRoute(name: 'auth', path: '/auth', builder: (_, _) => const AuthScreen()),
    GoRoute(
      path: '/overlay/customer',
      parentNavigatorKey: _parentKey,
      builder: (_, state) =>
          CustomerCardScreen(customer: state.extra! as LookupCustomer),
    ),
    GoRoute(
      path: '/overlay/receipt',
      parentNavigatorKey: _parentKey,
      builder: (_, state) => ReceiptScope(
        child: ReceiptScreen(customer: state.extra! as LookupCustomer),
      ),
    ),
    GoRoute(
      path: '/overlay/success',
      parentNavigatorKey: _parentKey,
      builder: (_, state) =>
          ReceiptSuccessScreen(result: state.extra! as CommitResult),
    ),
    StatefulShellRoute.indexedStack(
      builder: (_, _, navigationShell) =>
          CustomBottomNavigationBar(navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/shift',
              builder: (_, _) => const ShiftScope(child: ShiftScreen()),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/enroll',
              builder: (_, _) => const EnrollScope(child: EnrollScreen()),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/scan',
              builder: (_, _) => const ScanScope(child: ScanScreen()),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/receipts',
              builder: (_, _) => const ShiftScope(child: ShiftScreen()),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(path: '/profile', builder: (_, _) => const ProfileScreen()),
          ],
        ),
      ],
    ),
    StatefulShellRoute.indexedStack(
      builder: (_, _, navigationShell) =>
          CustomBottomNavigationBar(navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/admin/customers',
              builder: (_, _) => const AdminCustomersScope(
                child: AdminCustomersScreen(),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/admin/staff',
              builder: (_, _) => const AdminStaffScope(
                child: AdminStaffScreen(),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/admin/scan',
              builder: (_, _) => const ScanScope(child: ScanScreen()),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/admin/stores',
              builder: (_, _) => const AdminStoresScope(
                child: AdminStoresScreen(),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/admin/more',
              builder: (_, _) => const AdminMoreScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);
