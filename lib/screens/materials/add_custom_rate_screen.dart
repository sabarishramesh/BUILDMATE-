import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../utils/notification_helper.dart';
import '../../widgets/common_widgets.dart';

class AddCustomRateScreen extends StatefulWidget {
  const AddCustomRateScreen({super.key});

  @override
  State<AddCustomRateScreen> createState() => _AddCustomRateScreenState();
}

class _AddCustomRateScreenState extends State<AddCustomRateScreen> {
  final _nameCtrl = TextEditingController();
  final _rateCtrl = TextEditingController();
  final _unitCtrl = TextEditingController();
  final _supplierCtrl = TextEditingController();
  String _category = 'Structural';

  final _categories = ['Structural', 'Finishing', 'Plumbing', 'Electrical', 'Wood & Carpentry', 'Other'];

  @override
  void dispose() {
    _nameCtrl.dispose();
    _rateCtrl.dispose();
    _unitCtrl.dispose();
    _supplierCtrl.dispose();
    super.dispose();
  }

  void _save() {
    if (_nameCtrl.text.trim().isEmpty || _rateCtrl.text.trim().isEmpty) {
      NotificationHelper.showError(context, 'Please fill in material name and rate.');
      return;
    }
    NotificationHelper.showSuccess(context, 'Rates updated');
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppBarWidget(title: 'Add Custom Rate'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Add Material Rate', style: AppTextStyles.heading2),
            Text('Enter local or supplier-specific pricing.', style: AppTextStyles.subtitle),
            const SizedBox(height: 20),
            AppTextField(label: 'Material Name', hint: 'e.g. Fly Ash Brick', controller: _nameCtrl),
            const SizedBox(height: 12),
            const Text('CATEGORY', style: AppTextStyles.label),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _categories.map((c) => GestureDetector(
                    onTap: () => setState(() => _category = c),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                      decoration: BoxDecoration(
                        color: _category == c ? AppColors.primary : AppColors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: _category == c ? AppColors.primary : AppColors.border),
                      ),
                      child: Text(c, style: TextStyle(
                        color: _category == c ? Colors.white : AppColors.textMedium,
                        fontWeight: FontWeight.w500, fontSize: 13,
                      )),
                    ),
                  )).toList(),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: AppTextField(label: 'Rate (₹)', hint: '0.00', controller: _rateCtrl, keyboardType: TextInputType.number)),
                const SizedBox(width: 12),
                Expanded(child: AppTextField(label: 'Unit', hint: 'per bag / per m³', controller: _unitCtrl)),
              ],
            ),
            const SizedBox(height: 12),
            AppTextField(label: 'Supplier Name (optional)', hint: 'e.g. City Traders', controller: _supplierCtrl),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3E0),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: const [
                  Icon(Icons.info_outline, color: AppColors.warning, size: 16),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Custom rates override default values only for your device. They will be used in all new project calculations.',
                      style: TextStyle(fontSize: 12, color: AppColors.warning),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            PrimaryButton(text: 'SAVE RATE', onPressed: _save),
          ],
        ),
      ),
    );
  }
}
