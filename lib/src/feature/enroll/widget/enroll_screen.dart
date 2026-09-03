import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:merch/src/core/constant/localization/localization.dart';
import 'package:merch/src/core/utils/extensions/context_extension.dart';
import 'package:merch/src/feature/auth/widget/auth_scope.dart';
import 'package:merch/src/feature/enroll/widget/enroll_scope.dart';
import 'package:qr_flutter/qr_flutter.dart';

class EnrollScreen extends StatefulWidget {
  const EnrollScreen({super.key});

  @override
  State<EnrollScreen> createState() => _EnrollScreenState();
}

class _EnrollScreenState extends State<EnrollScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _consent = false;
  String? _error;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final enroll = EnrollScope.of(context);
    final result = enroll.result;
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.issueCard)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (result == null) ...[
            TextField(
              controller: _nameController,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(hintText: l10n.nameOptional),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(hintText: l10n.phoneOptional),
            ),
            const SizedBox(height: 8),
            CheckboxListTile(
              value: _consent,
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              title: Text(
                l10n.phoneConsent,
                style: context.textTheme.bodyMedium,
              ),
              onChanged: (value) => setState(() => _consent = value ?? false),
            ),
            if (_error != null)
              Text(
                _error!,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: context.colorScheme.error,
                ),
              ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: enroll.isProcessing ? null : _submit,
              child: enroll.isProcessing
                  ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(l10n.issueCard),
            ),
          ] else ...[
            Text(
              l10n.showQrToCustomer,
              style: context.textTheme.headlineLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Center(
              child: QrImageView(
                data: result.barcode,
                size: 240,
                backgroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              result.barcode,
              textAlign: TextAlign.center,
              style: context.textTheme.titleMedium?.copyWith(
                fontFamily: 'monospace',
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(
                AuthScope.of(context).isAdmin ? '/admin/scan' : '/scan',
              ),
              child: Text(l10n.goToReceipt),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () => EnrollScope.of(context).reset(),
              child: Text(l10n.anotherCard),
            ),
          ],
        ],
      ),
    );
  }

  void _submit() {
    final phone = _phoneController.text.trim();
    if (phone.isNotEmpty && !_consent) {
      setState(() => _error = context.l10n.phoneConsentRequired);
      return;
    }
    setState(() => _error = null);
    EnrollScope.of(context).submit(
      name: _nameController.text.trim(),
      phone: phone.isEmpty || !_consent ? null : phone,
      onSuccess: (result) {
        if (!mounted) return;
        if (!result.created) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(context.l10n.cardAlreadyExists)),
          );
        }
      },
      onError: (error) {
        if (mounted) setState(() => _error = context.errorMessage(error));
      },
    );
  }
}
