import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../widgets/common_widgets.dart';

class BrickCountCalculatorScreen extends StatefulWidget {
  const BrickCountCalculatorScreen({super.key});

  @override
  State<BrickCountCalculatorScreen> createState() => _BrickCountCalculatorScreenState();
}

class _BrickCountCalculatorScreenState extends State<BrickCountCalculatorScreen> {
  String _wallType = '9 inch (Main Outer)'; // 9 inch vs 4.5 inch
  final _lenCtrl = TextEditingController(text: '10'); // meters
  final _heightCtrl = TextEditingController(text: '3'); // meters
  final _openingsCtrl = TextEditingController(text: '0'); // sq.m deductions

  @override
  void dispose() {
    _lenCtrl.dispose();
    _heightCtrl.dispose();
    _openingsCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final length = double.tryParse(_lenCtrl.text) ?? 0.0;
    final height = double.tryParse(_heightCtrl.text) ?? 0.0;
    final openings = double.tryParse(_openingsCtrl.text) ?? 0.0;

    final wallThicknessM = _wallType.contains('9') ? 0.230 : 0.115; // 230mm vs 115mm
    final grossAreaSqM = length * height;
    final netAreaSqM = (grossAreaSqM - openings).clamp(0.0, double.infinity);
    final wallVolumeCuM = netAreaSqM * wallThicknessM;

    // Standard brick dimensions: 190 x 90 x 90 mm
    // With 10mm mortar joint: 200 x 100 x 100 mm = 0.002 m3
    // Standard rule: 500 bricks per m3 of brickwork
    final rawBricks = wallVolumeCuM * 500.0;
    final totalBricksWithWastage = (rawBricks * 1.05).ceil(); // 5% wastage

    // Mortar estimation (1:6 mix ratio)
    // Mortar volume is ~25% of total brickwork volume
    final mortarVolCuM = wallVolumeCuM * 0.25;
    final dryMortarVol = mortarVolCuM * 1.4; // 1.4 dry factor for mortar
    final cementBags = (dryMortarVol * (1.0 / 7.0) * 1440.0 / 50.0 * 1.10).ceil(); // 10% wastage
    final sandCuM = dryMortarVol * (6.0 / 7.0) * 1.10;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppBarWidget(title: 'Brick Count Calculator'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Brick Count Calculator', style: AppTextStyles.heading2),
            Text('Calculate brick count, cement & sand for masonry walls.', style: AppTextStyles.subtitle),
            const SizedBox(height: 20),

            const Text('WALL THICKNESS TYPE', style: AppTextStyles.label),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _wallType = '9 inch (Main Outer)'),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _wallType.contains('9') ? AppColors.primary : AppColors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: _wallType.contains('9') ? AppColors.primary : AppColors.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('9" Main Wall', style: TextStyle(fontWeight: FontWeight.w700, color: _wallType.contains('9') ? Colors.white : AppColors.textDark)),
                          Text('230mm (Double Brick)', style: TextStyle(fontSize: 11, color: _wallType.contains('9') ? Colors.white70 : AppColors.textMedium)),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _wallType = '4.5 inch (Partition)'),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _wallType.contains('4.5') ? AppColors.primary : AppColors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: _wallType.contains('4.5') ? AppColors.primary : AppColors.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('4.5" Partition', style: TextStyle(fontWeight: FontWeight.w700, color: _wallType.contains('4.5') ? Colors.white : AppColors.textDark)),
                          Text('115mm (Single Brick)', style: TextStyle(fontSize: 11, color: _wallType.contains('4.5') ? Colors.white70 : AppColors.textMedium)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: AppTextField(
                    label: 'Wall Length',
                    hint: '10',
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
                    label: 'Wall Height',
                    hint: '3',
                    controller: _heightCtrl,
                    keyboardType: TextInputType.number,
                    onChanged: (_) => setState(() {}),
                    suffixIcon: const Padding(
                      padding: EdgeInsets.only(right: 12),
                      child: Text('m', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textMedium)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            AppTextField(
              label: 'Openings / Deductions (Doors, Windows)',
              hint: '0',
              controller: _openingsCtrl,
              keyboardType: TextInputType.number,
              onChanged: (_) => setState(() {}),
              suffixIcon: const Padding(
                padding: EdgeInsets.only(right: 12),
                child: Text('m²', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textMedium)),
              ),
            ),
            const SizedBox(height: 20),

            // Highlight Box: Brick Count Output
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
                      const Text('TOTAL BRICKS REQUIRED', style: TextStyle(color: Colors.white70, fontSize: 11, letterSpacing: 1)),
                      const SizedBox(height: 2),
                      Text('$totalBricksWithWastage nos', style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w700, fontFamily: 'monospace')),
                      const Text('Includes 5% site wastage factor', style: TextStyle(color: Colors.white70, fontSize: 12)),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.grid_view_rounded, color: Colors.white, size: 28),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            const SectionTitle('MORTAR & DIMENSION DETAILS'),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.45,
              children: [
                _ResultCard(
                  icon: Icons.view_in_ar_rounded,
                  iconBg: AppColors.iconBgBlue,
                  iconColor: AppColors.primary,
                  title: 'WALL VOLUME',
                  value: '${wallVolumeCuM.toStringAsFixed(2)} m³',
                  subText: '${netAreaSqM.toStringAsFixed(1)} m² net area',
                ),
                _ResultCard(
                  icon: Icons.inventory_2_outlined,
                  iconBg: AppColors.iconBgGreen,
                  iconColor: AppColors.accentGreen,
                  title: 'MORTAR CEMENT',
                  value: '$cementBags bags',
                  subText: '1:6 Mortar Mix Ratio',
                ),
                _ResultCard(
                  icon: Icons.water_drop_outlined,
                  iconBg: AppColors.iconBgOrange,
                  iconColor: AppColors.warning,
                  title: 'MORTAR SAND',
                  value: '${sandCuM.toStringAsFixed(2)} m³',
                  subText: 'Approx ${(sandCuM * 1.6).toStringAsFixed(1)} tons',
                ),
                _ResultCard(
                  icon: Icons.straighten_rounded,
                  iconBg: AppColors.iconBgRed,
                  iconColor: AppColors.error,
                  title: 'STANDARD SIZE',
                  value: '19x9x9 cm',
                  subText: '10mm mortar joint',
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
                'ⓘ Standard Modular Brick size is 190 x 90 x 90 mm (with 10mm mortar = 200 x 100 x 100 mm). Brick density assumes standard 500 bricks per m³ of wall volume.',
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
