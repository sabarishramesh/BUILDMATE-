import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../routes/app_routes.dart';
import '../../services/project_service.dart';
import '../../widgets/common_widgets.dart';

import 'package:intl/intl.dart';
import '../../models/project_model.dart';

class StructuralDetailsScreen extends StatefulWidget {
  const StructuralDetailsScreen({super.key});

  @override
  State<StructuralDetailsScreen> createState() => _StructuralDetailsScreenState();
}

class _StructuralDetailsScreenState extends State<StructuralDetailsScreen> {
  final _areaCtrl = TextEditingController(text: '2400');
  int _floors = 3;
  double _floorH = 3.0;
  double _slabMm = 150;
  double _wallMm = 230;
  bool _basement = false;

  @override
  void initState() {
    super.initState();
    _areaCtrl.addListener(_onAreaChanged);
  }

  void _onAreaChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    _areaCtrl.removeListener(_onAreaChanged);
    _areaCtrl.dispose();
    super.dispose();
  }

  ProjectModel? get _livePreview {
    final area = double.tryParse(_areaCtrl.text);
    if (area == null || area <= 0) return null;
    final temp = ProjectModel(
      id: 'preview',
      name: 'Live Preview',
      builtUpAreaSqft: area,
      numberOfFloors: _floors,
      floorHeightM: _floorH,
      slabThicknessMm: _slabMm,
      wallThicknessMm: _wallMm,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    ProjectService.calculate(temp);
    return temp;
  }

  Future<void> _calculate() async {
    final area = double.tryParse(_areaCtrl.text);
    if (area == null || area <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid positive built-up area (sq.ft).')),
      );
      return;
    }
    // Create a temporary project to store inputs
    final p = await ProjectService.createProject(name: 'Quick Estimate');
    p.builtUpAreaSqft  = area;
    p.numberOfFloors   = _floors;
    p.floorHeightM     = _floorH;
    p.slabThicknessMm  = _slabMm;
    p.wallThicknessMm  = _wallMm;
    await ProjectService.saveCalculation(p);
    if (!mounted) return;
    Navigator.pushNamed(context, AppRoutes.slabCalculation, arguments: p.id);
  }

  @override
  Widget build(BuildContext context) {
    final preview = _livePreview;
    final fmt = NumberFormat('#,##,##0', 'en_IN');

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBarWidget(
        title: 'Structural Details',
        actions: [Text('1 / 3', style: AppTextStyles.label.copyWith(color: AppColors.textMedium))
            .let((t) => Padding(padding: const EdgeInsets.only(right: 16), child: t))],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTextField(
              label: 'Built-Up Area (sq.ft)',
              hint: '2400',
              controller: _areaCtrl,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            const Text('NUMBER OF FLOORS', style: AppTextStyles.label),
            const SizedBox(height: 10),
            Row(
              children: [
                _Btn(Icons.remove, () { if (_floors > 1) setState(() => _floors--); }),
                Container(
                  width: 80,
                  alignment: Alignment.center,
                  child: Text('$_floors', style: AppTextStyles.heading3),
                ),
                _Btn(Icons.add, () => setState(() => _floors++)),
              ],
            ),
            const SizedBox(height: 20),
            Text('FLOOR HEIGHT   ${_floorH.toStringAsFixed(1)} m', style: AppTextStyles.label),
            Slider(
              value: _floorH, min: 2.5, max: 5.0, divisions: 10,
              activeColor: AppColors.primary,
              onChanged: (v) => setState(() => _floorH = v),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('SLAB THICKNESS ⓘ', style: AppTextStyles.label),
                      const SizedBox(height: 8),
                      Text('${_slabMm.toInt()} mm',
                          style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
                      Slider(
                        value: _slabMm, min: 100, max: 250, divisions: 15,
                        activeColor: AppColors.primary,
                        onChanged: (v) => setState(() => _slabMm = v),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('WALL THICKNESS', style: AppTextStyles.label),
                      const SizedBox(height: 8),
                      Text('${_wallMm.toInt()} mm',
                          style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
                      Slider(
                        value: _wallMm, min: 100, max: 350, divisions: 25,
                        activeColor: AppColors.primary,
                        onChanged: (v) => setState(() => _wallMm = v),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            AppCard(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Include Basement?', style: AppTextStyles.body),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => setState(() => _basement = true),
                        child: _Toggle('YES', _basement),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () => setState(() => _basement = false),
                        child: _Toggle('NO', !_basement),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Sticky Live Preview Strip
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.iconBgBlue,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.bolt, color: AppColors.primary, size: 18),
                        SizedBox(width: 6),
                        Text(
                          'Live Preview:',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    preview != null
                        ? Text(
                            'Concrete ~${preview.totalConcreteVolumeM3.toStringAsFixed(1)} m³ · ₹${fmt.format(preview.structuralCost.toInt())}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              color: AppColors.textDark,
                              fontSize: 12,
                            ),
                          )
                        : const Text(
                            'Enter built-up area…',
                            style: TextStyle(color: AppColors.textLight, fontSize: 12),
                          ),
                  ],
                ),
              ),
              PrimaryButton(text: 'Calculate  →', onPressed: _calculate),
            ],
          ),
        ),
      ),
    );
  }
}

class _Btn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _Btn(this.icon, this.onTap);
  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: 36, height: 36,
          decoration: BoxDecoration(border: Border.all(color: AppColors.border), borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, size: 18, color: AppColors.primary),
        ),
      );
}

class _Toggle extends StatelessWidget {
  final String label;
  final bool active;
  const _Toggle(this.label, this.active);
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: active ? AppColors.primary : AppColors.border,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(label,
            style: TextStyle(
                color: active ? Colors.white : AppColors.textMedium,
                fontWeight: FontWeight.w600, fontSize: 13)),
      );
}

extension on Widget {
  Widget let(Widget Function(Widget) f) => f(this);
}
