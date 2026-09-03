import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import '/src/core/utils/extensions/context_extension.dart';
import '/src/feature/initialization/model/dependencies.dart';

class DependenciesScope extends InheritedWidget {
  const DependenciesScope({
    required super.child,
    required this.dependencies,
    super.key,
  });

  final Dependencies dependencies;

  static Dependencies of(BuildContext context) =>
      context.inhOf<DependenciesScope>(listen: false).dependencies;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<Dependencies>('dependencies', dependencies),
    );
  }

  @override
  bool updateShouldNotify(DependenciesScope oldWidget) => false;
}
