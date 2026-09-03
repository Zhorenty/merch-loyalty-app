sealed class LoyaltySettingsEvent {
  const LoyaltySettingsEvent();

  const factory LoyaltySettingsEvent.started() = LoyaltySettingsEvent$Started;

  const factory LoyaltySettingsEvent.saved({
    required Map<String, String> settings,
    required void Function() onSuccess,
    required void Function(Object error) onError,
  }) = LoyaltySettingsEvent$Saved;
}

final class LoyaltySettingsEvent$Started extends LoyaltySettingsEvent {
  const LoyaltySettingsEvent$Started();
}

final class LoyaltySettingsEvent$Saved extends LoyaltySettingsEvent {
  const LoyaltySettingsEvent$Saved({
    required this.settings,
    required this.onSuccess,
    required this.onError,
  });

  final Map<String, String> settings;
  final void Function() onSuccess;
  final void Function(Object error) onError;
}
