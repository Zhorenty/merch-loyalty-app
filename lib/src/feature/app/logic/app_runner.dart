import 'dart:async';
import 'dart:io';

import 'package:bloc_concurrency/bloc_concurrency.dart' as bloc_concurrency;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:merch/src/core/utils/http_overrides.dart';
import 'package:merch/src/core/utils/refined_logger.dart';
import 'package:merch/src/feature/initialization/logic/initialization_processor.dart';
import 'package:merch/src/feature/initialization/widget/initialization_failed_app.dart';
import '/src/core/utils/app_bloc_observer.dart';
import '/src/feature/app/widget/app.dart';

final class AppRunner {
  const AppRunner();

  Future<void> initializeAndRun() async {
    final binding = WidgetsFlutterBinding.ensureInitialized();
    binding.deferFirstFrame();

    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Color(0xFFF4F5F8),
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    FlutterError.onError = logger.logFlutterError;
    WidgetsBinding.instance.platformDispatcher.onError =
        logger.logPlatformDispatcherError;

    Bloc.observer = AppBlocObserver(logger);
    Bloc.transformer = bloc_concurrency.sequential();

    HttpOverrides.global = AppHttpOverrides();

    const initializationProcessor = InitializationProcessor();

    Future<void> initializeAndRun() async {
      try {
        final result = await initializationProcessor.initialize();
        runApp(App(result: result));
      } catch (e, stackTrace) {
        logger.error('Initialization failed', error: e, stackTrace: stackTrace);
        runApp(
          InitializationFailedApp(
            error: e,
            stackTrace: stackTrace,
            retryInitialization: initializeAndRun,
          ),
        );
      } finally {
        binding.allowFirstFrame();
      }
    }

    await initializeAndRun();
  }
}
