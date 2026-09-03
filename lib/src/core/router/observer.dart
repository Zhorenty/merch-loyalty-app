import 'package:flutter/material.dart';
import 'package:merch/src/core/utils/refined_logger.dart';

class RouterObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    logger.info('Route pushed: ${route.settings.name ?? 'Modal'}');
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    logger.info('Route replaced: ${newRoute?.settings.name ?? 'Modal'}');
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    logger.info('Route popped: ${route.settings.name ?? 'Modal'}');
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    logger.info('Route removed: ${route.settings.name ?? 'Modal'}');
  }
}
