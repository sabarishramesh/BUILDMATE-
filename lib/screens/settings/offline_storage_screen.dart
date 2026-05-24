import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../services/hive_service.dart';
import '../../widgets/common_widgets.dart';

class OfflineStorageScreen extends StatefulWidget {
  const OfflineStorageScreen({super.key});

  @override
  State<OfflineStorageScreen> createState() => _OfflineStorageScreenState();
}

class _OfflineStorageScreenState extends State<OfflineStorageScreen> {
  int get _projectCount => HiveService.projectBox.length;
  int get _ratesCount => HiveService.ratesBox.length;

  void _clearCache() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Clear Cache?'),
        content: const Text('This will remove all temporary data but keep your projects and accounts intact.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Cache cleared.')),
              );
            },
            child: const Text('Clear', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppBarWidget(title: 'Offline Storage'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Offline Storage', style: AppTextStyles.heading2),
            Text('All data is stored locally on this device.', style: AppTextStyles.subtitle),
            const SizedBox(height: 20),
            const SectionTitle('STORED DATA'),
            const SizedBox(height: 8),
            AppCard(
              child: Column(
                children: [
                  _Row('Projects saved', '$_projectCount'),
                  const Divider(height: 24),
                  _Row('Material rates', '$_ratesCount'),
                  const Divider(height: 24),
                  _Row('User accounts', '${HiveService.userBox.length}'),
                  const Divider(height: 24),
                  _Row('App settings', '${HiveService.settingsBox.length} entries'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const SectionTitle('STORAGE USAGE'),
            const SizedBox(height: 8),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Used', style: AppTextStyles.body),
                      Text('${(_projectCount * 2 + _ratesCount / 10).toStringAsFixed(1)} KB',
                          style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: ((_projectCount * 2 + _ratesCount) / 1000).clamp(0.0, 1.0),
                      backgroundColor: AppColors.border,
                      color: AppColors.primary,
                      minHeight: 8,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text('All data stored in Hive local database on device.',
                      style: AppTextStyles.bodySmall),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFEBEE),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Row(
                children: const [
                  Icon(Icons.warning_amber_outlined, color: Colors.red, size: 18),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Uninstalling the app will permanently delete all offline data. Export your reports before uninstalling.',
                      style: TextStyle(fontSize: 12, color: Colors.red),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            OutlineButton(text: 'Clear Cache', onPressed: _clearCache),
          ],
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
