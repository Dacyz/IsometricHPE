import 'package:app_position/core/models/exercise_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TimerText<T extends ExerciseInterfaceProvider?> extends StatelessWidget {
  const TimerText({super.key});

  @override
  Widget build(BuildContext context) {
    final time = context.select((T camera) => camera?.time);
    return Hero(
      tag: 'timer',
      child: Material(
        color: Colors.transparent,
        child: Text(
          time ?? '',
          maxLines: 1,
          overflow: TextOverflow.clip,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 72,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
