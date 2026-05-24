import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../widgets/common_widgets.dart';

class CostHistoryScreen extends StatefulWidget {
  const CostHistoryScreen({super.key});

  @override
  State<CostHistoryScreen> createState() => _CostHistoryScreenState();
}

class _CostHistoryScreenState extends State<CostHistoryScreen> {
  String _material = 'Cement';
  final _materials = ['Cement', 'Steel', 'Sand', 'Aggregate'];

  static const _history = {
    'Cement': [
      ['Jan 2026', '₹360'],
      ['Feb 2026', '₹365'],
      ['Mar 2026', '₹370'],
      ['Apr 2026', '₹375'],
      ['May 2026', '₹380'],
    ],
    'Steel': [
      ['Jan 2026', '₹65,000'],
      ['Feb 2026', '₹65,500'],
      ['Mar 2026', '₹66,800'],
      ['Apr 2026', '₹67,200'],
      ['May 2026', '₹68,000'],
    ],
    'Sand': [
      ['Jan 2026', '₹1,050'],
      ['Feb 2026', '₹1,080'],
      ['Mar 2026', '₹1,120'],
      ['Apr 2026', '₹1,150'],
      ['May 2026', '₹1,200'],
    ],
    'Aggregate': [
      ['Jan 2026', '₹820'],
      ['Feb 2026', '₹840'],
      ['Mar 2026', '₹860'],
      ['Apr 2026', '₹880'],
      ['May 2026', '₹900'],
    ],
  };

  @override
  Widget build(BuildContext context) {
    final rows = _history[_material]!;
    final first = rows.first[1];
    final last = rows.last[1];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppBarWidget(title: 'Cost History'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Price History', style: AppTextStyles.heading2),
            Text('Track how material costs have changed.', style: AppTextStyles.subtitle),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _materials.map((m) => GestureDetector(
                      onTap: () => setState(() => _material = m),
                      child: Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                        decoration: BoxDecoration(
                          color: _material == m ? AppColors.primary : AppColors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: _material == m ? AppColors.primary : AppColors.border),
                        ),
                        child: Text(m, style: TextStyle(
                          color: _material == m ? Colors.white : AppColors.textMedium,
                          fontWeight: FontWeight.w500, fontSize: 13,
                        )),
                      ),
                    )).toList(),
              ),
            ),
            const SizedBox(height: 20),
            // Trend bar
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Simple bar chart
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: rows.asMap().entries.map((e) {
                      final idx = e.key;
                      final isLast = idx == rows.length - 1;
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            width: 36,
                            height: 40.0 + idx * 12,
                            decoration: BoxDecoration(
                              color: isLast ? AppColors.primary : AppColors.iconBgBlue,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(e.value[0].substring(0, 3),
                              style: const TextStyle(fontSize: 10, color: AppColors.textLight)),
                        ],
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('JAN 2026', style: AppTextStyles.label),
                          Text(first, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700)),
                        ],
                      ),
                      const Icon(Icons.trending_up, color: AppColors.warning),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text('MAY 2026', style: AppTextStyles.label),
                          Text(last, style: AppTextStyles.body.copyWith(
                              fontWeight: FontWeight.w700, color: AppColors.primary)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SectionTitle('$_material — MONTHLY RATES'),
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
                                fontWeight: FontWeight.w700,
                                color: isLast ? AppColors.primary : AppColors.textDark)),
                          ],
                        ),
                      ),
                      if (!isLast) const Divider(height: 1),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
