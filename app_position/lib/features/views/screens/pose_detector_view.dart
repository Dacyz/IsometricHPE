import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_position/core/const.dart';
import 'package:app_position/features/providers/camera.dart';
import 'package:app_position/features/views/widgets/camera_view.dart';
import 'package:app_position/features/views/widgets/custom_elevated_button.dart';

class PoseDetectorView extends StatefulWidget {
  const PoseDetectorView({Key? key}) : super(key: key);
  static const String route = '/pose%20detector';

  @override
  State<StatefulWidget> createState() => _PoseDetectorViewState();
}

class _PoseDetectorViewState extends State<PoseDetectorView> {
  bool isTimerRunning = false;
  bool isCameraButtonEnabled = true;
  int millisecondsElapsed = 0; // Cambiado a milisegundos
  Timer? timer;
  int currentExercise = 1;

  // Tiempo total de la rutina (10 minutos)
  int totalTime = 120; // 10 minutos = 600 segundos

  // Tiempo para cada ejercicio en segundos
  int exercise1Time = 30; // 2 minutos
  int exercise2Time = 30; // 3 minutos
  int exercise3Time = 30; // 2 minutos
  int exercise4Time = 30; // 3 minutos

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void startTimer(int exerciseTime) {
    timer = Timer.periodic(
      const Duration(milliseconds: 10),
      (Timer t) {
        // Cambiado a milisegundos
        setState(() {
          millisecondsElapsed += 10; // Incrementado en 10 milisegundos
          if (millisecondsElapsed >= totalTime * 1000) {
            // Cambiado a milisegundos
            stopTimer();
          } else if (millisecondsElapsed >= exerciseTime * 1000) {
            // Cambiado a milisegundos
            // Cambio de ejercicio
            showExerciseChangeSnackbar(context, currentExercise);
            currentExercise++;
            if (currentExercise == 2) {
              exerciseTime = exercise2Time;
            } else if (currentExercise == 3) {
              exerciseTime = exercise3Time;
            } else if (currentExercise == 4) {
              exerciseTime = exercise4Time;
            }
          }
        });
      },
    );
  }

  void stopTimer() {
    timer?.cancel();
    setState(() {
      isTimerRunning = false;
      isCameraButtonEnabled = true;
    });
  }

  void showExerciseChangeSnackbar(BuildContext context, int exerciseNumber) {
    String exerciseMessage = '';

    switch (exerciseNumber) {
      case 1:
        exerciseMessage = '¡Es hora del ejercicio 2!';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(exerciseMessage),
            duration: Duration(seconds: exercise2Time),
          ),
        );
        break;
      case 2:
        exerciseMessage = '¡Es hora del ejercicio 3!';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(exerciseMessage),
            duration: Duration(seconds: exercise3Time),
          ),
        );
        break;
      case 3:
        exerciseMessage = '¡Es hora del ejercicio 4!';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(exerciseMessage),
            duration: Duration(seconds: exercise4Time),
          ),
        );
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    double exerciseProgress = millisecondsElapsed / (totalTime * 1000); // Cambiado a milisegundos

    return Scaffold(
      body: Column(
        children: [
          const Expanded(child: CameraView()),
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
                            : () {
                                setState(() {
                                  isTimerRunning = true;
                                  isCameraButtonEnabled = false;
                                  millisecondsElapsed = 0; // Reiniciar los milisegundos
                                  currentExercise = 1;
                                });
                                startTimer(exercise1Time);
                              },
                      ),
                    ),
                    const SizedBox(width: 8),
                    FloatingActionButton(
                      elevation: 0,
                      shape: CircleBorder(side: BorderSide(color: AppConstants.colors.primary)),
                      onPressed: isCameraButtonEnabled
                          ? () {
                              final camera = Provider.of<Camera>(context, listen: false);
                              camera.switchLiveCamera();
                            }
                          : null,
                      highlightElevation: 0,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.flip_camera_android_outlined,
                        color: isCameraButtonEnabled ? AppConstants.colors.primary : Colors.grey,
                        size: 25,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  '${(millisecondsElapsed ~/ 60000).toString().padLeft(2, '0')}:${((millisecondsElapsed ~/ 1000) % 60).toString().padLeft(2, '0')}.${((millisecondsElapsed % 1000) ~/ 10).toString().padLeft(2, '0')}', // Actualizado para mostrar milisegundos
                  style: const TextStyle(
                    fontSize: 72,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                LinearProgressIndicator(
                  value: exerciseProgress,
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(8),
                  color: AppConstants.colors.primary,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 8,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return SizedBox(
                        width: 2,
                        child: Material(
                          color: index > 72 ? const Color(0xFFE6E0EB) : AppConstants.colors.primary,
                          borderRadius: index == 0
                              ? const BorderRadius.horizontal(left: Radius.circular(32), right: Radius.zero)
                              : index == 99
                                  ? const BorderRadius.horizontal(right: Radius.circular(32), left: Radius.zero)
                                  : null,
                        ),
                      );
                    },
                    itemCount: 100,
                    clipBehavior: Clip.none,
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.zero,
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
