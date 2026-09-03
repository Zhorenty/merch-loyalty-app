import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:merch/src/core/constant/localization/localization.dart';
import 'package:merch/src/core/model/models.dart';
import 'package:merch/src/core/utils/extensions/context_extension.dart';
import 'package:merch/src/core/widget/states.dart';
import 'package:merch/src/feature/admin_customers/bloc/admin_customers_state.dart';
import 'package:merch/src/feature/admin_customers/widget/admin_customers_scope.dart';

class AdminCustomersScreen extends StatefulWidget {
  const AdminCustomersScreen({super.key});

  @override
  State<AdminCustomersScreen> createState() => _AdminCustomersScreenState();
}

class _AdminCustomersScreenState extends State<AdminCustomersScreen> {
  final _query = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _query.dispose();
    super.dispose();
  }

  void _onQuery(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      if (!mounted) return;
      AdminCustomersScope.of(context, listen: false).search(value.trim());
    });
  }

  Future<void> _open(AdminCustomer customer) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => AdminCustomersScope(
          autoload: false,
          child: AdminCustomerSheet(customer: customer),
        ),
      ),
    );
    if (!mounted) return;
    AdminCustomersScope.of(context, listen: false).search(_query.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    final controller = AdminCustomersScope.of(context);
    final state = controller.state;
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.customers)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              controller: _query,
              decoration: InputDecoration(
                hintText: l10n.customerSearchHint,
                prefixIcon: const Icon(Icons.search),
              ),
              onChanged: _onQuery,
            ),
          ),
          Expanded(
            child: switch (state) {
              AdminCustomersState$Processing() => const SkeletonList(),
              AdminCustomersState$Error(:final error) => ErrorState(
                message: context.errorMessage(error),
                onRetry: () => controller.search(_query.text.trim()),
              ),
              AdminCustomersState$Idle(:final customers)
                  when customers.isEmpty =>
                EmptyState(
                  title: l10n.customersEmpty,
                  subtitle: l10n.customersEmptyHint,
                ),
              AdminCustomersState$Idle(:final customers) => ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: customers.length,
                separatorBuilder: (_, _) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final customer = customers[index];
                  return Card(
                    child: ListTile(
                      title: Text(customer.displayName),
                      subtitle: Text(
                        '${customer.barcode} · ${customer.points} б.',
                        style: const TextStyle(fontFamily: 'monospace'),
                      ),
                      trailing: customer.blocked
                          ? Text(
                              l10n.blocked,
                              style: TextStyle(
                                color: context.colorScheme.error,
                              ),
                            )
                          : null,
                      onTap: () => _open(customer),
                    ),
                  );
                },
              ),
            },
          ),
        ],
      ),
    );
  }
}

class AdminCustomerSheet extends StatefulWidget {
  const AdminCustomerSheet({required this.customer, super.key});

  final AdminCustomer customer;

  @override
  State<AdminCustomerSheet> createState() => _AdminCustomerSheetState();
}

class _AdminCustomerSheetState extends State<AdminCustomerSheet> {
  late AdminCustomer _customer;
  final _delta = TextEditingController();
  final _reason = TextEditingController();
  bool _busy = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _customer = widget.customer;
  }

  @override
  void dispose() {
    _delta.dispose();
    _reason.dispose();
    super.dispose();
  }

  void _toggleBlock() {
    setState(() {
      _busy = true;
      _error = null;
    });
    AdminCustomersScope.of(context, listen: false).setBlocked(
      id: _customer.id,
      blocked: !_customer.blocked,
      onSuccess: () {
        if (!mounted) return;
        setState(() {
          _busy = false;
          _customer = AdminCustomer(
            id: _customer.id,
            barcode: _customer.barcode,
            name: _customer.name,
            phone: _customer.phone,
            points: _customer.points,
            blocked: !_customer.blocked,
          );
        });
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

  void _adjust() {
    final l10n = context.l10n;
    final reason = _reason.text.trim();
    final delta = int.tryParse(_delta.text.trim());
    if (reason.isEmpty) {
      setState(() => _error = l10n.adjustReasonRequired);
      return;
    }
    if (delta == null || delta == 0) {
      setState(() => _error = l10n.adjustDeltaRequired);
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    AdminCustomersScope.of(context, listen: false).adjust(
      barcode: _customer.barcode,
      delta: delta,
      reason: reason,
      onSuccess: (points) {
        if (!mounted) return;
        setState(() {
          _busy = false;
          _customer = AdminCustomer(
            id: _customer.id,
            barcode: _customer.barcode,
            name: _customer.name,
            phone: _customer.phone,
            points: points,
            blocked: _customer.blocked,
          );
          _delta.clear();
          _reason.clear();
        });
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

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(_customer.displayName)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            '${_customer.points}',
            textAlign: TextAlign.center,
            style: context.textTheme.displayLarge,
          ),
          Text(
            l10n.points,
            textAlign: TextAlign.center,
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _customer.barcode,
            textAlign: TextAlign.center,
            style: const TextStyle(fontFamily: 'monospace'),
          ),
          if (_customer.phone.isNotEmpty)
            Text(_customer.phone, textAlign: TextAlign.center),
          const SizedBox(height: 24),
          OutlinedButton(
            onPressed: _busy ? null : _toggleBlock,
            child: Text(_customer.blocked ? l10n.unblock : l10n.block),
          ),
          const SizedBox(height: 24),
          Text(l10n.manualAdjust, style: context.textTheme.titleMedium),
          const SizedBox(height: 8),
          TextField(
            controller: _delta,
            keyboardType: const TextInputType.numberWithOptions(signed: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'-?\d*')),
            ],
            decoration: InputDecoration(hintText: l10n.deltaHint),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _reason,
            decoration: InputDecoration(hintText: l10n.reasonHint),
            onChanged: (_) => setState(() {}),
          ),
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
          ElevatedButton(
            onPressed: _busy || _reason.text.trim().isEmpty ? null : _adjust,
            child: Text(l10n.changePoints),
          ),
        ],
      ),
    );
  }
}
