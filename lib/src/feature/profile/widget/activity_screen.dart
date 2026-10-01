import 'package:flutter/material.dart';
import 'package:merch/src/core/constant/localization/localization.dart';
import 'package:merch/src/core/model/models.dart';
import 'package:merch/src/core/utils/extensions/context_extension.dart';
import 'package:merch/src/core/widget/states.dart';
import 'package:merch/src/feature/auth/widget/auth_scope.dart';
import 'package:merch/src/feature/initialization/widget/dependencies_scope.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  List<ActivityEntry>? _items;
  Object? _error;
  var _loading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final admin = AuthScope.of(context).session?.isAdmin == true;
      final items = await DependenciesScope.of(
        context,
      ).activityRepository.list(admin: admin);
      if (!mounted) return;
      setState(() {
        _items = items;
        _loading = false;
      });
    } on Object catch (error) {
      if (!mounted) return;
      setState(() {
        _error = error;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.recentActivity)),
      body: _body(l10n),
    );
  }

  Widget _body(AppLocalizations l10n) {
    if (_loading && _items == null) return const SkeletonList();
    if (_error != null && (_items == null || _items!.isEmpty)) {
      return ErrorState(message: context.errorMessage(_error!), onRetry: _load);
    }
    final items = _items ?? const <ActivityEntry>[];
    if (items.isEmpty) {
      return EmptyState(
        title: l10n.activityEmpty,
        subtitle: l10n.activityEmptyHint,
      );
    }
    return RefreshIndicator(
      onRefresh: _load,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: items.length,
        separatorBuilder: (_, _) => const SizedBox(height: 8),
        itemBuilder: (context, index) => _ActivityTile(entry: items[index]),
      ),
    );
  }
}

class _ActivityTile extends StatelessWidget {
  const _ActivityTile({required this.entry});

  final ActivityEntry entry;

  @override
  Widget build(BuildContext context) {
    final meta = [
      if (entry.actorName.isNotEmpty) entry.actorName,
      _formatWhen(entry.createdAt),
    ].join(' · ');
    return Card(
      child: ListTile(
        leading: Icon(_icon(entry.kind), color: context.colorScheme.primary),
        title: Text(entry.title),
        subtitle: Text(
          [if (entry.detail.isNotEmpty) entry.detail, meta].join('\n'),
        ),
        isThreeLine: entry.detail.isNotEmpty,
      ),
    );
  }
}

IconData _icon(String kind) => switch (kind) {
  'card_issued' => Icons.credit_card,
  'customer_blocked' || 'customer_deleted' => Icons.block,
  'customer_unblocked' || 'customer_restored' => Icons.restart_alt,
  'points_adjusted' => Icons.toll,
  'receipt_committed' => Icons.receipt_long,
  'receipt_refunded' => Icons.undo,
  'staff_created' || 'staff_updated' || 'staff_deleted' => Icons.badge_outlined,
  'store_created' ||
  'store_updated' ||
  'store_deleted' => Icons.storefront_outlined,
  'settings_updated' => Icons.tune,
  _ => Icons.history,
};

String _formatWhen(DateTime value) {
  final local = value.toLocal();
  final now = DateTime.now();
  final time =
      '${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}';
  final sameDay =
      local.year == now.year &&
      local.month == now.month &&
      local.day == now.day;
  if (sameDay) return time;
  final date =
      '${local.day.toString().padLeft(2, '0')}.${local.month.toString().padLeft(2, '0')}';
  return '$date $time';
}
