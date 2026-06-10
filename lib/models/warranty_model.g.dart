// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'warranty_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ScrapInfoAdapter extends TypeAdapter<ScrapInfo> {
  @override
  final int typeId = 10;

  @override
  ScrapInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ScrapInfo(
      metalType: fields[0] as String,
      weight: fields[1] as double,
      weightUnit: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ScrapInfo obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.metalType)
      ..writeByte(1)
      ..write(obj.weight)
      ..writeByte(2)
      ..write(obj.weightUnit);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScrapInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class WarrantyItemAdapter extends TypeAdapter<WarrantyItem> {
  @override
  final int typeId = 11;

  @override
  WarrantyItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WarrantyItem(
      uid: fields[0] as String,
      product: fields[1] as ProductModel,
    );
  }

  @override
  void write(BinaryWriter writer, WarrantyItem obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.uid)
      ..writeByte(1)
      ..write(obj.product);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WarrantyItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class WarrantyModelAdapter extends TypeAdapter<WarrantyModel> {
  @override
  final int typeId = 7;

  @override
  WarrantyModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WarrantyModel(
      id: fields[0] as String,
      customer: fields[1] as CustomerModel,
      items: (fields[2] as List).cast<WarrantyItem>(),
      saleDate: fields[3] as DateTime,
      totalAmount: fields[4] as double,
      paidAmount: fields[5] as double,
      isPaid: fields[6] as bool,
      scrapInfo: fields[7] as ScrapInfo?,
      status: fields[8] as WarrantyStatus,
      isDeleted: fields[9] as bool,
      createdBy: fields[10] as String,
    );
  }

  @override
  void write(BinaryWriter writer, WarrantyModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.customer)
      ..writeByte(2)
      ..write(obj.items)
      ..writeByte(3)
      ..write(obj.saleDate)
      ..writeByte(4)
      ..write(obj.totalAmount)
      ..writeByte(5)
      ..write(obj.paidAmount)
      ..writeByte(6)
      ..write(obj.isPaid)
      ..writeByte(7)
      ..write(obj.scrapInfo)
      ..writeByte(8)
      ..write(obj.status)
      ..writeByte(9)
      ..write(obj.isDeleted)
      ..writeByte(10)
      ..write(obj.createdBy);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WarrantyModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class WarrantyStatusAdapter extends TypeAdapter<WarrantyStatus> {
  @override
  final int typeId = 6;

  @override
  WarrantyStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return WarrantyStatus.active;
      case 1:
        return WarrantyStatus.expired;
      default:
        return WarrantyStatus.active;
    }
  }

  @override
  void write(BinaryWriter writer, WarrantyStatus obj) {
    switch (obj) {
      case WarrantyStatus.active:
        writer.writeByte(0);
        break;
      case WarrantyStatus.expired:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WarrantyStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
