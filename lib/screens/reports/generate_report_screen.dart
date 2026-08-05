import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../routes/app_routes.dart';
import '../../services/project_service.dart';
import '../../utils/notification_helper.dart';
import '../../widgets/common_widgets.dart';

class GenerateReportScreen extends StatefulWidget {
  const GenerateReportScreen({super.key});

  @override
  State<GenerateReportScreen> createState() => _GenerateReportScreenState();
}

class _GenerateReportScreenState extends State<GenerateReportScreen> {
  String? _selectedProjectId;
  bool _includeBreakdown = true;
  bool _includeMaterials = true;
  bool _includeCosts = true;
  bool _includeNotes = false;
  bool _generating = false;

  List<Map<String, String>> get _projects {
    return ProjectService.getActiveProjects().map((p) => {
      'id': p.id,
      'name': p.name,
    }).toList();
  }

  void _generate() async {
    if (_selectedProjectId == null) {
      NotificationHelper.showError(context, 'Please select a project first.');
      return;
    }
    setState(() => _generating = true);
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    setState(() => _generating = false);
    NotificationHelper.showSuccess(context, 'Estimate ready');
    Navigator.pushNamed(context, AppRoutes.reportPreview, arguments: _selectedProjectId);
  }

  @override
  Widget build(BuildContext context) {
    final projects = _projects;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppBarWidget(title: 'Generate Report'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Generate Report', style: AppTextStyles.heading2),
            Text('Create a detailed estimate report for your project.', style: AppTextStyles.subtitle),
            const SizedBox(height: 20),
            const Text('SELECT PROJECT', style: AppTextStyles.label),
            const SizedBox(height: 8),
            AppCard(
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: _selectedProjectId,
                  hint: const Text('Choose a project…', style: TextStyle(color: AppColors.textLight)),
                  items: projects.map((p) => DropdownMenuItem(
                    value: p['id'],
                    child: Text(p['name']!),
                  )).toList(),
                  onChanged: (v) => setState(() => _selectedProjectId = v),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text('INCLUDE IN REPORT', style: AppTextStyles.label),
            const SizedBox(height: 8),
            AppCard(
              child: Column(
                children: [
                  _Toggle('Phase-wise Breakdown', _includeBreakdown, (v) => setState(() => _includeBreakdown = v)),
                  const Divider(height: 1),
                  _Toggle('Materials List', _includeMaterials, (v) => setState(() => _includeMaterials = v)),
                  const Divider(height: 1),
                  _Toggle('Cost Summary', _includeCosts, (v) => setState(() => _includeCosts = v)),
                  const Divider(height: 1),
                  _Toggle('Site Notes', _includeNotes, (v) => setState(() => _includeNotes = v)),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _generating
                ? const Center(child: CircularProgressIndicator())
                : PrimaryButton(text: 'GENERATE REPORT', onPressed: _generate),
          ],
        ),
      ),
    );
  }
}

class _Toggle extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  const _Toggle(this.label, this.value, this.onChanged);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppTextStyles.body),
            Switch(value: value, onChanged: onChanged, activeColor: AppColors.primary),
          ],
        ),
      );
}
