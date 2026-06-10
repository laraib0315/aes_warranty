// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'qr_batch_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class QrBatchModelAdapter extends TypeAdapter<QrBatchModel> {
  @override
  final int typeId = 11;

  @override
  QrBatchModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return QrBatchModel(
      id: fields[0] as String,
      generatedDate: fields[1] as DateTime,
      quantity: fields[2] as int,
      purpose: fields[3] as String,
      uids: (fields[4] as List).cast<String>(),
      pdfPath: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, QrBatchModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.generatedDate)
      ..writeByte(2)
      ..write(obj.quantity)
      ..writeByte(3)
      ..write(obj.purpose)
      ..writeByte(4)
      ..write(obj.uids)
      ..writeByte(5)
      ..write(obj.pdfPath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QrBatchModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
