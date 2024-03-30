import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_position/core/const.dart';
import 'package:app_position/features/providers/camera.dart';
import 'package:app_position/features/views/widgets/camera_view.dart';
import 'package:app_position/features/views/widgets/custom_elevated_button.dart';

class PoseDetectorView extends StatefulWidget {
  const PoseDetectorView({Key? key}) : super(key: key);
  static const String route = '/pose%20detector';

  @override
  State<StatefulWidget> createState() => _PoseDetectorViewState();
}

class _PoseDetectorViewState extends State<PoseDetectorView> {

  @override
  Widget build(BuildContext context) {
    final camera = Provider.of<Camera>(context);
    return Scaffold(
      body: Column(
        children: [
          const Expanded(child: CameraView()),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            width: double.infinity,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: CustomElevatedButton(
                        title: 'Ejercitarse',
                        onPressed: camera.isTimerRunning
                            ? null
                            : () {
                                camera.restartTimer();
                              },
                      ),
                    ),
                    const SizedBox(width: 8),
                    FloatingActionButton(
                      elevation: 0,
                      shape: CircleBorder(side: BorderSide(color: AppConstants.colors.primary)),
                      onPressed: camera.isTimerRunning
                          ? () {
                              final camera = Provider.of<Camera>(context, listen: false);
                              camera.switchLiveCamera();
                            }
                          : null,
                      highlightElevation: 0,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.flip_camera_android_outlined,
                        color: camera.isTimerRunning ? AppConstants.colors.primary : Colors.grey,
                        size: 25,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  '${camera.currentExercise.name} ${camera.fullTime.toString()} ${camera.exerciseProgress.toStringAsFixed(3)}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  camera.time, // Actualizado para mostrar milisegundos
                  style: const TextStyle(
                    fontSize: 72,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                LinearProgressIndicator(
                  value: camera.exerciseProgress,
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(8),
                  color: AppConstants.colors.primary,
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
