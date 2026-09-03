import 'package:flutter/material.dart';
import 'package:merch/src/feature/auth/widget/auth_scope.dart';
import 'package:merch/src/feature/initialization/model/dependencies.dart';
import 'package:merch/src/feature/initialization/widget/dependencies_scope.dart';
import '/src/feature/app/widget/material_context.dart';

class App extends StatelessWidget {
  const App({required this.result, super.key});

  final InitializationResult result;

  @override
  Widget build(BuildContext context) => DependenciesScope(
    dependencies: result.dependencies,
    child: const AuthScope(child: MaterialContext()),
  );
}
