import 'package:app_position/features/models/exercise/exercise.dart';
import 'package:app_position/features/models/tools.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

final List<Exercise> data = [
  lowPlankIsometric,
  sideLeftBridge,
  sideRightBridge,
  dBridge,
  cBridge,
];

final Exercise lowPlankIsometric = Exercise(
  name: 'Plancha',
  time: const Duration(seconds: 60),
  toPaint: (canvas, size, pose, imageSize, rotation, cameraLensDirection) {
    final leftPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..color = Colors.green;
    final rightPaint = leftPaint;
    final wrongPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..color = Colors.redAccent;

    final tool = ExerciseTools(
      canvas,
      size: size,
      pose: pose,
      imageSize: imageSize,
      rotation: rotation,
      cameraLensDirection: cameraLensDirection,
    );

    final direction = tool.isLookingRight();

    final angle1 = tool.getAngle(PoseLandmarkType.leftElbow, PoseLandmarkType.leftShoulder, PoseLandmarkType.leftWrist);
    final angle2 =
        tool.getAngle(PoseLandmarkType.rightElbow, PoseLandmarkType.rightShoulder, PoseLandmarkType.rightWrist);
    final angle0 = tool.getAngleToFloor(PoseLandmarkType.leftShoulder, PoseLandmarkType.leftHip);
    final angle3 = tool.getAngleToFloor(PoseLandmarkType.rightShoulder, PoseLandmarkType.rightHip);

    final validationAngle1 = (angle1 < 120 && angle1 > 30) || (angle1 > 240 && angle1 < 290);
    final validationAngle2 = (angle2 > 30 && angle2 < 120) || (angle2 < 290 && angle2 > 240);
    final validationFloor = (angle0 >= 260 && angle0 <= 280) && (angle3 >= 260 && angle3 <= 280) ||
        (angle0 >= 85 && angle0 <= 100) && (angle3 >= 85 && angle3 <= 100);

    //Draw arms
    tool.paintLine(
        PoseLandmarkType.leftShoulder, PoseLandmarkType.leftElbow, validationAngle1 ? leftPaint : wrongPaint);
    tool.paintLine(PoseLandmarkType.leftElbow, PoseLandmarkType.leftWrist, validationAngle1 ? leftPaint : wrongPaint);
    tool.paintLine(
        PoseLandmarkType.rightShoulder, PoseLandmarkType.rightElbow, validationAngle2 ? rightPaint : wrongPaint);
    tool.paintLine(
        PoseLandmarkType.rightElbow, PoseLandmarkType.rightWrist, validationAngle2 ? rightPaint : wrongPaint);

    //Draw Body
    tool.paintLine(PoseLandmarkType.leftShoulder, PoseLandmarkType.leftHip, validationFloor ? leftPaint : wrongPaint);
    tool.paintLine(
        PoseLandmarkType.rightShoulder, PoseLandmarkType.rightHip, validationFloor ? rightPaint : wrongPaint);

    //Draw Angles
    tool.paintAngle(PoseLandmarkType.leftElbow, angle1, validationAngle1 ? Colors.green : Colors.red);
    tool.paintAngle(PoseLandmarkType.rightElbow, angle2, validationAngle2 ? Colors.green : Colors.red);
    //Draw legs
    tool.paintLine(PoseLandmarkType.leftHip, PoseLandmarkType.leftKnee, leftPaint);
    tool.paintLine(PoseLandmarkType.leftKnee, PoseLandmarkType.leftAnkle, leftPaint);
    tool.paintLine(PoseLandmarkType.rightHip, PoseLandmarkType.rightKnee, rightPaint);
    tool.paintLine(PoseLandmarkType.rightKnee, PoseLandmarkType.rightAnkle, rightPaint);
    String value = '';
    if (!validationFloor) {
      value = '${angle0.toStringAsFixed(2)} ${angle3.toStringAsFixed(2)} ';
      final diff = angle0 - angle3;
      if (diff.abs() >= 10) {
        value = 'Tu cuerpo no esta recto';
      } else {
        final caderaPosition = direction ? angle0 < 260 : angle0 >= 85;
        if (caderaPosition) {
          value = 'Eleva tu cadera';
        } else {
          value = 'Baja tu cadera';
        }
      }
    }
    if (!validationAngle1 && !validationAngle2) {
      value = 'Tus brazos no esta correctamente ubicados';
    } else {
      if (!validationAngle1) {
        value = 'Tu brazo izquierdo no esta correctamente ubicado';
      }
      if (!validationAngle2) {
        value = 'Tu brazo derecho no esta correctamente ubicado';
      }
    }

    tool.paintDescription([
      ' \n Resultado: $value',
      ' \n Mirando: ${direction ? 'Derecha' : 'Izquierda'}',
      ' \n Hombro Izquierda: ${angle0.toStringAsFixed(2)}',
      ' \n Hombro Derecha: ${angle3.toStringAsFixed(2)}',
      ' \n Brazo Izquierdo: ${angle1.toStringAsFixed(2)}',
      ' \n Brazo Derecho: ${angle2.toStringAsFixed(2)}',
    ]);
    return value;
  },
);

final Exercise sideLeftBridge = Exercise(
  name: 'Puente lateral izquierdo',
  time: const Duration(seconds: 30),
  toPaint: (canvas, size, pose, imageSize, rotation, cameraLensDirection) {
    final tool = ExerciseTools(
      canvas,
      size: size,
      pose: pose,
      imageSize: imageSize,
      rotation: rotation,
      cameraLensDirection: cameraLensDirection,
    );

    final direction = tool.isLookingRight();
    String value = '';
    final angleHip = direction
        ? tool.getAngle(PoseLandmarkType.leftHip, PoseLandmarkType.leftShoulder, PoseLandmarkType.leftKnee)
        : tool.getAngle(PoseLandmarkType.rightHip, PoseLandmarkType.rightShoulder, PoseLandmarkType.rightKnee);
    final angleShoulder =
        tool.getAngle(PoseLandmarkType.leftShoulder, PoseLandmarkType.leftHip, PoseLandmarkType.leftElbow);
    final angleFloor = direction
        ? tool.getAngleToFloor(PoseLandmarkType.leftHip, PoseLandmarkType.leftShoulder)
        : tool.getAngleToFloor(PoseLandmarkType.rightHip, PoseLandmarkType.rightShoulder);
    var distanceEyes = tool.calculateDistance(PoseLandmarkType.leftEye, PoseLandmarkType.rightEye);
    distanceEyes = distanceEyes <= 0 ? 0.1 : distanceEyes;
    final distanceShoulders = tool.calculateDistance(PoseLandmarkType.leftShoulder, PoseLandmarkType.rightShoulder);
    final wa = distanceShoulders ~/ distanceEyes;
    final validationAngleHip = angleHip > 350 || angleHip < 10;
    final validationShoulders = wa <= 7;
    final validationFloor = angleFloor > 275 && angleFloor < 300;
    final validationBrazo = angleShoulder > 80 && angleShoulder < 110;
    if (!validationAngleHip || !validationShoulders || !validationFloor || !validationBrazo) {
      if (!validationBrazo) {
        value = 'Centra tu brazo';
      }
      if (angleHip >= 10) {
        value = 'Endereza la cadera';
      } else {
        value = 'Baja la cadera';
      }
      if (!validationShoulders || !validationFloor) {
        value = 'Corrige tu postura';
      }
    }
    final wrongPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..color = Colors.redAccent;
    final rightPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..color = Colors.green;
    final paint = value == 'Corrige tu postura' ? wrongPaint : rightPaint;

    tool.paintAngle(PoseLandmarkType.leftShoulder, angleShoulder, validationBrazo ? Colors.green : Colors.red);

    //Draw arms
    tool.paintLine(PoseLandmarkType.leftShoulder, PoseLandmarkType.leftElbow, paint);
    tool.paintLine(PoseLandmarkType.leftElbow, PoseLandmarkType.leftWrist, paint);
    tool.paintLine(PoseLandmarkType.rightShoulder, PoseLandmarkType.rightElbow, paint);
    tool.paintLine(PoseLandmarkType.rightElbow, PoseLandmarkType.rightWrist, paint);

    //Draw Body
    tool.paintLine(PoseLandmarkType.leftShoulder, PoseLandmarkType.leftHip, paint);
    tool.paintLine(PoseLandmarkType.rightShoulder, PoseLandmarkType.rightHip, validationAngleHip ? paint : wrongPaint);

    //Draw legs
    tool.paintLine(PoseLandmarkType.leftHip, PoseLandmarkType.leftKnee, paint);
    tool.paintLine(PoseLandmarkType.leftKnee, PoseLandmarkType.leftAnkle, paint);
    tool.paintLine(PoseLandmarkType.rightHip, PoseLandmarkType.rightKnee, validationAngleHip ? paint : wrongPaint);
    tool.paintLine(PoseLandmarkType.rightKnee, PoseLandmarkType.rightAnkle, paint);

    tool.paintDescription([
      ' \n Resultado: $value',
      ' \n Mirando: ${direction ? 'Derecha' : 'Izquierda'}',
      ' \n Distancia ejecutada: ${wa.toStringAsFixed(2)}',
      ' \n Distancia ojos: ${distanceEyes.toStringAsFixed(2)}',
      ' \n Distancia hombros: ${distanceShoulders.toStringAsFixed(2)}',
      ' \n Angulo cadera: ${angleFloor.toStringAsFixed(2)}',
      ' \n Costado derecho: ${angleHip.toStringAsFixed(2)}',
    ]);

    return value;
  },
);

final Exercise sideRightBridge = Exercise(
  name: 'Puente lateral derecho',
  time: const Duration(seconds: 30),
  toPaint: (canvas, size, pose, imageSize, rotation, cameraLensDirection) {
    final tool = ExerciseTools(
      canvas,
      size: size,
      pose: pose,
      imageSize: imageSize,
      rotation: rotation,
      cameraLensDirection: cameraLensDirection,
    );

    final direction = tool.isLookingRight();
    String value = '';
    final angleShoulder = direction
        ? tool.getAngle(PoseLandmarkType.rightShoulder, PoseLandmarkType.rightElbow, PoseLandmarkType.rightHip)
        : tool.getAngle(PoseLandmarkType.leftHip, PoseLandmarkType.leftShoulder, PoseLandmarkType.leftKnee);
    final angleHip = tool.getAngle(PoseLandmarkType.leftHip, PoseLandmarkType.leftShoulder, PoseLandmarkType.leftKnee);
    final angleFloor = direction
        ? tool.getAngleToFloor(PoseLandmarkType.leftShoulder, PoseLandmarkType.leftHip)
        : tool.getAngleToFloor(PoseLandmarkType.rightShoulder, PoseLandmarkType.rightHip);
    var distanceEyes = tool.calculateDistance(PoseLandmarkType.leftEye, PoseLandmarkType.rightEye);
    distanceEyes = distanceEyes <= 0 ? 0.1 : distanceEyes;
    final distanceShoulders = tool.calculateDistance(PoseLandmarkType.leftShoulder, PoseLandmarkType.rightShoulder);
    final wa = distanceShoulders ~/ distanceEyes;
    final validationAngleHip = angleHip > 350 || angleHip < 10;
    final validationShoulders = wa <= 7;
    final validationFloor = angleFloor > 230 && angleFloor < 270;
    final validationBrazo = angleShoulder > 80 && angleShoulder < 120;
    if (!validationAngleHip || !validationShoulders || !validationFloor || !validationBrazo) {
      if (!validationBrazo) {
        value = 'Centra tu brazo';
      }
      if (angleHip >= 10) {
        value = 'Endereza la cadera';
      } else {
        value = 'Baja la cadera';
      }
      if (!validationShoulders || !validationFloor) {
        value = 'Corrige tu postura';
      }
    }
    final wrongPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..color = Colors.redAccent;
    final rightPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..color = Colors.green;
    final paint = value == 'Corrige tu postura' ? wrongPaint : rightPaint;

    tool.paintAngle(PoseLandmarkType.rightShoulder, angleShoulder, validationBrazo ? Colors.green : Colors.red);

    //Draw arms
    tool.paintLine(PoseLandmarkType.leftShoulder, PoseLandmarkType.leftElbow, paint);
    tool.paintLine(PoseLandmarkType.leftElbow, PoseLandmarkType.leftWrist, paint);
    tool.paintLine(PoseLandmarkType.rightShoulder, PoseLandmarkType.rightElbow, paint);
    tool.paintLine(PoseLandmarkType.rightElbow, PoseLandmarkType.rightWrist, paint);

    //Draw Body
    tool.paintLine(PoseLandmarkType.leftShoulder, PoseLandmarkType.leftHip, validationAngleHip ? paint : wrongPaint);
    tool.paintLine(PoseLandmarkType.rightShoulder, PoseLandmarkType.rightHip, paint);

    //Draw legs
    tool.paintLine(PoseLandmarkType.leftHip, PoseLandmarkType.leftKnee, validationAngleHip ? paint : wrongPaint);
    tool.paintLine(PoseLandmarkType.leftKnee, PoseLandmarkType.leftAnkle, paint);
    tool.paintLine(PoseLandmarkType.rightHip, PoseLandmarkType.rightKnee, paint);
    tool.paintLine(PoseLandmarkType.rightKnee, PoseLandmarkType.rightAnkle, paint);

    tool.paintDescription([
      ' \n Resultado: $value',
      ' \n Mirando: ${direction ? 'Derecha' : 'Izquierda'}',
      ' \n Distancia ejecutada: ${wa.toStringAsFixed(2)}',
      ' \n Distancia ojos: ${distanceEyes.toStringAsFixed(2)}',
      ' \n Distancia hombros: ${distanceShoulders.toStringAsFixed(2)}',
      ' \n Angulo cadera: ${angleFloor.toStringAsFixed(2)}',
      ' \n Costado derecho: ${angleHip.toStringAsFixed(2)}',
    ]);
    return '';
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

    return '';
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

    return '';
  },
);
