import 'package:app_position/features/views/screens/pose_detector_view.dart';
import 'package:app_position/features/views/screens/settings_view.dart';
import 'package:app_position/features/views/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});
  static const String route = '/splash';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Icono grande
            Expanded(
              child: SvgPicture.asset(
                'assets/svg/splash_image.svg',
                fit: BoxFit.scaleDown,
                alignment: Alignment.bottomCenter,
              ),
            ),
            const SizedBox(height: 20.0),
            const Text('App Position',
                textAlign: TextAlign.center, style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.w500)),
            const SizedBox(height: 20.0),
            // Botones
            CustomElevatedButton(
              title: 'Ejercitarse',
              onPressed: () => Navigator.pushNamed(context, PoseDetectorView.route),
            ),
            const SizedBox(height: 10.0),
            CustomElevatedButton.outlined(
              title: 'Progreso',
              onPressed: () => false,
            ),
            const SizedBox(height: 10.0),
            CustomElevatedButton.outlined(
              title: 'Configuración',
              onPressed: () => Navigator.pushNamed(context, SettingsView.route),
            ),
          ],
        ),
      ),
    );
  }
}
