import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

enum ExerciseType { rest, exercise }

class ExerciseModel {
  final String name;
  final ExerciseType type;
  Duration time;
  final Function(Canvas canvas, Size size, Pose poses, Size imageSize, InputImageRotation rotation,
      CameraLensDirection cameraLensDirection) toPaint;

  ExerciseModel({
    required this.name,
    required this.time,
    required this.toPaint,
    this.type = ExerciseType.exercise,
  });
}

class Exercise extends ExerciseModel {
  Exercise({
    required super.name,
    required super.time,
    required super.toPaint,
    super.type = ExerciseType.exercise,
    this.isDone = false,
    this.millisecondsElapsed = 0,
  });

  factory Exercise.rest() {
    return Exercise(
      name: 'Descanso',
      type: ExerciseType.rest,
      time: const Duration(seconds: 10),
      toPaint: (canvas, size, pose, imageSize, rotation, cameraLensDirection) {},
    );
  }

  bool isDone;
  int millisecondsElapsed;
  String get heroTag => '$name$hashCode';
  String get duration => '${(time.inMilliseconds ~/ 60000).toString().padLeft(2, '0')}:${((time.inMilliseconds ~/ 1000) % 60).toString().padLeft(2, '0')}';
  String get timer =>
      '${(millisecondsElapsed ~/ 60000).toString().padLeft(2, '0')}:${((millisecondsElapsed ~/ 1000) % 60).toString().padLeft(2, '0')}';
  @override
  String toString() {
    return name;
  }

  Exercise copyWith({
    String? name,
    Duration? time,
    bool? isDone,
    int? millisecondsElapsed,
    Function(Canvas canvas, Size size, Pose poses, Size imageSize, InputImageRotation rotation,
            CameraLensDirection cameraLensDirection)?
        toPaint,
  }) {
    return Exercise(
      name: name ?? this.name,
      time: time ?? this.time,
      isDone: isDone ?? this.isDone,
      millisecondsElapsed: millisecondsElapsed ?? this.millisecondsElapsed,
      toPaint: toPaint ?? this.toPaint,
    );
  }
}
