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
    return Scaffold(body: _liveFeedBody());
  }

  Widget _liveFeedBody() {
    final camera = Provider.of<Camera>(context);
    if (camera.cameras.isEmpty) return const SizedBox();
    if (camera.controller == null) return const SizedBox();
    if (camera.controller?.value.isInitialized == false) return Container(color: Colors.black);
    return Container(
      color: Colors.black,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Center(
            child: camera.changingCameraLens
                ? const Center(
                    child: Text('Changing camera lens'),
                  )
                : CameraPreview(
                    camera.controller!,
                    child: camera.customPaint,
                  ),
          ),
          _backButton(),
          Positioned(
            bottom: -1,
            left: 0,
            right: 0,
            child: Container(
              height: 32,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32)),
                color: Colors.white,
              ),
              width: double.infinity,
            ),
          ),
        ],
      ),
    );
  }

  Widget _backButton() => Positioned(
        top: 40,
        left: 8,
        child: SizedBox(
          height: 50.0,
          width: 50.0,
          child: FloatingActionButton(
            heroTag: Object(),
            shape: const CircleBorder(),
            onPressed: () => Navigator.of(context).pop(),
            backgroundColor: Colors.white,
            child: Icon(
              Icons.arrow_back_ios_outlined,
              color: AppConstants.colors.primary,
              size: 20,
            ),
          ),
        ),
      );
}
