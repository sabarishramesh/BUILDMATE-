import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../constants/engineering_constants.dart';
import '../../routes/app_routes.dart';
import '../../services/hive_service.dart';
import '../../widgets/common_widgets.dart';

class MaterialEstimateScreen extends StatelessWidget {
  final String projectId;
  const MaterialEstimateScreen({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
    final p = HiveService.projectBox.get(projectId);
    if (p == null) return const Scaffold(body: Center(child: Text('Not found')));
    final fmt = NumberFormat('#,##,##0', 'en_IN');

    final materials = [
      _Mat('Cement', 'OPC 53 Grade', '${fmt.format(p.cementBags.toInt())} bags',
          '₹${fmt.format((p.cementBags * MaterialRates.cementPerBag).toInt())}',
          AppColors.primary, Icons.inventory_2_outlined),
      _Mat('Steel/TMT', 'Fe 500D', '${p.steelMT.toStringAsFixed(2)} MT',
          '₹${fmt.format((p.steelMT * MaterialRates.steelPerMT).toInt())}',
          AppColors.error, Icons.linear_scale),
      _Mat('River Sand', 'Fine Aggregate', '${p.sandM3.toStringAsFixed(2)} m³',
          '₹${fmt.format((p.sandM3 * MaterialRates.sandPerCubicM).toInt())}',
          const Color(0xFFD4A017), Icons.water_drop_outlined),
      _Mat('Coarse Aggregate', '20mm Crushed Stone', '${p.aggregateM3.toStringAsFixed(2)} m³',
          '₹${fmt.format((p.aggregateM3 * MaterialRates.aggregatePerCubicM).toInt())}',
          AppColors.textMedium, Icons.circle_outlined),
      _Mat('Bricks', 'First Class Red Bricks', '${fmt.format(p.brickCount)} nos',
          '₹${fmt.format((p.brickCount * MaterialRates.brickPerUnit).toInt())}',
          const Color(0xFF8B4513), Icons.grid_view_outlined),
      _Mat('Water', 'Construction Grade',
          '${(p.totalConcreteVolumeM3 * 150).toInt()} litres',
          '₹${fmt.format((p.totalConcreteVolumeM3 * 150 * 0.02).toInt())}',
          AppColors.info, Icons.water),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBarWidget(
        title: 'Material Estimate',
        actions: [
          IconButton(
            icon: const Icon(Icons.download_outlined, color: AppColors.textDark),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.shareExport,
                arguments: projectId),
          ),
        ],
      ),
      body: Column(
        children: [
          // Project header
          Container(
            color: AppColors.white,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.iconBgGreen,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text('ACTIVE',
                            style: TextStyle(
                                color: AppColors.accentGreen,
                                fontSize: 10, fontWeight: FontWeight.w700)),
                      ),
                      const SizedBox(height: 6),
                      Text(p.name,
                          style: AppTextStyles.heading2.copyWith(fontSize: 20)),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text('TOTAL AREA', style: AppTextStyles.label),
                    Text('${p.builtUpAreaSqft.toInt()} sq.ft',
                        style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
                    Text('G+${p.numberOfFloors - 1} Levels',
                        style: AppTextStyles.bodySmall),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const SectionTitle('STRUCTURAL MATERIALS'),
                ...materials.map((m) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: AppCard(
                        child: Row(
                          children: [
                            Container(
                              width: 10, height: 10,
                              decoration: BoxDecoration(color: m.color, shape: BoxShape.circle),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(m.name, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
                                  Text(m.grade, style: AppTextStyles.bodySmall),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(m.qty, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700)),
                                Text(m.cost, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMedium)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )),
                const SizedBox(height: 8),
                const SectionTitle('FINISHING MATERIALS'),
                ...[
                  ['Tiles/Flooring', '${p.builtUpAreaSqft.toInt()} sq.ft estimated'],
                  ['Plaster', '${(p.builtUpAreaSqft * 2).toInt()} sq.ft total wall'],
                  ['Paint', '${(p.builtUpAreaSqft * 0.35).toInt()} Liters (3 Coats)'],
                  ['Wood', 'Teak – 450 cu.ft'],
                ].map((item) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: AppCard(
                        child: Row(
                          children: [
                            Checkbox(
                              value: true,
                              activeColor: AppColors.primary,
                              onChanged: (_) {},
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item[0], style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
                                  Text(item[1], style: AppTextStyles.bodySmall),
                                ],
                              ),
                            ),
                            const Icon(Icons.chevron_right, color: AppColors.textLight),
                          ],
                        ),
                      ),
                    )),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        color: AppColors.white,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('ESTIMATED TOTAL', style: AppTextStyles.label),
                Text('₹${fmt.format(p.totalEstimatedCost.toInt())}',
                    style: AppTextStyles.heading3.copyWith(color: AppColors.primary)),
              ],
            ),
            const SizedBox(height: 12),
            PrimaryButton(
              text: 'Calculate Cost  →',
              onPressed: () => Navigator.pushNamed(context, AppRoutes.generateReport),
            ),
          ],
        ),
      ),
    );
  }
}

class _Mat {
  final String name, grade, qty, cost;
  final Color color;
  final IconData icon;
  const _Mat(this.name, this.grade, this.qty, this.cost, this.color, this.icon);
}
