import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../widgets/common_widgets.dart';

class SteelWeightCalculatorScreen extends StatefulWidget {
  const SteelWeightCalculatorScreen({super.key});

  @override
  State<SteelWeightCalculatorScreen> createState() => _SteelWeightCalculatorScreenState();
}

class _SteelWeightCalculatorScreenState extends State<SteelWeightCalculatorScreen> {
  int _selectedDia = 12; // mm
  final _lenCtrl = TextEditingController(text: '12'); // meters (standard bar length)
  final _qtyCtrl = TextEditingController(text: '10'); // number of bars

  final List<int> _standardDiameters = [6, 8, 10, 12, 16, 20, 25, 32];

  @override
  void dispose() {
    _lenCtrl.dispose();
    _qtyCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final length = double.tryParse(_lenCtrl.text) ?? 12.0;
    final qty = int.tryParse(_qtyCtrl.text) ?? 1;

    // Unit weight formula: d^2 / 162.28 kg/m
    final unitWeightKgPerM = (_selectedDia * _selectedDia) / 162.28;
    final totalLengthM = length * qty;
    final totalWeightKg = unitWeightKgPerM * totalLengthM;
    final totalWeightMT = totalWeightKg / 1000.0;
    final totalLengthFt = totalLengthM * 3.28084;
    final approxCostInr = totalWeightKg * 65.0; // ~Rs 65/kg standard TMT steel

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppBarWidget(title: 'Steel Weight Calculator'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Steel Weight Calculator', style: AppTextStyles.heading2),
            Text('Calculate TMT rebar unit weight and total tonnage instantly.', style: AppTextStyles.subtitle),
            const SizedBox(height: 20),

            const Text('BAR DIAMETER (mm)', style: AppTextStyles.label),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _standardDiameters.map((d) {
                final isSelected = _selectedDia == d;
                return GestureDetector(
                  onTap: () => setState(() => _selectedDia = d),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : AppColors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: isSelected ? AppColors.primary : AppColors.border),
                      boxShadow: isSelected
                          ? [BoxShadow(color: AppColors.primary.withValues(alpha: 0.2), blurRadius: 4, offset: const Offset(0, 2))]
                          : null,
                    ),
                    child: Text(
                      '${d}mm',
                      style: TextStyle(
                        color: isSelected ? Colors.white : AppColors.textDark,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: AppTextField(
                    label: 'Length per Bar',
                    hint: '12',
                    controller: _lenCtrl,
                    keyboardType: TextInputType.number,
                    onChanged: (_) => setState(() {}),
                    suffixIcon: const Padding(
                      padding: EdgeInsets.only(right: 12),
                      child: Text('m', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textMedium)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppTextField(
                    label: 'Quantity (Bars)',
                    hint: '10',
                    controller: _qtyCtrl,
                    keyboardType: TextInputType.number,
                    onChanged: (_) => setState(() {}),
                    suffixIcon: const Padding(
                      padding: EdgeInsets.only(right: 12),
                      child: Text('nos', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textMedium)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Highlight Box: Unit Weight Formula
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
                      const Text('UNIT WEIGHT FORMULA', style: TextStyle(color: Colors.white70, fontSize: 11, letterSpacing: 1)),
                      const SizedBox(height: 2),
                      Text('${_selectedDia}² / 162.28', style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700, fontFamily: 'monospace')),
                      Text('= ${unitWeightKgPerM.toStringAsFixed(3)} kg/m', style: const TextStyle(color: Colors.white, fontSize: 14)),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text('IS 1786 Standard', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            const SectionTitle('CALCULATED WEIGHT RESULTS'),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.45,
              children: [
                _ResultCard(
                  icon: Icons.scale_rounded,
                  iconBg: AppColors.iconBgBlue,
                  iconColor: AppColors.primary,
                  title: 'TOTAL WEIGHT (KG)',
                  value: '${totalWeightKg.toStringAsFixed(1)} kg',
                  subText: '${(totalWeightKg / qty).toStringAsFixed(1)} kg per bar',
                ),
                _ResultCard(
                  icon: Icons.local_shipping_outlined,
                  iconBg: AppColors.iconBgOrange,
                  iconColor: AppColors.warning,
                  title: 'TONNAGE (MT)',
                  value: '${totalWeightMT.toStringAsFixed(3)} MT',
                  subText: 'Metric Tons',
                ),
                _ResultCard(
                  icon: Icons.straighten_rounded,
                  iconBg: AppColors.iconBgGreen,
                  iconColor: AppColors.accentGreen,
                  title: 'TOTAL RUNNING LENGTH',
                  value: '${totalLengthM.toStringAsFixed(1)} m',
                  subText: '${totalLengthFt.toStringAsFixed(0)} ft total',
                ),
                _ResultCard(
                  icon: Icons.currency_rupee_rounded,
                  iconBg: AppColors.iconBgPurple,
                  iconColor: Colors.purple,
                  title: 'ESTIMATED COST',
                  value: '₹${approxCostInr.toStringAsFixed(0)}',
                  subText: '@ ₹65 / kg approx',
                ),
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
                'ⓘ Unit weight is calculated using standard IS:1786 formula W = d²/162.28 kg per meter. Standard rebar bundle length is 12 meters (39.37 ft).',
                style: TextStyle(fontSize: 12, color: AppColors.textMedium),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: PrimaryButton(text: 'Done', onPressed: () => Navigator.pop(context)),
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  final IconData icon;
  final Color iconBg, iconColor;
  final String title, value, subText;

  const _ResultCard({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.value,
    required this.subText,
  });

  @override
  Widget build(BuildContext context) => AppCard(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(6)),
                  child: Icon(icon, size: 14, color: iconColor),
                ),
                const SizedBox(width: 6),
                Expanded(child: Text(title, style: AppTextStyles.label, maxLines: 1, overflow: TextOverflow.ellipsis)),
              ],
            ),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                value,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.primary, fontFamily: 'monospace'),
              ),
            ),
            Text(subText, style: AppTextStyles.bodySmall),
          ],
        ),
      );
}
