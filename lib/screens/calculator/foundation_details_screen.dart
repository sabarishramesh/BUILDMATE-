import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../constants/engineering_constants.dart';
import '../../routes/app_routes.dart';
import '../../widgets/common_widgets.dart';

class FoundationDetailsScreen extends StatefulWidget {
  final String projectId;
  const FoundationDetailsScreen({super.key, required this.projectId});

  @override
  State<FoundationDetailsScreen> createState() => _FoundationDetailsScreenState();
}

class _FoundationDetailsScreenState extends State<FoundationDetailsScreen> {
  int _type = 0; // 0=Isolated 1=Strip 2=Raft
  final _depthCtrl   = TextEditingController(text: '1.50');
  final _lengthCtrl  = TextEditingController(text: '2.00');
  final _breadthCtrl = TextEditingController(text: '2.00');
  final _colCtrl     = TextEditingController(text: '12');

  double get _volPerCol {
    final d = double.tryParse(_depthCtrl.text) ?? 1.5;
    final l = double.tryParse(_lengthCtrl.text) ?? 2.0;
    final b = double.tryParse(_breadthCtrl.text) ?? 2.0;
    return l * b * d;
  }

  double get _totalVol {
    final cols = double.tryParse(_colCtrl.text) ?? 12;
    return _volPerCol * cols;
  }

  double get _excavation => _totalVol * EngineeringConstants.excavationFactor;

  @override
  void dispose() {
    _depthCtrl.dispose(); _lengthCtrl.dispose();
    _breadthCtrl.dispose(); _colCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBarWidget(title: 'Foundation Details'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Type selector
            Row(
              children: ['Isolated Footing', 'Strip Footing', 'Raft Slab']
                  .asMap()
                  .entries
                  .map((e) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: GestureDetector(
                          onTap: () => setState(() => _type = e.key),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: _type == e.key ? AppColors.primary : AppColors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: _type == e.key ? AppColors.primary : AppColors.border,
                              ),
                            ),
                            child: Text(e.value,
                                style: TextStyle(
                                    color: _type == e.key ? Colors.white : AppColors.textMedium,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12)),
                          ),
                        ),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 20),
            AppTextField(label: 'Foundation Depth (m)', hint: '1.50', controller: _depthCtrl,
                keyboardType: TextInputType.number),
            const SizedBox(height: 16),
            Row(children: [
              Expanded(child: AppTextField(label: 'Footing Length (L)', hint: '2.00',
                  controller: _lengthCtrl, keyboardType: TextInputType.number)),
              const SizedBox(width: 12),
              Expanded(child: AppTextField(label: 'Footing Breadth (B)', hint: '2.00',
                  controller: _breadthCtrl, keyboardType: TextInputType.number)),
            ]),
            const SizedBox(height: 16),
            AppTextField(label: 'Number of Columns', hint: '12', controller: _colCtrl,
                keyboardType: TextInputType.number),
            const SizedBox(height: 24),
            AppCard(
              child: Column(
                children: [
                  _ResRow('Foundation Volume per Column',
                      '${_volPerCol.toStringAsFixed(2)} m³'),
                  const Divider(height: 20),
                  _ResRow('Total Foundation Volume',
                      '${_totalVol.toStringAsFixed(2)} m³'),
                  const Divider(height: 20),
                  _ResRow('Excavation Volume',
                      '${_excavation.toStringAsFixed(2)} m³'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3E0),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('FOUNDATION', style: AppTextStyles.label),
                      const Text('CONCRETE', style: AppTextStyles.label),
                      Text('${_totalVol.toStringAsFixed(2)} m³',
                          style: const TextStyle(
                              fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.primary)),
                    ],
                  ),
                  const Spacer(),
                  const Icon(Icons.architecture, color: AppColors.primary, size: 32),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: PrimaryButton(
          text: 'Include in Total',
          onPressed: () => Navigator.pushNamed(context, AppRoutes.concreteSummary,
              arguments: widget.projectId),
        ),
      ),
    );
  }
}

class _ResRow extends StatelessWidget {
  final String label, value;
  const _ResRow(this.label, this.value);
  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.body),
          Text(value, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700, color: AppColors.primary)),
        ],
      );
}
