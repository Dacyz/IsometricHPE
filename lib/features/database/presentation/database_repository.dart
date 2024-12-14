import 'package:app_position/features/models/exercise/exercise.dart';
import 'package:app_position/features/models/pose_detail/pose_detail.dart';
import 'package:app_position/features/models/routine/routine.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:app_position/features/models/pose_detail/pose.dart' as kit;

enum BoxStatus { loading, start, error, completed }

class HiveRepository with ChangeNotifier {
  static const String dbName = 'AppPosition';
  static const String dbBox = 'exercises';

  HiveRepository() {
    _initBD();
  }
  late final BoxCollection collection;
  late final Box<Routine> exerciseBox;

  BoxStatus _status = BoxStatus.start;
  bool showExportButton = false;

  set status(BoxStatus value) {
    _status = value;
    notifyListeners();
  }

  void resetStatus() {
    _status = BoxStatus.start;
    showExportButton = false;
  }

  bool get isStart => _status == BoxStatus.start;
  bool get isLoading => _status == BoxStatus.loading;
  bool get isCompleted => _status == BoxStatus.completed;
  bool get isError => _status == BoxStatus.error;

  Future<int> putRoutine({
    required PoseDetails detail,
    required DateTime date,
    required Duration duration,
  }) async {
    try {
      _status = BoxStatus.loading;
      final newId = await exerciseBox.add(Routine(
        detail: detail,
        date: date,
        duration: duration,
      ));
      if (newId == -1) {
        _status = BoxStatus.error;
        return newId;
      }
      _status = BoxStatus.completed;
      return newId;
    } catch (e) {
      debugPrint(e.toString());
      _status = BoxStatus.error;
      return -1;
    }
  }

  void _initBD() async {
    try {
      // Open your box. Optional: Give it a type.
      Hive.registerAdapter(RoutineAdapter());
      Hive.registerAdapter(PoseDetailAdapter());
      Hive.registerAdapter(kit.PoseAdapter());
      Hive.registerAdapter(kit.PoseLandmarkAdapter());
      Hive.registerAdapter(ExerciseModelAdapter());
      Hive.registerAdapter(ExerciseTypeAdapter());
      exerciseBox = await Hive.openBox<Routine>(dbBox);
    } catch (ex) {
      debugPrint('initBD ${ex.toString()}');
    }
  }
}
