import 'dart:math';

import 'package:app_position/features/models/helper.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

class ExerciseTools {
  final Size size;
  final Pose pose;
  final Size imageSize;
  final InputImageRotation rotation;
  final CameraLensDirection cameraLensDirection;
  final Canvas canvas;
  final bool showDescription;

  const ExerciseTools(
    this.canvas, {
    required this.size,
    required this.pose,
    required this.imageSize,
    required this.rotation,
    required this.cameraLensDirection,
    this.showDescription = true,
  });

  double getAngle(PoseLandmarkType middle, PoseLandmarkType start, PoseLandmarkType end) {
    final PoseLandmark joint1 = pose.landmarks[middle]!;
    final middlePoint = poseOffset(
      joint1,
      size,
      imageSize,
      rotation,
      cameraLensDirection,
    );
    final PoseLandmark joint2 = pose.landmarks[start]!;
    final startPoint = poseOffset(
      joint2,
      size,
      imageSize,
      rotation,
      cameraLensDirection,
    );
    final PoseLandmark joint3 = pose.landmarks[end]!;
    final endPoint = poseOffset(
      joint3,
      size,
      imageSize,
      rotation,
      cameraLensDirection,
    );
    return calcularAnguloEntreTresPuntos(startPoint, middlePoint, endPoint);
  }

  double calculateAngle(PoseLandmarkType middle, PoseLandmarkType start, PoseLandmarkType end) {
    final PoseLandmark pointA = pose.landmarks[start]!;
    final PoseLandmark pointB = pose.landmarks[middle]!;
    final PoseLandmark pointC = pose.landmarks[end]!;
    // Calcula los vectores AB y BC
    double ABx = pointB.x - pointA.x;
    double ABy = pointB.y - pointA.y;
    double ABz = pointB.z - pointA.z;

    double BCx = pointC.x - pointB.x;
    double BCy = pointC.y - pointB.y;
    double BCz = pointC.z - pointB.z;

    // Calcula el producto escalar AB · BC
    double dotProduct = ABx * BCx + ABy * BCy + ABz * BCz;

    // Calcula las magnitudes de AB y BC
    double magnitudeAB = sqrt(ABx * ABx + ABy * ABy + ABz * ABz);
    double magnitudeBC = sqrt(BCx * BCx + BCy * BCy + BCz * BCz);

    // Calcula el coseno del ángulo entre AB y BC
    double cosAngle = dotProduct / (magnitudeAB * magnitudeBC);

    // Calcula el ángulo en radianes
    double angleRad = acos(cosAngle);

    // Convierte el ángulo a grados
    double angleDeg = angleRad * (180 / pi);

    return angleDeg;
  }

  bool isLookingRight() {
    final PoseLandmark eye = pose.landmarks[PoseLandmarkType.leftEye]!;
    final knee = pose.landmarks[PoseLandmarkType.rightHeel]!;
    return knee.x > eye.x;
  }

  double getAngleToFloor(PoseLandmarkType middle, PoseLandmarkType start) {
    final PoseLandmark joint1 = pose.landmarks[middle]!;
    final middlePoint = poseOffset(
      joint1,
      size,
      imageSize,
      rotation,
      cameraLensDirection,
    );
    final PoseLandmark joint2 = pose.landmarks[start]!;
    final startPoint = poseOffset(
      joint2,
      size,
      imageSize,
      rotation,
      cameraLensDirection,
    );
    return calcularAnguloEntreTresPuntos(startPoint, middlePoint, Offset(middlePoint.dx, size.height));
  }

  double calculateDistance(PoseLandmarkType start, PoseLandmarkType end) {
    final PoseLandmark point1 = pose.landmarks[start]!;
    final PoseLandmark point2 = pose.landmarks[end]!;
    return sqrt(pow(point2.x - point1.x, 2) + pow(point2.y - point1.y, 2) + pow(point2.z - point1.z, 2));
  }

  double getDistance(PoseLandmarkType start, PoseLandmarkType end) {
    final PoseLandmark joint2 = pose.landmarks[start]!;
    final point1 = poseOffset(
      joint2,
      size,
      imageSize,
      rotation,
      cameraLensDirection,
    );
    final PoseLandmark joint3 = pose.landmarks[end]!;
    final point2 = poseOffset(
      joint3,
      size,
      imageSize,
      rotation,
      cameraLensDirection,
    );
    final double dx = point1.dx - point2.dx;
    final double dy = point1.dy - point2.dy;
    return sqrt(dx * dx + dy * dy);
  }

  double getDistanceToFloor(PoseLandmarkType start) {
    final point1 = poseOffset(
      pose.landmarks[start]!,
      size,
      imageSize,
      rotation,
      cameraLensDirection,
    );
    final point2 = Offset(point1.dx, size.height);
    final double dx = point1.dx - point2.dx;
    final double dy = point1.dy - point2.dy;
    return sqrt(dx * dx + dy * dy);
  }

  void paintAngle(PoseLandmarkType point, double angle, [Color color = Colors.green]) {
    if (!showDescription) return;
    final PoseLandmark joint1 = pose.landmarks[point]!;
    final middlePoint = poseOffset(
      joint1,
      size,
      imageSize,
      rotation,
      cameraLensDirection,
    );
    TextSpan span = TextSpan(
      style: TextStyle(color: color, fontWeight: FontWeight.w800),
      text: '\n${angle.toStringAsFixed(2)}',
    );
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
    tp.paint(canvas, const Offset(16, 16));
  }

  void paintLine(PoseLandmarkType type1, PoseLandmarkType type2, Paint paintType) {
    final PoseLandmark joint1 = pose.landmarks[type1]!;
    final PoseLandmark joint2 = pose.landmarks[type2]!;
    canvas.drawLine(
      poseOffset(
        joint1,
        size,
        imageSize,
        rotation,
        cameraLensDirection,
      ),
      poseOffset(
        joint2,
        size,
        imageSize,
        rotation,
        cameraLensDirection,
      ),
      paintType,
    );
  }

  void paintDescription([List<String> paintDescription = const ['Without description']]) {
    if (!showDescription) return;
    TextPainter tp2 = TextPainter(
      text: TextSpan(
        text: 'Descripción:',
        children: paintDescription
            .map<TextSpan>((e) => TextSpan(
                  text: e,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                  ),
                ))
            .toList(),
      ),
      textAlign: TextAlign.left,
      textDirection: TextDirection.ltr,
    );
    tp2.layout();
    tp2.paint(canvas, const Offset(80, 124));
  }
}
