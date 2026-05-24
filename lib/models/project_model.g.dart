// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProjectModelAdapter extends TypeAdapter<ProjectModel> {
  @override
  final int typeId = 1;

  @override
  ProjectModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProjectModel(
      id: fields[0] as String,
      name: fields[1] as String,
      projectType: fields[2] as String,
      location: fields[3] as String,
      clientName: fields[4] as String,
      startDate: fields[5] as DateTime?,
      notes: fields[6] as String,
      builtUpAreaSqft: fields[7] as double,
      numberOfFloors: fields[8] as int,
      floorHeightM: fields[9] as double,
      slabThicknessMm: fields[10] as double,
      wallThicknessMm: fields[11] as double,
      slabVolumeM3: fields[12] as double,
      wallVolumeM3: fields[13] as double,
      foundationVolumeM3: fields[14] as double,
      totalConcreteVolumeM3: fields[15] as double,
      cementBags: fields[16] as double,
      steelMT: fields[17] as double,
      sandM3: fields[18] as double,
      aggregateM3: fields[19] as double,
      brickCount: fields[20] as int,
      totalEstimatedCost: fields[21] as double,
      status: fields[22] as String,
      progressPercent: fields[23] as double,
      createdAt: fields[24] as DateTime,
      updatedAt: fields[25] as DateTime,
      isArchived: fields[26] as bool,
      structuralCost: fields[27] as double,
      finishingCost: fields[28] as double,
      plumbingCost: fields[29] as double,
      electricalCost: fields[30] as double,
      carpentrycost: fields[31] as double,
    );
  }

  @override
  void write(BinaryWriter writer, ProjectModel obj) {
    writer
      ..writeByte(32)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.projectType)
      ..writeByte(3)
      ..write(obj.location)
      ..writeByte(4)
      ..write(obj.clientName)
      ..writeByte(5)
      ..write(obj.startDate)
      ..writeByte(6)
      ..write(obj.notes)
      ..writeByte(7)
      ..write(obj.builtUpAreaSqft)
      ..writeByte(8)
      ..write(obj.numberOfFloors)
      ..writeByte(9)
      ..write(obj.floorHeightM)
      ..writeByte(10)
      ..write(obj.slabThicknessMm)
      ..writeByte(11)
      ..write(obj.wallThicknessMm)
      ..writeByte(12)
      ..write(obj.slabVolumeM3)
      ..writeByte(13)
      ..write(obj.wallVolumeM3)
      ..writeByte(14)
      ..write(obj.foundationVolumeM3)
      ..writeByte(15)
      ..write(obj.totalConcreteVolumeM3)
      ..writeByte(16)
      ..write(obj.cementBags)
      ..writeByte(17)
      ..write(obj.steelMT)
      ..writeByte(18)
      ..write(obj.sandM3)
      ..writeByte(19)
      ..write(obj.aggregateM3)
      ..writeByte(20)
      ..write(obj.brickCount)
      ..writeByte(21)
      ..write(obj.totalEstimatedCost)
      ..writeByte(22)
      ..write(obj.status)
      ..writeByte(23)
      ..write(obj.progressPercent)
      ..writeByte(24)
      ..write(obj.createdAt)
      ..writeByte(25)
      ..write(obj.updatedAt)
      ..writeByte(26)
      ..write(obj.isArchived)
      ..writeByte(27)
      ..write(obj.structuralCost)
      ..writeByte(28)
      ..write(obj.finishingCost)
      ..writeByte(29)
      ..write(obj.plumbingCost)
      ..writeByte(30)
      ..write(obj.electricalCost)
      ..writeByte(31)
      ..write(obj.carpentrycost);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProjectModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
