import 'dart:io';
import 'dart:ui';
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

double translateX(
  double x,
  Size canvasSize,
  Size imageSize,
  InputImageRotation rotation,
  CameraLensDirection cameraLensDirection,
) {
  switch (rotation) {
    case InputImageRotation.rotation90deg:
      return x * canvasSize.width / (Platform.isIOS ? imageSize.width : imageSize.height);
    case InputImageRotation.rotation270deg:
      return canvasSize.width - x * canvasSize.width / (Platform.isIOS ? imageSize.width : imageSize.height);
    case InputImageRotation.rotation0deg:
    case InputImageRotation.rotation180deg:
      switch (cameraLensDirection) {
        case CameraLensDirection.back:
          return x * canvasSize.width / imageSize.width;
        default:
          return canvasSize.width - x * canvasSize.width / imageSize.width;
      }
  }
}

double translateY(
  double y,
  Size canvasSize,
  Size imageSize,
  InputImageRotation rotation,
  CameraLensDirection cameraLensDirection,
) {
  switch (rotation) {
    case InputImageRotation.rotation90deg:
    case InputImageRotation.rotation270deg:
      return y * canvasSize.height / (Platform.isIOS ? imageSize.height : imageSize.width);
    case InputImageRotation.rotation0deg:
    case InputImageRotation.rotation180deg:
      return y * canvasSize.height / imageSize.height;
  }
}

Offset poseOffset(
  PoseLandmark pose,
  Size size,
  Size imageSize,
  InputImageRotation rotation,
  CameraLensDirection direction,
) {
  return Offset(
    translateX(
      pose.x,
      size,
      imageSize,
      rotation,
      direction,
    ),
    translateY(
      pose.y,
      size,
      imageSize,
      rotation,
      direction,
    ),
  );
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
