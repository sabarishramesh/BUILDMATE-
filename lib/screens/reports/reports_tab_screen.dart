import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../routes/app_routes.dart';
import '../../services/project_service.dart';
import '../../widgets/common_widgets.dart';

class ReportsTabScreen extends StatelessWidget {
  const ReportsTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppBarWidget(title: 'Reports'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Reports & Analytics', style: AppTextStyles.heading2),
            Text('Generate, view and share project reports.', style: AppTextStyles.subtitle),
            const SizedBox(height: 20),
            const SectionTitle('GENERATE'),
            const SizedBox(height: 8),
            _ActionTile(
              icon: Icons.description_outlined,
              iconBg: AppColors.iconBgBlue,
              iconColor: AppColors.primary,
              title: 'Generate Report',
              subtitle: 'Create a full project estimate report',
              onTap: () => Navigator.pushNamed(context, AppRoutes.generateReport),
            ),
            const SizedBox(height: 8),
            _ActionTile(
              icon: Icons.bar_chart,
              iconBg: AppColors.iconBgGreen,
              iconColor: AppColors.accentGreen,
              title: 'Project Analytics',
              subtitle: 'Cost breakdowns and visualisations',
              onTap: () => Navigator.pushNamed(context, AppRoutes.analytics),
            ),
            const SizedBox(height: 8),
            _ActionTile(
              icon: Icons.history,
              iconBg: AppColors.iconBgOrange,
              iconColor: AppColors.warning,
              title: 'Cost History',
              subtitle: 'Track material price changes over time',
              onTap: () => Navigator.pushNamed(context, AppRoutes.costHistory),
            ),
            const SizedBox(height: 20),
            const SectionTitle('RECENT REPORTS'),
            const SizedBox(height: 8),
            if (ProjectService.getActiveProjects().isEmpty)
              EmptyStateWidget(
                icon: Icons.assignment_outlined,
                title: 'No Reports Generated Yet',
                subtitle: 'Generate your first detailed construction estimate report.',
                actionLabel: 'Generate Report',
                onAction: () => Navigator.pushNamed(context, AppRoutes.generateReport),
              )
            else
              ...ProjectService.getActiveProjects().take(3).map((p) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _RecentReportCard(
                      title: '${p.name} – Full Estimate',
                      date: 'Aug 03, 2026',
                      size: '1.2 MB',
                      onTap: () => Navigator.pushNamed(context, AppRoutes.reportPreview, arguments: p.id),
                    ),
                  )),
            const SizedBox(height: 20),
            const SectionTitle('EXPORT'),
            const SizedBox(height: 8),
            _ActionTile(
              icon: Icons.share_outlined,
              iconBg: AppColors.iconBgBlue,
              iconColor: AppColors.info,
              title: 'Share / Export',
              subtitle: 'PDF, CSV or WhatsApp share',
              onTap: () => Navigator.pushNamed(context, AppRoutes.shareExport),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final Color iconBg, iconColor;
  final String title, subtitle;
  final VoidCallback onTap;

  const _ActionTile({
    required this.icon, required this.iconBg, required this.iconColor,
    required this.title, required this.subtitle, required this.onTap,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: AppCard(
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(10)),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
                    Text(subtitle, style: AppTextStyles.bodySmall),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppColors.textLight),
            ],
          ),
        ),
      );
}

class _RecentReportCard extends StatelessWidget {
  final String title, date, size;
  final VoidCallback onTap;
  const _RecentReportCard({required this.title, required this.date, required this.size, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: AppCard(
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: const Color(0xFFFFEBEE), borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.picture_as_pdf, color: Colors.red, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
                    Text('$date • $size', style: AppTextStyles.bodySmall),
                  ],
                ),
              ),
              const Icon(Icons.more_vert, color: AppColors.textLight),
            ],
          ),
        ),
      );
}
