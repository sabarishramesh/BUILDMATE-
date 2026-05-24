import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../widgets/common_widgets.dart';

class UnitsMeasurementsScreen extends StatefulWidget {
  const UnitsMeasurementsScreen({super.key});

  @override
  State<UnitsMeasurementsScreen> createState() => _UnitsMeasurementsScreenState();
}

class _UnitsMeasurementsScreenState extends State<UnitsMeasurementsScreen> {
  String _area = 'sq.ft';
  String _volume = 'm³';
  String _length = 'm';
  String _currency = '₹ (INR)';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppBarWidget(title: 'Units & Measurements'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Units & Measurements', style: AppTextStyles.heading2),
            Text('Choose default units for your calculations.', style: AppTextStyles.subtitle),
            const SizedBox(height: 20),
            _UnitGroup(
              label: 'AREA',
              options: ['sq.ft', 'sq.m', 'sq.in'],
              selected: _area,
              onSelect: (v) => setState(() => _area = v),
            ),
            const SizedBox(height: 16),
            _UnitGroup(
              label: 'VOLUME',
              options: ['m³', 'cu.ft', 'litres'],
              selected: _volume,
              onSelect: (v) => setState(() => _volume = v),
            ),
            const SizedBox(height: 16),
            _UnitGroup(
              label: 'LENGTH',
              options: ['m', 'ft', 'cm', 'in'],
              selected: _length,
              onSelect: (v) => setState(() => _length = v),
            ),
            const SizedBox(height: 16),
            _UnitGroup(
              label: 'CURRENCY',
              options: ['₹ (INR)', '\$ (USD)', '£ (GBP)'],
              selected: _currency,
              onSelect: (v) => setState(() => _currency = v),
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              text: 'SAVE PREFERENCES',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Preferences saved.')),
                );
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _UnitGroup extends StatelessWidget {
  final String label;
  final List<String> options;
  final String selected;
  final ValueChanged<String> onSelect;

  const _UnitGroup({required this.label, required this.options, required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.label),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: options.map((o) => GestureDetector(
                onTap: () => onSelect(o),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
                  decoration: BoxDecoration(
                    color: selected == o ? AppColors.primary : AppColors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: selected == o ? AppColors.primary : AppColors.border),
                  ),
                  child: Text(o, style: TextStyle(
                    color: selected == o ? Colors.white : AppColors.textMedium,
                    fontWeight: FontWeight.w500, fontSize: 13,
                  )),
                ),
              )).toList(),
        ),
      ],
    );
  }
}
