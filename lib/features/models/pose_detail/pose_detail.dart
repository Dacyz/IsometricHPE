import 'package:app_position/features/models/pose_detail/pose.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:app_position/features/models/exercise/exercise.dart';

part 'pose_detail.g.dart';

typedef PoseDetails = List<PoseDetail>;

@HiveType(typeId: 2)
class PoseDetail {
  @HiveField(0)
  final Pose pose;
  @HiveField(1)
  final ExerciseModel exercise;

  PoseDetail(
    this.pose, {
    required this.exercise,
  });

  @override
  String toString() {
    return 'PoseDetail{pose: $pose, exercise: ${exercise.name}}';
  }
}