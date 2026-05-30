import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../routes/app_routes.dart';
import '../../widgets/common_widgets.dart';

class MaterialRatesScreen extends StatefulWidget {
  const MaterialRatesScreen({super.key});

  @override
  State<MaterialRatesScreen> createState() => _MaterialRatesScreenState();
}

class _MaterialRatesScreenState extends State<MaterialRatesScreen> {
  String _filter = 'All';
  final _filters = ['All', 'Structural', 'Finishing', 'Plumbing', 'Electrical'];

  List<Map<String, String>> get _rates {
    final all = [
      {'name': 'Cement (PPC)', 'cat': 'Structural', 'rate': '₹380', 'unit': 'per bag', 'updated': 'May 20'},
      {'name': 'Steel TMT Fe500', 'cat': 'Structural', 'rate': '₹68,000', 'unit': 'per MT', 'updated': 'May 18'},
      {'name': 'River Sand', 'cat': 'Structural', 'rate': '₹1,200', 'unit': 'per m³', 'updated': 'May 15'},
      {'name': '20mm Aggregate', 'cat': 'Structural', 'rate': '₹900', 'unit': 'per m³', 'updated': 'May 15'},
      {'name': 'Red Brick', 'cat': 'Structural', 'rate': '₹8.50', 'unit': 'per unit', 'updated': 'May 10'},
      {'name': 'Vitrified Tiles 2×2', 'cat': 'Finishing', 'rate': '₹55', 'unit': 'per sq.ft', 'updated': 'May 12'},
      {'name': 'Plywood 18mm BWR', 'cat': 'Finishing', 'rate': '₹85', 'unit': 'per sq.ft', 'updated': 'May 8'},
      {'name': 'Interior Paint', 'cat': 'Finishing', 'rate': '₹18', 'unit': 'per sq.ft', 'updated': 'May 5'},
      {'name': 'Cement Plaster', 'cat': 'Finishing', 'rate': '₹22', 'unit': 'per sq.ft', 'updated': 'May 5'},
      {'name': 'CPVC Pipe 1 inch', 'cat': 'Plumbing', 'rate': '₹120', 'unit': 'per metre', 'updated': 'Apr 30'},
      {'name': 'PVC Conduit 25mm', 'cat': 'Electrical', 'rate': '₹45', 'unit': 'per metre', 'updated': 'Apr 28'},
    ];
    if (_filter == 'All') return all;
    return all.where((r) => r['cat'] == _filter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBarWidget(
        title: 'Material Rates',
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: AppColors.primary),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.addCustomRate),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Market Rates', style: AppTextStyles.heading2),
                Text('Current material prices used in calculations.', style: AppTextStyles.subtitle),
                const SizedBox(height: 12),
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: _filters.map((f) => GestureDetector(
                    onTap: () => setState(() => _filter = f),
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                      decoration: BoxDecoration(
                        color: _filter == f ? AppColors.primary : AppColors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: _filter == f ? AppColors.primary : AppColors.border),
                      ),
                      child: Text(f, style: TextStyle(
                        color: _filter == f ? Colors.white : AppColors.textMedium,
                        fontWeight: FontWeight.w500, fontSize: 13,
                      )),
                    ),
                  )).toList(),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _rates.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (_, i) {
                final r = _rates[i];
                return AppCard(
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(r['name']!, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
                            Text('${r['cat']} • Updated ${r['updated']}', style: AppTextStyles.bodySmall),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(r['rate']!, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700, color: AppColors.primary)),
                          Text(r['unit']!, style: AppTextStyles.bodySmall),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: OutlineButton(
          text: 'View Regional Pricing',
          onPressed: () => Navigator.pushNamed(context, AppRoutes.regionalPricing),
        ),
      ),
    );
  }
}
