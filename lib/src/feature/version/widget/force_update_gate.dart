import 'package:flutter/material.dart';
import 'package:merch/src/core/constant/localization/localization.dart';
import 'package:merch/src/core/utils/extensions/context_extension.dart';
import 'package:merch/src/feature/initialization/widget/dependencies_scope.dart';
import 'package:url_launcher/url_launcher.dart';

class ForceUpdateGate extends StatelessWidget {
  const ForceUpdateGate({required this.child, super.key});

  final Widget child;

  static bool needsUpdate(String current, String minSupported) {
    if (minSupported.isEmpty) return false;
    return _compareSemver(current, minSupported) < 0;
  }

  static int _compareSemver(String a, String b) {
    List<int> parts(String v) => v
        .split('.')
        .map((p) => int.tryParse(p.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0)
        .toList();
    final left = parts(a);
    final right = parts(b);
    final len = left.length > right.length ? left.length : right.length;
    for (var i = 0; i < len; i++) {
      final l = i < left.length ? left[i] : 0;
      final r = i < right.length ? right[i] : 0;
      if (l != r) return l.compareTo(r);
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final deps = DependenciesScope.of(context);
    final info = deps.appVersion;
    if (info == null || !needsUpdate(deps.currentVersion, info.minSupported)) {
      return child;
    }
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              Image.asset('assets/images/merch-logo.png', height: 120),
              const SizedBox(height: 24),
              Text(
                context.l10n.updateApp,
                style: context.textTheme.headlineLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                context.l10n.updateAppBody(info.minSupported),
                style: context.textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: info.downloadUrl.isEmpty
                    ? null
                    : () => launchUrl(
                        Uri.parse(info.downloadUrl),
                        mode: LaunchMode.externalApplication,
                      ),
                child: Text(context.l10n.downloadApk),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
