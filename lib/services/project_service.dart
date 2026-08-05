import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../models/project_model.dart';
import '../constants/engineering_constants.dart';
import 'auth_service.dart';
import 'hive_service.dart';

class ProjectService {
  static const _uuid = Uuid();
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ── Sync Project to Firestore document ──────────────────────────────────
  static Future<void> syncToFirestore(ProjectModel project) async {
    try {
      final docRef = _firestore.collection('projects').doc(project.id);
      await docRef.set({
        'id': project.id,
        'userId': project.userId,
        'name': project.name,
        'projectType': project.projectType,
        'location': project.location,
        'clientName': project.clientName,
        'startDate': project.startDate?.toIso8601String(),
        'notes': project.notes,
        'builtUpAreaSqft': project.builtUpAreaSqft,
        'numberOfFloors': project.numberOfFloors,
        'floorHeightM': project.floorHeightM,
        'slabThicknessMm': project.slabThicknessMm,
        'wallThicknessMm': project.wallThicknessMm,
        'slabVolumeM3': project.slabVolumeM3,
        'wallVolumeM3': project.wallVolumeM3,
        'foundationVolumeM3': project.foundationVolumeM3,
        'totalConcreteVolumeM3': project.totalConcreteVolumeM3,
        'cementBags': project.cementBags,
        'steelMT': project.steelMT,
        'sandM3': project.sandM3,
        'aggregateM3': project.aggregateM3,
        'brickCount': project.brickCount,
        'totalEstimatedCost': project.totalEstimatedCost,
        'status': project.status,
        'progressPercent': project.progressPercent,
        'createdAt': project.createdAt.toIso8601String(),
        'updatedAt': project.updatedAt.toIso8601String(),
        'isArchived': project.isArchived,
        'structuralCost': project.structuralCost,
        'finishingCost': project.finishingCost,
        'plumbingCost': project.plumbingCost,
        'electricalCost': project.electricalCost,
        'carpentrycost': project.carpentrycost,
      }, SetOptions(merge: true));
    } catch (_) {
      // Allow offline operation to continue smoothly
    }
  }

  // ── Create a new blank project ────────────────────────────────────────────
  static Future<ProjectModel> createProject({
    required String name,
    String projectType = 'Residential',
    String location = '',
    String clientName = '',
    DateTime? startDate,
    String notes = '',
    String status = 'Active',
  }) async {
    final now = DateTime.now();
    final currentUserId = AuthService.currentUser?.id ?? '';
    final project = ProjectModel(
      id: _uuid.v4(),
      name: name,
      userId: currentUserId,
      projectType: projectType,
      location: location,
      clientName: clientName,
      startDate: startDate,
      notes: notes,
      status: status,
      createdAt: now,
      updatedAt: now,
    );
    if (HiveService.isProjectBoxOpen) {
      await HiveService.projectBox.put(project.id, project);
    }
    await syncToFirestore(project);
    return project;
  }

  // ── Get all non-archived projects (scoped to current user) ────────────────
  static List<ProjectModel> getActiveProjects() {
    if (!HiveService.isProjectBoxOpen) return [];
    final currentUserId = AuthService.currentUser?.id ?? '';
    return HiveService.projectBox.values
        .where((p) => !p.isArchived && (currentUserId.isEmpty || p.userId.isEmpty || p.userId == currentUserId))
        .toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  }

  // ── Get archived projects (scoped to current user) ────────────────────────
  static List<ProjectModel> getArchivedProjects() {
    if (!HiveService.isProjectBoxOpen) return [];
    final currentUserId = AuthService.currentUser?.id ?? '';
    return HiveService.projectBox.values
        .where((p) => p.isArchived && (currentUserId.isEmpty || p.userId.isEmpty || p.userId == currentUserId))
        .toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  }

  // ── Archive / restore ─────────────────────────────────────────────────────
  static Future<void> archiveProject(String id) async {
    if (!HiveService.isProjectBoxOpen) return;
    final p = HiveService.projectBox.get(id);
    if (p == null) return;
    p.isArchived = true;
    p.updatedAt = DateTime.now();
    await p.save();
    await syncToFirestore(p);
  }

  static Future<void> restoreProject(String id) async {
    if (!HiveService.isProjectBoxOpen) return;
    final p = HiveService.projectBox.get(id);
    if (p == null) return;
    p.isArchived = false;
    p.updatedAt = DateTime.now();
    await p.save();
    await syncToFirestore(p);
  }

  static Future<void> deleteProject(String id) async {
    if (HiveService.isProjectBoxOpen) {
      await HiveService.projectBox.delete(id);
    }
    try {
      await _firestore.collection('projects').doc(id).delete();
    } catch (_) {}
  }

  // ── THE CORE CALCULATOR ──────────────────────────────────────────────────
  // Takes the 5 inputs and fills in all the result fields on the project.
  static void calculate(ProjectModel p) {
    // 1. Convert area from sq.ft to sq.m (builtUpAreaSqft * 0.0929)
    final areaSqm = p.builtUpAreaSqft * EngineeringConstants.sqftToSqm;

    // 2. Slab volume (sq.m * slabThickness in metres * numberOfFloors)
    final slabThicknessM = p.slabThicknessMm / 1000.0;
    p.slabVolumeM3 = areaSqm * slabThicknessM * p.numberOfFloors;

    // 3. Foundation and column RCC volume (~0.05 m³ per sq.m + floor column factor)
    p.foundationVolumeM3 = (areaSqm * 0.05) + (p.numberOfFloors * 0.5);

    // 4. Total concrete volume = Slab concrete + Foundation/Column concrete (walls are brickwork)
    p.totalConcreteVolumeM3 = p.slabVolumeM3 + p.foundationVolumeM3;

    // 5. Wall volume for brickwork (Perimeter * floorHeight * floors * opening deduction * partition ratio)
    final perimM = 4 * _sqrt(areaSqm);
    final wallThicknessM = p.wallThicknessMm / 1000.0;
    final grossWallArea = perimM * p.floorHeightM * p.numberOfFloors;
    // 25% openings deduction + 80% partition ratio multiplier
    final netWallArea = grossWallArea * (1.0 - EngineeringConstants.wallOpeningDeductionFactor);
    p.wallVolumeM3 = netWallArea * wallThicknessM * 0.80;

    // 6. Brick count (500 bricks / m³ of brickwork)
    p.brickCount = (p.wallVolumeM3 * EngineeringConstants.bricksPerCubicMetre).round();

    // 7. Cement bags (Concrete cement M20 mix + Mortar cement for brickwork)
    final mixRatio = EngineeringConstants.mixRatios['M20']!;
    final totalParts = mixRatio[0] + mixRatio[1] + mixRatio[2];
    final cementProportion = mixRatio[0] / totalParts;
    final wetVolumePerM3 = EngineeringConstants.dryToWetFactor;
    final cementKgPerM3 = wetVolumePerM3 * cementProportion * 1440; // 1440 kg/m³ density
    final concreteCementBags = (p.totalConcreteVolumeM3 * cementKgPerM3 / EngineeringConstants.cementBagKg) * EngineeringConstants.wastageFactor;
    final mortarCementBags = p.wallVolumeM3 * 1.8; // ~1.8 bags per m³ of brick masonry mortar
    p.cementBags = (concreteCementBags + mortarCementBags).ceilToDouble();

    // 8. Steel MT (1.0% by volume in RCC concrete, steel density = 7850 kg/m³)
    p.steelMT = (p.totalConcreteVolumeM3 * 0.010 * EngineeringConstants.steelDensityKgPerM3) / 1000.0;

    // 9. Sand and aggregate
    final sandProportion = mixRatio[1] / totalParts;
    final aggProportion = mixRatio[2] / totalParts;
    final concreteSand = p.totalConcreteVolumeM3 * wetVolumePerM3 * sandProportion * EngineeringConstants.wastageFactor;
    final mortarSand = p.wallVolumeM3 * 0.20; // sand in brick mortar
    p.sandM3 = concreteSand + mortarSand;
    p.aggregateM3 = p.totalConcreteVolumeM3 * wetVolumePerM3 * aggProportion * EngineeringConstants.wastageFactor;

    // 10. Costs (Material costs + Structural Labour)
    final cementCost = p.cementBags * MaterialRates.cementPerBag;
    final steelCost = p.steelMT * MaterialRates.steelPerMT;
    final sandCost = p.sandM3 * MaterialRates.sandPerCubicM;
    final aggCost = p.aggregateM3 * MaterialRates.aggregatePerCubicM;
    final brickCost = p.brickCount * MaterialRates.brickPerUnit;
    final totalMaterialCost = cementCost + steelCost + sandCost + aggCost + brickCost;

    final structuralLabourCost = totalMaterialCost * 0.38; // ~38% for structural civil labour
    p.structuralCost = totalMaterialCost + structuralLabourCost;

    p.finishingCost = totalMaterialCost * 0.40;
    p.plumbingCost = totalMaterialCost * 0.15;
    p.electricalCost = totalMaterialCost * 0.15;
    p.carpentrycost = totalMaterialCost * 0.12;

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

  // ── Save calculated results back to Hive & Firestore ────────────────────
  static Future<void> saveCalculation(ProjectModel p) async {
    calculate(p);
    p.updatedAt = DateTime.now();
    if (p.isInBox) {
      await p.save();
    } else if (HiveService.isProjectBoxOpen) {
      await HiveService.projectBox.put(p.id, p);
    }
    await syncToFirestore(p);
  }
}
