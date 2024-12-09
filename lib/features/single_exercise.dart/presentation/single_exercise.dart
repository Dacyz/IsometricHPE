import 'dart:async';
import 'dart:io';
import 'package:app_position/features/models/exercise/exercise.dart';
import 'package:app_position/core/models/exercise_provider.dart';
import 'package:app_position/features/views/widgets/pose_painter.dart';
import 'package:app_position/features/voice/presentation/voice_repository.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

class SingleExerciseProvider extends ExerciseInterfaceProvider {
  final VoiceRepository voiceRepository;
  final Exercise currentExercise;
  SingleExerciseProvider(
    this.currentExercise,
    this.voiceRepository, {
    this.initialCameraLensDirection = CameraLensDirection.front,
  });

  @override
  void dispose() {
    stop();
    super.dispose();
  }

  final CameraLensDirection initialCameraLensDirection;
  List<CameraDescription> cameras = [];

  int get fullTime => currentExercise.time.inSeconds;
  int get totalTime => fullTime * 1000;
  @override
  String get time =>
      '${(fullMillisecondsElapsed ~/ 60000).toString().padLeft(2, '0')}:${((fullMillisecondsElapsed ~/ 1000) % 60).toString().padLeft(2, '0')}.${((fullMillisecondsElapsed % 1000) ~/ 10).toString().padLeft(2, '0')}';
  CameraController? controller;
  int cameraIndex = -1;
  bool changingCameraLens = false;

  bool isTimerRunning = false;
  bool isPaused = false;
  int millisecondsElapsed = 0;
  int errorCounter = 0;
  Timer? timer;

  void _startTimer() {
    final exercise = currentExercise;
    isTimerRunning = true;
    voiceRepository.talk(exercise.name);
    timer = Timer.periodic(
      const Duration(milliseconds: 50),
      (Timer t) {
        if (isPaused) return;
        millisecondsElapsed += 50;
        exercise.millisecondsElapsed = millisecondsElapsed;
        if (millisecondsElapsed >= exercise.time.inMilliseconds) {
          _stopTimer();
          millisecondsElapsed = 0;
          exercise.isDone = true;
        }
        notifyListeners();
      },
    );
  }

  void start() async {
    currentExercise.isDone = false;
    currentExercise.millisecondsElapsed = 0;
    millisecondsElapsed = 0;
    _startTimer();
    isPaused = false;
    notifyListeners();
  }

  void _stopTimer() {
    timer?.cancel();
    isTimerRunning = false;
    notifyListeners();
  }

  void stop() {
    currentExercise.isDone = false;
    currentExercise.millisecondsElapsed = 0;
    millisecondsElapsed = 0;
    isPaused = false;
    stopLiveFeed();
    WakelockPlus.disable();
    _stopTimer();
  }

  double get exerciseProgress =>
      millisecondsElapsed / currentExercise.time.inMilliseconds;
  int get fullMillisecondsElapsed => currentExercise.millisecondsElapsed;
  double get fullProgress => fullMillisecondsElapsed / totalTime;

  Future<void> initCameras() async {
    if (cameras.isEmpty) {
      cameras = await availableCameras();
    }
  }

  final PoseDetector _poseDetector = PoseDetector(
      options: PoseDetectorOptions(model: PoseDetectionModel.base));

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
    await _paintLines(inputImage);
    _isBusy = false;
    if (hasListeners) notifyListeners();
  }

  Future<void> _paintLines(InputImage inputImage) async {
    final poses = await _poseDetector.processImage(inputImage);
    if (poses.isEmpty ||
        inputImage.metadata?.size == null ||
        inputImage.metadata?.rotation == null) {
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
        validator: (value) {
          if (isTimerRunning && !isPaused && millisecondsElapsed % 25 == 0) {
            errorCounter++;
            debugPrint(errorCounter.toString());
            if (errorCounter % 25 == 0) {
              voiceRepository.talk(value, false);
            }
          }
        },
      ),
    );
  }

  void initialize() async {
    await initCameras();
    WakelockPlus.enable();
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
      imageFormatGroup: Platform.isAndroid
          ? ImageFormatGroup.nv21
          : ImageFormatGroup.bgra8888,
    );
    if (controller == null) return;
    await controller?.initialize();
    await controller?.startImageStream(_processCameraImage);
    notifyListeners();
  }

  Future stopLiveFeed() async {
    if (controller?.value.isStreamingImages == true) {
      await controller?.stopImageStream();
    }
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

  void pause([bool speak = true]) {
    isPaused = true;
    if (speak) {
      voiceRepository.talk('Pausado');
    }
    notifyListeners();
  }

  void resume([bool speak = true]) {
    isPaused = false;
    if (speak) {
      voiceRepository.talk('Reanudado');
    }
    notifyListeners();
  }

  void _processCameraImage(CameraImage image) {
    if (controller == null) return;
    if (!isTimerRunning) {
      if (customPaint != null) {
        customPaint = null;
        notifyListeners();
      }
      return;
    }
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
      var rotationCompensation =
          _orientations[controller!.value.deviceOrientation];
      if (rotationCompensation == null) return null;
      if (camera.lensDirection == CameraLensDirection.front) {
        // front-facing
        rotationCompensation = (sensorOrientation + rotationCompensation) % 360;
      } else {
        // back-facing
        rotationCompensation =
            (sensorOrientation - rotationCompensation + 360) % 360;
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
