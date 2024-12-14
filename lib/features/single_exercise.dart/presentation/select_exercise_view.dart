import 'package:app_position/features/data/exercise.dart';
import 'package:app_position/features/single_exercise.dart/presentation/single_exercise_view.dart';
import 'package:flutter/material.dart';

class SelectExerciseView extends StatelessWidget {
  static const String route = '/select_exercise';
  const SelectExerciseView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Elige un ejercicio'),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(vertical: 24),
        child: ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) => ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 24),
            title: Text('Exercise ${data[index]}'),
            trailing: const Icon(Icons.arrow_right),
            leading: const Icon(Icons.directions_run),
            subtitle: Text(data[index].duration),
            onTap: () => Navigator.pushNamed(context, SingleExerciseView.route,
                arguments: data[index]),
          ),
        ),
      ),
    );
  }
}
