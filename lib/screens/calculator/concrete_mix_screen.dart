import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../constants/engineering_constants.dart';
import '../../widgets/common_widgets.dart';

class ConcreteMixScreen extends StatefulWidget {
  const ConcreteMixScreen({super.key});

  @override
  State<ConcreteMixScreen> createState() => _ConcreteMixScreenState();
}

class _ConcreteMixScreenState extends State<ConcreteMixScreen> {
  String _grade = 'M20';
  final _volCtrl = TextEditingController(text: '10');

  @override
  void dispose() { _volCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final vol = double.tryParse(_volCtrl.text) ?? 10.0;
    final ratios = EngineeringConstants.mixRatios[_grade] ?? [1, 1.5, 3];
    final total = ratios[0] + ratios[1] + ratios[2];
    final dry = vol * EngineeringConstants.dryToWetFactor * EngineeringConstants.wastageFactor;
    final cementKg = dry * (ratios[0] / total) * 1440;
    final cementBags = (cementKg / 50).ceil();
    final sand = dry * (ratios[1] / total);
    final agg  = dry * (ratios[2] / total);
    final water = cementKg * EngineeringConstants.waterCementRatio;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppBarWidget(title: 'Concrete Mix Ratio'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Concrete Mix Ratio', style: AppTextStyles.heading2),
            Text('Calculate material quantities for standard and custom mixes.', style: AppTextStyles.subtitle),
            const SizedBox(height: 20),
            const Text('MIX GRADE SELECTOR', style: AppTextStyles.label),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: ['M15', 'M20', 'M25', 'M30', 'Custom'].map((m) => GestureDetector(
                    onTap: () => setState(() => _grade = m == 'Custom' ? 'M20' : m),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: _grade == m ? AppColors.primary : AppColors.white,
                        shape: BoxShape.circle,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: _grade == m ? AppColors.primary : AppColors.border),
                      ),
                      child: Text(m,
                          style: TextStyle(
                              color: _grade == m ? Colors.white : AppColors.textMedium,
                              fontWeight: FontWeight.w600)),
                    ),
                  )).toList(),
            ),
            const SizedBox(height: 20),
            AppTextField(
              label: 'Volume Required',
              hint: '10',
              controller: _volCtrl,
              keyboardType: TextInputType.number,
              suffixIcon: const Padding(padding: EdgeInsets.only(right: 12), child: Text('m³', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textMedium))),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('MIX RATIO',
                          style: TextStyle(color: Colors.white70, fontSize: 11, letterSpacing: 1)),
                      Text('${ratios[0].toStringAsFixed(0)} : ${ratios[1]} : ${ratios[2].toStringAsFixed(0)}',
                          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
                      const Text('(Cement : Sand : Aggregate)',
                          style: TextStyle(color: Colors.white60, fontSize: 12)),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text('W/C Ratio: ${EngineeringConstants.waterCementRatio}',
                        style: const TextStyle(color: Colors.white, fontSize: 11)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const SectionTitle('MATERIAL ESTIMATE'),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.6,
              children: [
                _Card(Icons.inventory_2_outlined, AppColors.iconBgBlue, AppColors.primary,
                    'CEMENT', '${cementKg.toStringAsFixed(0)} kg', '$cementBags bags'),
                _Card(Icons.water_drop_outlined, AppColors.iconBgGreen, AppColors.accentGreen,
                    'SAND', '${sand.toStringAsFixed(2)} m³', 'Approx ${(sand * 1.6).toStringAsFixed(1)} tons'),
                _Card(Icons.circle, AppColors.iconBgOrange, AppColors.warning,
                    'AGGREGATE', '${agg.toStringAsFixed(2)} m³', '20mm standard'),
                _Card(Icons.opacity, AppColors.iconBgBlue, AppColors.info,
                    'WATER', '${water.toStringAsFixed(0)} litres', 'Portable source'),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.border),
              ),
              child: const Text(
                'ⓘ  Results include 20% wastage factor and 54% dry-to-wet conversion coefficient.',
                style: TextStyle(fontSize: 12, color: AppColors.textMedium),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: PrimaryButton(text: '+ Add to Estimate', onPressed: () => Navigator.pop(context)),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final IconData icon;
  final Color iconBg, iconColor;
  final String title, main, sub;
  const _Card(this.icon, this.iconBg, this.iconColor, this.title, this.main, this.sub);

  @override
  Widget build(BuildContext context) => AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(children: [
              Container(padding: const EdgeInsets.all(4), decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(4)),
                  child: Icon(icon, size: 14, color: iconColor)),
              const SizedBox(width: 6),
              Text(title, style: AppTextStyles.label),
            ]),
            Text(main, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.primary)),
            Text(sub, style: AppTextStyles.bodySmall),
          ],
        ),
      );
}
