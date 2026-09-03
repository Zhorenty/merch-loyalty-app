import 'package:flutter/material.dart';
import 'package:merch/src/core/constant/localization/localization.dart';
import 'package:merch/src/core/utils/extensions/context_extension.dart';
import 'package:merch/src/core/widget/states.dart';
import 'package:merch/src/feature/admin_settings/bloc/loyalty_settings_state.dart';
import 'package:merch/src/feature/admin_settings/widget/loyalty_settings_scope.dart';
import 'package:merch/src/feature/profile/widget/profile_screen.dart';

class AdminMoreScreen extends StatelessWidget {
  const AdminMoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.more)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.tune),
              title: Text(l10n.loyaltyRules),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const LoyaltySettingsScope(
                    child: LoyaltySettingsScreen(),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const ProfileBody(),
        ],
      ),
    );
  }
}

class LoyaltySettingsScreen extends StatefulWidget {
  const LoyaltySettingsScreen({super.key});

  @override
  State<LoyaltySettingsScreen> createState() => _LoyaltySettingsScreenState();
}

class _LoyaltySettingsScreenState extends State<LoyaltySettingsScreen> {
  final _controllers = <String, TextEditingController>{};

  static const _keys = <String>[
    'earn_percent',
    'redeem_min',
    'redeem_max_share',
    'redeem_rate',
    'earn_min_receipt',
  ];

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _syncControllers(Map<String, String> settings) {
    for (final key in _keys) {
      _controllers.putIfAbsent(
        key,
        () => TextEditingController(text: settings[key] ?? ''),
      );
    }
  }

  String _label(AppLocalizations l10n, String key) => switch (key) {
    'earn_percent' => l10n.settingEarnPercent,
    'redeem_min' => l10n.settingRedeemMin,
    'redeem_max_share' => l10n.settingRedeemMaxShare,
    'redeem_rate' => l10n.settingRedeemRate,
    'earn_min_receipt' => l10n.settingEarnMinReceipt,
    _ => key,
  };

  @override
  Widget build(BuildContext context) {
    final controller = LoyaltySettingsScope.of(context);
    final state = controller.state;
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.loyaltyRules)),
      body: switch (state) {
        LoyaltySettingsState$Processing() => const SkeletonList(count: 5),
        LoyaltySettingsState$Error(:final error) => ErrorState(
          message: context.errorMessage(error),
          onRetry: controller.refresh,
        ),
        LoyaltySettingsState$Idle(:final settings, :final saving) => () {
          _syncControllers(settings);
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              for (final key in _keys) ...[
                Text(_label(l10n, key), style: context.textTheme.titleSmall),
                const SizedBox(height: 8),
                TextField(controller: _controllers[key]),
                const SizedBox(height: 16),
              ],
              ElevatedButton(
                onPressed: saving
                    ? null
                    : () => controller.save(
                        settings: {
                          for (final entry in _controllers.entries)
                            entry.key: entry.value.text,
                        },
                        onSuccess: () {
                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(l10n.settingsSaved)),
                          );
                        },
                        onError: (error) {
                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(context.errorMessage(error)),
                            ),
                          );
                        },
                      ),
                child: Text(l10n.save),
              ),
            ],
          );
        }(),
      },
    );
  }
}
