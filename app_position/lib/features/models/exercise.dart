import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

class ExerciseModel {
  final String name;
  final Duration time;
  final Function(Canvas canvas, Size size, Pose poses, Size imageSize, InputImageRotation rotation,
      CameraLensDirection cameraLensDirection) toPaint;

  const ExerciseModel({
    required this.name,
    required this.time,
    required this.toPaint,
  });
}

class Exercise extends ExerciseModel {
  Exercise({
    required super.name,
    required super.time,
    required super.toPaint,
    this.isDone = false,
  });

  bool isDone;
  int millisecondsElapsed = 0;

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
