import 'package:app_position/core/extensions/duration.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:app_position/features/models/pose_detail/pose_detail.dart';

part 'routine.g.dart';

@HiveType(typeId: 1)
class Routine {
  @HiveField(0)
  PoseDetails detail;
  @HiveField(1)
  DateTime date;
  @HiveField(2)
  int timeInMilliseconds;

  Duration get duration => Duration(milliseconds: timeInMilliseconds);
  set duration(Duration value) => timeInMilliseconds = value.inMilliseconds;

  String get time => duration.toTime;

  Routine({
    required this.detail,
    required this.date,
    final Duration duration = const Duration(seconds: 1),
  }) : timeInMilliseconds = duration.inMilliseconds;

  @override
  String toString() => '$date: $detail';
}
