import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:merch/src/core/constant/localization/generated/l10n.dart';
import 'package:merch/src/core/router/refresh.dart';
import 'package:merch/src/core/router/routes.dart';
import 'package:merch/src/core/theme/theme.dart';
import 'package:merch/src/feature/initialization/widget/dependencies_scope.dart';
import 'package:merch/src/feature/version/widget/force_update_gate.dart';

class MaterialContext extends StatefulWidget {
  const MaterialContext({super.key});

  static final _globalKey = GlobalKey();

  @override
  State<MaterialContext> createState() => _MaterialContextState();
}

class _MaterialContextState extends State<MaterialContext> {
  late final GoRouter _router;
  late final GoRouterRefreshStream _refresh;

  @override
  void initState() {
    super.initState();
    final authBloc = DependenciesScope.of(context).authBloc;
    _refresh = GoRouterRefreshStream(authBloc.stream);
    _router = createRouter(refreshListenable: _refresh);
  }

  @override
  void dispose() {
    _refresh.dispose();
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MaterialApp.router(
    debugShowCheckedModeBanner: false,
    title: 'MERCH Касса',
    theme: $lightThemeData,
    routerConfig: _router,
    locale: const Locale('ru'),
    supportedLocales: AppLocalizations.delegate.supportedLocales,
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    builder: (context, child) {
      final textScaler = MediaQuery.textScalerOf(context);
      final clampedScale = textScaler.scale(1.0).clamp(1.0, 2.0);

      return ForceUpdateGate(
        child: MediaQuery(
          key: MaterialContext._globalKey,
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.linear(clampedScale)),
          child: child ?? const SizedBox.shrink(),
        ),
      );
    },
  );
}
