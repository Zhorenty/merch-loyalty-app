import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:merch/src/core/constant/localization/localization.dart';
import 'package:merch/src/core/model/models.dart';
import 'package:merch/src/core/utils/extensions/context_extension.dart';
import 'package:merch/src/core/widget/app_dialog.dart';
import 'package:merch/src/core/widget/states.dart';
import 'package:merch/src/feature/auth/widget/auth_scope.dart';
import 'package:merch/src/feature/receipt/bloc/receipt_state.dart';
import 'package:merch/src/feature/receipt/widget/receipt_scope.dart';
import 'package:uuid/uuid.dart';

class ReceiptScreen extends StatefulWidget {
  const ReceiptScreen({required this.customer, super.key});

  final LookupCustomer customer;

  @override
  State<ReceiptScreen> createState() => _ReceiptScreenState();
}

class _ReceiptScreenState extends State<ReceiptScreen> {
  static const _quoteDelay = Duration(milliseconds: 200);

  final _amountController = TextEditingController();
  final _receiptId = const Uuid().v4();
  final _redeemController = TextEditingController(text: '0');
  Timer? _debounce;
  int _redeem = 0;
  bool _sliding = false;
  bool _clampScheduled = false;

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
    final state = ReceiptScope.of(context).state;
    final l10n = context.l10n;
    final maxPoints = _maxFor(state);
    final shown = _shownRedeem(state);
    final amount = _amount;
    final hasAmount = amount != null && amount > 0;
    final matches = _matches(state);
    final pending =
        hasAmount &&
        !matches &&
        ((_debounce?.isActive ?? false) || state.isQuoting);
    final redeemInvalid = shown > 0 && shown < customer.redeemMin;
    final payable = _payable(state);
    final problem = _problem(state, redeemInvalid: redeemInvalid);
    _scheduleClamp(maxPoints);

    final name = customer.name.trim().isEmpty ? l10n.guest : customer.name;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.receipt)),
      body: Column(
        children: [
          if (state.offline) const OfflineBanner(),
          Expanded(
            child: ListView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.textTheme.titleLarge,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      l10n.onCardPoints(customer.points),
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: context.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  autofocus: true,
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  style: context.textTheme.headlineSmall,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    hintText: l10n.amountHint,
                    hintStyle: context.textTheme.bodyLarge?.copyWith(
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                    suffixText: '₽',
                    suffixStyle: context.textTheme.headlineSmall,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 18,
                    ),
                  ),
                  onTap: () {
                    _amountController.selection = TextSelection(
                      baseOffset: 0,
                      extentOffset: _amountController.text.length,
                    );
                  },
                  onChanged: (_) => _onAmountChanged(),
                  onEditingComplete: _flushQuote,
                ),
                const SizedBox(height: 16),
                _ResultCard(
                  payableLabel: l10n.payable,
                  payable: hasAmount ? '$payable ₽' : '—',
                  earnLabel: l10n.willEarn,
                  earn: _earnLabel(
                    state,
                    hasAmount: hasAmount,
                    matches: matches,
                  ),
                  earnPositive: matches && (state.quote?.earnPoints ?? 0) > 0,
                  pending: pending,
                ),
                if (problem != null) ...[
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          problem,
                          style: context.textTheme.bodyMedium?.copyWith(
                            color: context.colorScheme.error,
                          ),
                        ),
                      ),
                      if (state.error != null)
                        TextButton(
                          onPressed: _flushQuote,
                          child: Text(l10n.retry),
                        ),
                    ],
                  ),
                ],
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                l10n.redeemPointsLabel,
                                style: context.textTheme.titleMedium,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                maxPoints > 0
                                    ? l10n.availablePoints(maxPoints)
                                    : l10n.redeemFrom(customer.redeemMin),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.end,
                                style: context.textTheme.bodySmall,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: _RedeemSlider(
                            value: shown,
                            max: maxPoints,
                            onChanged: maxPoints <= 0
                                ? null
                                : (value) => _setRedeem(value, syncField: true),
                            onChangeStart: () {
                              _sliding = true;
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                            onChangeEnd: () {
                              _sliding = false;
                              HapticFeedback.selectionClick();
                              _flushQuote();
                            },
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: _PresetButton(
                                label: l10n.redeemNone,
                                selected: shown == 0,
                                onPressed: () => _setRedeem(
                                  0,
                                  syncField: true,
                                  immediate: true,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _PresetButton(
                                label: l10n.redeemMax,
                                selected: maxPoints > 0 && shown == maxPoints,
                                onPressed: maxPoints <= 0
                                    ? null
                                    : () => _setRedeem(
                                        maxPoints,
                                        syncField: true,
                                        immediate: true,
                                      ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                enabled: maxPoints > 0,
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.done,
                                controller: _redeemController,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                decoration: const InputDecoration(
                                  hintText: '0',
                                  suffixText: 'б.',
                                ),
                                onChanged: _onRedeemTyped,
                                onEditingComplete: _flushQuote,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              '= ${shown * _rate} ₽',
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
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: context.colorScheme.outline),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Column(
                children: [
                  if (!_canCommit(state) && state.offline)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        l10n.offlineCommitDisabled,
                        textAlign: TextAlign.center,
                        style: context.textTheme.bodySmall?.copyWith(
                          color: context.colorScheme.error,
                        ),
                      ),
                    ),
                  ElevatedButton(
                    onPressed: _canCommit(state) ? _commit : null,
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
          ),
        ],
      ),
    );
  }

  int get _rate => customer.redeemRate <= 0 ? 1 : customer.redeemRate;

  int? get _amount {
    final text = _amountController.text.trim();
    if (text.isEmpty) return null;
    return int.tryParse(text);
  }

  int _maxFor(ReceiptState state) {
    final amount = _amount;
    final quote = state.quote;
    final max = quote != null && amount != null && state.amountRub == amount
        ? quote.maxPoints
        : customer.points;
    return max < 0 ? 0 : max;
  }

  int _shownRedeem(ReceiptState state) => _redeem.clamp(0, _maxFor(state));

  bool _matches(ReceiptState state) {
    final amount = _amount;
    final quote = state.quote;
    if (amount == null || amount <= 0 || quote == null || state.error != null) {
      return false;
    }
    return state.amountRub == amount &&
        quote.requestedPoints == _shownRedeem(state);
  }

  int _payable(ReceiptState state) {
    final amount = _amount ?? 0;
    if (amount <= 0) return 0;
    final quote = state.quote;
    if (_matches(state) && quote != null && quote.allowed) {
      return quote.payableRub;
    }
    final payable = amount - _shownRedeem(state) * _rate;
    return payable < 0 ? 0 : payable;
  }

  int _earn(ReceiptState state) {
    final quote = state.quote;
    if (_matches(state) && quote != null && quote.allowed) {
      return quote.earnPoints;
    }
    return 0;
  }

  String _earnLabel(
    ReceiptState state, {
    required bool hasAmount,
    required bool matches,
  }) {
    if (!hasAmount) return '—';
    if (matches && state.quote!.allowed) return '${state.quote!.earnPoints} б.';
    final pending = (_debounce?.isActive ?? false) || state.isQuoting;
    return pending ? '…' : '—';
  }

  String? _problem(ReceiptState state, {required bool redeemInvalid}) {
    if (state.error != null) {
      return state.quote?.reason ?? context.errorMessage(state.error!);
    }
    final quote = state.quote;
    if (quote != null &&
        !quote.allowed &&
        _matches(state) &&
        !redeemInvalid &&
        (quote.reason?.isNotEmpty ?? false)) {
      return quote.reason;
    }
    return null;
  }

  bool _canCommit(ReceiptState state) {
    final amount = _amount;
    final shown = _shownRedeem(state);
    final pending = (_debounce?.isActive ?? false) || state.isQuoting;
    if (state.isCommitting || state.offline || pending) return false;
    if (amount == null || amount <= 0) return false;
    if (shown > 0 && shown < customer.redeemMin) return false;
    if (shown == 0) return true;
    final quote = state.quote;
    return _matches(state) && quote != null && quote.allowed;
  }

  void _scheduleClamp(int maxPoints) {
    if (_clampScheduled || _sliding || _redeem <= maxPoints) return;
    _clampScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _clampScheduled = false;
      if (!mounted || _sliding) return;
      final max = _maxFor(ReceiptScope.of(context, listen: false).state);
      if (_redeem <= max) return;
      setState(() => _redeem = max);
      _writeRedeemField(max);
      _flushQuote();
    });
  }

  void _onAmountChanged() {
    setState(() {});
    _scheduleQuote();
  }

  void _onRedeemTyped(String value) {
    final parsed = int.tryParse(value) ?? 0;
    final max = _maxFor(ReceiptScope.of(context, listen: false).state);
    final next = max > 0 ? parsed.clamp(0, max) : (parsed < 0 ? 0 : parsed);
    setState(() => _redeem = next);
    if (max > 0 && parsed > max) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _writeRedeemField(max);
      });
    }
    _scheduleQuote();
  }

  void _setRedeem(
    int value, {
    required bool syncField,
    bool immediate = false,
  }) {
    final max = _maxFor(ReceiptScope.of(context, listen: false).state);
    final next = value.clamp(0, max);
    if (next != _redeem) setState(() => _redeem = next);
    if (syncField) _writeRedeemField(next);
    if (immediate) {
      FocusManager.instance.primaryFocus?.unfocus();
      HapticFeedback.selectionClick();
      _flushQuote();
    } else {
      _scheduleQuote();
    }
  }

  void _writeRedeemField(int value) {
    final text = '$value';
    if (_redeemController.text == text) return;
    _redeemController.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }

  void _scheduleQuote() {
    _debounce?.cancel();
    _debounce = Timer(_quoteDelay, _requestQuote);
  }

  void _flushQuote() {
    _debounce?.cancel();
    _requestQuote();
  }

  void _requestQuote() {
    if (!mounted) return;
    final state = ReceiptScope.of(context, listen: false).state;
    ReceiptScope.of(context, listen: false).quote(
      barcode: customer.barcode,
      amountRub: _amount ?? 0,
      requestedPoints: _shownRedeem(state),
    );
  }

  Future<void> _commit() async {
    final l10n = context.l10n;
    final amount = _amount;
    if (amount == null || amount <= 0) return;
    final receiptState = ReceiptScope.of(context, listen: false).state;
    final redeemPoints = _shownRedeem(receiptState);
    final payable = _payable(receiptState);
    final earn = _earn(receiptState);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AppDialog(
        title: customer.name.trim().isEmpty ? l10n.guest : customer.name,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.redeemLine(redeemPoints)),
            Text(l10n.payableLine(payable)),
            Text(l10n.earnLine(earn)),
          ],
        ),
        actions: [
          AppDialogAction(
            label: l10n.confirm,
            primary: true,
            onPressed: () => Navigator.pop(context, true),
          ),
          AppDialogAction(
            label: l10n.back,
            onPressed: () => Navigator.pop(context, false),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    final latest = ReceiptScope.of(context, listen: false).state;
    ReceiptScope.of(context, listen: false).commit(
      receiptId: _receiptId,
      barcode: customer.barcode,
      amountRub: amount,
      redeemPoints: _shownRedeem(latest),
      onSuccess: (result) {
        if (!mounted) return;
        context.go('/overlay/success', extra: result);
      },
    );
  }
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({
    required this.payableLabel,
    required this.payable,
    required this.earnLabel,
    required this.earn,
    required this.earnPositive,
    required this.pending,
  });

  final String payableLabel;
  final String payable;
  final String earnLabel;
  final String earn;
  final bool earnPositive;
  final bool pending;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              payableLabel,
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                Expanded(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      payable,
                      style: context.textTheme.displayMedium,
                    ),
                  ),
                ),
                if (pending)
                  const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Text(
                  earnLabel,
                  style: context.textTheme.bodyLarge?.copyWith(
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                ),
                const Spacer(),
                Text(
                  earn,
                  style: context.textTheme.titleMedium?.copyWith(
                    color: earnPositive
                        ? context.colorScheme.tertiary
                        : context.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PresetButton extends StatelessWidget {
  const _PresetButton({
    required this.label,
    required this.selected,
    required this.onPressed,
  });

  final String label;
  final bool selected;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colorScheme;
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(0, 40),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        backgroundColor: selected ? scheme.primaryContainer : Colors.white,
        foregroundColor: scheme.primary,
        side: BorderSide(color: selected ? scheme.primary : scheme.outline),
      ),
      child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
    );
  }
}

class _RedeemSlider extends StatelessWidget {
  const _RedeemSlider({
    required this.value,
    required this.max,
    required this.onChanged,
    required this.onChangeStart,
    required this.onChangeEnd,
  });

  final int value;
  final int max;
  final ValueChanged<int>? onChanged;
  final VoidCallback onChangeStart;
  final VoidCallback onChangeEnd;

  @override
  Widget build(BuildContext context) {
    final enabled = onChanged != null && max > 0;
    final sliderMax = max <= 0 ? 1.0 : max.toDouble();
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        trackHeight: 8,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 14),
        overlayShape: const _RedeemSliderHit(),
        showValueIndicator: ShowValueIndicator.onDrag,
        valueIndicatorColor: context.colorScheme.primary,
        valueIndicatorTextStyle: context.textTheme.labelLarge?.copyWith(
          color: Colors.white,
        ),
      ),
      child: Slider(
        padding: const EdgeInsets.symmetric(vertical: 8),
        value: value.clamp(0, max).toDouble(),
        max: sliderMax,
        label: '$value',
        onChanged: enabled ? (next) => onChanged!(next.round()) : null,
        onChangeStart: enabled ? (_) => onChangeStart() : null,
        onChangeEnd: enabled ? (_) => onChangeEnd() : null,
      ),
    );
  }
}

/// Tall invisible overlay so the thumb is easy to grab, with a narrow width
/// that keeps the track inset from the screen edge and the iOS back swipe.
class _RedeemSliderHit extends SliderComponentShape {
  const _RedeemSliderHit();

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) => const Size(36, 64);

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {}
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
