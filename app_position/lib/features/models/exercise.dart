import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

class Exercise {
  final String name;
  final Duration time;
  final Function(Canvas canvas, Size size, Pose poses, Size imageSize, InputImageRotation rotation,
      CameraLensDirection cameraLensDirection) toPaint;

  const Exercise({
    required this.name,
    required this.time,
    required this.toPaint,
  });

  @override
  String toString() {
    return name;
  }

  Exercise copyWith({
    String? name,
    Duration? time,
    Function(Canvas canvas, Size size, Pose poses, Size imageSize, InputImageRotation rotation,
            CameraLensDirection cameraLensDirection)?
        toPaint,
  }) {
    return Exercise(
      name: name ?? this.name,
      time: time ?? this.time,
      toPaint: toPaint ?? this.toPaint,
    );
  }
}
