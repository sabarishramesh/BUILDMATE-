import 'package:uuid/uuid.dart';
import '../models/project_model.dart';
import '../constants/engineering_constants.dart';
import 'hive_service.dart';

class ProjectService {
  static const _uuid = Uuid();

  // ── Create a new blank project ────────────────────────────────────────────
  static Future<ProjectModel> createProject({
    required String name,
    String projectType = 'Residential',
    String location = '',
    String clientName = '',
    DateTime? startDate,
    String notes = '',
  }) async {
    final now = DateTime.now();
    final project = ProjectModel(
      id: _uuid.v4(),
      name: name,
      projectType: projectType,
      location: location,
      clientName: clientName,
      startDate: startDate,
      notes: notes,
      createdAt: now,
      updatedAt: now,
    );
    await HiveService.projectBox.put(project.id, project);
    return project;
  }

  // ── Get all non-archived projects ────────────────────────────────────────
  static List<ProjectModel> getActiveProjects() {
    return HiveService.projectBox.values
        .where((p) => !p.isArchived)
        .toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  }

  // ── Get archived projects ─────────────────────────────────────────────────
  static List<ProjectModel> getArchivedProjects() {
    return HiveService.projectBox.values
        .where((p) => p.isArchived)
        .toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  }

  // ── Archive / restore ─────────────────────────────────────────────────────
  static Future<void> archiveProject(String id) async {
    final p = HiveService.projectBox.get(id);
    if (p == null) return;
    p.isArchived = true;
    p.updatedAt = DateTime.now();
    await p.save();
  }

  static Future<void> restoreProject(String id) async {
    final p = HiveService.projectBox.get(id);
    if (p == null) return;
    p.isArchived = false;
    p.updatedAt = DateTime.now();
    await p.save();
  }

  static Future<void> deleteProject(String id) async {
    await HiveService.projectBox.delete(id);
  }

  // ── THE CORE CALCULATOR ──────────────────────────────────────────────────
  // Takes the 5 inputs and fills in all the result fields on the project.
  static void calculate(ProjectModel p) {
    // Convert area from sq.ft to sq.m
    final areaSqm = p.builtUpAreaSqft * EngineeringConstants.sqftToSqm;

    // ── Slab volume ──────────────────────────────────────────────────────────
    // Slab thickness in mm → convert to metres first
    final slabThicknessM = p.slabThicknessMm / 1000.0;
    p.slabVolumeM3 = areaSqm * slabThicknessM * p.numberOfFloors;

    // ── Wall volume ──────────────────────────────────────────────────────────
    // Perimeter ~ 4 × √(area) for a square plan approximation
    final perimM = 4 * _sqrt(areaSqm);
    final wallThicknessM = p.wallThicknessMm / 1000.0;
    final grossWallArea = perimM * p.floorHeightM * p.numberOfFloors;
    final netWallArea = grossWallArea *
        (1 - EngineeringConstants.wallOpeningDeductionFactor);
    p.wallVolumeM3 = netWallArea * wallThicknessM;

    // ── Foundation volume (isolated footing default) ──────────────────────
    p.foundationVolumeM3 =
        EngineeringConstants.defaultFootingLength *
        EngineeringConstants.defaultFootingBreadth *
        EngineeringConstants.defaultFoundationDepth *
        EngineeringConstants.defaultNumberOfColumns;

    // ── Total concrete ────────────────────────────────────────────────────
    p.totalConcreteVolumeM3 =
        p.slabVolumeM3 + p.wallVolumeM3 + p.foundationVolumeM3;

    // ── Cement bags (M20 mix: 1:1.5:3, dry factor 1.54) ──────────────────
    final mixRatio = EngineeringConstants.mixRatios['M20']!;
    final totalParts = mixRatio[0] + mixRatio[1] + mixRatio[2];
    final cementProportion = mixRatio[0] / totalParts;
    final wetVolumePerM3 = EngineeringConstants.dryToWetFactor;
    // kg of cement per m³ of concrete
    final cementKgPerM3 = (wetVolumePerM3 * cementProportion * 1440); // 1440 kg/m³ density of cement
    p.cementBags = (p.totalConcreteVolumeM3 * cementKgPerM3 /
            EngineeringConstants.cementBagKg *
            EngineeringConstants.wastageFactor)
        .ceilToDouble();

    // ── Steel ────────────────────────────────────────────────────────────
    p.steelMT = (p.totalConcreteVolumeM3 *
            (EngineeringConstants.defaultSteelPercentage / 100) *
            EngineeringConstants.steelDensityKgPerM3) /
        1000; // convert kg to MT

    // ── Sand and aggregate (M20 mix) ─────────────────────────────────────
    final sandProportion = mixRatio[1] / totalParts;
    final aggProportion = mixRatio[2] / totalParts;
    p.sandM3 = p.totalConcreteVolumeM3 * wetVolumePerM3 * sandProportion *
        EngineeringConstants.wastageFactor;
    p.aggregateM3 = p.totalConcreteVolumeM3 * wetVolumePerM3 * aggProportion *
        EngineeringConstants.wastageFactor;

    // ── Bricks (for wall volume, not replacing concrete walls) ───────────
    p.brickCount = (p.wallVolumeM3 *
            EngineeringConstants.bricksPerCubicMetre)
        .round();

    // ── Cost calculation ─────────────────────────────────────────────────
    final cementCost = p.cementBags * MaterialRates.cementPerBag;
    final steelCost = p.steelMT * MaterialRates.steelPerMT;
    final sandCost = p.sandM3 * MaterialRates.sandPerCubicM;
    final aggCost = p.aggregateM3 * MaterialRates.aggregatePerCubicM;
    final brickCost = p.brickCount * MaterialRates.brickPerUnit;
    final totalMaterialCost =
        cementCost + steelCost + sandCost + aggCost + brickCost;

    // Phase costs
    p.structuralCost = totalMaterialCost * EngineeringConstants.structuralPhasePercent;
    p.finishingCost = totalMaterialCost * EngineeringConstants.finishingPhasePercent;
    p.plumbingCost = totalMaterialCost * EngineeringConstants.plumbingPhasePercent;
    p.electricalCost = totalMaterialCost * EngineeringConstants.electricalPhasePercent;
    p.carpentrycost = totalMaterialCost * EngineeringConstants.carpentryPhasePercent;

    p.totalEstimatedCost = p.structuralCost +
        p.finishingCost +
        p.plumbingCost +
        p.electricalCost +
        p.carpentrycost;
  }

  static double _sqrt(double x) {
    if (x <= 0) return 0;
    return x <= 0 ? 0 : _sqrtHelper(x, x / 2, 0);
  }

  static double _sqrtHelper(double x, double guess, int iter) {
    if (iter > 50) return guess;
    final next = (guess + x / guess) / 2;
    if ((next - guess).abs() < 0.0001) return next;
    return _sqrtHelper(x, next, iter + 1);
  }

  // ── Save calculated results back to Hive ─────────────────────────────────
  static Future<void> saveCalculation(ProjectModel p) async {
    calculate(p);
    p.updatedAt = DateTime.now();
    await p.save();
  }
}
