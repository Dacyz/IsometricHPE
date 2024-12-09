import 'package:app_position/core/widgets/timer_text.dart';
import 'package:app_position/features/models/exercise/exercise.dart';
import 'package:app_position/features/single_exercise.dart/presentation/single_exercise.dart';
import 'package:app_position/features/single_exercise.dart/presentation/widgets/camera_single_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_position/core/const.dart';
import 'package:app_position/features/views/widgets/custom_elevated_button.dart';

class SingleExerciseView extends StatelessWidget {
  const SingleExerciseView({Key? key, required this.exercise})
      : super(key: key);
  static const String route = '/single_exercise';
  final Exercise exercise;

  @override
  Widget build(BuildContext context) {
    final isTimerRunning =
        context.select((SingleExerciseProvider r) => r.isTimerRunning);
    return Scaffold(
      body: Column(
        children: [
          const Expanded(
            child: CameraSingleExercise(),
          ),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            width: double.infinity,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: CustomElevatedButton(
                        title: 'Ejercitarse',
                        onPressed: isTimerRunning
                            ? null
                            : context.read<SingleExerciseProvider>().start,
                      ),
                    ),
                    if (isTimerRunning) ...[
                      const SizedBox(width: 8),
                      FloatingActionButton(
                        heroTag: "btn1",
                        elevation: 0,
                        shape: CircleBorder(
                          side: BorderSide(color: AppConstants.colors.primary),
                        ),
                        onPressed: () {
                          final camera = context.read<SingleExerciseProvider>();
                          if (camera.isPaused) {
                            camera.resume();
                          } else {
                            camera.pause();
                          }
                        },
                        highlightElevation: 0,
                        backgroundColor: Colors.white,
                        child: Selector<SingleExerciseProvider, bool>(
                            selector: (_, camera) => camera.isPaused,
                            builder: (context, isPaused, _) {
                              return Icon(
                                isPaused
                                    ? Icons.play_arrow_outlined
                                    : Icons.pause,
                                color: AppConstants.colors.primary,
                                size: 25,
                              );
                            }),
                      )
                    ],
                    const SizedBox(width: 8),
                    !isTimerRunning
                        ? FloatingActionButton(
                            heroTag: "btn2",
                            elevation: 0,
                            shape: CircleBorder(
                                side: BorderSide(
                                    color: AppConstants.colors.primary)),
                            onPressed: () {
                              context
                                  .read<SingleExerciseProvider>()
                                  .switchLiveCamera();
                            },
                            highlightElevation: 0,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.flip_camera_android_outlined,
                              color: AppConstants.colors.primary,
                              size: 25,
                            ),
                          )
                        : FloatingActionButton(
                            heroTag: "btn3",
                            elevation: 0,
                            shape: CircleBorder(
                              side: BorderSide(
                                  color: AppConstants.colors.primary),
                            ),
                            onPressed: () {
                              _sureCancel(context);
                            },
                            highlightElevation: 0,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.close,
                              color: AppConstants.colors.primary,
                              size: 25,
                            ),
                          ),
                  ],
                ),
                const SizedBox(height: 8),
                const TimerText<SingleExerciseProvider>(),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _sureCancel(BuildContext context) async {
    final camera = context.read<SingleExerciseProvider>();
    camera.pause(false);
    final result = await Navigator.push<bool>(
      context,
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: true,
        transitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (BuildContext context, _, __) {
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
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        RichText(
                          text: const TextSpan(
                            text: 'Se pauso el monitoreo\n',
                            children: [
                              TextSpan(
                                text: '¿Estás seguro de cancelar el monitoreo?',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const TimerText(),
                        CustomElevatedButton(
                          title: 'Cancelar monitoreo',
                          onPressed: () => Navigator.pop(context, true),
                        ),
                        const SizedBox(height: 8),
                        CustomElevatedButton.outlined(
                          title: 'Regresar',
                          onPressed: () => Navigator.pop(context),
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
    camera.resume(false);
    if (result != true) return;
    camera.stop();
  }
}
