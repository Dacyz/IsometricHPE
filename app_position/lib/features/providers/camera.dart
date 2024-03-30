import 'dart:io';

import 'package:app_position/features/models/exercise.dart';
import 'package:app_position/features/models/tools.dart';
import 'package:app_position/features/models/helper.dart';
import 'package:app_position/features/views/widgets/pose_painter.dart';
import 'package:wakelock/wakelock.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

    void paintAngle(PoseLandmarkType point, double angle, [Color color = Colors.green]) {
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

    //Draw arms
    paintLine(PoseLandmarkType.leftShoulder, PoseLandmarkType.leftElbow, leftPaint);
    paintLine(PoseLandmarkType.leftElbow, PoseLandmarkType.leftWrist, leftPaint);
    paintLine(PoseLandmarkType.rightShoulder, PoseLandmarkType.rightElbow, rightPaint);
    paintLine(PoseLandmarkType.rightElbow, PoseLandmarkType.rightWrist, rightPaint);

    //Draw Body
    paintLine(PoseLandmarkType.leftShoulder, PoseLandmarkType.leftHip, leftPaint);
    paintLine(PoseLandmarkType.rightShoulder, PoseLandmarkType.rightHip, rightPaint);

    final angle1 = getAngle(PoseLandmarkType.leftElbow, PoseLandmarkType.leftShoulder, PoseLandmarkType.leftWrist);
    final angle2 = getAngle(PoseLandmarkType.rightElbow, PoseLandmarkType.rightShoulder, PoseLandmarkType.rightWrist);

    final validationAngle1 = (angle1 < 120 && angle1 > 30) || (angle1 > 240 && angle1 < 290);
    final validationAngle2 = (angle2 > 30 && angle2 < 120) || (angle2 < 290 && angle2 > 240);

    paintAngle(PoseLandmarkType.leftElbow, angle1, validationAngle1 ? Colors.green : Colors.red);
    paintAngle(PoseLandmarkType.rightElbow, angle2, validationAngle2 ? Colors.green : Colors.red);

    TextPainter tp2 = TextPainter(
      text: TextSpan(text: 'Ángulos:', children: [
        TextSpan(
          text: ' \n${angle1.toStringAsFixed(2)}',
          style: TextStyle(color: validationAngle1 ? Colors.green : Colors.red, fontWeight: FontWeight.w800),
        ),
        TextSpan(
          text: ' \n${angle2.toStringAsFixed(2)}',
          style: TextStyle(color: validationAngle2 ? Colors.green : Colors.red, fontWeight: FontWeight.w800),
        ),
      ]),
      textAlign: TextAlign.left,
      textDirection: TextDirection.ltr,
    );
    tp2.layout();
    tp2.paint(canvas, Offset(size.width * 0.2, size.height * 0.3));
    //Draw legs
    paintLine(PoseLandmarkType.leftHip, PoseLandmarkType.leftKnee, leftPaint);
    paintLine(PoseLandmarkType.leftKnee, PoseLandmarkType.leftAnkle, leftPaint);
    paintLine(PoseLandmarkType.rightHip, PoseLandmarkType.rightKnee, rightPaint);
    paintLine(PoseLandmarkType.rightKnee, PoseLandmarkType.rightAnkle, rightPaint);
  },
);

class Camera extends ChangeNotifier {
  var initialCameraLensDirection = CameraLensDirection.back;
  List<CameraDescription> cameras = [];
  final List<Exercise> listExercises = [
    fullBridge,
    sideLeftBridge,
  ];
  late Exercise currentExercise = listExercises.first;
  CameraController? controller;
  int cameraIndex = -1;
  bool changingCameraLens = false;

  Future<void> initCameras() async {
    if (cameras.isEmpty) {
      cameras = await availableCameras();
    }
  }

  final PoseDetector _poseDetector = PoseDetector(options: PoseDetectorOptions(model: PoseDetectionModel.base));

  bool _canProcess = true;
  bool _isBusy = false;
  CustomPaint? customPaint;

  void disposeCameras() {
    _canProcess = false;
    _poseDetector.close();
  }

  Future<void> _processImage(InputImage inputImage) async {
    if (!_canProcess) return;
    if (_isBusy) return;
    _isBusy = true;
    notifyListeners();
    await _paintLines(inputImage);
    _isBusy = false;
    notifyListeners();
  }

  Future<void> _paintLines(InputImage inputImage) async {
    final poses = await _poseDetector.processImage(inputImage);
    if (poses.isEmpty || inputImage.metadata?.size == null || inputImage.metadata?.rotation == null) {
      customPaint = null;
      return;
    }
    customPaint = CustomPaint(
      painter: PosePainter(
        poses.first,
        inputImage.metadata!.size,
        inputImage.metadata!.rotation,
        initialCameraLensDirection,
        currentExercise,
      ),
    );
  }

  void initialize() async {
    await initCameras();
    Wakelock.enable();
    for (var i = 0; i < cameras.length; i++) {
      if (cameras[i].lensDirection == initialCameraLensDirection) {
        cameraIndex = i;
        notifyListeners();
        break;
      }
    }
    if (cameraIndex != -1) {
      await startLiveFeed();
    }
    notifyListeners();
  }

  Future startLiveFeed() async {
    final camera = cameras[cameraIndex];
    controller = CameraController(
      camera,
      // Set to ResolutionPreset.high. Do NOT set it to ResolutionPreset.max because for some phones does NOT work.
      ResolutionPreset.low,
      enableAudio: false,
      imageFormatGroup: Platform.isAndroid ? ImageFormatGroup.nv21 : ImageFormatGroup.bgra8888,
    );
    if (controller == null) return;
    await controller?.initialize();
    await controller?.startImageStream(_processCameraImage);
    notifyListeners();
  }

  Future stopLiveFeed() async {
    await controller?.stopImageStream();
    // await controller?.dispose();
    // controller = null;
  }

  Future switchLiveCamera() async {
    changingCameraLens = true;
    notifyListeners();
    cameraIndex = (cameraIndex + 1) % cameras.length;

    await stopLiveFeed();
    await startLiveFeed();
    changingCameraLens = false;
    notifyListeners();
  }

  void _processCameraImage(CameraImage image) {
    final inputImage = _inputImageFromCameraImage(image);
    if (inputImage == null) return;
    _processImage(inputImage);
  }

  final _orientations = {
    DeviceOrientation.portraitUp: 0,
    DeviceOrientation.landscapeLeft: 90,
    DeviceOrientation.portraitDown: 180,
    DeviceOrientation.landscapeRight: 270,
  };

  InputImage? _inputImageFromCameraImage(CameraImage image) {
    if (controller == null) return null;

    // get image rotation
    // it is used in android to convert the InputImage from Dart to Java: https://github.com/flutter-ml/google_ml_kit_flutter/blob/master/packages/google_mlkit_commons/android/src/main/java/com/google_mlkit_commons/InputImageConverter.java
    // `rotation` is not used in iOS to convert the InputImage from Dart to Obj-C: https://github.com/flutter-ml/google_ml_kit_flutter/blob/master/packages/google_mlkit_commons/ios/Classes/MLKVisionImage%2BFlutterPlugin.m
    // in both platforms `rotation` and `camera.lensDirection` can be used to compensate `x` and `y` coordinates on a canvas: https://github.com/flutter-ml/google_ml_kit_flutter/blob/master/packages/example/lib/vision_detector_views/painters/coordinates_translator.dart
    final camera = cameras[cameraIndex];
    final sensorOrientation = camera.sensorOrientation;
    // print(
    //     'lensDirection: ${camera.lensDirection}, sensorOrientation: $sensorOrientation, ${_controller?.value.deviceOrientation} ${_controller?.value.lockedCaptureOrientation} ${_controller?.value.isCaptureOrientationLocked}');
    InputImageRotation? rotation;
    if (Platform.isIOS) {
      rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
    } else if (Platform.isAndroid) {
      var rotationCompensation = _orientations[controller!.value.deviceOrientation];
      if (rotationCompensation == null) return null;
      if (camera.lensDirection == CameraLensDirection.front) {
        // front-facing
        rotationCompensation = (sensorOrientation + rotationCompensation) % 360;
      } else {
        // back-facing
        rotationCompensation = (sensorOrientation - rotationCompensation + 360) % 360;
      }
      rotation = InputImageRotationValue.fromRawValue(rotationCompensation);
      // print('rotationCompensation: $rotationCompensation');
    }
    if (rotation == null) return null;
    // print('final rotation: $rotation');

    // get image format
    final format = InputImageFormatValue.fromRawValue(image.format.raw);
    // validate format depending on platform
    // only supported formats:
    // * nv21 for Android
    // * bgra8888 for iOS
    if (format == null ||
        (Platform.isAndroid && format != InputImageFormat.nv21) ||
        (Platform.isIOS && format != InputImageFormat.bgra8888)) return null;

    // since format is constraint to nv21 or bgra8888, both only have one plane
    if (image.planes.length != 1) return null;
    final plane = image.planes.first;

    // compose InputImage using bytes
    return InputImage.fromBytes(
      bytes: plane.bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation, // used only in Android
        format: format, // used only in iOS
        bytesPerRow: plane.bytesPerRow, // used only in iOS
      ),
    );
  }
}
