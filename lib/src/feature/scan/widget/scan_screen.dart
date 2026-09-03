import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:merch/src/core/constant/localization/localization.dart';
import 'package:merch/src/core/utils/extensions/context_extension.dart';
import 'package:merch/src/feature/scan/widget/scan_scope.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
  );
  bool _torch = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scan = ScanScope.of(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          MobileScanner(controller: _controller, onDetect: _onDetect),
          const _ScanMask(),
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 16),
                Text(
                  context.l10n.scanHint,
                  style: context.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _RoundAction(
                      icon: _torch ? Icons.flash_on : Icons.flash_off,
                      onTap: () async {
                        await _controller.toggleTorch();
                        setState(() => _torch = !_torch);
                      },
                    ),
                    const SizedBox(width: 24),
                    _RoundAction(
                      icon: Icons.keyboard_alt_outlined,
                      onTap: _manualEntry,
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                if (scan.isProcessing)
                  const Padding(
                    padding: EdgeInsets.only(bottom: 24),
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onDetect(BarcodeCapture capture) async {
    if (ScanScope.of(context, listen: false).isProcessing) return;
    final barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;
    final raw = barcodes.first.rawValue;
    if (raw == null || raw.isEmpty) return;
    _lookup(raw.trim());
  }

  void _lookup(String barcode) {
    ScanScope.of(context, listen: false).lookup(
      barcode: barcode,
      onSuccess: (customer) {
        if (!mounted) return;
        context.push('/overlay/customer', extra: customer);
      },
      onError: (error) {
        if (!mounted) return;
        showDialog<void>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(context.l10n.cardNotFound),
            content: Text(context.errorMessage(error)),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(context.l10n.gotIt),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _manualEntry() async {
    final controller = TextEditingController();
    final l10n = context.l10n;
    final value = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.enterCode),
        content: TextField(
          controller: controller,
          autofocus: true,
          textCapitalization: TextCapitalization.characters,
          decoration: InputDecoration(hintText: l10n.barcodeOrUuidHint),
          onSubmitted: (v) => Navigator.pop(context, v),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: Text(l10n.find),
          ),
        ],
      ),
    );
    controller.dispose();
    final barcode = value?.trim();
    if (barcode == null || barcode.isEmpty) return;
    _lookup(barcode);
  }
}

class _ScanMask extends StatelessWidget {
  const _ScanMask();

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      const cut = 240.0;
      return ColorFiltered(
        colorFilter: ColorFilter.mode(
          context.colorScheme.scrim,
          BlendMode.srcOut,
        ),
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Colors.black,
                backgroundBlendMode: BlendMode.dstOut,
              ),
            ),
            Align(
              child: Container(
                width: cut,
                height: cut,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

class _RoundAction extends StatelessWidget {
  const _RoundAction({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.white.withValues(alpha: 0.15),
    shape: const CircleBorder(),
    child: InkWell(
      customBorder: const CircleBorder(),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Icon(icon, color: Colors.white),
      ),
    ),
  );
}
