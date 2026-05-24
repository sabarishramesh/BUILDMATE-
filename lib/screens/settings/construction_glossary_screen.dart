import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../widgets/common_widgets.dart';

class ConstructionGlossaryScreen extends StatefulWidget {
  const ConstructionGlossaryScreen({super.key});

  @override
  State<ConstructionGlossaryScreen> createState() => _ConstructionGlossaryScreenState();
}

class _ConstructionGlossaryScreenState extends State<ConstructionGlossaryScreen> {
  String _query = '';

  static const _terms = [
    ['BUA', 'Built-Up Area. The total floor area including walls and internal spaces.'],
    ['M20', 'Concrete grade with characteristic compressive strength of 20 N/mm² at 28 days.'],
    ['TMT', 'Thermo-Mechanically Treated steel bars used for reinforcement.'],
    ['W/C Ratio', 'Water-Cement Ratio. The ratio of water to cement by weight in a concrete mix.'],
    ['PPC', 'Portland Pozzolana Cement. A blended cement with fly ash for better workability.'],
    ['OPC', 'Ordinary Portland Cement. The most commonly used general-purpose cement.'],
    ['DPC', 'Damp Proof Course. A barrier to prevent moisture rising through walls.'],
    ['RCC', 'Reinforced Cement Concrete. Concrete with steel reinforcement embedded.'],
    ['AAC', 'Autoclaved Aerated Concrete. Lightweight precast building material.'],
    ['Plinth', 'The base or platform of a building that transfers load to the soil.'],
    ['Footing', 'The base of a foundation that distributes the structural load.'],
    ['Lintel', 'A horizontal beam placed above door or window openings.'],
    ['Soffit', 'The underside of an arch, staircase, balcony or beam.'],
    ['Purlin', 'A horizontal roof member that supports roof covering.'],
    ['Curing', 'The process of maintaining moisture in concrete to ensure proper hydration.'],
    ['Efflorescence', 'White crystalline deposits on masonry caused by salt migration.'],
    ['Slump Test', 'A test to measure the workability/consistency of fresh concrete.'],
    ['Cover', 'The minimum concrete thickness protecting embedded steel from corrosion.'],
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = _query.isEmpty
        ? _terms
        : _terms.where((t) => t[0].toLowerCase().contains(_query.toLowerCase()) ||
            t[1].toLowerCase().contains(_query.toLowerCase())).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppBarWidget(title: 'Construction Glossary'),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: (v) => setState(() => _query = v),
              decoration: InputDecoration(
                hintText: 'Search terms…',
                prefixIcon: const Icon(Icons.search, color: AppColors.textLight, size: 20),
                filled: true,
                fillColor: AppColors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: filtered.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (_, i) => AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(filtered[i][0],
                        style: AppTextStyles.body.copyWith(
                            fontWeight: FontWeight.w700, color: AppColors.primary)),
                    const SizedBox(height: 4),
                    Text(filtered[i][1], style: AppTextStyles.body),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
