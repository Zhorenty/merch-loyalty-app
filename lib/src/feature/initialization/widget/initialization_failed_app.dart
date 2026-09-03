import 'package:flutter/material.dart';

class InitializationFailedApp extends StatefulWidget {
  const InitializationFailedApp({
    required this.error,
    required this.stackTrace,
    this.retryInitialization,
    super.key,
  });

  final Object error;
  final StackTrace stackTrace;
  final Future<void> Function()? retryInitialization;

  @override
  State<InitializationFailedApp> createState() =>
      _InitializationFailedAppState();
}

class _InitializationFailedAppState extends State<InitializationFailedApp> {
  final _inProgress = ValueNotifier<bool>(false);

  @override
  void dispose() {
    _inProgress.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
    home: Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Не удалось запустить приложение',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                '${widget.error}',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.error,
                ),
                textAlign: TextAlign.center,
              ),
              if (widget.retryInitialization != null) ...[
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _retryInitialization,
                  child: const Text('Повторить'),
                ),
              ],
            ],
          ),
        ),
      ),
    ),
  );

  Future<void> _retryInitialization() async {
    _inProgress.value = true;
    await widget.retryInitialization!();
    _inProgress.value = false;
  }
}
