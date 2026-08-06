import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../routes/app_routes.dart';
import '../../widgets/common_widgets.dart';

import 'package:intl/intl.dart';
import '../../services/hive_service.dart';
import '../../services/project_service.dart';
import '../../models/project_model.dart';

class ReportPreviewScreen extends StatelessWidget {
  final String? projectId;
  const ReportPreviewScreen({super.key, this.projectId});

  @override
  Widget build(BuildContext context) {
    ProjectModel? p;
    if (projectId != null) {
      p = HiveService.projectBox.get(projectId);
    }
    p ??= ProjectService.getActiveProjects().firstOrNull;

    final fmt = NumberFormat('#,##,##0', 'en_IN');
    final name = p?.name ?? 'Sunrise Villa';
    final area = p != null ? '${p.builtUpAreaSqft.toInt()} sq.ft' : '2,400 sq.ft';
    final floors = p != null ? '${p.numberOfFloors}' : '3';
    final slabVol = p != null ? '${p.slabVolumeM3.toStringAsFixed(1)} m³' : '100.3 m³';
    final wallVol = p != null ? '${p.wallVolumeM3.toStringAsFixed(1)} m³' : '74.2 m³';
    final totalConc = p != null ? '${p.totalConcreteVolumeM3.toStringAsFixed(1)} m³' : '112.98 m³';

    final cement = p != null ? '${fmt.format(p.cementBags.toInt())} bags' : '1,136 bags';
    final steel = p != null ? '${p.steelMT.toStringAsFixed(2)} MT' : '8.87 MT';
    final sand = p != null ? '${p.sandM3.toStringAsFixed(1)} m³' : '67.0 m³';
    final agg = p != null ? '${p.aggregateM3.toStringAsFixed(1)} m³' : '104.4 m³';
    final bricks = p != null ? '${fmt.format(p.brickCount)} units' : '37,088 units';

    final structCost = p != null ? '₹${fmt.format(p.structuralCost.toInt())}' : '₹21,03,738';
    final finishCost = p != null ? '₹${fmt.format(p.finishingCost.toInt())}' : '₹6,09,779';
    final plumbCost = p != null ? '₹${fmt.format(p.plumbingCost.toInt())}' : '₹2,28,667';
    final electCost = p != null ? '₹${fmt.format(p.electricalCost.toInt())}' : '₹2,28,667';
    final carpCost = p != null ? '₹${fmt.format(p.carpentrycost.toInt())}' : '₹1,82,933';

    final totalCost = p != null ? '₹${fmt.format(p.totalEstimatedCost.toInt())}' : '₹33,53,784';
    final perSqft = p != null && p.builtUpAreaSqft > 0
        ? 'Approx. ₹${(p.totalEstimatedCost / (p.builtUpAreaSqft * p.numberOfFloors)).toStringAsFixed(0)} per sq.ft'
        : 'Approx. ₹879 per sq.ft';

    final dateStr = p != null ? DateFormat('MMM dd, yyyy').format(p.updatedAt) : 'Aug 03, 2026';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBarWidget(
        title: 'Report Preview',
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: AppColors.primary),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.shareExport, arguments: projectId),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(color: AppColors.iconBgBlue, borderRadius: BorderRadius.circular(10)),
                        child: const Icon(Icons.business, color: AppColors.primary, size: 24),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('BuildMate', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700)),
                            const Text('Construction Estimate Report', style: AppTextStyles.bodySmall),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Divider(),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('RATE SOURCE', style: AppTextStyles.label),
                      const CostConfidenceBadge(),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _Row('Project', name),
                  _Row('Date', dateStr),
                  _Row('Prepared By', 'Site Engineer'),
                  _Row('Status', p?.status ?? 'Active'),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const SectionTitle('STRUCTURAL SUMMARY'),
            AppCard(
              child: Column(
                children: [
                  _Row('Built-up Area', area),
                  const Divider(height: 16),
                  _Row('Floors', floors),
                  const Divider(height: 16),
                  _Row('Slab Volume', slabVol),
                  const Divider(height: 16),
                  _Row('Wall Volume', wallVol),
                  const Divider(height: 16),
                  _Row('Total Concrete', totalConc),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const SectionTitle('MATERIAL QUANTITIES'),
            AppCard(
              child: Column(
                children: [
                  _Row('Cement', cement),
                  const Divider(height: 16),
                  _Row('Steel TMT', steel),
                  const Divider(height: 16),
                  _Row('Sand', sand),
                  const Divider(height: 16),
                  _Row('Aggregate', agg),
                  const Divider(height: 16),
                  _Row('Bricks', bricks),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const SectionTitle('PHASE-WISE COST ESTIMATE'),
            AppCard(
              child: Column(
                children: [
                  _Row('Structural Phase', structCost),
                  const Divider(height: 16),
                  _Row('Finishing Phase', finishCost),
                  const Divider(height: 16),
                  _Row('Plumbing Phase', plumbCost),
                  const Divider(height: 16),
                  _Row('Electrical Phase', electCost),
                  const Divider(height: 16),
                  _Row('Carpentry Phase', carpCost),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('TOTAL ESTIMATED COST', style: TextStyle(color: Colors.white70, fontSize: 12, letterSpacing: 1)),
                  const SizedBox(height: 4),
                  Text(totalCost, style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w800)),
                  Text(perSqft, style: const TextStyle(color: Colors.white60, fontSize: 13)),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: PrimaryButton(
          text: 'SHARE / EXPORT',
          onPressed: () => Navigator.pushNamed(context, AppRoutes.shareExport, arguments: projectId),
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label, value;
  const _Row(this.label, this.value);

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.body),
          Text(value, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
        ],
      );
}
