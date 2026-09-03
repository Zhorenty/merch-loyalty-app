import 'package:flutter/widgets.dart';
import 'package:merch/src/core/constant/localization/generated/l10n.dart';
import 'package:merch/src/core/rest_client/rest_client.dart';

export 'package:merch/src/core/constant/localization/generated/l10n.dart';

extension LocalizationX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);

  String errorMessage(Object error) {
    if (error is ConnectionException) return l10n.offlineRetry;
    if (error is StructuredBackendException) return error.backendMessage;
    return l10n.genericError;
  }
}
