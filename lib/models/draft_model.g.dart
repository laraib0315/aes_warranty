// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'draft_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DraftModelAdapter extends TypeAdapter<DraftModel> {
  @override
  final int typeId = 10;

  @override
  DraftModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DraftModel(
      id: fields[0] as String,
      type: fields[1] as DraftType,
      data: (fields[2] as Map).cast<String, dynamic>(),
      createdAt: fields[3] as DateTime,
      lastUpdated: fields[4] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, DraftModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.data)
      ..writeByte(3)
      ..write(obj.createdAt)
      ..writeByte(4)
      ..write(obj.lastUpdated);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DraftModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DraftTypeAdapter extends TypeAdapter<DraftType> {
  @override
  final int typeId = 9;

  @override
  DraftType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return DraftType.warranty;
      case 1:
        return DraftType.product;
      case 2:
        return DraftType.customer;
      case 3:
        return DraftType.qrBatch;
      default:
        return DraftType.warranty;
    }
  }

  @override
  void write(BinaryWriter writer, DraftType obj) {
    switch (obj) {
      case DraftType.warranty:
        writer.writeByte(0);
        break;
      case DraftType.product:
        writer.writeByte(1);
        break;
      case DraftType.customer:
        writer.writeByte(2);
        break;
      case DraftType.qrBatch:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DraftTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
