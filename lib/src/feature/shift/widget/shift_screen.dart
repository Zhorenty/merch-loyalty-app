import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:merch/src/core/constant/localization/localization.dart';
import 'package:merch/src/core/model/models.dart';
import 'package:merch/src/core/utils/extensions/context_extension.dart';
import 'package:merch/src/core/widget/states.dart';
import 'package:merch/src/feature/shift/bloc/shift_state.dart';
import 'package:merch/src/feature/shift/widget/shift_scope.dart';

class ShiftScreen extends StatelessWidget {
  const ShiftScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final shift = ShiftScope.of(context);
    final state = shift.state;
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.shift)),
      body: switch (state) {
        ShiftState$Processing() => const SkeletonList(),
        ShiftState$Error(:final error) => ErrorState(
          message: context.errorMessage(error),
          onRetry: shift.refresh,
        ),
        ShiftState$Idle(:final unavailable)
            when unavailable =>
          EmptyState(
            icon: Icons.receipt_long_outlined,
            title: l10n.shiftHistoryLater,
            subtitle: l10n.shiftHistoryNotCached,
          ),
        ShiftState$Idle(:final receipts)
            when receipts == null || receipts.isEmpty =>
          EmptyState(
            icon: Icons.qr_code_scanner,
            title: l10n.emptyTitle,
            subtitle: l10n.emptyScanHint,
          ),
        ShiftState$Idle(:final receipts) => RefreshIndicator(
          onRefresh: () async => shift.refresh(),
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: receipts!.length,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (context, index) => _ReceiptTile(row: receipts[index]),
          ),
        ),
      },
    );
  }
}

class _ReceiptTile extends StatelessWidget {
  const _ReceiptTile({required this.row});

  final ReceiptRow row;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final time = DateFormat('HH:mm').format(row.createdAt.toLocal());
    final name = row.customerName.isEmpty ? row.barcode : row.customerName;

    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text('${row.amountRub} ₽ · $name'),
        subtitle: Text(
          l10n.receiptSubtitle(time, row.redeemPoints, row.earnPoints),
        ),
        trailing: _StatusChip(refunded: row.isRefunded),
        onTap: () => showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          builder: (context) => ReceiptDetailSheet(row: row),
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.refunded});

  final bool refunded;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: refunded
            ? context.colorScheme.primaryContainer
            : context.colorScheme.tertiaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        refunded ? l10n.statusRefunded : l10n.statusCommitted,
        style: context.textTheme.labelMedium?.copyWith(
          color: refunded
              ? context.colorScheme.onSurfaceVariant
              : context.colorScheme.tertiary,
        ),
      ),
    );
  }
}

class ReceiptDetailSheet extends StatefulWidget {
  const ReceiptDetailSheet({required this.row, super.key});

  final ReceiptRow row;

  @override
  State<ReceiptDetailSheet> createState() => _ReceiptDetailSheetState();
}

class _ReceiptDetailSheetState extends State<ReceiptDetailSheet> {
  bool _busy = false;
  String? _error;

  @override
  Widget build(BuildContext context) {
    final row = widget.row;
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.receipt, style: context.textTheme.headlineLarge),
          const SizedBox(height: 12),
          Text(row.barcode, style: const TextStyle(fontFamily: 'monospace')),
          const SizedBox(height: 8),
          Text(l10n.amountRub(row.amountRub)),
          Text(l10n.redeemedPoints(row.redeemPoints)),
          Text(l10n.earnedPoints(row.earnPoints)),
          Text(l10n.pointsAfter(row.pointsAfter)),
          if (_error != null) ...[
            const SizedBox(height: 12),
            Text(
              _error!,
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colorScheme.error,
              ),
            ),
          ],
          const SizedBox(height: 16),
          if (!row.isRefunded)
            ElevatedButton(
              onPressed: _busy ? null : _refund,
              child: _busy
                  ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(l10n.refund),
            ),
        ],
      ),
    );
  }

  Future<void> _refund() async {
    final l10n = context.l10n;
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.refundReceiptTitle),
        content: Text(l10n.refundReceiptBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.refund),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    ShiftScope.of(context, listen: false).refund(
      receiptId: widget.row.receiptId,
      onSuccess: () {
        if (mounted) Navigator.pop(context);
      },
      onError: (error) {
        if (!mounted) return;
        setState(() {
          _busy = false;
          _error = context.errorMessage(error);
        });
      },
    );
  }
}
