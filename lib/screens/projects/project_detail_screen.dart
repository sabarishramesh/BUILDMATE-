import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../routes/app_routes.dart';
import '../../services/project_service.dart';
import '../../models/project_model.dart';
import '../../widgets/common_widgets.dart';

class ProjectDetailScreen extends StatefulWidget {
  final String projectId;
  const ProjectDetailScreen({super.key, required this.projectId});

  @override
  State<ProjectDetailScreen> createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends State<ProjectDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final project = ProjectService.getActiveProjects()
            .cast<ProjectModel?>()
            .firstWhere((p) => p?.id == widget.projectId, orElse: () => null) ??
        ProjectService.getArchivedProjects()
            .cast<ProjectModel?>()
            .firstWhere((p) => p?.id == widget.projectId, orElse: () => null);

    if (project == null) {
      return Scaffold(
        appBar: AppBarWidget(title: 'Project'),
        body: const Center(child: Text('Project not found')),
      );
    }

    final fmt = NumberFormat('#,##,##0', 'en_IN');

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: AppColors.textDark, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('${project.name}...',
            style: AppTextStyles.heading3,
            overflow: TextOverflow.ellipsis),
        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.more_vert, color: AppColors.textDark),
            itemBuilder: (_) => [
              const PopupMenuItem(value: 'edit', child: Text('Edit Project')),
              const PopupMenuItem(value: 'archive', child: Text('Archive')),
              const PopupMenuItem(
                  value: 'delete',
                  child: Text('Delete', style: TextStyle(color: Colors.red))),
            ],
            onSelected: (v) async {
              if (v == 'edit') {
                await Navigator.pushNamed(context, AppRoutes.editProject,
                    arguments: project.id);
                setState(() {});
              } else if (v == 'archive') {
                await ProjectService.archiveProject(project.id);
                Navigator.pop(context);
              } else if (v == 'delete') {
                final ok = await showDialog<bool>(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Delete Project?'),
                    content: Text('Delete "${project.name}"? This cannot be undone.'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                      TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete', style: TextStyle(color: Colors.red))),
                    ],
                  ),
                );
                if (ok == true) {
                  await ProjectService.deleteProject(project.id);
                  if (mounted) Navigator.pop(context);
                }
              }
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColors.divider),
        ),
      ),
      body: Column(
        children: [
          // Header info
          Container(
            color: AppColors.white,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(project.name, style: AppTextStyles.heading3),
                              const SizedBox(width: 8),
                              _Badge(project.projectType),
                            ],
                          ),
                          if (project.location.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.location_on_outlined,
                                    size: 12, color: AppColors.textLight),
                                const SizedBox(width: 4),
                                Text(project.location,
                                    style: AppTextStyles.bodySmall),
                              ],
                            ),
                          ],
                          if (project.clientName.isNotEmpty) ...[
                            const SizedBox(height: 2),
                            Text('Client: ${project.clientName}',
                                style: AppTextStyles.bodySmall),
                          ],
                        ],
                      ),
                    ),
                    // Progress circle
                    SizedBox(
                      width: 60,
                      height: 60,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CircularProgressIndicator(
                            value: project.progressPercent / 100,
                            strokeWidth: 6,
                            backgroundColor: AppColors.border,
                            color: AppColors.primary,
                          ),
                          Text('${project.progressPercent.toInt()}%',
                              style: const TextStyle(
                                  fontSize: 11, fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TabBar(
                  controller: _tabs,
                  isScrollable: false,
                  labelColor: AppColors.primary,
                  unselectedLabelColor: AppColors.textMedium,
                  indicatorColor: AppColors.primary,
                  labelStyle: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 13),
                  tabs: const [
                    Tab(text: 'Overview'),
                    Tab(text: 'Materials'),
                    Tab(text: 'Costs'),
                    Tab(text: 'Reports'),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabs,
              children: [
                _OverviewTab(project: project, fmt: fmt),
                _MaterialsTab(project: project, fmt: fmt),
                _CostsTab(project: project, fmt: fmt),
                _ReportsTab(project: project),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PrimaryButton(
              text: 'View Full Estimate',
              onPressed: () => Navigator.pushNamed(
                  context, AppRoutes.materialEstimate,
                  arguments: project.id),
            ),
            const SizedBox(height: 10),
            OutlineButton(
              text: 'Generate Report',
              onPressed: () => Navigator.pushNamed(
                  context, AppRoutes.generateReport),
            ),
          ],
        ),
      ),
    );
  }
}

class _OverviewTab extends StatelessWidget {
  final ProjectModel project;
  final NumberFormat fmt;
  const _OverviewTab({required this.project, required this.fmt});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.8,
            children: [
              _GridCell('TOTAL AREA', '${project.builtUpAreaSqft.toInt()} sq.ft'),
              _GridCell('FLOORS', 'G+${project.numberOfFloors - 1}'),
              _GridCell('SLAB THICKNESS', '${project.slabThicknessMm.toInt()} mm'),
              _GridCell('WALL THICKNESS', '${project.wallThicknessMm.toInt()} mm'),
              _GridCell('CONCRETE VOLUME', '${project.totalConcreteVolumeM3.toStringAsFixed(0)} m³'),
              _GridCell('CEMENT', '${fmt.format(project.cementBags.toInt())} bags'),
              _GridCell('STEEL', '${project.steelMT.toStringAsFixed(1)} MT'),
              _GridCell('BRICKS', '${fmt.format(project.brickCount)} pcs'),
            ],
          ),
        ],
      ),
    );
  }
}

class _GridCell extends StatelessWidget {
  final String label, value;
  const _GridCell(this.label, this.value);

  @override
  Widget build(BuildContext context) => AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(label, style: AppTextStyles.label),
            const SizedBox(height: 4),
            Text(value,
                style: AppTextStyles.body
                    .copyWith(fontWeight: FontWeight.w700, fontSize: 15)),
          ],
        ),
      );
}

class _MaterialsTab extends StatelessWidget {
  final ProjectModel project;
  final NumberFormat fmt;
  const _MaterialsTab({required this.project, required this.fmt});

  @override
  Widget build(BuildContext context) {
    final items = [
      ['Cement (OPC 53)', '${fmt.format(project.cementBags.toInt())} bags'],
      ['Steel / TMT', '${project.steelMT.toStringAsFixed(2)} MT'],
      ['River Sand', '${project.sandM3.toStringAsFixed(2)} m³'],
      ['Coarse Aggregate', '${project.aggregateM3.toStringAsFixed(2)} m³'],
      ['Bricks (First Class)', '${fmt.format(project.brickCount)} nos'],
    ];
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (_, i) => ListTile(
        title: Text(items[i][0]),
        trailing: Text(items[i][1],
            style: AppTextStyles.body
                .copyWith(fontWeight: FontWeight.w600)),
      ),
    );
  }
}

class _CostsTab extends StatelessWidget {
  final ProjectModel project;
  final NumberFormat fmt;
  const _CostsTab({required this.project, required this.fmt});

  @override
  Widget build(BuildContext context) {
    final phases = [
      ['Structural', project.structuralCost],
      ['Finishing', project.finishingCost],
      ['Plumbing', project.plumbingCost],
      ['Electrical', project.electricalCost],
      ['Carpentry', project.carpentrycost],
    ];
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('TOTAL ESTIMATED COST', style: AppTextStyles.label),
              const SizedBox(height: 8),
              Text('₹${fmt.format(project.totalEstimatedCost.toInt())}',
                  style: AppTextStyles.bigNumber),
            ],
          ),
        ),
        const SizedBox(height: 16),
        ...phases.map((p) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: AppCard(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(p[0] as String, style: AppTextStyles.body),
                    Text('₹${fmt.format((p[1] as double).toInt())}',
                        style: AppTextStyles.body
                            .copyWith(fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            )),
      ],
    );
  }
}

class _ReportsTab extends StatelessWidget {
  final ProjectModel project;
  const _ReportsTab({required this.project});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          AppCard(
            onTap: () => Navigator.pushNamed(context, AppRoutes.generateReport),
            child: const Row(
              children: [
                Icon(Icons.picture_as_pdf_outlined, color: AppColors.primary),
                SizedBox(width: 12),
                Text('Generate PDF Report'),
                Spacer(),
                Icon(Icons.chevron_right, color: AppColors.textLight),
              ],
            ),
          ),
          const SizedBox(height: 12),
          AppCard(
            onTap: () => Navigator.pushNamed(context, AppRoutes.shareExport,
                arguments: project.id),
            child: const Row(
              children: [
                Icon(Icons.share_outlined, color: AppColors.primary),
                SizedBox(width: 12),
                Text('Share / Export'),
                Spacer(),
                Icon(Icons.chevron_right, color: AppColors.textLight),
              ],
            ),
          ),
          const SizedBox(height: 12),
          AppCard(
            onTap: () => Navigator.pushNamed(context, AppRoutes.costHistory),
            child: const Row(
              children: [
                Icon(Icons.history, color: AppColors.primary),
                SizedBox(width: 12),
                Text('Cost History'),
                Spacer(),
                Icon(Icons.chevron_right, color: AppColors.textLight),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String text;
  const _Badge(this.text);
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: AppColors.iconBgBlue,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(text,
            style: const TextStyle(
                color: AppColors.primary,
                fontSize: 10,
                fontWeight: FontWeight.w600)),
      );
}
