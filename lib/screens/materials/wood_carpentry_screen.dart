import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../widgets/common_widgets.dart';

class WoodCarpentryScreen extends StatefulWidget {
  const WoodCarpentryScreen({super.key});

  @override
  State<WoodCarpentryScreen> createState() => _WoodCarpentryScreenState();
}

class _WoodCarpentryScreenState extends State<WoodCarpentryScreen> {
  String _tab = 'All';
  final _tabs = ['All', 'Plywood', 'Doors', 'Windows', 'Fixtures'];

  static const _items = [
    _Item('18mm BWR Plywood', 'Boiling Water Resistant', '\$85.50', Colors.brown),
    _Item('12mm Commercial Ply', 'Standard Grade', '\$62.00', Colors.brown),
    _Item('Teak Wood Door Frame', '7ft × 3ft standard', '\$210.00', Color(0xFF6D4C41)),
    _Item('UPVC Window 3ft×4ft', 'Double Glazed / White', '\$145.00', Colors.blueGrey),
    _Item('Gypsum False Ceiling', 'Per Sq Ft. Rate', '\$12.50', Colors.grey),
    _Item('Vitrified Tiles 2×2', 'Glossy Finish / Box of 4', '\$38.90', Colors.blueAccent),
    _Item('SS Hinges 4 inch', 'Stainless Steel / Grade 304', '\$4.20', Colors.blueGrey),
    _Item('Mortise Door Lock', 'Chrome Finish / 3 Keys', '\$45.00', Colors.blueGrey),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppBarWidget(title: 'Wood & Carpentry'),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Wood & Carpentry', style: AppTextStyles.heading2),
                Text('Browse premium materials for civil engineering projects.',
                    style: AppTextStyles.subtitle),
                const SizedBox(height: 12),
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: _tabs.map((t) => GestureDetector(
                    onTap: () => setState(() => _tab = t),
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                      decoration: BoxDecoration(
                        color: _tab == t ? AppColors.primary : AppColors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: _tab == t ? AppColors.primary : AppColors.border),
                      ),
                      child: Text(t, style: TextStyle(
                        color: _tab == t ? Colors.white : AppColors.textMedium,
                        fontWeight: FontWeight.w500, fontSize: 13,
                      )),
                    ),
                  )).toList(),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                const Padding(padding: EdgeInsets.only(bottom: 8), child: SectionTitle('MATERIALS CATALOG')),
                ..._items.map((item) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: AppCard(
                        child: Row(
                          children: [
                            Container(
                              width: 40, height: 40,
                              decoration: BoxDecoration(
                                color: item.color.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(Icons.carpenter, color: item.color, size: 20),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item.name, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
                                  Text(item.desc, style: AppTextStyles.bodySmall),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(item.price, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700)),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: AppColors.accentGreen),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Text('Add',
                                      style: TextStyle(color: AppColors.accentGreen, fontSize: 12, fontWeight: FontWeight.w600)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Item {
  final String name, desc, price;
  final Color color;
  const _Item(this.name, this.desc, this.price, this.color);
}
