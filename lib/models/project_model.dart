import 'package:hive/hive.dart';

part 'project_model.g.dart';

@HiveType(typeId: 1)
class ProjectModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String projectType; // Residential / Commercial / Industrial

  @HiveField(3)
  String location;

  @HiveField(4)
  String clientName;

  @HiveField(5)
  DateTime? startDate;

  @HiveField(6)
  String notes;

  // ── Structural inputs (the 5 core calculator fields) ──────────────────────
  @HiveField(7)
  double builtUpAreaSqft;

  @HiveField(8)
  int numberOfFloors;

  @HiveField(9)
  double floorHeightM;

  @HiveField(10)
  double slabThicknessMm;

  @HiveField(11)
  double wallThicknessMm;

  // ── Calculated results (saved so the user can reopen later) ───────────────
  @HiveField(12)
  double slabVolumeM3;

  @HiveField(13)
  double wallVolumeM3;

  @HiveField(14)
  double foundationVolumeM3;

  @HiveField(15)
  double totalConcreteVolumeM3;

  @HiveField(16)
  double cementBags;

  @HiveField(17)
  double steelMT;

  @HiveField(18)
  double sandM3;

  @HiveField(19)
  double aggregateM3;

  @HiveField(20)
  int brickCount;

  @HiveField(21)
  double totalEstimatedCost;

  // ── Project status ────────────────────────────────────────────────────────
  @HiveField(22)
  String status; // Draft / Active / Completed / Archived

  @HiveField(23)
  double progressPercent;

  @HiveField(24)
  DateTime createdAt;

  @HiveField(25)
  DateTime updatedAt;

  @HiveField(26)
  bool isArchived;

  // ── Phase-wise costs ──────────────────────────────────────────────────────
  @HiveField(27)
  double structuralCost;

  @HiveField(28)
  double finishingCost;

  @HiveField(29)
  double plumbingCost;

  @HiveField(30)
  double electricalCost;

  @HiveField(31)
  double carpentrycost;

  @HiveField(32)
  String userId;

  ProjectModel({
    required this.id,
    required this.name,
    this.userId = '',
    this.projectType = 'Residential',
    this.location = '',
    this.clientName = '',
    this.startDate,
    this.notes = '',
    this.builtUpAreaSqft = 0,
    this.numberOfFloors = 1,
    this.floorHeightM = 3.0,
    this.slabThicknessMm = 150,
    this.wallThicknessMm = 230,
    this.slabVolumeM3 = 0,
    this.wallVolumeM3 = 0,
    this.foundationVolumeM3 = 0,
    this.totalConcreteVolumeM3 = 0,
    this.cementBags = 0,
    this.steelMT = 0,
    this.sandM3 = 0,
    this.aggregateM3 = 0,
    this.brickCount = 0,
    this.totalEstimatedCost = 0,
    this.status = 'Draft',
    this.progressPercent = 0,
    required this.createdAt,
    required this.updatedAt,
    this.isArchived = false,
    this.structuralCost = 0,
    this.finishingCost = 0,
    this.plumbingCost = 0,
    this.electricalCost = 0,
    this.carpentrycost = 0,
  });
}
