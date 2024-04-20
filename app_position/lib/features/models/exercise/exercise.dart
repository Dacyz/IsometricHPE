import 'package:app_position/features/data/exercise.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'exercise.g.dart';

@HiveType(typeId: 5)
enum ExerciseType {
  @HiveField(0)
  rest,
  @HiveField(1)
  exercise,
}

@HiveType(typeId: 6)
class ExerciseModel {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final ExerciseType type;
  @HiveField(2)
  int timeInMilliseconds;

  Duration get time => Duration(milliseconds: timeInMilliseconds);
  set time(Duration value) => timeInMilliseconds = value.inMilliseconds;

  final String Function(Canvas canvas, Size size, Pose poses, Size imageSize, InputImageRotation rotation,
      CameraLensDirection cameraLensDirection)? toPaint;

  Exercise toExercise() => Exercise.exercise(this);

  ExerciseModel({
    required this.name,
    final Duration time = const Duration(seconds: 1),
    this.toPaint,
    this.type = ExerciseType.exercise,
  }) : timeInMilliseconds = time.inMilliseconds;

  @override
  String toString() {
    return name;
  }
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
      time: const Duration(seconds: 20),
      toPaint: (canvas, size, pose, imageSize, rotation, cameraLensDirection) => '',
    );
  }

  factory Exercise.exercise(ExerciseModel model) {
    if (model.toPaint == null) {
      final toPaint = data.indexWhere((e) => e.name == model.name);
      if (toPaint != -1) {
        return Exercise(
          name: model.name,
          type: model.type,
          time: model.time,
          toPaint: data[toPaint].toPaint,
        );
      }
    }
    return Exercise(
      name: model.name,
      type: model.type,
      time: model.time,
      toPaint: model.toPaint,
    );
  }

  bool isDone;
  int millisecondsElapsed;
  String get heroTag => '$name$hashCode';
  String get duration =>
      '${(time.inMilliseconds ~/ 60000).toString().padLeft(2, '0')}:${((time.inMilliseconds ~/ 1000) % 60).toString().padLeft(2, '0')}';
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
    String Function(Canvas canvas, Size size, Pose poses, Size imageSize, InputImageRotation rotation,
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
