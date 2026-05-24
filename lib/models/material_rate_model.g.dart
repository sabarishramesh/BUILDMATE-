// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'material_rate_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MaterialRateModelAdapter extends TypeAdapter<MaterialRateModel> {
  @override
  final int typeId = 2;

  @override
  MaterialRateModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MaterialRateModel(
      id: fields[0] as String,
      materialName: fields[1] as String,
      category: fields[2] as String,
      rate: fields[3] as double,
      unit: fields[4] as String,
      supplierName: fields[5] as String,
      validFrom: fields[6] as DateTime?,
      notes: fields[7] as String,
      isDefault: fields[8] as bool,
      updatedAt: fields[9] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, MaterialRateModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.materialName)
      ..writeByte(2)
      ..write(obj.category)
      ..writeByte(3)
      ..write(obj.rate)
      ..writeByte(4)
      ..write(obj.unit)
      ..writeByte(5)
      ..write(obj.supplierName)
      ..writeByte(6)
      ..write(obj.validFrom)
      ..writeByte(7)
      ..write(obj.notes)
      ..writeByte(8)
      ..write(obj.isDefault)
      ..writeByte(9)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MaterialRateModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
