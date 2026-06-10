// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_log_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ActivityLogModelAdapter extends TypeAdapter<ActivityLogModel> {
  @override
  final int typeId = 12;

  @override
  ActivityLogModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ActivityLogModel(
      id: fields[0] as String,
      userId: fields[1] as String,
      username: fields[2] as String,
      action: fields[3] as String,
      details: (fields[4] as Map).cast<String, dynamic>(),
      timestamp: fields[5] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, ActivityLogModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.username)
      ..writeByte(3)
      ..write(obj.action)
      ..writeByte(4)
      ..write(obj.details)
      ..writeByte(5)
      ..write(obj.timestamp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActivityLogModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
