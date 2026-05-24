import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../constants/engineering_constants.dart';
import '../../services/hive_service.dart';
import '../../widgets/common_widgets.dart';

class SteelReinforcementScreen extends StatefulWidget {
  final String projectId;
  const SteelReinforcementScreen({super.key, required this.projectId});

  @override
  State<SteelReinforcementScreen> createState() => _SteelReinforcementScreenState();
}

class _SteelReinforcementScreenState extends State<SteelReinforcementScreen> {
  double _pct = EngineeringConstants.defaultSteelPercentage;
  int _grade = 1; // 0=Fe415 1=Fe500 2=Fe550

  @override
  Widget build(BuildContext context) {
    final p = HiveService.projectBox.get(widget.projectId);
    if (p == null) return const Scaffold(body: Center(child: Text('Not found')));

    final steelKg = p.totalConcreteVolumeM3 * (_pct / 100) * EngineeringConstants.steelDensityKgPerM3;
    final steelMT = steelKg / 1000;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppBarWidget(title: 'Steel / TMT Reinforcement'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.iconBgBlue,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, color: AppColors.primary, size: 16),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Steel is estimated at 1.0%–1.5% of concrete volume for residential RCC structures.',
                      style: TextStyle(fontSize: 13, color: AppColors.primary),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            AppCard(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('CONCRETE VOLUME', style: AppTextStyles.label),
                  Row(
                    children: [
                      Text('${p.totalConcreteVolumeM3.toStringAsFixed(2)} m³',
                          style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700)),
                      const SizedBox(width: 6),
                      const Icon(Icons.lock_outline, size: 14, color: AppColors.textLight),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('STEEL PERCENTAGE', style: AppTextStyles.label),
                Text('${_pct.toStringAsFixed(1)}%',
                    style: AppTextStyles.label.copyWith(color: AppColors.primary)),
              ],
            ),
            Slider(
              value: _pct,
              min: EngineeringConstants.minSteelPercentage,
              max: EngineeringConstants.maxSteelPercentage,
              divisions: 12,
              activeColor: AppColors.primary,
              onChanged: (v) => setState(() => _pct = v),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('MIN ${EngineeringConstants.minSteelPercentage}%', style: AppTextStyles.bodySmall),
                Text('MAX ${EngineeringConstants.maxSteelPercentage}%', style: AppTextStyles.bodySmall),
              ],
            ),
            const SizedBox(height: 24),
            Center(
              child: Text('${_pct.toStringAsFixed(1)}%',
                  style: AppTextStyles.bigNumber.copyWith(fontSize: 40)),
            ),
            const SizedBox(height: 20),
            const Text('STEEL GRADE', style: AppTextStyles.label),
            const SizedBox(height: 8),
            Row(
              children: ['Fe415', 'Fe500', 'Fe550'].asMap().entries.map((e) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () => setState(() => _grade = e.key),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: _grade == e.key ? AppColors.primary : AppColors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: _grade == e.key ? AppColors.primary : AppColors.border),
                        ),
                        child: Text(e.value,
                            style: TextStyle(
                                color: _grade == e.key ? Colors.white : AppColors.textMedium,
                                fontWeight: FontWeight.w600)),
                      ),
                    ),
                  )).toList(),
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('REQUIRED STEEL',
                      style: TextStyle(color: Colors.white70, fontSize: 11, letterSpacing: 1.5)),
                  const SizedBox(height: 8),
                  Text('${steelMT.toStringAsFixed(2)} MT',
                      style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.w700)),
                  Text('${steelKg.toStringAsFixed(0)} kg',
                      style: const TextStyle(color: Colors.white70, fontSize: 14)),
                  const SizedBox(height: 8),
                  Text('12mm bar = 0.888 kg/m',
                      style: const TextStyle(color: Colors.white54, fontSize: 12)),
                ],
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
