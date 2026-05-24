import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../services/project_service.dart';
import '../../models/project_model.dart';
import '../../widgets/common_widgets.dart';

class ProjectComparisonScreen extends StatefulWidget {
  const ProjectComparisonScreen({super.key});

  @override
  State<ProjectComparisonScreen> createState() => _ProjectComparisonScreenState();
}

class _ProjectComparisonScreenState extends State<ProjectComparisonScreen> {
  ProjectModel? _a, _b;
  final fmt = NumberFormat('#,##,##0', 'en_IN');

  @override
  Widget build(BuildContext context) {
    final projects = ProjectService.getActiveProjects();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppBarWidget(title: 'Compare Projects'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Compare Projects', style: AppTextStyles.heading2),
            const SizedBox(height: 4),
            Text('Analyze metrics between two estimates.', style: AppTextStyles.subtitle),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(child: _ProjectPicker(label: 'Project A', selected: _a, projects: projects, onChanged: (p) => setState(() => _a = p))),
                const SizedBox(width: 12),
                Expanded(child: _ProjectPicker(label: 'Project B', selected: _b, projects: projects, onChanged: (p) => setState(() => _b = p))),
              ],
            ),
            const SizedBox(height: 16),
            PrimaryButton(
              text: '⇄  Compare',
              onPressed: () => setState(() {}),
            ),
            if (_a != null && _b != null) ...[
              const SizedBox(height: 20),
              AppCard(
                child: Table(
                  columnWidths: const {
                    0: FlexColumnWidth(1.4),
                    1: FlexColumnWidth(1),
                    2: FlexColumnWidth(1),
                  },
                  children: [
                    _headerRow('Metric', 'Project A', 'Project B'),
                    _row('Total Area', '${_a!.builtUpAreaSqft.toInt()}', '${_b!.builtUpAreaSqft.toInt()}'),
                    _row('Floors', 'G+${_a!.numberOfFloors - 1}', 'G+${_b!.numberOfFloors - 1}'),
                    _row('Concrete Vol.', '${_a!.totalConcreteVolumeM3.toStringAsFixed(0)} m³', '${_b!.totalConcreteVolumeM3.toStringAsFixed(0)} m³'),
                    _row('Cement Bags', fmt.format(_a!.cementBags.toInt()), fmt.format(_b!.cementBags.toInt())),
                    _row('Steel (MT)', _a!.steelMT.toStringAsFixed(1), _b!.steelMT.toStringAsFixed(1)),
                    _row('Bricks (k)', '${(_a!.brickCount / 1000).toStringAsFixed(0)}k', '${(_b!.brickCount / 1000).toStringAsFixed(0)}k'),
                    _row('Est. Cost', '₹${fmt.format(_a!.totalEstimatedCost.toInt())}', '₹${fmt.format(_b!.totalEstimatedCost.toInt())}'),
                    _row('Cost/sq.ft',
                      _a!.builtUpAreaSqft > 0 ? '₹${(_a!.totalEstimatedCost / _a!.builtUpAreaSqft).toStringAsFixed(0)}' : '-',
                      _b!.builtUpAreaSqft > 0 ? '₹${(_b!.totalEstimatedCost / _b!.builtUpAreaSqft).toStringAsFixed(0)}' : '-',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              if (_a!.totalEstimatedCost > 0 && _b!.totalEstimatedCost > 0)
                AppCard(
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline, color: AppColors.primary, size: 18),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _b!.totalEstimatedCost < _a!.totalEstimatedCost
                              ? 'Project B is ${((1 - _b!.totalEstimatedCost / _a!.totalEstimatedCost) * 100).toStringAsFixed(0)}% more cost-efficient per sq.ft compared to Project A.'
                              : 'Project A is ${((1 - _a!.totalEstimatedCost / _b!.totalEstimatedCost) * 100).toStringAsFixed(0)}% more cost-efficient per sq.ft compared to Project B.',
                          style: const TextStyle(fontSize: 13, color: AppColors.primary),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }

  TableRow _headerRow(String a, String b, String c) => TableRow(
        decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.divider))),
        children: [a, b, c].map((t) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: Text(t, style: AppTextStyles.label),
        )).toList(),
      );

  TableRow _row(String metric, String a, String b) => TableRow(
        decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.divider))),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
            child: Text(metric, style: AppTextStyles.body),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
            child: Text(a, style: AppTextStyles.body.copyWith(color: AppColors.primary)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
            child: Row(
              children: [
                Text(b, style: AppTextStyles.body.copyWith(color: AppColors.accentGreen)),
                const SizedBox(width: 4),
                const Icon(Icons.check_circle, color: AppColors.accentGreen, size: 14),
              ],
            ),
          ),
        ],
      );
}

class _ProjectPicker extends StatelessWidget {
  final String label;
  final ProjectModel? selected;
  final List<ProjectModel> projects;
  final ValueChanged<ProjectModel?> onChanged;
  const _ProjectPicker({required this.label, required this.selected, required this.projects, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.label),
        const SizedBox(height: 6),
        DropdownButtonFormField<ProjectModel>(
          value: selected,
          items: projects.map((p) => DropdownMenuItem(value: p, child: Text(p.name, overflow: TextOverflow.ellipsis))).toList(),
          onChanged: onChanged,
          hint: const Text('Select'),
          decoration: InputDecoration(
            filled: true, fillColor: AppColors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.border)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
        ),
      ],
    );
  }
}
