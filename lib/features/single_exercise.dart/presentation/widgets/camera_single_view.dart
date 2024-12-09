import 'package:app_position/core/const.dart';
import 'package:app_position/features/models/exercise/exercise.dart';
import 'package:app_position/features/single_exercise.dart/presentation/single_exercise.dart';
import 'package:camera/camera.dart';
import 'package:duration_picker/duration_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CameraSingleExercise extends StatefulWidget {
  const CameraSingleExercise({Key? key}) : super(key: key);

  @override
  State<CameraSingleExercise> createState() => _CameraSingleExerciseState();
}

class _CameraSingleExerciseState extends State<CameraSingleExercise> {
  late SingleExerciseProvider camera;

  @override
  void initState() {
    camera = Provider.of<SingleExerciseProvider>(context, listen: false);
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => camera.initialize());
  }

  @override
  void dispose() {
    if (mounted) camera.stopLiveFeed();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        _liveFeedBody(),
        if (!camera.isTimerRunning || camera.isPaused) const _BackButton(),
        _switchExercise(),
        _decoration(),
      ],
    );
  }

  Widget _decoration() => Positioned(
        bottom: -1,
        left: 0,
        right: 0,
        child: Container(
          height: 32,
          width: double.infinity,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(32), topRight: Radius.circular(32)),
            color: Colors.white,
          ),
        ),
      );

  Widget _switchExercise() {
    return Positioned(
      bottom: 32,
      left: 0,
      right: 0,
      child: SizedBox(
        height: 86,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: GestureDetector(
            onTap: _editDuration,
            child: _exerciseButton(),
          ),
        ),
      ),
    );
  }

  Widget _exerciseButton() {
    final single = context.watch<SingleExerciseProvider>();
    return Hero(
      tag: single.currentExercise.heroTag,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        height: 72,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: single.currentExercise.isDone
              ? AppConstants.colors.primary
              : AppConstants.colors.disabled,
          gradient: camera.isTimerRunning
              ? LinearGradient(
                  colors: [
                    AppConstants.colors.primary,
                    AppConstants.colors.disabled,
                  ],
                  tileMode: TileMode.decal,
                  stops: [camera.exerciseProgress, camera.exerciseProgress],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                )
              : null,
          borderRadius: BorderRadius.circular(32),
        ),
        child: single.currentExercise.type == ExerciseType.exercise
            ? RichText(
                text: TextSpan(
                    text: single.currentExercise.name,
                    children: [
                      TextSpan(
                        text: camera.isTimerRunning
                            ? '\n${single.currentExercise.timer}'
                            : '\n${single.currentExercise.duration}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                        ),
                      ),
                      TextSpan(
                        text: ' ${single.currentExercise.isDone ? '✓' : ''}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                        ),
                      ),
                    ],
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: !camera.isTimerRunning
                          ? AppConstants.colors.primary
                          : single.currentExercise.isDone
                              ? AppConstants.colors.disabled
                              : AppConstants.colors.primary,
                    )),
                textAlign: TextAlign.center,
              )
            : Icon(
                Icons.timer,
                color: !camera.isTimerRunning
                    ? AppConstants.colors.primary
                    : single.currentExercise.isDone
                        ? AppConstants.colors.disabled
                        : AppConstants.colors.primary,
              ),
      ),
    );
  }

  Widget _liveFeedBody() {
    final camera = context.watch<SingleExerciseProvider>();
    if (camera.cameras.isEmpty) return const SizedBox();
    if (camera.controller == null) return const SizedBox();
    if (camera.controller?.value.isInitialized == false) {
      return const SizedBox();
    }
    if (camera.changingCameraLens) {
      return const Center(child: Text('Changing camera lens'));
    }
    final value = camera.controller!.value;
    // fetch screen size
    final size = MediaQuery.sizeOf(context);
    // calculate scale depending on screen and camera ratios
    // this is actually size.aspectRatio / (1 / camera.aspectRatio)
    // because camera preview size is received as landscape
    // but we're calculating for portrait orientation
    var scale = size.aspectRatio * value.aspectRatio;

    // to prevent scaling down, invert the value
    if (scale < 1) scale = 1 / scale;
    return Center(
      child: Transform.scale(
        scale: scale,
        child: Center(
          child: CameraPreview(
            camera.controller!,
            child: camera.customPaint,
          ),
        ),
      ),
    );
  }

  void _editDuration() {
    final single = context.read<SingleExerciseProvider>();
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: true,
        transitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (BuildContext context, _, __) {
          Duration duration = single.currentExercise.time;
          return StatefulBuilder(builder: (context, state) {
            return FadeTransition(
              opacity: _.drive(CurveTween(curve: Curves.easeInOutCubic)),
              child: Material(
                color: Colors.black.withOpacity(.5 * _.value),
                animationDuration: const Duration(milliseconds: 300),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.all(42),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        RichText(
                          text: TextSpan(
                            text: 'Modifica el tiempo de\n',
                            children: [
                              TextSpan(
                                text: single.currentExercise.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        DurationPicker(
                          duration: duration,
                          baseUnit: BaseUnit.second,
                          onChange: (val) {
                            single.currentExercise.time = val;
                            state(() => duration = val);
                          },
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: _exerciseButton(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          });
        },
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 42,
      left: 16,
      child: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          height: 72,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppConstants.colors.disabled,
          ),
          child: Icon(
            Icons.arrow_back_ios_outlined,
            color: AppConstants.colors.primary,
            size: 20,
          ),
        ),
      ),
    );
  }
}
