import 'package:app_position/features/models/exercise/exercise.dart';
import 'package:app_position/features/models/pose_detail/pose_detail.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

class PosePainter extends CustomPainter {
  PosePainter(
    this.poses,
    this.imageSize,
    this.rotation,
    this.cameraLensDirection,
    this.currentExercise, {
    this.validator,
  });

  final Pose poses;
  final Size imageSize;
  final InputImageRotation rotation;
  final CameraLensDirection cameraLensDirection;
  final Exercise currentExercise;
  final Function(String? value)? validator;

  @override
  void paint(Canvas canvas, Size size) {
    if (currentExercise.toPaint != null) {
      final validation = currentExercise.toPaint!(canvas, size, poses, imageSize, rotation, cameraLensDirection);
      if (validation.isNotEmpty && validator != null) {
        validator!(validation);
      }
    }
  }

  @override
  bool shouldRepaint(covariant PosePainter oldDelegate) {
    return oldDelegate.imageSize != imageSize || oldDelegate.poses != poses;
  }
}

class PosePreview extends StatelessWidget {
  const PosePreview({
    super.key,
    required this.size,
    required this.detail,
    this.scale = 1.0,
    this.clipBehavior = Clip.hardEdge,
  });

  final Size size;
  final double scale;
  final PoseDetail detail;
  final Clip clipBehavior;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: size.height,
      width: size.width,
      clipBehavior: clipBehavior,
      decoration: const BoxDecoration(color: Colors.black),
      transform: Matrix4.diagonal3Values(scale, scale, 1.0),
      child: CustomPaint(
        size: size,
        painter: PosePainter(
          detail.pose.mlkpPose,
          size,
          InputImageRotation.rotation90deg,
          CameraLensDirection.back,
          detail.exercise.toExercise(),
        ),
      ),
    );
  }
}
