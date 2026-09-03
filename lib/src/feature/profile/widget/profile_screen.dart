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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          session?.staffName ?? l10n.employee,
          style: context.textTheme.headlineLarge,
        ),
        const SizedBox(height: 4),
        Text(session?.roleLabel ?? '', style: context.textTheme.bodyLarge),
        const SizedBox(height: 4),
        Text(
          session?.storeName?.isNotEmpty == true
              ? session!.storeName!
              : l10n.storeIdLabel(session?.storeId ?? ''),
          style: context.textTheme.bodyMedium?.copyWith(
            color: context.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 16),
        Text(l10n.appVersion(version), style: context.textTheme.bodySmall),
        const SizedBox(height: 24),
        OutlinedButton(
          onPressed: () => AuthScope.of(context).signOut(),
          child: Text(l10n.closeShift),
        ),
      ],
    );
  }
}
