import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../routes/app_routes.dart';
import '../../services/project_service.dart';
import '../../services/hive_service.dart';
import '../../widgets/common_widgets.dart';

class SlabCalculationScreen extends StatelessWidget {
  final String projectId;
  const SlabCalculationScreen({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
    final p = HiveService.projectBox.get(projectId);
    if (p == null) return const Scaffold(body: Center(child: Text('Project not found')));

    final areaSqm = p.builtUpAreaSqft * 0.0929;
    final slabM = p.slabThicknessMm / 1000.0;
    final slabPerFloor = areaSqm * slabM;
    final total = slabPerFloor * p.numberOfFloors;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBarWidget(title: 'Slab Calculation'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Input recap
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('INPUT RECAP', style: AppTextStyles.label),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _Recap('AREA', '${p.builtUpAreaSqft.toInt()} sq.ft'),
                      _Recap('FLOORS', '${p.numberOfFloors}'),
                      _Recap('SLAB THICK.', '${p.slabThicknessMm.toInt()} mm'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Breakdown
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('CALCULATION BREAKDOWN', style: AppTextStyles.label),
                  const SizedBox(height: 16),
                  _CalcRow('Floor Area', 'Input in sq.m',
                      '${areaSqm.toStringAsFixed(2)} m²'),
                  _CalcRow('Slab / Floor', 'Area × Thickness',
                      '${slabPerFloor.toStringAsFixed(2)} m²'),
                  _CalcRow('Total Volume', 'Vol/F × Floors',
                      '${total.toStringAsFixed(2)} m³'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Result highlight
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  Text('TOTAL SLAB VOLUME',
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.7), fontSize: 11, letterSpacing: 1.5)),
                  const SizedBox(height: 8),
                  Text('${total.toStringAsFixed(2)} m³',
                      style: const TextStyle(
                          color: Colors.white, fontSize: 36, fontWeight: FontWeight.w700)),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: PrimaryButton(
          text: 'Next: Wall Volume  →',
          onPressed: () => Navigator.pushNamed(context, AppRoutes.wallCalculation,
              arguments: projectId),
        ),
      ),
    );
  }
}

class _Recap extends StatelessWidget {
  final String label, value;
  const _Recap(this.label, this.value);
  @override
  Widget build(BuildContext context) => Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: AppTextStyles.label),
            Text(value, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
          ],
        ),
      );
}

class _CalcRow extends StatelessWidget {
  final String title, formula, result;
  const _CalcRow(this.title, this.formula, this.result);
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
                Text(formula, style: AppTextStyles.bodySmall),
              ],
            ),
            Text(result, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700, color: AppColors.primary)),
          ],
        ),
      );
}
