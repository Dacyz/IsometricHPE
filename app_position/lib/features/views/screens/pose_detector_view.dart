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
                                camera.restartTimer(context);
                              },
                      ),
                    ),
                    const SizedBox(width: 8),
                    FloatingActionButton(
                      elevation: 0,
                      shape: CircleBorder(
                          side: BorderSide(color: camera.isTimerRunning ? Colors.grey : AppConstants.colors.primary)),
                      onPressed: camera.isTimerRunning
                          ? null
                          : () {
                              final camera = Provider.of<Camera>(context, listen: false);
                              camera.switchLiveCamera();
                            },
                      highlightElevation: 0,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.flip_camera_android_outlined,
                        color: camera.isTimerRunning ? Colors.grey : AppConstants.colors.primary,
                        size: 25,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  camera.time,
                  style: const TextStyle(
                    fontSize: 72,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 16),
                LinearProgressIndicator(
                  value: camera.fullProgress,
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
