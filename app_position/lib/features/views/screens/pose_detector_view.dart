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
  @override
  Widget build(BuildContext context) {
    final camera = Provider.of<Camera>(context);
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
                        onPressed: camera.isTimerRunning ? null : camera.start,
                      ),
                    ),
                    if (camera.isTimerRunning) ...[
                      const SizedBox(width: 8),
                      FloatingActionButton(
                        heroTag: "btn1",
                        elevation: 0,
                        shape: CircleBorder(
                          side: BorderSide(color: AppConstants.colors.primary),
                        ),
                        onPressed: () {
                          if (camera.isPaused) {
                            camera.resume();
                          } else {
                            camera.pause();
                          }
                        },
                        highlightElevation: 0,
                        backgroundColor: Colors.white,
                        child: Icon(
                          camera.isPaused ? Icons.play_arrow_outlined : Icons.pause,
                          color: AppConstants.colors.primary,
                          size: 25,
                        ),
                      )
                    ],
                    if (!camera.isTimerRunning && camera.showExportButton) ...[
                      const SizedBox(width: 8),
                      FloatingActionButton(
                        heroTag: "btn4",
                        elevation: 0,
                        shape: CircleBorder(side: BorderSide(color: AppConstants.colors.primary)),
                        onPressed: () {
                          camera.export(context);
                        },
                        highlightElevation: 0,
                        backgroundColor: Colors.white,
                        child: camera.isLoading
                            ? const CircularProgressIndicator()
                            : Icon(
                                camera.isError ? Icons.close : camera.isCompleted ? Icons.file_download_done_outlined : Icons.file_download_outlined,
                                color: camera.isError ? Colors.red : AppConstants.colors.primary,
                                size: 25,
                              ),
                      ),
                    ],
                    const SizedBox(width: 8),
                    !camera.isTimerRunning
                        ? FloatingActionButton(
                            heroTag: "btn2",
                            elevation: 0,
                            shape: CircleBorder(side: BorderSide(color: AppConstants.colors.primary)),
                            onPressed: () {
                              camera.switchLiveCamera();
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
                              side: BorderSide(color: AppConstants.colors.primary),
                            ),
                            onPressed: () {
                              _sureCancel(camera);
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
                Hero(
                  tag: 'timer',
                  child: Material(
                    color: Colors.transparent,
                    child: Text(
                      camera.time,
                      style: const TextStyle(
                        fontSize: 72,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                LinearProgressIndicator(
                  value: camera.fullProgress,
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(8),
                  color: AppConstants.colors.primary,
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _sureCancel(Camera camera) async {
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
                        Hero(
                          tag: 'timer',
                          child: Material(
                            color: Colors.transparent,
                            child: Text(
                              camera.time,
                              style: const TextStyle(
                                fontSize: 72,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
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
