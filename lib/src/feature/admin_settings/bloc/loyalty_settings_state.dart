sealed class LoyaltySettingsState {
  const LoyaltySettingsState();

  const factory LoyaltySettingsState.processing() =
      LoyaltySettingsState$Processing;

  const factory LoyaltySettingsState.idle({
    required Map<String, String> settings,
    bool saving,
  }) = LoyaltySettingsState$Idle;

  const factory LoyaltySettingsState.error({required Object error}) =
      LoyaltySettingsState$Error;

  bool get isProcessing => this is LoyaltySettingsState$Processing;

  bool get isSaving => switch (this) {
    final LoyaltySettingsState$Idle s => s.saving,
    _ => false,
  };

  Map<String, String> get settings => switch (this) {
    final LoyaltySettingsState$Idle s => s.settings,
    _ => const {},
  };

  Object? get error => switch (this) {
    final LoyaltySettingsState$Error e => e.error,
    _ => null,
  };
}

final class LoyaltySettingsState$Processing extends LoyaltySettingsState {
  const LoyaltySettingsState$Processing();
}

final class LoyaltySettingsState$Idle extends LoyaltySettingsState {
  const LoyaltySettingsState$Idle({required this.settings, this.saving = false});

  @override
  final Map<String, String> settings;

  final bool saving;
}

final class LoyaltySettingsState$Error extends LoyaltySettingsState {
  const LoyaltySettingsState$Error({required this.error});

  @override
  final Object error;
}
