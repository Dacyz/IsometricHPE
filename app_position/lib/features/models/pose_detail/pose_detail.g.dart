// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pose_detail.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PoseDetailAdapter extends TypeAdapter<PoseDetail> {
  @override
  final int typeId = 2;

  @override
  PoseDetail read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PoseDetail(
      fields[0] as Pose,
      exercise: fields[1] as ExerciseModel,
    );
  }

  @override
  void write(BinaryWriter writer, PoseDetail obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.pose)
      ..writeByte(1)
      ..write(obj.exercise);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PoseDetailAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
