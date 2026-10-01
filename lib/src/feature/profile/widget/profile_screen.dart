import 'package:flutter/material.dart';
import 'package:merch/src/core/constant/localization/localization.dart';
import 'package:merch/src/core/utils/extensions/context_extension.dart';
import 'package:merch/src/feature/auth/widget/auth_scope.dart';
import 'package:merch/src/feature/initialization/widget/dependencies_scope.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(context.l10n.profile)),
    body: const Padding(padding: EdgeInsets.all(16), child: ProfileBody()),
  );
}

class ProfileBody extends StatelessWidget {
  const ProfileBody({super.key});

  @override
  Widget build(BuildContext context) {
    final session = AuthScope.of(context).session;
    final version = DependenciesScope.of(context).currentVersion;
    final l10n = context.l10n;
    final name = session?.staffName.isNotEmpty == true
        ? session!.staffName
        : l10n.employee;
    final store = session?.storeName?.isNotEmpty == true
        ? session!.storeName!
        : l10n.storeIdLabel(session?.storeId ?? '');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: context.colorScheme.primary.withValues(
                        alpha: 0.08,
                      ),
                      foregroundColor: context.colorScheme.primary,
                      child: Text(
                        name.characters.first.toUpperCase(),
                        style: context.textTheme.titleMedium,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(name, style: context.textTheme.titleLarge),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(),
                _ProfileRow(label: l10n.role, value: session?.roleLabel ?? ''),
                _ProfileRow(label: l10n.store, value: store),
                const SizedBox(height: 8),
                Text(
                  l10n.appVersion(version),
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        OutlinedButton(
          onPressed: () => AuthScope.of(context).signOut(),
          child: Text(l10n.signOut),
        ),
      ],
    );
  }
}

class _ProfileRow extends StatelessWidget {
  const _ProfileRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 72,
            child: Text(
              label,
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(child: Text(value, style: context.textTheme.titleSmall)),
        ],
      ),
    );
  }
}
