// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pose.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PoseAdapter extends TypeAdapter<Pose> {
  @override
  final int typeId = 3;

  @override
  Pose read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Pose(
      landmarks: (fields[0] as Map).cast<int, PoseLandmark>(),
    );
  }

  @override
  void write(BinaryWriter writer, Pose obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.landmarks);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PoseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PoseLandmarkAdapter extends TypeAdapter<PoseLandmark> {
  @override
  final int typeId = 4;

  @override
  PoseLandmark read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PoseLandmark(
      type: fields[0] as int,
      x: fields[1] as double,
      y: fields[2] as double,
      z: fields[3] as double,
      likelihood: fields[4] as double,
    );
  }

  @override
  void write(BinaryWriter writer, PoseLandmark obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.x)
      ..writeByte(2)
      ..write(obj.y)
      ..writeByte(3)
      ..write(obj.z)
      ..writeByte(4)
      ..write(obj.likelihood);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PoseLandmarkAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
