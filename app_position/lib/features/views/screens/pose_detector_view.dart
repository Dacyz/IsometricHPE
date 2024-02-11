import 'package:app_position/core/const.dart';
import 'package:app_position/features/views/widgets/camera_view.dart';
import 'package:app_position/features/views/widgets/custom_elevated_button.dart';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:wakelock/wakelock.dart';

import '../widgets/pose_painter.dart';

class PoseDetectorView extends StatefulWidget {
  const PoseDetectorView({super.key});
  static const String route = '/pose%20detector';

  @override
  State<StatefulWidget> createState() => _PoseDetectorViewState();
}

class _PoseDetectorViewState extends State<PoseDetectorView> {
  final PoseDetector _poseDetector = PoseDetector(options: PoseDetectorOptions(model: PoseDetectionModel.base));
  bool _canProcess = true;
  bool _isBusy = false;
  CustomPaint? _customPaint;
  var _cameraLensDirection = CameraLensDirection.front;

  @override
  void initState() {
    Wakelock.enable();
    super.initState();
  }

  @override
  void dispose() async {
    _canProcess = false;
    _poseDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: CameraView(
              customPaint: _customPaint,
              onImage: _processImage,
              onCameraFeedReady: () {
                debugPrint('wa');
              },
              initialCameraLensDirection: _cameraLensDirection,
              onCameraLensDirectionChanged: (value) => _cameraLensDirection = value,
            ),
          ),
          Container(
            color: Colors.white,
            height: 380,
            padding: const EdgeInsets.all(24),
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
                      onPressed: () {},
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

  Future<void> _processImage(InputImage inputImage) async {
    if (!_canProcess) return;
    if (_isBusy) return;
    _isBusy = true;
    _paintLines(inputImage);
    _isBusy = false;
    if (mounted) {
      setState(() {});
    }
  }

  void _paintLines(InputImage inputImage) async {
    final poses = await _poseDetector.processImage(inputImage);
    if (inputImage.metadata?.size != null && inputImage.metadata?.rotation != null) {
      final painter = PosePainter(
        poses,
        inputImage.metadata!.size,
        inputImage.metadata!.rotation,
        _cameraLensDirection,
      );
      _customPaint = CustomPaint(painter: painter);
    } else {
      // TODO: set customPaint to draw landmarks on top of image
      _customPaint = null;
    }
  }
}
