import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../constants/engineering_constants.dart';
import '../../routes/app_routes.dart';
import '../../services/hive_service.dart';
import '../../widgets/common_widgets.dart';

class WallCalculationScreen extends StatelessWidget {
  final String projectId;
  const WallCalculationScreen({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
    final p = HiveService.projectBox.get(projectId);
    if (p == null) return const Scaffold(body: Center(child: Text('Project not found')));

    final areaSqm   = p.builtUpAreaSqft * 0.0929;
    final perimM    = 4 * math.sqrt(areaSqm);
    final totalWallH = p.floorHeightM * p.numberOfFloors;
    final grossArea  = perimM * totalWallH;
    final deduction  = grossArea * EngineeringConstants.wallOpeningDeductionFactor;
    final netArea    = grossArea - deduction;
    final wallM      = p.wallThicknessMm / 1000.0;
    final volume     = netArea * wallM;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBarWidget(title: 'Wall Calculation'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('PROJECT PARAMETERS', style: AppTextStyles.label),
                  const SizedBox(height: 12),
                  Row(children: [
                    _Cell('BASE AREA', '${areaSqm.toStringAsFixed(2)} m²'),
                    _Cell('FLOORS', '${p.numberOfFloors}'),
                  ]),
                  const SizedBox(height: 8),
                  Row(children: [
                    _Cell('FLOOR HEIGHT', '${p.floorHeightM.toStringAsFixed(2)} m'),
                    _Cell('WALL THICKNESS', '${wallM.toStringAsFixed(2)} m'),
                  ]),
                ],
              ),
            ),
            const SizedBox(height: 16),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('CALCULATION BREAKDOWN', style: AppTextStyles.label),
                  const SizedBox(height: 16),
                  _Row('Perimeter estimation', '${perimM.toStringAsFixed(2)} m'),
                  _Row('Total Wall Height (${p.numberOfFloors} Floors)', '${totalWallH.toStringAsFixed(2)} m'),
                  _Row('Gross Wall Area', '${grossArea.toStringAsFixed(2)} m²', bold: true),
                  _Row('Deductions (Openings)', '- ${deduction.toStringAsFixed(2)} m²', color: AppColors.error),
                  Text('Doors & Windows', style: AppTextStyles.bodySmall),
                  const SizedBox(height: 8),
                  _Row('Net Wall Volume', '${netArea.toStringAsFixed(2)} m² × ${wallM.toStringAsFixed(1)}m', bold: true),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.accentGreen,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  Text('TOTAL WALL VOLUME',
                      style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 11, letterSpacing: 1.5)),
                  const SizedBox(height: 8),
                  Text('${volume.toStringAsFixed(2)} m³',
                      style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  Text('Openings deducted: ~15% for doors and windows',
                      style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 11)),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: PrimaryButton(
          text: 'Next: Total Concrete  →',
          onPressed: () => Navigator.pushNamed(context, AppRoutes.concreteSummary,
              arguments: projectId),
        ),
      ),
    );
  }
}

class _Cell extends StatelessWidget {
  final String label, value;
  const _Cell(this.label, this.value);
  @override
  Widget build(BuildContext context) => Expanded(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: AppTextStyles.label),
          Text(value, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
        ]),
      );
}

class _Row extends StatelessWidget {
  final String label, value;
  final bool bold;
  final Color? color;
  const _Row(this.label, this.value, {this.bold = false, this.color});
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(label, style: bold ? AppTextStyles.body.copyWith(fontWeight: FontWeight.w600) : AppTextStyles.body),
          Text(value, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700, color: color ?? AppColors.textDark)),
        ]),
      );
}
