import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:merch/src/core/constant/localization/localization.dart';
import 'package:merch/src/core/model/models.dart';
import 'package:merch/src/core/utils/extensions/context_extension.dart';

class CustomerCardScreen extends StatelessWidget {
  const CustomerCardScreen({required this.customer, super.key});

  final LookupCustomer customer;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final name = customer.name.trim().isEmpty ? l10n.guest : customer.name;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.customer)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 24),
            Text(
              name,
              style: context.textTheme.headlineLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              customer.barcode,
              textAlign: TextAlign.center,
              style: context.textTheme.bodySmall?.copyWith(
                fontFamily: 'monospace',
                color: context.colorScheme.onSurfaceVariant,
              ),
            ),
            const Spacer(),
            Text(
              '${customer.points}',
              textAlign: TextAlign.center,
              style: context.textTheme.displayLarge,
            ),
            const SizedBox(height: 4),
            Text(
              l10n.points,
              textAlign: TextAlign.center,
              style: context.textTheme.titleMedium?.copyWith(
                color: context.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              customer.canRedeem
                  ? l10n.canRedeemFrom(customer.redeemMin)
                  : l10n.redeemFrom(customer.redeemMin),
              textAlign: TextAlign.center,
              style: context.textTheme.bodyMedium?.copyWith(
                color: customer.canRedeem
                    ? context.colorScheme.tertiary
                    : context.colorScheme.onSurfaceVariant,
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () =>
                  context.push('/overlay/receipt', extra: customer),
              child: Text(l10n.receipt),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () => context.pop(),
              child: Text(l10n.close),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
