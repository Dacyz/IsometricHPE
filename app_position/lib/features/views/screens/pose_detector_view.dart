import 'package:app_position/core/const.dart';
import 'package:app_position/features/providers/camera.dart';
import 'package:app_position/features/views/widgets/camera_view.dart';
import 'package:app_position/features/views/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PoseDetectorView extends StatefulWidget {
  const PoseDetectorView({super.key});
  static const String route = '/pose%20detector';

  @override
  State<StatefulWidget> createState() => _PoseDetectorViewState();
}

class _PoseDetectorViewState extends State<PoseDetectorView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Expanded(
            child: CameraView(),
          ),
          Container(
            color: Colors.white,
            height: 350,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            width: double.infinity,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: CustomElevatedButton(
                        title: 'Ejercitarse',
                        onPressed: () => false,
                      ),
                    ),
                    const SizedBox(width: 8),
                    FloatingActionButton(
                      elevation: 0,
                      shape: CircleBorder(side: BorderSide(color: AppConstants.colors.primary)),
                      onPressed: () {
                        final camera = Provider.of<Camera>(context, listen: false);
                        camera.switchLiveCamera();
                      },
                      highlightElevation: 0,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.flip_camera_android_outlined,
                        color: AppConstants.colors.primary,
                        size: 25,
                      ),
                    )
                  ],
                ),
                const Text(
                  '00:00:00',
                  style: TextStyle(
                    fontSize: 72,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Transform.flip(
                  flipX: true,
                  child: LinearProgressIndicator(
                    value: 0.5,
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(8),
                    color: AppConstants.colors.primary,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
