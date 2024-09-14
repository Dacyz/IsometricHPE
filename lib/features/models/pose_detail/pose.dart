import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart' as kit;
import 'package:hive_flutter/hive_flutter.dart';

part 'pose.g.dart';

@HiveType(typeId: 3)
class Pose {
  /// A map of all the landmarks in the detected pose.
  @HiveField(0)
  final Map<int, PoseLandmark> landmarks;

  kit.Pose get mlkpPose => kit.Pose(
        landmarks: landmarks.map<kit.PoseLandmarkType, kit.PoseLandmark>(
            (key, value) => MapEntry(kit.PoseLandmarkType.values[key], value.toPoseLandmark)),
      );

  /// Returns an instance of [Pose] from a given [json].
  factory Pose.fromHive(kit.Pose pose) {
    return Pose(
      landmarks: pose.landmarks.map<int, PoseLandmark>(
        (key, value) => MapEntry(kit.PoseLandmarkType.values.indexOf(key), PoseLandmark.fromPoseLandmark(value)),
      ),
    );
  }

  /// Constructor to create an instance of [Pose].
  Pose({required this.landmarks});
}

/// A landmark in a pose detection result.
@HiveType(typeId: 4)
class PoseLandmark {
  /// The landmark type.
  @HiveField(0)
  final int type;

  /// Gives x coordinate of landmark in image frame.
  @HiveField(1)
  final double x;

  /// Gives y coordinate of landmark in image frame.
  @HiveField(2)
  final double y;

  /// Gives z coordinate of landmark in image space.
  @HiveField(3)
  final double z;

  /// Gives the likelihood of this landmark being in the image frame.
  @HiveField(4)
  final double likelihood;

  kit.PoseLandmark get toPoseLandmark => kit.PoseLandmark(
        type: kit.PoseLandmarkType.values[type],
        x: x,
        y: y,
        z: z,
        likelihood: likelihood,
      );

  /// Constructor to create an instance of [PoseLandmark].
  PoseLandmark({
    required this.type,
    required this.x,
    required this.y,
    required this.z,
    required this.likelihood,
  });

  /// Returns an instance of [PoseLandmark] from a given [poseLandmark].
  factory PoseLandmark.fromPoseLandmark(kit.PoseLandmark poseLandmark) {
    return PoseLandmark(
      type: kit.PoseLandmarkType.values.indexOf(poseLandmark.type),
      x: poseLandmark.x,
      y: poseLandmark.y,
      z: poseLandmark.z,
      likelihood: poseLandmark.likelihood,
    );
  }

  /// Returns an instance of [PoseLandmark] from a given [json].
  factory PoseLandmark.fromJson(Map<dynamic, dynamic> json) {
    return PoseLandmark(
      type: json['type'].toInt(),
      x: json['x'],
      y: json['y'],
      z: json['z'],
      likelihood: json['likelihood'] ?? 0.0,
    );
  }
}
