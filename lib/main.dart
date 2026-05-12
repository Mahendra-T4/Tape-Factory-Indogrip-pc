import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:indogrip/app.dart';
import 'package:indogrip/core/database/round_db_hive.dart';
import 'package:indogrip/core/service/connectivity/internate%20connectivity-checker.dart';
import 'package:indogrip/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:indogrip/features/carton/presentation/bloc/carton_bloc.dart';
import 'package:indogrip/features/client/presentation/bloc/client_bloc.dart';
import 'package:indogrip/features/dashboard/presentation/bloc/home_bloc.dart';
import 'package:indogrip/features/global/data/repositories/global_manager_repo.dart';
import 'package:indogrip/features/global/presentation/bloc/global_bloc.dart';
import 'package:indogrip/features/jumbo%20roll/presentation/bloc/jumbo_roll_bloc.dart';
import 'package:indogrip/features/staff/presentation/bloc/staff_bloc.dart';
import 'package:window_manager/window_manager.dart';
import 'package:indogrip/core/database/hive_service.dart';
import 'package:indogrip/core/service/api%20service/dio_service.dart';
import 'core/config/env_config.dart';

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  InternetConnectionService().startMonitoring();
  RoundDBHive.initialize();

  // Initialize Hive for local storage
  await HiveService.init();

  // Initialize environment config
  await EnvConfig.init();

  // Initialize Dio with proper timeout configuration
  DioService.initialize();

  log('UserKey: ${HiveService.getUserId()}');

  // Initialize window manager
  await windowManager.ensureInitialized();

  // Calculate responsive window size based on typical screen sizes
  // Use conservative defaults that work on most screens
  final defaultWidth = 1300.0; // Reasonable default width
  final defaultHeight =
      850.0; // Reasonable default height with space for title bar

  // Ensure minimum size allows proper title bar display
  final minWidth = 1300.0; // Increased minimum width for title bar
  final minHeight = 760.0; // Increased minimum height for proper layout

  // Configure window options with responsive sizing and proper title bar
  WindowOptions windowOptions = WindowOptions(
    size: Size(defaultWidth, defaultHeight),
    // minimumSize: Size(minWidth, minHeight),
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.normal,
    title: 'IndoGrip',
    windowButtonVisibility: true,
  );

  // Apply window configurations
  await windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();

    // Ensure window is properly positioned and sized after showing
    await windowManager.setMinimumSize(Size(minWidth, minHeight));

    // Additional window setup for better compatibility across different PCs
    await windowManager.setTitleBarStyle(
      TitleBarStyle.normal,
      windowButtonVisibility: true,
    );
    await windowManager.setTitle('IndoGrip');

    // Handle window state to prevent title bar issues
    try {
      // If window is maximized, unmaximize it first
      if (await windowManager.isMaximized()) {
        await windowManager.unmaximize();
      }

      // If window is minimized, restore it
      if (await windowManager.isMinimized()) {
        await windowManager.restore();
      }

      // Ensure proper window size (not too small for title bar)
      final currentSize = await windowManager.getSize();
      if (currentSize.width < minWidth || currentSize.height < minHeight) {
        await windowManager.setSize(Size(defaultWidth, defaultHeight));
      }

      // Center window on screen for better visibility
      await windowManager.center();

      // Set always on top temporarily to ensure it's visible, then remove it
      await windowManager.setAlwaysOnTop(true);
      await Future.delayed(const Duration(milliseconds: 100));
      await windowManager.setAlwaysOnTop(false);
    } catch (e) {
      // If any window operations fail, ensure basic functionality
      print('Window setup warning: $e');
      await windowManager.center();
    }
  });

  runApp(
    ProviderScope(
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => AuthBloc()),
          BlocProvider(create: (context) => CartonBloc()),
          BlocProvider(create: (context) => JumboRollBloc()),
          BlocProvider(create: (context) => ClientBloc()),
          BlocProvider(create: (context) => StaffBloc()),
          BlocProvider(create: (context) => HomeBloc()),
          BlocProvider(
            create: (context) =>
                GlobalBloc(globalRepository: GlobalManagerRepository()),
          ),
        ],
        child: App(),
      ),
    ),
  );
}
