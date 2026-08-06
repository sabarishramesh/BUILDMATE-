import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../services/project_service.dart';
import '../../widgets/common_widgets.dart';

class ProjectArchiveScreen extends StatefulWidget {
  const ProjectArchiveScreen({super.key});

  @override
  State<ProjectArchiveScreen> createState() => _ProjectArchiveScreenState();
}

class _ProjectArchiveScreenState extends State<ProjectArchiveScreen> {
  @override
  Widget build(BuildContext context) {
    final archived = ProjectService.getArchivedProjects();
    final fmt = NumberFormat('#,##,##0', 'en_IN');

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBarWidget(
        title: 'Archived Projects',
        actions: [
          IconButton(
            icon: const Icon(Icons.inventory_2_outlined, color: AppColors.textDark),
            onPressed: () {},
          ),
        ],
      ),
      body: archived.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inventory_2_outlined, size: 64, color: AppColors.textLight),
                  const SizedBox(height: 16),
                  const Text('No archived projects', style: AppTextStyles.subtitle),
                ],
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF3CD),
                    borderRadius: BorderRadius.circular(10),
                    border: const Border(
                        left: BorderSide(color: AppColors.warning, width: 3)),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.info_outline, color: AppColors.warning, size: 16),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Archived projects are read-only and can be restored anytime.',
                          style: TextStyle(
                              color: AppColors.warning,
                              fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
                ...archived.map((p) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: AppCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 40, height: 40,
                                  decoration: BoxDecoration(
                                    color: AppColors.border,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(Icons.domain,
                                      color: AppColors.textLight, size: 20),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(p.name, style: AppTextStyles.heading3.copyWith(fontSize: 15)),
                                      Text(
                                        'Archived on ${p.updatedAt.day}/${p.updatedAt.month}/${p.updatedAt.year}',
                                        style: AppTextStyles.bodySmall,
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    const Text('ESTIMATED COST', style: AppTextStyles.label),
                                    Text('₹${fmt.format(p.totalEstimatedCost.toInt())}',
                                        style: AppTextStyles.body.copyWith(
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.primary)),
                                  ],
                                ),
                              ],
                            ),
                            const Divider(height: 20),
                            Row(
                              children: [
                                OutlinedButton(
                                  onPressed: () async {
                                    await ProjectService.restoreProject(p.id);
                                    setState(() {});
                                  },
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: AppColors.primary,
                                    side: const BorderSide(color: AppColors.primary),
                                  ),
                                  child: const Text('Restore'),
                                ),
                                const SizedBox(width: 12),
                                TextButton(
                                  onPressed: () async {
                                    final ok = await showDialog<bool>(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                        title: const Text('Permanently Delete?'),
                                        content: const Text('This cannot be undone.'),
                                        actions: [
                                          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                                          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete', style: TextStyle(color: Colors.red))),
                                        ],
                                      ),
                                    );
                                    if (ok == true) {
                                      await ProjectService.deleteProject(p.id);
                                      setState(() {});
                                    }
                                  },
                                  child: const Text('Delete',
                                      style: TextStyle(color: AppColors.error)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )),
              ],
            ),
    );
  }
}
