// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'warranty_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ScrapInfoAdapter extends TypeAdapter<ScrapInfo> {
  @override
  final int typeId = 16;

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
  final int typeId = 17;

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
      uid: fields[1] as String,
      customer: fields[2] as CustomerModel,
      product: fields[3] as ProductModel,
      saleDate: fields[4] as DateTime,
      sellingPrice: fields[5] as double?,
      motorExpiryDate: fields[6] as DateTime,
      boardExpiryDate: fields[7] as DateTime,
      status: fields[8] as WarrantyStatus,
      isDeleted: fields[9] as bool,
      totalPaid: fields[10] as double,
      totalAmount: fields[11] as double,
      isFullyPaid: fields[12] as bool,
      payments: (fields[13] as List).cast<PaymentModel>(),
      items: (fields[14] as List).cast<WarrantyItem>(),
      scrapInfo: fields[15] as ScrapInfo?,
    );
  }

  @override
  void write(BinaryWriter writer, WarrantyModel obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.uid)
      ..writeByte(2)
      ..write(obj.customer)
      ..writeByte(3)
      ..write(obj.product)
      ..writeByte(4)
      ..write(obj.saleDate)
      ..writeByte(5)
      ..write(obj.sellingPrice)
      ..writeByte(6)
      ..write(obj.motorExpiryDate)
      ..writeByte(7)
      ..write(obj.boardExpiryDate)
      ..writeByte(8)
      ..write(obj.status)
      ..writeByte(9)
      ..write(obj.isDeleted)
      ..writeByte(10)
      ..write(obj.totalPaid)
      ..writeByte(11)
      ..write(obj.totalAmount)
      ..writeByte(12)
      ..write(obj.isFullyPaid)
      ..writeByte(13)
      ..write(obj.payments)
      ..writeByte(14)
      ..write(obj.items)
      ..writeByte(15)
      ..write(obj.scrapInfo);
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
