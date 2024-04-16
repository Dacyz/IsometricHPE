import 'package:app_position/features/models/exercise/exercise.dart';
import 'package:app_position/features/models/tools.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

final List<Exercise> data = [
  fullBridge,
  sideLeftBridge,
  sideRightBridge,
  dBridge,
  cBridge,
];

final Exercise fullBridge = Exercise(
  name: 'Full Bridge',
  time: const Duration(seconds: 60),
  toPaint: (canvas, size, pose, imageSize, rotation, cameraLensDirection) {
    final leftPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..color = Colors.yellow;
    final rightPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..color = Colors.blueAccent;

    final tool = ExerciseTools(
      canvas,
      size: size,
      pose: pose,
      imageSize: imageSize,
      rotation: rotation,
      cameraLensDirection: cameraLensDirection,
    );

    //Draw arms
    tool.paintLine(PoseLandmarkType.leftShoulder, PoseLandmarkType.leftElbow, leftPaint);
    tool.paintLine(PoseLandmarkType.leftElbow, PoseLandmarkType.leftWrist, leftPaint);
    tool.paintLine(PoseLandmarkType.rightShoulder, PoseLandmarkType.rightElbow, rightPaint);
    tool.paintLine(PoseLandmarkType.rightElbow, PoseLandmarkType.rightWrist, rightPaint);

    //Draw Body
    tool.paintLine(PoseLandmarkType.leftShoulder, PoseLandmarkType.leftHip, leftPaint);
    tool.paintLine(PoseLandmarkType.rightShoulder, PoseLandmarkType.rightHip, rightPaint);

    final angle1 = tool.getAngle(PoseLandmarkType.leftElbow, PoseLandmarkType.leftShoulder, PoseLandmarkType.leftWrist);
    final angle2 =
        tool.getAngle(PoseLandmarkType.rightElbow, PoseLandmarkType.rightShoulder, PoseLandmarkType.rightWrist);

    final validationAngle1 = (angle1 < 120 && angle1 > 30) || (angle1 > 240 && angle1 < 290);
    final validationAngle2 = (angle2 > 30 && angle2 < 120) || (angle2 < 290 && angle2 > 240);

    //Draw Angles
    tool.paintAngle(PoseLandmarkType.leftElbow, angle1, validationAngle1 ? Colors.green : Colors.red);
    tool.paintAngle(PoseLandmarkType.rightElbow, angle2, validationAngle2 ? Colors.green : Colors.red);
    //Draw legs
    tool.paintLine(PoseLandmarkType.leftHip, PoseLandmarkType.leftKnee, leftPaint);
    tool.paintLine(PoseLandmarkType.leftKnee, PoseLandmarkType.leftAnkle, leftPaint);
    tool.paintLine(PoseLandmarkType.rightHip, PoseLandmarkType.rightKnee, rightPaint);
    tool.paintLine(PoseLandmarkType.rightKnee, PoseLandmarkType.rightAnkle, rightPaint);

    tool.paintDescription([' \n${angle1.toStringAsFixed(2)}', ' \n${angle2.toStringAsFixed(2)}']);
  },
);

final Exercise sideLeftBridge = Exercise(
  name: 'Side Left Bridge',
  time: const Duration(seconds: 30),
  toPaint: (canvas, size, pose, imageSize, rotation, cameraLensDirection) {
    final leftPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..color = Colors.yellow;
    final rightPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..color = Colors.blueAccent;
    final tool = ExerciseTools(
      canvas,
      size: size,
      pose: pose,
      imageSize: imageSize,
      rotation: rotation,
      cameraLensDirection: cameraLensDirection,
    );

    //Draw arms
    tool.paintLine(PoseLandmarkType.leftShoulder, PoseLandmarkType.leftElbow, leftPaint);
    tool.paintLine(PoseLandmarkType.leftElbow, PoseLandmarkType.leftWrist, leftPaint);
    tool.paintLine(PoseLandmarkType.rightShoulder, PoseLandmarkType.rightElbow, rightPaint);
    tool.paintLine(PoseLandmarkType.rightElbow, PoseLandmarkType.rightWrist, rightPaint);

    //Draw Body
    tool.paintLine(PoseLandmarkType.leftShoulder, PoseLandmarkType.leftHip, leftPaint);
    tool.paintLine(PoseLandmarkType.rightShoulder, PoseLandmarkType.rightHip, rightPaint);

    final angle0 = tool.getAngle(PoseLandmarkType.leftElbow, PoseLandmarkType.leftShoulder, PoseLandmarkType.leftWrist);
    final angle1 = tool.getAngle(PoseLandmarkType.leftHip, PoseLandmarkType.leftShoulder, PoseLandmarkType.leftKnee);
    final angle2 = tool.getAngle(PoseLandmarkType.rightHip, PoseLandmarkType.rightShoulder, PoseLandmarkType.rightKnee);
    final distance1 = tool.getDistance(PoseLandmarkType.leftShoulder, PoseLandmarkType.leftElbow);
    final distance2 = tool.getDistance(PoseLandmarkType.leftElbow, PoseLandmarkType.leftWrist);

    final validationAngle1 = angle0 > 300 || angle0 < 60;
    final validationAngle2 = angle1 > 320 || angle1 < 40;
    final validationAngle3 = angle2 > 320 || angle2 < 40;

    tool.paintAngle(PoseLandmarkType.leftElbow, angle0, validationAngle1 ? Colors.green : Colors.red);
    tool.paintAngle(PoseLandmarkType.leftHip, angle1, validationAngle2 ? Colors.green : Colors.red);
    tool.paintAngle(PoseLandmarkType.rightHip, angle2, validationAngle3 ? Colors.green : Colors.red);

    //Draw legs
    tool.paintLine(PoseLandmarkType.leftHip, PoseLandmarkType.leftKnee, leftPaint);
    tool.paintLine(PoseLandmarkType.leftKnee, PoseLandmarkType.leftAnkle, leftPaint);
    tool.paintLine(PoseLandmarkType.rightHip, PoseLandmarkType.rightKnee, rightPaint);
    tool.paintLine(PoseLandmarkType.rightKnee, PoseLandmarkType.rightAnkle, rightPaint);

    tool.paintDescription([
      ' \n${angle0.toStringAsFixed(2)}',
      ' \n${angle1.toStringAsFixed(2)}',
      ' \n${angle2.toStringAsFixed(2)}',
      ' \nDistance1: ${distance1.toStringAsFixed(2)}',
      ' \nDistance2: ${distance2.toStringAsFixed(2)}',
    ]);
  },
);

final Exercise sideRightBridge = Exercise(
  name: 'Side Right Bridge',
  time: const Duration(seconds: 30),
  toPaint: (canvas, size, pose, imageSize, rotation, cameraLensDirection) {
    final leftPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..color = Colors.yellow;
    final rightPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..color = Colors.blueAccent;
    final tool = ExerciseTools(
      canvas,
      size: size,
      pose: pose,
      imageSize: imageSize,
      rotation: rotation,
      cameraLensDirection: cameraLensDirection,
    );

    //Draw arms
    tool.paintLine(PoseLandmarkType.leftShoulder, PoseLandmarkType.leftElbow, leftPaint);
    tool.paintLine(PoseLandmarkType.leftElbow, PoseLandmarkType.leftWrist, leftPaint);
    tool.paintLine(PoseLandmarkType.rightShoulder, PoseLandmarkType.rightElbow, rightPaint);
    tool.paintLine(PoseLandmarkType.rightElbow, PoseLandmarkType.rightWrist, rightPaint);

    //Draw Body
    tool.paintLine(PoseLandmarkType.leftShoulder, PoseLandmarkType.leftHip, leftPaint);
    tool.paintLine(PoseLandmarkType.rightShoulder, PoseLandmarkType.rightHip, rightPaint);

    final angle1 = tool.getAngle(PoseLandmarkType.leftElbow, PoseLandmarkType.leftShoulder, PoseLandmarkType.leftWrist);
    final angle2 =
        tool.getAngle(PoseLandmarkType.rightElbow, PoseLandmarkType.rightShoulder, PoseLandmarkType.rightWrist);

    final validationAngle1 = (angle1 < 120 && angle1 > 30) || (angle1 > 240 && angle1 < 290);
    final validationAngle2 = (angle2 > 30 && angle2 < 120) || (angle2 < 290 && angle2 > 240);

    tool.paintAngle(PoseLandmarkType.leftElbow, angle1, validationAngle1 ? Colors.green : Colors.red);
    tool.paintAngle(PoseLandmarkType.rightElbow, angle2, validationAngle2 ? Colors.green : Colors.red);

    //Draw legs
    tool.paintLine(PoseLandmarkType.leftHip, PoseLandmarkType.leftKnee, leftPaint);
    tool.paintLine(PoseLandmarkType.leftKnee, PoseLandmarkType.leftAnkle, leftPaint);
    tool.paintLine(PoseLandmarkType.rightHip, PoseLandmarkType.rightKnee, rightPaint);
    tool.paintLine(PoseLandmarkType.rightKnee, PoseLandmarkType.rightAnkle, rightPaint);

    tool.paintDescription([' \n${angle1.toStringAsFixed(2)}', ' \n${angle2.toStringAsFixed(2)}']);
  },
);

final Exercise dBridge = Exercise(
  name: 'Proob 1.0',
  time: const Duration(seconds: 10),
  toPaint: (canvas, size, pose, imageSize, rotation, cameraLensDirection) {
    final leftPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..color = Colors.yellow;
    final rightPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..color = Colors.blueAccent;
    final tool = ExerciseTools(
      canvas,
      size: size,
      pose: pose,
      imageSize: imageSize,
      rotation: rotation,
      cameraLensDirection: cameraLensDirection,
    );

    //Draw arms
    tool.paintLine(PoseLandmarkType.leftShoulder, PoseLandmarkType.leftElbow, leftPaint);
    tool.paintLine(PoseLandmarkType.leftElbow, PoseLandmarkType.leftWrist, leftPaint);
    tool.paintLine(PoseLandmarkType.rightShoulder, PoseLandmarkType.rightElbow, rightPaint);
    tool.paintLine(PoseLandmarkType.rightElbow, PoseLandmarkType.rightWrist, rightPaint);

    //Draw Body
    tool.paintLine(PoseLandmarkType.leftShoulder, PoseLandmarkType.leftHip, leftPaint);
    tool.paintLine(PoseLandmarkType.rightShoulder, PoseLandmarkType.rightHip, rightPaint);

    final angle1 = tool.getAngle(PoseLandmarkType.leftElbow, PoseLandmarkType.leftShoulder, PoseLandmarkType.leftWrist);
    final angle2 =
        tool.getAngle(PoseLandmarkType.rightElbow, PoseLandmarkType.rightShoulder, PoseLandmarkType.rightWrist);

    final validationAngle1 = (angle1 < 120 && angle1 > 30) || (angle1 > 240 && angle1 < 290);
    final validationAngle2 = (angle2 > 30 && angle2 < 120) || (angle2 < 290 && angle2 > 240);

    tool.paintAngle(PoseLandmarkType.leftElbow, angle1, validationAngle1 ? Colors.green : Colors.red);
    tool.paintAngle(PoseLandmarkType.rightElbow, angle2, validationAngle2 ? Colors.green : Colors.red);

    //Draw legs
    tool.paintLine(PoseLandmarkType.leftHip, PoseLandmarkType.leftKnee, leftPaint);
    tool.paintLine(PoseLandmarkType.leftKnee, PoseLandmarkType.leftAnkle, leftPaint);
    tool.paintLine(PoseLandmarkType.rightHip, PoseLandmarkType.rightKnee, rightPaint);
    tool.paintLine(PoseLandmarkType.rightKnee, PoseLandmarkType.rightAnkle, rightPaint);

    tool.paintDescription([' \n${angle1.toStringAsFixed(2)}', ' \n${angle2.toStringAsFixed(2)}']);
  },
);

final Exercise cBridge = Exercise(
  name: 'Proob 2.0',
  time: const Duration(seconds: 10),
  toPaint: (canvas, size, pose, imageSize, rotation, cameraLensDirection) {
    final leftPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..color = Colors.yellow;
    final rightPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..color = Colors.blueAccent;
    final tool = ExerciseTools(
      canvas,
      size: size,
      pose: pose,
      imageSize: imageSize,
      rotation: rotation,
      cameraLensDirection: cameraLensDirection,
    );

    //Draw arms
    tool.paintLine(PoseLandmarkType.leftShoulder, PoseLandmarkType.leftElbow, leftPaint);
    tool.paintLine(PoseLandmarkType.leftElbow, PoseLandmarkType.leftWrist, leftPaint);
    tool.paintLine(PoseLandmarkType.rightShoulder, PoseLandmarkType.rightElbow, rightPaint);
    tool.paintLine(PoseLandmarkType.rightElbow, PoseLandmarkType.rightWrist, rightPaint);

    //Draw Body
    tool.paintLine(PoseLandmarkType.leftShoulder, PoseLandmarkType.leftHip, leftPaint);
    tool.paintLine(PoseLandmarkType.rightShoulder, PoseLandmarkType.rightHip, rightPaint);

    final angle1 = tool.getAngle(PoseLandmarkType.leftElbow, PoseLandmarkType.leftShoulder, PoseLandmarkType.leftWrist);
    final angle2 =
        tool.getAngle(PoseLandmarkType.rightElbow, PoseLandmarkType.rightShoulder, PoseLandmarkType.rightWrist);

    final validationAngle1 = (angle1 < 120 && angle1 > 30) || (angle1 > 240 && angle1 < 290);
    final validationAngle2 = (angle2 > 30 && angle2 < 120) || (angle2 < 290 && angle2 > 240);

    tool.paintAngle(PoseLandmarkType.leftElbow, angle1, validationAngle1 ? Colors.green : Colors.red);
    tool.paintAngle(PoseLandmarkType.rightElbow, angle2, validationAngle2 ? Colors.green : Colors.red);

    //Draw legs
    tool.paintLine(PoseLandmarkType.leftHip, PoseLandmarkType.leftKnee, leftPaint);
    tool.paintLine(PoseLandmarkType.leftKnee, PoseLandmarkType.leftAnkle, leftPaint);
    tool.paintLine(PoseLandmarkType.rightHip, PoseLandmarkType.rightKnee, rightPaint);
    tool.paintLine(PoseLandmarkType.rightKnee, PoseLandmarkType.rightAnkle, rightPaint);

    tool.paintDescription([' \n${angle1.toStringAsFixed(2)}', ' \n${angle2.toStringAsFixed(2)}']);
  },
);
