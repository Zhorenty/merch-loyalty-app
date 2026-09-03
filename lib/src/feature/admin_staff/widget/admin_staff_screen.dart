import 'package:flutter/material.dart';
import 'package:merch/src/core/constant/localization/localization.dart';
import 'package:merch/src/core/model/models.dart';
import 'package:merch/src/core/utils/extensions/context_extension.dart';
import 'package:merch/src/core/widget/states.dart';
import 'package:merch/src/feature/admin_staff/bloc/admin_staff_state.dart';
import 'package:merch/src/feature/admin_staff/widget/admin_staff_scope.dart';

class AdminStaffScreen extends StatelessWidget {
  const AdminStaffScreen({super.key});

  Future<void> _open(BuildContext context, {StaffRow? staff}) async {
    final saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => AdminStaffScope(
          autoload: false,
          child: StaffFormScreen(staff: staff),
        ),
      ),
    );
    if (saved == true && context.mounted) {
      AdminStaffScope.of(context, listen: false).refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = AdminStaffScope.of(context);
    final state = controller.state;
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.staff)),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _open(context),
        child: const Icon(Icons.add),
      ),
      body: switch (state) {
        AdminStaffState$Processing() => const SkeletonList(),
        AdminStaffState$Error(:final error) => ErrorState(
          message: context.errorMessage(error),
          onRetry: controller.refresh,
        ),
        AdminStaffState$Idle(:final staff) when staff.isEmpty => EmptyState(
          title: l10n.staffEmpty,
          subtitle: l10n.staffEmptyHint,
        ),
        AdminStaffState$Idle(:final staff) => ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: staff.length,
          separatorBuilder: (_, _) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final row = staff[index];
            return Card(
              child: ListTile(
                title: Text(row.name),
                subtitle: Text(
                  '${row.login} · ${row.role == 'admin' ? l10n.roleAdmin : l10n.roleManager}',
                ),
                trailing: Text(
                  row.active ? l10n.active : l10n.inactive,
                  style: TextStyle(
                    color: row.active
                        ? context.colorScheme.tertiary
                        : context.colorScheme.error,
                  ),
                ),
                onTap: () => _open(context, staff: row),
              ),
            );
          },
        ),
      },
    );
  }
}

class StaffFormScreen extends StatefulWidget {
  const StaffFormScreen({this.staff, super.key});

  final StaffRow? staff;

  @override
  State<StaffFormScreen> createState() => _StaffFormScreenState();
}

class _StaffFormScreenState extends State<StaffFormScreen> {
  late final TextEditingController _login;
  late final TextEditingController _name;
  late final TextEditingController _password;
  String _role = 'manager';
  bool _active = true;
  bool _busy = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    final staff = widget.staff;
    _login = TextEditingController(text: staff?.login ?? '');
    _name = TextEditingController(text: staff?.name ?? '');
    _password = TextEditingController();
    _role = staff == null
        ? 'manager'
        : (staff.role == 'admin' ? 'admin' : 'manager');
    _active = staff?.active ?? true;
  }

  @override
  void dispose() {
    _login.dispose();
    _name.dispose();
    _password.dispose();
    super.dispose();
  }

  void _save() {
    final l10n = context.l10n;
    if (_login.text.trim().isEmpty || _name.text.trim().isEmpty) {
      setState(() => _error = l10n.loginAndNameRequired);
      return;
    }
    if (widget.staff == null && _password.text.isEmpty) {
      setState(() => _error = l10n.passwordRequired);
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    final controller = AdminStaffScope.of(context, listen: false);
    void onSuccess() {
      if (!mounted) return;
      Navigator.pop(context, true);
    }

    void onError(Object error) {
      if (!mounted) return;
      setState(() {
        _busy = false;
        _error = context.errorMessage(error);
      });
    }

    if (widget.staff == null) {
      controller.create(
        login: _login.text.trim(),
        name: _name.text.trim(),
        password: _password.text,
        role: _role,
        onSuccess: onSuccess,
        onError: onError,
      );
    } else {
      controller.update(
        id: widget.staff!.id,
        login: _login.text.trim(),
        name: _name.text.trim(),
        password: _password.text,
        role: _role,
        active: _active,
        onSuccess: onSuccess,
        onError: onError,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.staff == null ? l10n.newStaff : l10n.staffMember),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _name,
            decoration: InputDecoration(hintText: l10n.nameHint),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _login,
            decoration: InputDecoration(hintText: l10n.loginHint),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _password,
            obscureText: true,
            decoration: InputDecoration(
              hintText: widget.staff == null
                  ? l10n.passwordHint
                  : l10n.newPasswordOptional,
            ),
          ),
          const SizedBox(height: 16),
          Text(l10n.role, style: context.textTheme.titleMedium),
          const SizedBox(height: 8),
          SegmentedButton<String>(
            segments: [
              ButtonSegment(value: 'manager', label: Text(l10n.roleManager)),
              ButtonSegment(value: 'admin', label: Text(l10n.roleAdmin)),
            ],
            selected: {_role},
            onSelectionChanged: (value) => setState(() => _role = value.first),
          ),
          if (widget.staff != null)
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.staffActive),
              value: _active,
              onChanged: (value) => setState(() => _active = value),
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
            child: Text(widget.staff == null ? l10n.create : l10n.save),
          ),
        ],
      ),
    );
  }
}
