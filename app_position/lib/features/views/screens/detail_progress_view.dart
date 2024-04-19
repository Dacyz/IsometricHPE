import 'package:app_position/features/models/routine/routine.dart';
import 'package:app_position/features/views/widgets/pose_painter.dart';
import 'package:flutter/material.dart';

class DetailProgressView extends StatefulWidget {
  const DetailProgressView({super.key, required this.routine});
  final Routine routine;
  @override
  State<DetailProgressView> createState() => _DetailProgressViewState();
}

class _DetailProgressViewState extends State<DetailProgressView> {
  int currentPose = 0;
  bool isPlaying = false;

  void _nextFrame() {
    if (currentPose < widget.routine.detail.length - 1 && isPlaying && mounted) {
      setState(() {
        currentPose++;
      });
      Future.delayed(const Duration(milliseconds: 100), _nextFrame);
    } else {
      if (mounted) {
        setState(() {
          isPlaying = false;
        });
      }
    }
  }

  void _play() {
    if (isPlaying) {
      isPlaying = false;
      setState(() {});
      return;
    }
    setState(() {
      isPlaying = true;
    });
    _nextFrame();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    if (widget.routine.detail.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Rutina de ${widget.routine.date}'),
        ),
        body: const Center(
          child: Text('No routine detected'),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Progreso'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          PosePreview(
            size: Size(size.width, 600),
            detail: widget.routine.detail[currentPose],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${currentPose + 1}'),
                Text('${widget.routine.detail.length}'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Slider(
              value: currentPose / widget.routine.detail.length,
              onChanged: (value) {
                currentPose = (value * widget.routine.detail.length).toInt().clamp(0, widget.routine.detail.length - 1);
                setState(() {});
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: _play,
                  child: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
