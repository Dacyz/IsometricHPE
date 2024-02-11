import 'package:app_position/features/views/screens/pose_detector_view.dart';
import 'package:app_position/features/views/screens/settings_view.dart';
import 'package:app_position/features/views/screens/splash_view.dart';
import 'package:flutter/material.dart';

class AppConstants {
  static final Map<String, Widget Function(BuildContext _)> routes = {
    // Here add app routes
    SplashView.route: (_) => const SplashView(),
    PoseDetectorView.route: (_) => const PoseDetectorView(),
    SettingsView.route: (_) => const SettingsView(),
  };

  static const initialRoute = SplashView.route;

  static final ConstantColors colors = ConstantColors();
}

class ConstantColors {
  // Here add app colors
  final Color primary = const Color(0xFF256D67);
  final Color secondary = const Color(0xFFFFBC57);
  final Color disabled = const Color(0xFFD9D9D9);
}
