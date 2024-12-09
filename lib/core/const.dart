import 'package:app_position/features/models/exercise/exercise.dart';
import 'package:app_position/features/single_exercise.dart/presentation/single_exercise_view.dart';
import 'package:app_position/features/single_exercise.dart/presentation/single_exercise.dart';
import 'package:app_position/features/views/screens/about_view.dart';
import 'package:app_position/features/views/screens/pose_detector_view.dart';
import 'package:app_position/features/views/screens/progress_view.dart';
import 'package:app_position/features/views/screens/settings_view.dart';
import 'package:app_position/features/views/screens/splash_view.dart';
import 'package:app_position/features/voice/presentation/voice_repository.dart';
import 'package:app_position/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppConstants {
  static final Map<String, Widget Function(BuildContext _)> routes = {
    // Here add app routes
    SplashView.route: (_) => const SplashView(),
    PoseDetectorView.route: (_) => const PoseDetectorView(),
    SettingsView.route: (_) => const SettingsView(),
    ProgressView.route: (_) => const ProgressView(),
    AboutView.route: (_) => const AboutView(),
  };

  static Route<dynamic>? routing(RouteSettings routeSettings) {
    if (routeSettings.name == SingleExerciseView.route) {
      return MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider(
          create: (_) => SingleExerciseProvider(
              routeSettings.arguments as Exercise, getIt<VoiceRepository>()),
          child: SingleExerciseView(
            exercise: routeSettings.arguments as Exercise,
          ),
        ),
      );
    }
    return MaterialPageRoute(builder: routes[routeSettings.name]!);
  }

  static const initialRoute = SplashView.route;

  static const String dbName = 'AppPosition';
  static const String dbBox = 'exercises';

  static final ConstantColors colors = ConstantColors();
}

class ConstantColors {
  // Here add app colors
  final Color primary = const Color(0xFF256D67);
  final Color secondary = const Color(0xFFFFBC57);
  final Color disabled = const Color(0xFFD9D9D9);
}
