import 'package:app_position/features/models/exercise.dart';
import 'package:app_position/features/models/tools.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

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
    final angle2 = tool.getAngle(PoseLandmarkType.rightElbow, PoseLandmarkType.rightShoulder, PoseLandmarkType.rightWrist);

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

final Exercise sideRightBridge = Exercise(
  name: 'Side Right Bridge',
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
    final angle2 = tool.getAngle(PoseLandmarkType.rightElbow, PoseLandmarkType.rightShoulder, PoseLandmarkType.rightWrist);

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