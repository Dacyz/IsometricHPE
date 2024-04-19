import 'dart:async';
import 'dart:io';
import 'package:app_position/core/const.dart';
import 'package:app_position/core/extensions/integer.dart';
import 'package:app_position/features/data/exercise.dart';
import 'package:app_position/features/models/exercise/exercise.dart';
import 'package:app_position/features/models/pose_detail/pose.dart' as kit;
import 'package:app_position/features/models/pose_detail/pose_detail.dart';
import 'package:app_position/features/models/routine/routine.dart';
import 'package:app_position/features/providers/hive.dart';
import 'package:app_position/features/providers/settings.dart';
import 'package:app_position/features/views/widgets/pose_painter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:wakelock/wakelock.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

class Camera extends ChangeNotifier with Settings, BD {
  Camera() {
    _initTTS();
    initExercises();
    _initBD();
  }

  void _initTTS() async {
    final voiceList = await flutterTts.getVoices;
    flutterTts.awaitSpeakCompletion(true);
    try {
      final voicesList = List<Map>.from(voiceList);
      for (var element in voicesList) {
        final e = element['locale'] as String;
        // if (e.contains('es') || e.contains('en')) {
        if (e.contains('es')) {
          availableVoices.add(element);
          if (!localeVoices.contains(e)) {
            localeVoices.add(e);
          }
        }
      }
      notifyListeners();
    } catch (ex) {
      debugPrint(ex.toString());
    }
  }

  void _initBD() async {
    try {
      // Open your box. Optional: Give it a type.
      Hive.registerAdapter(RoutineAdapter());
      Hive.registerAdapter(PoseDetailAdapter());
      Hive.registerAdapter(kit.PoseAdapter());
      Hive.registerAdapter(kit.PoseLandmarkAdapter());
      Hive.registerAdapter(ExerciseModelAdapter());
      Hive.registerAdapter(ExerciseTypeAdapter());
      exerciseBox = await Hive.openBox<Routine>(AppConstants.dbBox);
    } catch (ex) {
      debugPrint('initBD ${ex.toString()}');
    }
  }

  void initExercises() {
    List<Exercise> exercisesList = [];
    for (var i = 0; i < listExercises.length; i++) {
      exercisesList.add(listExercises[i]);
      if (i != listExercises.length - 1) {
        exercisesList.insert(exercisesList.length, Exercise.rest());
      }
    }
    listExercises = exercisesList;
  }

  var initialCameraLensDirection = CameraLensDirection.back;
  List<CameraDescription> cameras = [];
  List<Exercise> listExercises = data;

  PoseDetails currentPoseList = [];
  late Exercise currentExercise = listExercises.first;
  int get fullTime =>
      listExercises.reduce((value, element) => element.copyWith(time: value.time + element.time)).time.inSeconds;
  int get totalTime => fullTime * 1000;
  String get time =>
      '${(fullMillisecondsElapsed ~/ 60000).toString().padLeft(2, '0')}:${((fullMillisecondsElapsed ~/ 1000) % 60).toString().padLeft(2, '0')}.${((fullMillisecondsElapsed % 1000) ~/ 10).toString().padLeft(2, '0')}';
  CameraController? controller;
  int cameraIndex = -1;
  bool changingCameraLens = false;

  bool isTimerRunning = false;
  bool isPaused = false;
  bool showExportButton = false;
  int millisecondsElapsed = 0;
  int errorCounter = 0;
  int _lastDuration = 0;
  Timer? timer;

  void _startTimer([Exercise? currentExercise]) {
    final exercise = currentExercise ?? this.currentExercise;
    isTimerRunning = true;
    talk(exercise.name);
    bool isBecomingOtherExercise = false;
    timer = Timer.periodic(
      const Duration(milliseconds: 10),
      (Timer t) {
        if (isPaused) return;
        millisecondsElapsed += 10;
        exercise.millisecondsElapsed = millisecondsElapsed;
        if (millisecondsElapsed >= exercise.time.inMilliseconds - 3200 && !isBecomingOtherExercise) {
          isBecomingOtherExercise = true;
          if (exercise.type == ExerciseType.rest) {
            talk('Prepárate');
          } else {
            talk('3 segundos');
          }
        }
        if (millisecondsElapsed >= exercise.time.inMilliseconds) {
          _lastDuration = millisecondsElapsed;
          _stopTimer();
          final id = listExercises.indexOf(exercise);
          millisecondsElapsed = 0;
          exercise.isDone = true;
          if (id != -1 && id < listExercises.length - 1) {
            this.currentExercise = listExercises[id + 1];
            _startTimer(this.currentExercise);
            return;
          }
          showExportButton = true;
        }
        notifyListeners();
      },
    );
  }

  void start() async {
    for (var element in listExercises) {
      element.isDone = false;
      element.millisecondsElapsed = 0;
    }
    millisecondsElapsed = 0;
    currentExercise = listExercises.first;
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
    _lastDuration = millisecondsElapsed;
    for (var element in listExercises) {
      element.isDone = false;
      element.millisecondsElapsed = 0;
    }
    millisecondsElapsed = 0;
    currentExercise = listExercises.first;
    showExportButton = true;
    isPaused = false;
    _stopTimer();
  }

  void export(BuildContext context) async {
    final newPoses = currentPoseList.toList(growable: false);
    final newId = await putRoutine(detail: newPoses, date: DateTime.now(), duration: _lastDuration.toDuration);
    if (newId != -1) {
      currentPoseList.clear();
    }
    Future.delayed(const Duration(seconds: 5), () {
      showExportButton = false;
      resetStatus();
    });
    notifyListeners();
  }

  double get exerciseProgress => millisecondsElapsed / currentExercise.time.inMilliseconds;
  int get fullMillisecondsElapsed => listExercises
      .reduce((value, element) =>
          element.copyWith(millisecondsElapsed: value.millisecondsElapsed + element.millisecondsElapsed))
      .millisecondsElapsed;
  double get fullProgress => fullMillisecondsElapsed / totalTime;

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
    if (isTimerRunning && !isPaused && millisecondsElapsed % 25 == 0) {
      currentPoseList.add(PoseDetail(kit.Pose.fromHive(poses.first), exercise: currentExercise));
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
              talk(value, false);
            }
          }
        },
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

  void pause([bool speak = true]) {
    isPaused = true;
    if (speak) {
      talk('Pausado');
    }
    notifyListeners();
  }

  void resume([bool speak = true]) {
    isPaused = false;
    if (speak) {
      talk('Reanudado');
    }
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
