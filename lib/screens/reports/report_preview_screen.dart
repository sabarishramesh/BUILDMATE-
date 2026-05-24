import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../routes/app_routes.dart';
import '../../widgets/common_widgets.dart';

class ReportPreviewScreen extends StatelessWidget {
  final String? projectId;
  const ReportPreviewScreen({super.key, this.projectId});

  @override
  Widget build(BuildContext context) {
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
                            Text('Nexus Build', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700)),
                            const Text('Construction Estimate Report', style: AppTextStyles.bodySmall),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Divider(),
                  const SizedBox(height: 8),
                  _Row('Project', 'Sunrise Villa'),
                  _Row('Date', 'May 24, 2026'),
                  _Row('Prepared By', 'Site Engineer'),
                  _Row('Status', 'Active'),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const SectionTitle('STRUCTURAL SUMMARY'),
            AppCard(
              child: Column(
                children: [
                  _Row('Built-up Area', '2,400 sq.ft'),
                  const Divider(height: 16),
                  _Row('Floors', '2'),
                  const Divider(height: 16),
                  _Row('Slab Volume', '45.2 m³'),
                  const Divider(height: 16),
                  _Row('Wall Volume', '28.7 m³'),
                  const Divider(height: 16),
                  _Row('Total Concrete', '73.9 m³'),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const SectionTitle('MATERIAL QUANTITIES'),
            AppCard(
              child: Column(
                children: [
                  _Row('Cement', '1,062 bags'),
                  const Divider(height: 16),
                  _Row('Steel TMT', '2.66 MT'),
                  const Divider(height: 16),
                  _Row('Sand', '18.5 m³'),
                  const Divider(height: 16),
                  _Row('Aggregate', '37.0 m³'),
                  const Divider(height: 16),
                  _Row('Bricks', '14,350 units'),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const SectionTitle('PHASE-WISE COST ESTIMATE'),
            AppCard(
              child: Column(
                children: [
                  _Row('Structural (40%)', '₹8,44,000'),
                  const Divider(height: 16),
                  _Row('Finishing (25%)', '₹5,27,500'),
                  const Divider(height: 16),
                  _Row('Plumbing (12%)', '₹2,53,200'),
                  const Divider(height: 16),
                  _Row('Electrical (13%)', '₹2,74,300'),
                  const Divider(height: 16),
                  _Row('Carpentry (10%)', '₹2,11,000'),
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
                children: const [
                  Text('TOTAL ESTIMATED COST', style: TextStyle(color: Colors.white70, fontSize: 12, letterSpacing: 1)),
                  SizedBox(height: 4),
                  Text('₹21,10,000', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w800)),
                  Text('Approx. ₹879 per sq.ft', style: TextStyle(color: Colors.white60, fontSize: 13)),
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
