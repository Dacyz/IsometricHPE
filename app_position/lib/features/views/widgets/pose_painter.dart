import 'package:camera/camera.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

import 'coordinates_translator.dart';

class Exercise {
  final String name;
  final Function(Canvas canvas, Size size, List<Pose> poses, Size imageSize, InputImageRotation rotation,
      CameraLensDirection cameraLensDirection) toPaint;

  const Exercise({
    required this.name,
    required this.toPaint,
  });
}

final Exercise fullBrigde = Exercise(
  name: 'Side Bridge',
  toPaint: (canvas, size, poses, imageSize, rotation, cameraLensDirection) {
    final leftPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..color = Colors.yellow;
    final rightPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..color = Colors.blueAccent;

    for (final pose in poses) {
      double paintAngle(PoseLandmarkType type1, PoseLandmarkType type2, PoseLandmarkType type3) {
        final PoseLandmark joint1 = pose.landmarks[type1]!;
        final middlePoint = Offset(
            translateX(
              joint1.x,
              size,
              imageSize,
              rotation,
              cameraLensDirection,
            ),
            translateY(
              joint1.y,
              size,
              imageSize,
              rotation,
              cameraLensDirection,
            ));
        final PoseLandmark joint2 = pose.landmarks[type2]!;
        final startPoint = Offset(
            translateX(
              joint2.x,
              size,
              imageSize,
              rotation,
              cameraLensDirection,
            ),
            translateY(
              joint2.y,
              size,
              imageSize,
              rotation,
              cameraLensDirection,
            ));
        final PoseLandmark joint3 = pose.landmarks[type3]!;
        final endPoint = Offset(
            translateX(
              joint3.x,
              size,
              imageSize,
              rotation,
              cameraLensDirection,
            ),
            translateY(
              joint3.y,
              size,
              imageSize,
              rotation,
              cameraLensDirection,
            ));
        final angle = calcularAnguloEntreTresPuntos(startPoint, middlePoint, endPoint);
        TextSpan span = TextSpan(
            style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w800),
            text: '\n${angle.toStringAsFixed(2)}');
        TextPainter tp = TextPainter(
          text: span,
          textAlign: TextAlign.left,
          textDirection: TextDirection.ltr,
        );
        tp.layout();
        tp.paint(
          canvas,
          middlePoint,
        );
        tp.paint(canvas, Offset(16, 16));
        return angle;
      }

      void paintLine(PoseLandmarkType type1, PoseLandmarkType type2, Paint paintType) {
        final PoseLandmark joint1 = pose.landmarks[type1]!;
        final PoseLandmark joint2 = pose.landmarks[type2]!;
        canvas.drawLine(
            Offset(
                translateX(
                  joint1.x,
                  size,
                  imageSize,
                  rotation,
                  cameraLensDirection,
                ),
                translateY(
                  joint1.y,
                  size,
                  imageSize,
                  rotation,
                  cameraLensDirection,
                )),
            Offset(
                translateX(
                  joint2.x,
                  size,
                  imageSize,
                  rotation,
                  cameraLensDirection,
                ),
                translateY(
                  joint2.y,
                  size,
                  imageSize,
                  rotation,
                  cameraLensDirection,
                )),
            paintType);
      }

      //Draw arms
      paintLine(PoseLandmarkType.leftShoulder, PoseLandmarkType.leftElbow, leftPaint);
      paintLine(PoseLandmarkType.leftElbow, PoseLandmarkType.leftWrist, leftPaint);
      paintLine(PoseLandmarkType.rightShoulder, PoseLandmarkType.rightElbow, rightPaint);
      paintLine(PoseLandmarkType.rightElbow, PoseLandmarkType.rightWrist, rightPaint);

      //Draw Body
      paintLine(PoseLandmarkType.leftShoulder, PoseLandmarkType.leftHip, leftPaint);
      paintLine(PoseLandmarkType.rightShoulder, PoseLandmarkType.rightHip, rightPaint);

      final angle1 = paintAngle(PoseLandmarkType.leftElbow, PoseLandmarkType.leftShoulder, PoseLandmarkType.leftWrist);
      final angle2 =
          paintAngle(PoseLandmarkType.rightElbow, PoseLandmarkType.rightShoulder, PoseLandmarkType.rightWrist);

      final correct = angle1 < 90 && angle2 > 90;
      TextPainter tp2 = TextPainter(
        text: TextSpan(
            style: TextStyle(color: correct ? Colors.green : Colors.red, fontWeight: FontWeight.w800),
            text: '\n${correct ? 'correcto' : 'incorrecto'}'),
        textAlign: TextAlign.left,
        textDirection: TextDirection.ltr,
      );
      tp2.layout();
      tp2.paint(canvas, Offset(size.width * 0.5, size.height * 0.5));
      //Draw legs
      paintLine(PoseLandmarkType.leftHip, PoseLandmarkType.leftKnee, leftPaint);
      paintLine(PoseLandmarkType.leftKnee, PoseLandmarkType.leftAnkle, leftPaint);
      paintLine(PoseLandmarkType.rightHip, PoseLandmarkType.rightKnee, rightPaint);
      paintLine(PoseLandmarkType.rightKnee, PoseLandmarkType.rightAnkle, rightPaint);
    }
  },
);

final List<Exercise> listExercises = [
  fullBrigde,

];

class PosePainter extends CustomPainter {
  PosePainter(
    this.poses,
    this.imageSize,
    this.rotation,
    this.cameraLensDirection,
  );

  final List<Pose> poses;
  final Size imageSize;
  final InputImageRotation rotation;
  final CameraLensDirection cameraLensDirection;

  @override
  void paint(Canvas canvas, Size size) {
    fullBrigde.toPaint(canvas, size, poses, imageSize, rotation, cameraLensDirection);
  }

  @override
  bool shouldRepaint(covariant PosePainter oldDelegate) {
    return oldDelegate.imageSize != imageSize || oldDelegate.poses != poses;
  }
}

double calcularAnguloEntreTresPuntos(Offset puntoA, Offset puntoB, Offset puntoC) {
  // Calcular los vectores AB y BC
  Offset vectorAB = Offset(puntoB.dx - puntoA.dx, puntoB.dy - puntoA.dy);
  Offset vectorBC = Offset(puntoC.dx - puntoB.dx, puntoC.dy - puntoB.dy);

  // Calcular los ángulos en radianes usando atan2
  double anguloAB = atan2(vectorAB.dy, vectorAB.dx);
  double anguloBC = atan2(vectorBC.dy, vectorBC.dx);

  // Calcular la diferencia de ángulos
  double diferenciaAngulos = anguloBC - anguloAB;

  // Asegurarse de que la diferencia esté en el rango [0, 2*pi)
  if (diferenciaAngulos < 0) {
    diferenciaAngulos += 2 * pi;
  }

  // Convertir el ángulo a grados si es necesario
  double anguloEnGrados = (diferenciaAngulos * 180) / pi;

  return anguloEnGrados;
}
