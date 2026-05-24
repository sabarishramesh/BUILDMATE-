import 'package:hive/hive.dart';

part 'material_rate_model.g.dart';

@HiveType(typeId: 2)
class MaterialRateModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String materialName;

  @HiveField(2)
  String category; // Structural / Masonry / Finishing / Plumbing / Electrical / Wood

  @HiveField(3)
  double rate;

  @HiveField(4)
  String unit; // bag / MT / m³ / sq.ft / no.

  @HiveField(5)
  String supplierName;

  @HiveField(6)
  DateTime? validFrom;

  @HiveField(7)
  String notes;

  @HiveField(8)
  bool isDefault;

  @HiveField(9)
  DateTime updatedAt;

  MaterialRateModel({
    required this.id,
    required this.materialName,
    required this.category,
    required this.rate,
    required this.unit,
    this.supplierName = '',
    this.validFrom,
    this.notes = '',
    this.isDefault = false,
    required this.updatedAt,
  });
}
