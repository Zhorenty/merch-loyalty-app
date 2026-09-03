import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:merch/src/core/constant/localization/localization.dart';
import 'package:merch/src/core/model/models.dart';
import 'package:merch/src/core/utils/extensions/context_extension.dart';
import 'package:merch/src/core/widget/states.dart';
import 'package:merch/src/feature/auth/widget/auth_scope.dart';
import 'package:merch/src/feature/receipt/widget/receipt_scope.dart';
import 'package:uuid/uuid.dart';

class ReceiptScreen extends StatefulWidget {
  const ReceiptScreen({required this.customer, super.key});

  final LookupCustomer customer;

  @override
  State<ReceiptScreen> createState() => _ReceiptScreenState();
}

class _ReceiptScreenState extends State<ReceiptScreen> {
  final _amountController = TextEditingController();
  final _receiptId = const Uuid().v4();
  final _redeemController = TextEditingController(text: '0');
  Timer? _debounce;
  int _redeem = 0;

  LookupCustomer get customer => widget.customer;

  @override
  void dispose() {
    _debounce?.cancel();
    _amountController.dispose();
    _redeemController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final receipt = ReceiptScope.of(context);
    final state = receipt.state;
    final l10n = context.l10n;
    final quote = state.quote;
    final maxPoints = quote?.maxPoints ?? customer.points;
    final amount = _amount;
    final redeemInvalid = _redeem > 0 && _redeem < customer.redeemMin;
    final canCommit =
        !state.isCommitting &&
        !state.offline &&
        amount != null &&
        amount > 0 &&
        !redeemInvalid &&
        (_redeem == 0 || quote == null || quote.allowed);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.receipt)),
      body: Column(
        children: [
          if (state.offline) const OfflineBanner(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  customer.name.trim().isEmpty
                      ? l10n.guest
                      : customer.name,
                  style: context.textTheme.titleLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.onCardPoints(customer.points),
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(hintText: l10n.amountHint),
                  onChanged: (_) => _onAmountChanged(),
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: state.isQuoting
                      ? null
                      : () => _requestQuote(requested: _redeem),
                  child: state.isQuoting
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(l10n.calculate),
                ),
                const SizedBox(height: 24),
                Text(
                  l10n.redeemPointsLabel,
                  style: context.textTheme.titleMedium,
                ),
                Slider(
                  value: _redeem.clamp(0, maxPoints).toDouble(),
                  max: maxPoints <= 0 ? 1 : maxPoints.toDouble(),
                  onChanged: maxPoints <= 0
                      ? null
                      : (value) {
                          setState(() {
                            _redeem = value.round();
                            _redeemController.text = '$_redeem';
                          });
                          _debounce?.cancel();
                          _debounce = Timer(
                            const Duration(milliseconds: 400),
                            () => _requestQuote(requested: _redeem),
                          );
                        },
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        keyboardType: TextInputType.number,
                        controller: _redeemController,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: const InputDecoration(hintText: '0'),
                        onChanged: (value) {
                          final parsed = int.tryParse(value) ?? 0;
                          setState(
                            () => _redeem = parsed.clamp(0, maxPoints),
                          );
                        },
                        onEditingComplete: () =>
                            _requestQuote(requested: _redeem),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '= $_redeem ₽',
                      style: context.textTheme.titleMedium,
                    ),
                  ],
                ),
                if (redeemInvalid)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      l10n.redeemMinHint(customer.redeemMin),
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.colorScheme.error,
                      ),
                    ),
                  ),
                const SizedBox(height: 24),
                _SummaryTile(
                  label: l10n.payable,
                  value: '$_payablePreview ₽',
                  emphasize: true,
                ),
                _SummaryTile(
                  label: l10n.willEarn,
                  value: '$_earnPreview б.',
                ),
                if (state.error != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    quote?.reason ?? context.errorMessage(state.error!),
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: context.colorScheme.error,
                    ),
                  ),
                ] else if (quote != null && !quote.allowed) ...[
                  const SizedBox(height: 16),
                  Text(
                    quote.reason ?? '',
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: context.colorScheme.error,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Column(
              children: [
                if (!canCommit && state.offline)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      l10n.offlineCommitDisabled,
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.colorScheme.error,
                      ),
                    ),
                  ),
                ElevatedButton(
                  onPressed: canCommit ? _commit : null,
                  child: state.isCommitting
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(l10n.commitReceipt),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  int? get _amount {
    final text = _amountController.text.trim();
    if (text.isEmpty) return null;
    return int.tryParse(text);
  }

  int get _payablePreview {
    final amount = _amount ?? 0;
    final quote = ReceiptScope.of(context).state.quote;
    return quote?.payableRub ?? (amount - _redeem).clamp(0, amount);
  }

  int get _earnPreview =>
      ReceiptScope.of(context).state.quote?.earnPoints ?? 0;

  void _onAmountChanged() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      _requestQuote(requested: 0);
    });
  }

  void _requestQuote({required int requested}) {
    final amount = _amount;
    if (amount == null) return;
    ReceiptScope.of(context, listen: false).quote(
      barcode: customer.barcode,
      amountRub: amount,
      requestedPoints: requested,
    );
  }

  Future<void> _commit() async {
    final l10n = context.l10n;
    final amount = _amount;
    if (amount == null || amount <= 0) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          customer.name.trim().isEmpty ? l10n.guest : customer.name,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.redeemLine(_redeem)),
            Text(l10n.payableLine(_payablePreview)),
            Text(l10n.earnLine(_earnPreview)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.back),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.confirm),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    ReceiptScope.of(context, listen: false).commit(
      receiptId: _receiptId,
      barcode: customer.barcode,
      amountRub: amount,
      redeemPoints: _redeem,
      onSuccess: (result) {
        if (!mounted) return;
        context.go('/overlay/success', extra: result);
      },
    );
  }
}

class _SummaryTile extends StatelessWidget {
  const _SummaryTile({
    required this.label,
    required this.value,
    this.emphasize = false,
  });

  final String label;
  final String value;
  final bool emphasize;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: context.textTheme.bodyLarge?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        Text(
          value,
          style: emphasize
              ? context.textTheme.headlineLarge
              : context.textTheme.titleMedium,
        ),
      ],
    ),
  );
}

class ReceiptSuccessScreen extends StatelessWidget {
  const ReceiptSuccessScreen({required this.result, super.key});

  final CommitResult result;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Spacer(),
              Icon(
                Icons.check_circle_outline,
                size: 64,
                color: context.colorScheme.tertiary,
              ),
              const SizedBox(height: 16),
              Text(l10n.done, style: context.textTheme.headlineLarge),
              const SizedBox(height: 24),
              Text('${result.points}', style: context.textTheme.displayLarge),
              Text(
                l10n.pointsOnCard,
                style: context.textTheme.titleMedium?.copyWith(
                  color: context.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 24),
              Text(l10n.redeemedPoints(result.redeemPoints)),
              Text(l10n.earnedPoints(result.earnPoints)),
              if (result.idempotentReplay)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Text(
                    l10n.idempotentReplay,
                    style: context.textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ),
              const Spacer(),
              ElevatedButton(
                onPressed: () => context.go(
                  AuthScope.of(context).isAdmin ? '/admin/scan' : '/scan',
                ),
                child: Text(l10n.done),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
