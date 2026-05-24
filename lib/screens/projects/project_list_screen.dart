import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../routes/app_routes.dart';
import '../../services/project_service.dart';
import '../../models/project_model.dart';
import '../../widgets/common_widgets.dart';

class ProjectListScreen extends StatefulWidget {
  const ProjectListScreen({super.key});

  @override
  State<ProjectListScreen> createState() => _ProjectListScreenState();
}

class _ProjectListScreenState extends State<ProjectListScreen> {
  String _filter = 'All';
  String _search = '';
  final _filters = ['All', 'Active', 'Completed', 'Draft'];

  List<ProjectModel> get _projects {
    var list = ProjectService.getActiveProjects();
    if (_search.isNotEmpty) {
      list = list
          .where((p) =>
              p.name.toLowerCase().contains(_search.toLowerCase()) ||
              p.location.toLowerCase().contains(_search.toLowerCase()))
          .toList();
    }
    if (_filter != 'All') {
      list = list.where((p) => p.status == _filter).toList();
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final projects = _projects;
    final fmt = NumberFormat('#,##,##0', 'en_IN');

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('My Projects', style: AppTextStyles.heading2),
                  IconButton(
                    icon: const Icon(Icons.add,
                        color: AppColors.primary, size: 28),
                    onPressed: () => Navigator.pushNamed(
                            context, AppRoutes.newProject)
                        .then((_) => setState(() {})),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: TextField(
                onChanged: (v) => setState(() => _search = v),
                decoration: InputDecoration(
                  hintText: 'Search projects...',
                  hintStyle: TextStyle(color: AppColors.textLight),
                  prefixIcon: const Icon(Icons.search,
                      color: AppColors.textLight, size: 20),
                  filled: true,
                  fillColor: AppColors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: _filters.map((f) {
                  final active = f == _filter;
                  return GestureDetector(
                    onTap: () => setState(() => _filter = f),
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: active ? AppColors.primary : AppColors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: active ? AppColors.primary : AppColors.border,
                        ),
                      ),
                      child: Text(
                        f,
                        style: TextStyle(
                          color:
                              active ? AppColors.white : AppColors.textMedium,
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: projects.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.architecture,
                              size: 64, color: AppColors.textLight),
                          const SizedBox(height: 16),
                          const Text('Found all your projects?',
                              style: AppTextStyles.subtitle),
                          const SizedBox(height: 4),
                          TextButton(
                            onPressed: () => Navigator.pushNamed(
                                    context, AppRoutes.newProject)
                                .then((_) => setState(() {})),
                            child: const Text('Add your first project'),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: () async => setState(() {}),
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: projects.length,
                        itemBuilder: (_, i) {
                          final p = projects[i];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: AppCard(
                              onTap: () => Navigator.pushNamed(
                                      context, AppRoutes.projectDetail,
                                      arguments: p.id)
                                  .then((_) => setState(() {})),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: AppColors.iconBgBlue,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: const Icon(Icons.domain,
                                            color: AppColors.primary, size: 20),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(p.name,
                                            style: AppTextStyles.heading3
                                                .copyWith(fontSize: 16)),
                                      ),
                                      _StatusBadge(p.projectType),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  if (p.location.isNotEmpty)
                                    Row(
                                      children: [
                                        const Icon(Icons.location_on_outlined,
                                            size: 12,
                                            color: AppColors.textLight),
                                        const SizedBox(width: 4),
                                        Text(p.location,
                                            style: AppTextStyles.bodySmall),
                                      ],
                                    ),
                                  const SizedBox(height: 8),
                                  const Divider(height: 1),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      _InfoCell('AREA',
                                          '${p.builtUpAreaSqft.toInt()} sq.ft'),
                                      const SizedBox(width: 24),
                                      _InfoCell('ESTIMATED COST',
                                          '₹${fmt.format(p.totalEstimatedCost.toInt())}',
                                          valueColor: AppColors.primary),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        p.status == 'Completed'
                                            ? 'STATUS'
                                            : 'PROGRESS',
                                        style: AppTextStyles.label,
                                      ),
                                      p.status == 'Completed'
                                          ? Row(children: [
                                              const Icon(
                                                  Icons.check_circle,
                                                  size: 14,
                                                  color: AppColors.accentGreen),
                                              const SizedBox(width: 4),
                                              const Text('Completed',
                                                  style: TextStyle(
                                                      color: AppColors
                                                          .accentGreen,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 12)),
                                            ])
                                          : Text(
                                              '${p.progressPercent.toInt()}%',
                                              style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                  color: AppColors.textMedium),
                                            ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: LinearProgressIndicator(
                                      value: p.progressPercent / 100,
                                      backgroundColor: AppColors.border,
                                      color: AppColors.accentGreen,
                                      minHeight: 5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String type;
  const _StatusBadge(this.type);

  @override
  Widget build(BuildContext context) {
    final isComm = type == 'Commercial';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: isComm
            ? AppColors.iconBgGreen
            : AppColors.iconBgBlue,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        type.toUpperCase(),
        style: TextStyle(
          color: isComm ? AppColors.accentGreen : AppColors.primary,
          fontSize: 9,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _InfoCell extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  const _InfoCell(this.label, this.value, {this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.label),
        const SizedBox(height: 2),
        Text(value,
            style: AppTextStyles.body.copyWith(
              fontWeight: FontWeight.w600,
              color: valueColor ?? AppColors.textDark,
            )),
      ],
    );
  }
}
