import 'package:app_position/core/const.dart';
import 'package:app_position/features/models/exercise/exercise.dart';
import 'package:app_position/features/providers/camera.dart';
import 'package:camera/camera.dart';
import 'package:duration_picker/duration_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CameraView extends StatefulWidget {
  const CameraView({
    Key? key,
  }) : super(key: key);

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  late Camera camera;

  @override
  void initState() {
    camera = Provider.of<Camera>(context, listen: false);
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
        if (!camera.isTimerRunning || camera.isPaused) _backButton(),
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
            borderRadius: BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32)),
            color: Colors.white,
          ),
        ),
      );
  Widget _switchExercise() {
    final list = camera.listExercises;
    return Positioned(
      bottom: 32,
      left: 0,
      right: 0,
      child: SizedBox(
        height: 86,
        child: ListView.separated(
          padding: const EdgeInsets.all(16),
          physics: const BouncingScrollPhysics(),
          clipBehavior: Clip.none,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) => GestureDetector(
            onTap: camera.isTimerRunning ? null : () => camera.currentExercise = list[index],
            onLongPress: camera.isTimerRunning || list[index].isDone ? null : () => _editDuration(list[index]),
            child: _exerciseButton(list[index]),
          ),
          separatorBuilder: (context, index) => const SizedBox(width: 4),
          itemCount: list.length,
        ),
      ),
    );
  }

  Widget _exerciseButton(Exercise index, {bool showDetails = false}) {
    return Hero(
      tag: index.heroTag,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        height: 72,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: camera.currentExercise == index || index.isDone
              ? AppConstants.colors.primary
              : AppConstants.colors.disabled,
          gradient: camera.currentExercise == index && camera.isTimerRunning
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
        child: index.type == ExerciseType.exercise || showDetails
            ? RichText(
                text: TextSpan(
                    text: index.name,
                    children: [
                      TextSpan(
                        text: camera.isTimerRunning && camera.currentExercise == index
                            ? '\n${index.timer}'
                            : '\n${index.duration}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                        ),
                      ),
                      TextSpan(
                        text: ' ${index.isDone ? '✓' : ''}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                        ),
                      ),
                    ],
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: camera.currentExercise == index
                          ? !camera.isTimerRunning
                              ? AppConstants.colors.disabled
                              : Colors.black
                          : index.isDone
                              ? AppConstants.colors.disabled
                              : AppConstants.colors.primary,
                    )),
                textAlign: TextAlign.center,
              )
            : Icon(
                Icons.timer,
                color: camera.currentExercise == index
                    ? !camera.isTimerRunning
                        ? AppConstants.colors.disabled
                        : Colors.black
                    : index.isDone
                        ? AppConstants.colors.disabled
                        : AppConstants.colors.primary,
              ),
      ),
    );
  }

  Widget _liveFeedBody() {
    final camera = Provider.of<Camera>(context);
    if (camera.cameras.isEmpty) return const SizedBox();
    if (camera.controller == null) return const SizedBox();
    if (camera.controller?.value.isInitialized == false) return const SizedBox();
    if (camera.changingCameraLens) return const Center(child: Text('Changing camera lens'));
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

  Widget _backButton() => Positioned(
        top: 42,
        left: 16,
        child: FloatingActionButton(
          heroTag: Object(),
          shape: const CircleBorder(),
          elevation: 0,
          onPressed: () => Navigator.of(context).pop(),
          backgroundColor: Colors.white,
          child: Icon(
            Icons.arrow_back_ios_outlined,
            color: AppConstants.colors.primary,
            size: 20,
          ),
        ),
      );

  void _editDuration(Exercise exercise) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: true,
        transitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (BuildContext context, _, __) {
          Duration duration = exercise.time;
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
                                text: exercise.name,
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
                            exercise.time = val;
                            state(() => duration = val);
                          },
                          snapToMins: 5.0,
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: _exerciseButton(exercise, showDetails: true),
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
