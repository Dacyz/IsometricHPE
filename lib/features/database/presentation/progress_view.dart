import 'package:app_position/features/database/presentation/database_repository.dart';
import 'package:app_position/features/views/screens/detail_progress_view.dart';
import 'package:app_position/features/views/widgets/pose_painter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProgressView extends StatefulWidget {
  const ProgressView({super.key});
  static const String route = '/progress';

  @override
  State<ProgressView> createState() => _ProgressViewState();
}

class _ProgressViewState extends State<ProgressView> {
  @override
  Widget build(BuildContext context) {
    final values = context.watch<HiveRepository>();
    if (values.exerciseBox.values.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Progreso'),
        ),
        body: const Center(
          child: Text('No pose detected'),
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
          Expanded(
            child: ListView.separated(
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final routine = values.exerciseBox.values.elementAt(index);
                return ListTile(
                  leading: routine.detail.isEmpty
                      ? const Icon(Icons.run_circle_outlined)
                      : PosePreview(
                          size: const Size(50, 50),
                          detail: routine.detail.first,
                        ),
                  title: Text('${routine.date}'),
                  subtitle: Text('${routine.time} / ${routine.detail.length} / ${routine.duration}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, _, __) => DetailProgressView(routine: routine),
                      ),
                    );
                  },
                );
              },
              itemCount: values.exerciseBox.values.length,
            ),
          ),
        ],
      ),
    );
  }
}
