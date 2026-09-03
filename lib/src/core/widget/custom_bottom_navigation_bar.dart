import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:merch/src/core/constant/localization/localization.dart';
import 'package:merch/src/core/utils/extensions/context_extension.dart';
import 'package:merch/src/feature/auth/widget/auth_scope.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar(this.navigationShell, {super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final isAdmin = AuthScope.of(context).isAdmin;
    final l10n = context.l10n;
    final items = isAdmin
        ? [
            BottomNavigationBarItem(
              icon: const Icon(Icons.people_outline),
              label: l10n.tabCustomers,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.badge_outlined),
              label: l10n.tabTeam,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.qr_code_scanner, size: 32),
              label: l10n.tabScan,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.storefront_outlined),
              label: l10n.tabStores,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.more_horiz),
              label: l10n.tabMore,
            ),
          ]
        : [
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
          ];

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: DecoratedBox(
        position: DecorationPosition.foreground,
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: context.colorScheme.outlineVariant),
          ),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: navigationShell.currentIndex,
          iconSize: 28,
          onTap: (index) => navigationShell.goBranch(index),
          items: items,
        ),
      ),
    );
  }
}
