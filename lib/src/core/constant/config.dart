import '/src/feature/initialization/model/environment.dart';

/// Application configuration.
class Config {
  const Config();

  Environment get environment {
    var environment = const String.fromEnvironment('ENVIRONMENT');
    if (environment.isNotEmpty) {
      return Environment.from(environment);
    }
    environment = const String.fromEnvironment('FLUTTER_APP_FLAVOR');
    return Environment.from(environment);
  }

  /// Whether to use an in-memory fake backend instead of real HTTP calls.
  ///
  /// Enable with `--dart-define=USE_MOCK_API=true` to smoke-test the app
  /// without running a backend. See [RestClientMock].
  bool get useMockApi =>
      const bool.fromEnvironment('USE_MOCK_API', defaultValue: false);

  /// HTTPS API MERCH. Override with `--dart-define=API_BASE_URL=...`.
  String get baseUrl {
    const override = String.fromEnvironment('API_BASE_URL');
    if (override.isNotEmpty) {
      return override.endsWith('/') ? override : '$override/';
    }
    return switch (environment) {
      Environment.dev => 'http://127.0.0.1:8080/',
      Environment.prod => 'https://api.merch.store/',
    };
  }
}
