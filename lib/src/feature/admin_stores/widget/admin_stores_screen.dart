import 'package:flutter/material.dart';
import 'package:merch/src/core/constant/localization/localization.dart';
import 'package:merch/src/core/model/models.dart';
import 'package:merch/src/core/utils/extensions/context_extension.dart';
import 'package:merch/src/core/widget/states.dart';
import 'package:merch/src/feature/admin_stores/bloc/admin_stores_state.dart';
import 'package:merch/src/feature/admin_stores/widget/admin_stores_scope.dart';

class AdminStoresScreen extends StatelessWidget {
  const AdminStoresScreen({super.key});

  Future<void> _open(BuildContext context, {StoreLocation? store}) async {
    final saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => AdminStoresScope(
          autoload: false,
          child: StoreFormScreen(store: store),
        ),
      ),
    );
    if (saved == true && context.mounted) {
      AdminStoresScope.of(context, listen: false).refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = AdminStoresScope.of(context);
    final state = controller.state;
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.stores)),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _open(context),
        child: const Icon(Icons.add),
      ),
      body: switch (state) {
        AdminStoresState$Processing() => const SkeletonList(),
        AdminStoresState$Error(:final error) => ErrorState(
          message: context.errorMessage(error),
          onRetry: controller.refresh,
        ),
        AdminStoresState$Idle(:final stores) when stores.isEmpty => EmptyState(
          title: l10n.storesEmpty,
          subtitle: l10n.storesEmptyHint,
        ),
        AdminStoresState$Idle(:final stores) => ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: stores.length,
          separatorBuilder: (_, _) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final store = stores[index];
            return Card(
              child: ListTile(
                title: Text(store.name),
                subtitle: Text(
                  store.address.isEmpty ? l10n.addressMissing : store.address,
                ),
                onTap: () => _open(context, store: store),
              ),
            );
          },
        ),
      },
    );
  }
}

class StoreFormScreen extends StatefulWidget {
  const StoreFormScreen({this.store, super.key});

  final StoreLocation? store;

  @override
  State<StoreFormScreen> createState() => _StoreFormScreenState();
}

class _StoreFormScreenState extends State<StoreFormScreen> {
  late final TextEditingController _name;
  late final TextEditingController _address;
  bool _busy = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.store?.name ?? '');
    _address = TextEditingController(text: widget.store?.address ?? '');
  }

  @override
  void dispose() {
    _name.dispose();
    _address.dispose();
    super.dispose();
  }

  void _save() {
    if (_name.text.trim().isEmpty) {
      setState(() => _error = context.l10n.storeNameRequired);
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    AdminStoresScope.of(context, listen: false).save(
      id: widget.store?.id,
      name: _name.text.trim(),
      address: _address.text.trim(),
      onSuccess: () {
        if (!mounted) return;
        Navigator.pop(context, true);
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
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteStoreTitle),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    setState(() => _busy = true);
    AdminStoresScope.of(context, listen: false).delete(
      id: widget.store!.id,
      onSuccess: () {
        if (!mounted) return;
        Navigator.pop(context, true);
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
      appBar: AppBar(
        title: Text(widget.store == null ? l10n.newStore : l10n.store),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _name,
            decoration: InputDecoration(hintText: l10n.storeNameHint),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _address,
            decoration: InputDecoration(hintText: l10n.addressHint),
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
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _busy ? null : _save,
            child: Text(widget.store == null ? l10n.create : l10n.save),
          ),
          if (widget.store != null) ...[
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: _busy ? null : _delete,
              child: Text(l10n.delete),
            ),
          ],
        ],
      ),
    );
  }
}
