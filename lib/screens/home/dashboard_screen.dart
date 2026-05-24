import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../routes/app_routes.dart';
import '../../services/auth_service.dart';
import '../../services/project_service.dart';
import '../../widgets/common_widgets.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good Morning';
    if (h < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthService.currentUser;
    final projects = ProjectService.getActiveProjects();
    final fmt = NumberFormat('#,##,##0', 'en_IN');

    // Aggregate totals across all projects
    double totalCost = 0, totalConcrete = 0, totalCement = 0,
           totalSteel = 0;
    int totalBricks = 0;
    for (final p in projects) {
      totalCost += p.totalEstimatedCost;
      totalConcrete += p.totalConcreteVolumeM3;
      totalCement += p.cementBags;
      totalSteel += p.steelMT;
      totalBricks += p.brickCount;
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async => setState(() {}),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${_greeting()}, ${user?.fullName.split(' ').first ?? 'User'} 👋',
                      style: AppTextStyles.heading3,
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.notifications_outlined,
                              color: AppColors.textDark),
                          onPressed: () => Navigator.pushNamed(
                              context, AppRoutes.notifications),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pushNamed(
                              context, AppRoutes.userProfile),
                          child: CircleAvatar(
                            backgroundColor: AppColors.primary,
                            radius: 18,
                            child: Text(
                              (user?.fullName.isNotEmpty == true)
                                  ? user!.fullName
                                      .substring(0, 2)
                                      .toUpperCase()
                                  : 'U',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Portfolio value card
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('TOTAL PORTFOLIO VALUE',
                          style: AppTextStyles.label),
                      const SizedBox(height: 8),
                      Text('₹${fmt.format(totalCost.toInt())}',
                          style: AppTextStyles.bigNumber.copyWith(
                              fontSize: 28, color: AppColors.primary)),
                      const SizedBox(height: 4),
                      Text('${projects.length} active projects · Updated today',
                          style: AppTextStyles.bodySmall),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // 4 stat cards
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.6,
                  children: [
                    _StatCard(
                      icon: Icons.layers_outlined,
                      iconBg: AppColors.iconBgBlue,
                      iconColor: AppColors.primary,
                      value: '${totalConcrete.toStringAsFixed(0)} m³',
                      label: 'Concrete',
                    ),
                    _StatCard(
                      icon: Icons.inventory_2_outlined,
                      iconBg: AppColors.iconBgGreen,
                      iconColor: AppColors.accentGreen,
                      value: '${fmt.format(totalCement.toInt())} bags',
                      label: 'Cement',
                    ),
                    _StatCard(
                      icon: Icons.linear_scale,
                      iconBg: AppColors.iconBgOrange,
                      iconColor: AppColors.warning,
                      value: '${totalSteel.toStringAsFixed(2)} MT',
                      label: 'Steel',
                    ),
                    _StatCard(
                      icon: Icons.grid_view_outlined,
                      iconBg: AppColors.iconBgRed,
                      iconColor: AppColors.error,
                      value: '${fmt.format(totalBricks)} nos',
                      label: 'Bricks',
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Recent projects
                const SectionTitle('RECENT PROJECTS'),
                if (projects.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          Icon(Icons.architecture,
                              size: 48, color: AppColors.textLight),
                          const SizedBox(height: 12),
                          const Text('No projects yet',
                              style: AppTextStyles.subtitle),
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed: () =>
                                Navigator.pushNamed(context, AppRoutes.newProject),
                            child: const Text('Create your first project'),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  ...projects.take(3).map((p) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _ProjectCard(project: p),
                      )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String value;
  final String label;

  const _StatCard({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: AppTextStyles.cardValue.copyWith(fontSize: 16)),
              Text(label, style: AppTextStyles.bodySmall),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProjectCard extends StatelessWidget {
  final dynamic project;
  const _ProjectCard({required this.project});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: () => Navigator.pushNamed(context, AppRoutes.projectDetail,
          arguments: project.id),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.iconBgBlue,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.domain, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(project.name,
                        style: AppTextStyles.body.copyWith(
                            fontWeight: FontWeight.w600)),
                    Text('${project.progressPercent.toInt()}%',
                        style: TextStyle(
                            fontSize: 12,
                            color: project.progressPercent >= 100
                                ? AppColors.accentGreen
                                : AppColors.warning,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
                Text(
                  '${project.location.isNotEmpty ? project.location : 'No location'} · ${project.builtUpAreaSqft.toInt()} sq.ft',
                  style: AppTextStyles.bodySmall,
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: project.progressPercent / 100,
                    backgroundColor: AppColors.border,
                    color: AppColors.accentGreen,
                    minHeight: 4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
