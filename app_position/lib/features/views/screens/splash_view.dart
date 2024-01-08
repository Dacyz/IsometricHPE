import 'package:app_position/features/views/screens/pose_detector_view.dart';
import 'package:app_position/features/views/screens/settings_view.dart';
import 'package:flutter/material.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});
  static const String route = '/splash';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icono grande
            const Icon(Icons.fitness_center, size: 150.0, color: Colors.blue),
            const Text('App Position', style: TextStyle(fontSize: 30.0)),
            const SizedBox(height: 20.0),
            // Botones
            ElevatedButton.icon(
                onPressed: () =>
                    Navigator.pushNamed(context, PoseDetectorView.route),
                icon: const Icon(Icons.directions_run),
                label: const Text('Ejercicios')),
            const SizedBox(height: 10.0),
            ElevatedButton.icon(
                onPressed: () =>
                    Navigator.pushNamed(context, SettingsView.route),
                icon: const Icon(Icons.settings),
                label: const Text('Configuración')),
          ],
        ),
      ),
    );
  }
}
