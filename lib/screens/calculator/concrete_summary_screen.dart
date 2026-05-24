import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../routes/app_routes.dart';
import '../../services/hive_service.dart';
import '../../widgets/common_widgets.dart';

class ConcreteSummaryScreen extends StatefulWidget {
  final String projectId;
  const ConcreteSummaryScreen({super.key, required this.projectId});

  @override
  State<ConcreteSummaryScreen> createState() => _ConcreteSummaryScreenState();
}

class _ConcreteSummaryScreenState extends State<ConcreteSummaryScreen> {
  String _mix = 'M20';

  @override
  Widget build(BuildContext context) {
    final p = HiveService.projectBox.get(widget.projectId);
    if (p == null) return const Scaffold(body: Center(child: Text('Not found')));

    final ratios = {'M15': [1,2,4], 'M20': [1,1.5,3], 'M25': [1,1,2], 'M30': [1,0.75,1.5]};
    final r = ratios[_mix]!;
    final total = r[0] + r[1] + r[2];
    final cementProp = r[0] / total;
    final sandProp   = r[1] / total;
    final aggProp    = r[2] / total;

    final concrete = p.totalConcreteVolumeM3;
    final cement   = (concrete * 1.54 * cementProp * 1440 / 50 * 1.10).ceil();
    final sand     = concrete * 1.54 * sandProp * 1.10;
    final agg      = concrete * 1.54 * aggProp  * 1.10;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBarWidget(title: 'Concrete Summary'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            AppCard(
              child: Column(
                children: [
                  _Vol('Slab Volume',  p.slabVolumeM3,       AppColors.primary),
                  _Vol('Wall Volume',  p.wallVolumeM3,       AppColors.accentGreen),
                  _Vol('Foundation',  p.foundationVolumeM3,  AppColors.warning),
                  const Divider(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('GRAND TOTAL CONCRETE',
                          style: AppTextStyles.label),
                      Text('${concrete.toStringAsFixed(2)} m³',
                          style: AppTextStyles.heading3.copyWith(
                              color: AppColors.primary)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('CONCRETE MIX RATIO', style: AppTextStyles.label),
                  const SizedBox(height: 12),
                  Row(
                    children: ['M15','M20','M25','M30'].map((m) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () => setState(() => _mix = m),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: _mix == m ? AppColors.primary : AppColors.background,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: _mix == m ? AppColors.primary : AppColors.border),
                          ),
                          child: Text(m, style: TextStyle(
                            color: _mix == m ? Colors.white : AppColors.textMedium,
                            fontWeight: FontWeight.w600,
                          )),
                        ),
                      ),
                    )).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(child: _MatCard(Icons.inventory_2_outlined, AppColors.iconBgBlue, AppColors.primary, 'CEMENT BAGS', '$cement Bags')),
              const SizedBox(width: 12),
              Expanded(child: _MatCard(Icons.water, AppColors.iconBgGreen, AppColors.accentGreen, 'SAND (m³)', sand.toStringAsFixed(2))),
            ]),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(child: _MatCard(Icons.circle, AppColors.iconBgOrange, AppColors.warning, 'AGGREGATE (m³)', agg.toStringAsFixed(2))),
              const SizedBox(width: 12),
              const Expanded(child: SizedBox()),
            ]),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: PrimaryButton(
          text: 'Proceed to Material Estimate  →',
          onPressed: () => Navigator.pushNamed(context, AppRoutes.materialEstimate,
              arguments: widget.projectId),
        ),
      ),
    );
  }
}

class _Vol extends StatelessWidget {
  final String label;
  final double value;
  final Color color;
  const _Vol(this.label, this.value, this.color);
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(children: [
          Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 8),
          Expanded(child: Text(label, style: AppTextStyles.body)),
          Text('${value.toStringAsFixed(2)} m³',
              style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
        ]),
      );
}

class _MatCard extends StatelessWidget {
  final IconData icon;
  final Color iconBg, iconColor;
  final String label, value;
  const _MatCard(this.icon, this.iconBg, this.iconColor, this.label, this.value);
  @override
  Widget build(BuildContext context) => AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(6)),
              child: Icon(icon, color: iconColor, size: 16)),
            const SizedBox(height: 8),
            Text(label, style: AppTextStyles.label),
            Text(value, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700, fontSize: 16, color: AppColors.primary)),
          ],
        ),
      );
}
