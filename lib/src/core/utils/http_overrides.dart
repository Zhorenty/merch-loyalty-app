import 'dart:io';

import 'package:flutter/foundation.dart';

class AppHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    final client = super.createHttpClient(context);
    if (kReleaseMode) return client;
    client.badCertificateCallback = (_, _, _) => true;
    return client;
  }
}
