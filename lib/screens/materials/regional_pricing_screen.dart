import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../widgets/common_widgets.dart';

class RegionalPricingScreen extends StatefulWidget {
  const RegionalPricingScreen({super.key});

  @override
  State<RegionalPricingScreen> createState() => _RegionalPricingScreenState();
}

class _RegionalPricingScreenState extends State<RegionalPricingScreen> {
  String _region = 'South India';

  static const _regions = ['South India', 'North India', 'West India', 'East India', 'Central India'];

  static const _data = {
    'South India': [
      ['Cement PPC', '₹370–₹390 / bag'],
      ['Steel TMT Fe500', '₹65,000–₹70,000 / MT'],
      ['River Sand', '₹1,100–₹1,300 / m³'],
      ['20mm Aggregate', '₹850–₹950 / m³'],
    ],
    'North India': [
      ['Cement PPC', '₹360–₹380 / bag'],
      ['Steel TMT Fe500', '₹64,000–₹68,000 / MT'],
      ['River Sand', '₹1,000–₹1,200 / m³'],
      ['20mm Aggregate', '₹800–₹900 / m³'],
    ],
    'West India': [
      ['Cement PPC', '₹375–₹395 / bag'],
      ['Steel TMT Fe500', '₹66,000–₹71,000 / MT'],
      ['River Sand', '₹1,150–₹1,350 / m³'],
      ['20mm Aggregate', '₹880–₹980 / m³'],
    ],
    'East India': [
      ['Cement PPC', '₹355–₹375 / bag'],
      ['Steel TMT Fe500', '₹63,000–₹67,000 / MT'],
      ['River Sand', '₹950–₹1,150 / m³'],
      ['20mm Aggregate', '₹780–₹880 / m³'],
    ],
    'Central India': [
      ['Cement PPC', '₹365–₹385 / bag'],
      ['Steel TMT Fe500', '₹64,500–₹69,000 / MT'],
      ['River Sand', '₹1,050–₹1,250 / m³'],
      ['20mm Aggregate', '₹820–₹920 / m³'],
    ],
  };

  @override
  Widget build(BuildContext context) {
    final rows = _data[_region]!;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppBarWidget(title: 'Regional Pricing'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Regional Pricing', style: AppTextStyles.heading2),
            Text('Approximate material rates by region across India.', style: AppTextStyles.subtitle),
            const SizedBox(height: 16),
            const Text('SELECT REGION', style: AppTextStyles.label),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _regions.map((r) => GestureDetector(
                      onTap: () => setState(() => _region = r),
                      child: Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                        decoration: BoxDecoration(
                          color: _region == r ? AppColors.primary : AppColors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: _region == r ? AppColors.primary : AppColors.border),
                        ),
                        child: Text(r, style: TextStyle(
                          color: _region == r ? Colors.white : AppColors.textMedium,
                          fontWeight: FontWeight.w500, fontSize: 13,
                        )),
                      ),
                    )).toList(),
              ),
            ),
            const SizedBox(height: 20),
            SectionTitle(_region.toUpperCase()),
            const SizedBox(height: 8),
            AppCard(
              child: Column(
                children: rows.asMap().entries.map((e) {
                  final isLast = e.key == rows.length - 1;
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(e.value[0], style: AppTextStyles.body),
                            Text(e.value[1], style: AppTextStyles.body.copyWith(
                              fontWeight: FontWeight.w600, color: AppColors.primary)),
                          ],
                        ),
                      ),
                      if (!isLast) const Divider(height: 1),
                    ],
                  );
                }).toList(),
              ),
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
                'ⓘ  Prices are indicative ranges based on market surveys. Actual rates may vary by city, supplier and season. Last updated: May 2026.',
                style: TextStyle(fontSize: 12, color: AppColors.textMedium),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
