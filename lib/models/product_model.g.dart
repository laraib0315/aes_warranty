// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductModelAdapter extends TypeAdapter<ProductModel> {
  @override
  final int typeId = 4;

  @override
  ProductModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductModel(
      id: fields[0] as String,
      name: fields[1] as String,
      sku: fields[2] as String,
      brand: fields[3] as BrandModel,
      category: fields[4] as CategoryModel,
      costPrice: fields[5] as double,
      sellingPrice: fields[6] as double?,
      hasSellingPrice: fields[7] as bool,
      stock: fields[8] as int,
      lowStockLimit: fields[9] as int,
      createdAt: fields[10] as DateTime,
      lastUpdated: fields[11] as DateTime,
      isDeleted: fields[12] as bool,
      motorWarrantyMonths: fields[13] as int,
      boardWarrantyMonths: fields[14] as int,
    );
  }

  @override
  void write(BinaryWriter writer, ProductModel obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.sku)
      ..writeByte(3)
      ..write(obj.brand)
      ..writeByte(4)
      ..write(obj.category)
      ..writeByte(5)
      ..write(obj.costPrice)
      ..writeByte(6)
      ..write(obj.sellingPrice)
      ..writeByte(7)
      ..write(obj.hasSellingPrice)
      ..writeByte(8)
      ..write(obj.stock)
      ..writeByte(9)
      ..write(obj.lowStockLimit)
      ..writeByte(10)
      ..write(obj.createdAt)
      ..writeByte(11)
      ..write(obj.lastUpdated)
      ..writeByte(12)
      ..write(obj.isDeleted)
      ..writeByte(13)
      ..write(obj.motorWarrantyMonths)
      ..writeByte(14)
      ..write(obj.boardWarrantyMonths);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
