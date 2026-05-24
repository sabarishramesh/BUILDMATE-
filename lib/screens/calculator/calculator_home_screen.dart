import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../routes/app_routes.dart';
import '../../services/project_service.dart';
import '../../widgets/common_widgets.dart';

class CalculatorHomeScreen extends StatelessWidget {
  const CalculatorHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final recent = ProjectService.getActiveProjects();
    final current = recent.isNotEmpty ? recent.first : null;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Estimator', style: AppTextStyles.heading2),
                  IconButton(
                    icon: const Icon(Icons.settings_outlined),
                    onPressed: () => Navigator.pushNamed(context, AppRoutes.materialRates),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 3 main calculators
              _CalcTile(
                icon: Icons.architecture,
                iconBg: const Color(0xFFE3F2FD),
                iconColor: AppColors.primary,
                accentColor: AppColors.primary,
                title: 'Structural Calculator',
                subtitle: 'Slab, wall, foundation volumes',
                onTap: () => Navigator.pushNamed(context, AppRoutes.structuralDetails),
              ),
              const SizedBox(height: 12),
              _CalcTile(
                icon: Icons.view_in_ar_outlined,
                iconBg: const Color(0xFFE8F5E9),
                iconColor: AppColors.accentGreen,
                accentColor: AppColors.accentGreen,
                title: 'Material Estimator',
                subtitle: 'Cement, steel, sand, aggregate, bricks',
                onTap: () {
                  if (current != null) {
                    Navigator.pushNamed(context, AppRoutes.materialEstimate,
                        arguments: current.id);
                  } else {
                    Navigator.pushNamed(context, AppRoutes.newProject);
                  }
                },
              ),
              const SizedBox(height: 12),
              _CalcTile(
                icon: Icons.payments_outlined,
                iconBg: const Color(0xFFFFF3E0),
                iconColor: AppColors.warning,
                accentColor: AppColors.warning,
                title: 'Cost Calculator',
                subtitle: 'Total project cost with phase breakdown',
                onTap: () {
                  if (current != null) {
                    Navigator.pushNamed(context, AppRoutes.materialEstimate,
                        arguments: current.id);
                  } else {
                    Navigator.pushNamed(context, AppRoutes.newProject);
                  }
                },
              ),
              const SizedBox(height: 24),

              const SectionTitle('QUICK CALCULATORS'),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 2.2,
                children: [
                  _QuickCalc(icon: Icons.swap_horiz, label: 'Unit Converter',
                      onTap: () => Navigator.pushNamed(context, AppRoutes.unitConverter)),
                  _QuickCalc(icon: Icons.water_drop_outlined, label: 'Concrete Mix',
                      onTap: () => Navigator.pushNamed(context, AppRoutes.concreteMix)),
                  _QuickCalc(icon: Icons.tune, label: 'Steel Weight',
                      onTap: () {
                        if (current != null) {
                          Navigator.pushNamed(context, AppRoutes.steelReinforcement,
                              arguments: current.id);
                        }
                      }),
                  _QuickCalc(icon: Icons.grid_on_outlined, label: 'Brick Count',
                      onTap: () => Navigator.pushNamed(context, AppRoutes.concreteMix)),
                ],
              ),
              const SizedBox(height: 24),

              if (current != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('CURRENT PROJECT',
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 11,
                              letterSpacing: 1)),
                      const SizedBox(height: 4),
                      Text(current.name,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w700)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _Chip('Est: ₹${(current.totalEstimatedCost / 100000).toStringAsFixed(1)}L'),
                          const SizedBox(width: 12),
                          _Chip('Progress: ${current.progressPercent.toInt()}%'),
                        ],
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CalcTile extends StatelessWidget {
  final IconData icon;
  final Color iconBg, iconColor, accentColor;
  final String title, subtitle;
  final VoidCallback onTap;

  const _CalcTile({
    required this.icon, required this.iconBg, required this.iconColor,
    required this.accentColor, required this.title, required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border(left: BorderSide(color: accentColor, width: 4)),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6, offset: const Offset(0, 2))],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(10)),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600, fontSize: 15)),
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

class _QuickCalc extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _QuickCalc({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Icon(icon, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              Expanded(child: Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500))),
            ],
          ),
        ),
      );
}

class _Chip extends StatelessWidget {
  final String text;
  const _Chip(this.text);
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
      );
}
