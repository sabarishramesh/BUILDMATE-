import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../widgets/common_widgets.dart';

class MaterialDetailScreen extends StatefulWidget {
  final String materialName;
  const MaterialDetailScreen({super.key, required this.materialName});

  @override
  State<MaterialDetailScreen> createState() => _MaterialDetailScreenState();
}

class _MaterialDetailScreenState extends State<MaterialDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() { _tabs.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBarWidget(title: widget.materialName),
      body: Column(
        children: [
          // Header card
          Container(
            color: AppColors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  width: 64, height: 64,
                  decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(14)),
                  child: const Icon(Icons.architecture, color: Colors.white, size: 36),
                ),
                const SizedBox(height: 12),
                Text('Portland Pozzolana Cement (PPC)',
                    style: AppTextStyles.heading3, textAlign: TextAlign.center),
                Text('Grade 43 • General Construction',
                    style: AppTextStyles.bodySmall, textAlign: TextAlign.center),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text('₹380', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: AppColors.primary)),
                    const Text('/bag', style: TextStyle(color: AppColors.textMedium, fontSize: 14)),
                  ],
                ),
                const SizedBox(height: 4),
                const Text('Approx. ₹10,850 per m³', style: AppTextStyles.bodySmall),
                const SizedBox(height: 12),
                TabBar(
                  controller: _tabs,
                  labelColor: AppColors.primary,
                  unselectedLabelColor: AppColors.textMedium,
                  indicatorColor: AppColors.primary,
                  tabs: const [Tab(text: 'Details'), Tab(text: 'Calculator'), Tab(text: 'History')],
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabs,
              children: [
                _DetailsTab(),
                _CalcTab(),
                _HistoryTab(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: PrimaryButton(
          text: '+ ADD TO ESTIMATE',
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }
}

class _DetailsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final rows = [
      ['STANDARD', 'IS 1489 (Part 1)'],
      ['IS CODE', '1489-1:2015'],
      ['DENSITY', '1440 kg/m³'],
      ['AVAILABLE GRADES', '33, 43, 53'],
    ];
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...rows.map((r) => Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(r[0], style: AppTextStyles.label),
                        Text(r[1], style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                ],
              )),
          const SizedBox(height: 16),
          const Text('STORAGE NOTES', style: AppTextStyles.label),
          const SizedBox(height: 8),
          const Text(
            'Store in dry, leak-proof areas. Keep away from moisture. Stack max 10 bags high.',
            style: AppTextStyles.body,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3E0),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(Icons.lightbulb_outline, color: AppColors.warning, size: 18),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Recommended for plastering and masonry work due to its higher finesse and resistance to chemical attacks from soil.',
                    style: TextStyle(fontSize: 13, color: AppColors.warning),
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

class _CalcTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) => const Center(child: Text('Calculator coming soon'));
}

class _HistoryTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) => const Center(child: Text('Price history coming soon'));
}
