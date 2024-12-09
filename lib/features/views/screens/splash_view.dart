import 'package:app_position/core/const.dart';
import 'package:app_position/features/data/exercise.dart';
import 'package:app_position/features/providers/camera.dart';
import 'package:app_position/features/single_exercise.dart/presentation/single_exercise_view.dart';
import 'package:app_position/features/views/screens/about_view.dart';
import 'package:app_position/features/views/screens/pose_detector_view.dart';
import 'package:app_position/features/views/screens/progress_view.dart';
import 'package:app_position/features/views/screens/settings_view.dart';
import 'package:app_position/features/views/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});
  static const String route = '/';

  @override
  Widget build(BuildContext context) {
    Provider.of<Camera>(context, listen: false);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Icono grande
              Expanded(
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: SvgPicture.asset(
                        'assets/svg/splash_image.svg',
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.bottomCenter,
                      ),
                    ),
                    Positioned(
                      height: 45,
                      right: 0,
                      child: FloatingActionButton(
                        heroTag: "btnSplash",
                        elevation: 0,
                        shape: CircleBorder(side: BorderSide(color: AppConstants.colors.primary)),
                        onPressed: () => Navigator.pushNamed(context, AboutView.route),
                        highlightElevation: 0,
                        backgroundColor: Colors.transparent,
                        child: Text(
                          'i',
                          style: TextStyle(
                            color: AppConstants.colors.primary,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20.0),
              Text(
                'IsometricHPE',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppConstants.colors.primary,
                  fontSize: 30.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 20.0),
              // Botones
              CustomElevatedButton(
                title: 'Single',
                onPressed: () => Navigator.pushNamed(context, SingleExerciseView.route, arguments: data.first),
              ),
              const SizedBox(height: 10.0),
              CustomElevatedButton(
                title: 'Ejercitarse',
                onPressed: () => Navigator.pushNamed(context, PoseDetectorView.route),
              ),
              const SizedBox(height: 10.0),
              CustomElevatedButton.outlined(
                title: 'Progreso',
                onPressed: () => Navigator.pushNamed(context, ProgressView.route),
              ),
              const SizedBox(height: 10.0),
              CustomElevatedButton.outlined(
                title: 'Configuración',
                onPressed: () => Navigator.pushNamed(context, SettingsView.route),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
