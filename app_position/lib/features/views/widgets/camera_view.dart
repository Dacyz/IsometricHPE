import 'package:app_position/core/const.dart';
import 'package:app_position/features/providers/camera.dart';
import 'package:camera/camera.dart';
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
    print('wa');
    camera = Provider.of<Camera>(context, listen: false);
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => camera.initialize());
  }

  @override
  void dispose() {
    if (mounted) {
      print('wa2');
      camera.stopLiveFeed();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        _liveFeedBody(),
        _backButton(),
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
}
