import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:merch/src/core/constant/localization/localization.dart';
import 'package:merch/src/core/model/models.dart';
import 'package:merch/src/core/utils/extensions/context_extension.dart';
import 'package:merch/src/core/utils/phone.dart';
import 'package:merch/src/core/widget/app_dialog.dart';
import 'package:merch/src/core/widget/states.dart';
import 'package:merch/src/feature/admin_customers/bloc/admin_customers_state.dart';
import 'package:merch/src/feature/admin_customers/widget/admin_customers_scope.dart';
import 'package:merch/src/feature/enroll/widget/enroll_scope.dart';
import 'package:merch/src/feature/enroll/widget/enroll_screen.dart';

class AdminCustomersScreen extends StatefulWidget {
  const AdminCustomersScreen({super.key});

  @override
  State<AdminCustomersScreen> createState() => _AdminCustomersScreenState();
}

class _AdminCustomersScreenState extends State<AdminCustomersScreen> {
  final _query = TextEditingController();
  Timer? _debounce;
  String _status = 'active';

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
      AdminCustomersScope.of(
        context,
        listen: false,
      ).search(value.trim(), status: _status);
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
    AdminCustomersScope.of(
      context,
      listen: false,
    ).search(_query.text.trim(), status: _status);
  }

  @override
  Widget build(BuildContext context) {
    final controller = AdminCustomersScope.of(context);
    final state = controller.state;
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.customers)),
      floatingActionButton: FloatingActionButton(
        heroTag: 'admin-customers-fab',
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => const EnrollScope(child: EnrollScreen()),
          ),
        ),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Column(
              children: [
                TextField(
                  controller: _query,
                  decoration: InputDecoration(
                    hintText: l10n.customerSearchHint,
                    prefixIcon: const Icon(Icons.search),
                  ),
                  onChanged: _onQuery,
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  key: ValueKey(_status),
                  initialValue: _status,
                  items: [
                    DropdownMenuItem(
                      value: 'all',
                      child: Text(l10n.customerFilterAll),
                    ),
                    DropdownMenuItem(
                      value: 'active',
                      child: Text(l10n.customerFilterActive),
                    ),
                    DropdownMenuItem(
                      value: 'blocked',
                      child: Text(l10n.customerFilterBlocked),
                    ),
                    DropdownMenuItem(
                      value: 'deleted',
                      child: Text(l10n.customerFilterDeleted),
                    ),
                  ],
                  onChanged: (value) {
                    if (value == null) return;
                    setState(() => _status = value);
                    AdminCustomersScope.of(
                      context,
                      listen: false,
                    ).search(_query.text.trim(), status: value);
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: switch (state) {
              AdminCustomersState$Processing() => const SkeletonList(),
              AdminCustomersState$Error(:final error) => ErrorState(
                message: context.errorMessage(error),
                onRetry: () =>
                    controller.search(_query.text.trim(), status: _status),
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
                      trailing: customer.deleted
                          ? Text(
                              l10n.cardDeleted,
                              style: TextStyle(
                                color: context.colorScheme.error,
                              ),
                            )
                          : customer.blocked
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
            deleted: _customer.deleted,
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

  Future<void> _delete() async {
    final l10n = context.l10n;
    final ok = await showConfirmDialog(
      context: context,
      title: l10n.deleteCardTitle,
      message: l10n.deleteCardBody,
      confirmLabel: l10n.delete,
      cancelLabel: l10n.cancel,
      destructive: true,
    );
    if (!ok || !mounted) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    AdminCustomersScope.of(context, listen: false).delete(
      id: _customer.id,
      onSuccess: () {
        if (!mounted) return;
        Navigator.pop(context);
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

  void _restore() {
    setState(() {
      _busy = true;
      _error = null;
    });
    AdminCustomersScope.of(context, listen: false).restore(
      id: _customer.id,
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
            blocked: _customer.blocked,
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
            deleted: _customer.deleted,
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
            Text(formatRuPhone(_customer.phone), textAlign: TextAlign.center),
          const SizedBox(height: 24),
          if (_customer.deleted)
            ElevatedButton(
              onPressed: _busy ? null : _restore,
              child: Text(l10n.restoreCard),
            )
          else ...[
            OutlinedButton(
              onPressed: _busy ? null : _toggleBlock,
              child: Text(_customer.blocked ? l10n.unblock : l10n.block),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: _busy ? null : _delete,
              style: OutlinedButton.styleFrom(
                foregroundColor: context.colorScheme.error,
                side: BorderSide(color: context.colorScheme.error),
              ),
              child: Text(l10n.delete),
            ),
          ],
          if (_error != null) ...[
            const SizedBox(height: 12),
            Text(
              _error!,
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colorScheme.error,
              ),
            ),
          ],
          if (!_customer.deleted) ...[
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
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _busy || _reason.text.trim().isEmpty ? null : _adjust,
              child: Text(l10n.changePoints),
            ),
          ],
        ],
      ),
    );
  }
}
