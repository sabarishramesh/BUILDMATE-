import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../widgets/common_widgets.dart';

class ProjectAnalyticsScreen extends StatefulWidget {
  const ProjectAnalyticsScreen({super.key});

  @override
  State<ProjectAnalyticsScreen> createState() => _ProjectAnalyticsScreenState();
}

class _ProjectAnalyticsScreenState extends State<ProjectAnalyticsScreen> {
  String _period = 'This Month';
  final _periods = ['This Week', 'This Month', 'This Year', 'All Time'];

  final _phases = [
    _Phase('Structural', 0.40, AppColors.primary),
    _Phase('Finishing', 0.25, AppColors.accentGreen),
    _Phase('Electrical', 0.13, AppColors.warning),
    _Phase('Plumbing', 0.12, AppColors.info),
    _Phase('Carpentry', 0.10, const Color(0xFF6D4C41)),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppBarWidget(title: 'Project Analytics'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Analytics', style: AppTextStyles.heading2),
            Text('Visual breakdown of costs and materials.', style: AppTextStyles.subtitle),
            const SizedBox(height: 16),
            // Period selector
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _periods.map((p) => GestureDetector(
                      onTap: () => setState(() => _period = p),
                      child: Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                        decoration: BoxDecoration(
                          color: _period == p ? AppColors.primary : AppColors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: _period == p ? AppColors.primary : AppColors.border),
                        ),
                        child: Text(p, style: TextStyle(
                          color: _period == p ? Colors.white : AppColors.textMedium,
                          fontWeight: FontWeight.w500, fontSize: 13,
                        )),
                      ),
                    )).toList(),
              ),
            ),
            const SizedBox(height: 20),
            // Summary cards
            Row(
              children: [
                Expanded(child: _StatCard('Total Projects', '12', AppColors.iconBgBlue, AppColors.primary)),
                const SizedBox(width: 12),
                Expanded(child: _StatCard('Avg Cost/sqft', '₹875', AppColors.iconBgGreen, AppColors.accentGreen)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _StatCard('Total Estimates', '₹1.2Cr', AppColors.iconBgOrange, AppColors.warning)),
                const SizedBox(width: 12),
                Expanded(child: _StatCard('Cement Bags', '12,450', AppColors.iconBgBlue, AppColors.info)),
              ],
            ),
            const SizedBox(height: 20),
            const SectionTitle('COST DISTRIBUTION'),
            const SizedBox(height: 8),
            AppCard(
              child: Column(
                children: _phases.map((ph) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(ph.name, style: AppTextStyles.body),
                              Text('${(ph.fraction * 100).toStringAsFixed(0)}%',
                                  style: AppTextStyles.body.copyWith(
                                      fontWeight: FontWeight.w700, color: ph.color)),
                            ],
                          ),
                          const SizedBox(height: 6),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: ph.fraction,
                              backgroundColor: AppColors.border,
                              color: ph.color,
                              minHeight: 8,
                            ),
                          ),
                        ],
                      ),
                    )).toList(),
              ),
            ),
            const SizedBox(height: 20),
            const SectionTitle('TOP PROJECTS BY COST'),
            const SizedBox(height: 8),
            ...[
              ['Sunrise Villa', '₹21,10,000', '2,400 sqft'],
              ['Commercial Block A', '₹48,50,000', '5,800 sqft'],
              ['Green Meadows', '₹15,75,000', '1,800 sqft'],
            ].map((p) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: AppCard(
                    child: Row(
                      children: [
                        Container(
                          width: 36, height: 36,
                          decoration: BoxDecoration(
                            color: AppColors.iconBgBlue,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.domain, color: AppColors.primary, size: 18),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(p[0], style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
                              Text(p[2], style: AppTextStyles.bodySmall),
                            ],
                          ),
                        ),
                        Text(p[1], style: AppTextStyles.body.copyWith(
                            fontWeight: FontWeight.w700, color: AppColors.primary)),
                      ],
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

class _Phase {
  final String name;
  final double fraction;
  final Color color;
  const _Phase(this.name, this.fraction, this.color);
}

class _StatCard extends StatelessWidget {
  final String label, value;
  final Color bg, fg;
  const _StatCard(this.label, this.value, this.bg, this.fg);

  @override
  Widget build(BuildContext context) => AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: AppTextStyles.bodySmall),
            const SizedBox(height: 4),
            Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: fg)),
          ],
        ),
      );
}
