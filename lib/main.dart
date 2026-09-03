import 'dart:async';

import '/src/core/utils/refined_logger.dart';
import '/src/feature/app/logic/app_runner.dart';

void main() => runZonedGuarded(
  () => const AppRunner().initializeAndRun(),
  logger.logZoneError,
);
