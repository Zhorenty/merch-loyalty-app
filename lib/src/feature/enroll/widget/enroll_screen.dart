import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:merch/src/core/constant/localization/localization.dart';
import 'package:merch/src/core/model/models.dart';
import 'package:merch/src/core/utils/extensions/context_extension.dart';
import 'package:merch/src/core/utils/phone.dart';
import 'package:merch/src/feature/enroll/widget/enroll_scope.dart';
import 'package:merch/src/feature/initialization/widget/dependencies_scope.dart';
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
              decoration: InputDecoration(hintText: l10n.nameHint),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              inputFormatters: const [RuPhoneInputFormatter()],
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
              l10n.cardReady,
              style: context.textTheme.headlineLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.saveCardHint,
              style: context.textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Center(
              child: QrImageView(
                data: result.addPage.isNotEmpty
                    ? result.addPage
                    : result.barcode,
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
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () => _copyBarcode(result.barcode),
              child: Text(l10n.copyBarcode),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => _openSale(result),
              child: Text(l10n.goToPurchase),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () {
                _nameController.clear();
                _phoneController.clear();
                setState(() {
                  _consent = false;
                  _error = null;
                });
                EnrollScope.of(context).reset();
              },
              child: Text(l10n.anotherCard),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _copyBarcode(String barcode) async {
    await Clipboard.setData(ClipboardData(text: barcode));
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(context.l10n.barcodeCopied)));
  }

  Future<void> _openSale(EnrollResult result) async {
    try {
      final customer = await DependenciesScope.of(
        context,
      ).scanRepository.lookup(result.barcode);
      if (!mounted) return;
      await context.push('/overlay/customer', extra: customer);
    } on Object catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.errorMessage(error))));
    }
  }

  void _submit() {
    final l10n = context.l10n;
    final name = _nameController.text.trim();
    final phone = normalizedRuPhone(_phoneController.text);
    if (name.isEmpty) {
      setState(() => _error = l10n.nameRequired);
      return;
    }
    if (phone == null) {
      setState(() => _error = l10n.phoneInvalid);
      return;
    }
    if (!_consent) {
      setState(() => _error = l10n.phoneConsentRequired);
      return;
    }
    setState(() => _error = null);
    EnrollScope.of(context).submit(
      name: name,
      phone: phone,
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
