// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:indogrip/app.dart';
// import 'package:indogrip/features/auth/presentation/bloc/auth_bloc.dart';
// import 'package:indogrip/features/carton/presentation/bloc/carton_bloc.dart';
// import 'package:indogrip/features/client/presentation/bloc/client_bloc.dart';
// import 'package:indogrip/features/dashboard/presentation/bloc/home_bloc.dart';
// import 'package:indogrip/features/global/data/repositories/global_manager_repo.dart';
// import 'package:indogrip/features/global/presentation/bloc/global_bloc.dart';
// import 'package:indogrip/features/jumbo%20roll/presentation/bloc/jumbo_roll_bloc.dart';
// import 'package:indogrip/features/staff/presentation/bloc/staff_bloc.dart';
// import 'package:window_manager/window_manager.dart';
// import 'package:indogrip/core/database/hive_service.dart';
// import 'package:indogrip/core/service/api%20service/dio_service.dart';
// import 'core/config/env_config.dart';

// void main() async {
//   // Ensure Flutter is initialized
//   WidgetsFlutterBinding.ensureInitialized();

//   // Initialize Hive for local storage
//   await HiveService.init();

//   // Initialize environment config
//   await EnvConfig.init();

//   // Initialize Dio with proper timeout configuration
//   DioService.initialize();

//   // Initialize window manager
//   await windowManager.ensureInitialized();

//   // Configure window options
//   WindowOptions windowOptions = const WindowOptions(
//     size: Size(1200, 800),
//     minimumSize: Size(1100, 600),
//     center: true,
//     backgroundColor: Colors.transparent,
//     skipTaskbar: false,
//     titleBarStyle: TitleBarStyle.normal,
//     title: 'IndoGrip',
//     windowButtonVisibility: true,
//   );

//   // Apply window configurations
//   await windowManager.waitUntilReadyToShow(windowOptions, () async {
//     await windowManager.show();
//     await windowManager.focus();
//   });

//   runApp(
//     ProviderScope(
//       child: MultiBlocProvider(
//         providers: [
//           BlocProvider(create: (_) => AuthBloc()),
//           BlocProvider(create: (context) => CartonBloc()),
//           BlocProvider(create: (context) => JumboRollBloc()),
//           BlocProvider(create: (context) => ClientBloc()),
//           BlocProvider(create: (context) => StaffBloc()),
//           BlocProvider(create: (context) => HomeBloc()),
//           BlocProvider(
//             create: (context) =>
//                 GlobalBloc(globalRepository: GlobalManagerRepository()),
//           ),
//         ],
//         child: App(),
//       ),
//     ),
//   );
// }
