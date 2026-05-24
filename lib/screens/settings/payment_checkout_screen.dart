import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../widgets/common_widgets.dart';

class PaymentCheckoutScreen extends StatefulWidget {
  const PaymentCheckoutScreen({super.key});

  @override
  State<PaymentCheckoutScreen> createState() => _PaymentCheckoutScreenState();
}

class _PaymentCheckoutScreenState extends State<PaymentCheckoutScreen> {
  String _plan = 'Annual';
  bool _processing = false;

  void _pay() async {
    setState(() => _processing = true);
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    setState(() => _processing = false);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Payment Gateway'),
        content: const Text(
            'Payment integration requires a live environment. This is a demo screen — no actual charge will be made.'),
        actions: [
          TextButton(
            onPressed: () { Navigator.pop(context); Navigator.pop(context); },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isAnnual = _plan == 'Annual';
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppBarWidget(title: 'Checkout'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Complete Purchase', style: AppTextStyles.heading2),
            Text('Upgrade to Nexus Build Pro.', style: AppTextStyles.subtitle),
            const SizedBox(height: 20),
            const Text('SELECT PLAN', style: AppTextStyles.label),
            const SizedBox(height: 8),
            Row(
              children: ['Monthly', 'Annual'].map((p) => Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _plan = p),
                      child: Container(
                        margin: const EdgeInsets.only(right: p == 'Monthly' ? 8 : 0),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: _plan == p ? AppColors.primary : AppColors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: _plan == p ? AppColors.primary : AppColors.border),
                        ),
                        child: Column(
                          children: [
                            Text(p, style: TextStyle(
                                color: _plan == p ? Colors.white : AppColors.textMedium,
                                fontWeight: FontWeight.w600)),
                            Text(p == 'Monthly' ? '₹299/mo' : '₹2,399/yr',
                                style: TextStyle(
                                    color: _plan == p ? Colors.white70 : AppColors.textLight,
                                    fontSize: 12)),
                          ],
                        ),
                      ),
                    ),
                  )).toList(),
            ),
            const SizedBox(height: 20),
            const Text('ORDER SUMMARY', style: AppTextStyles.label),
            const SizedBox(height: 8),
            AppCard(
              child: Column(
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    const Text('Plan', style: AppTextStyles.body),
                    Text('Nexus Build Pro – $_plan',
                        style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
                  ]),
                  const Divider(height: 24),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    const Text('Amount', style: AppTextStyles.body),
                    Text(isAnnual ? '₹2,399' : '₹299',
                        style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700, color: AppColors.primary)),
                  ]),
                  const Divider(height: 24),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    const Text('GST (18%)', style: AppTextStyles.body),
                    Text(isAnnual ? '₹431.82' : '₹53.82',
                        style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
                  ]),
                  const Divider(height: 24),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text('Total', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700)),
                    Text(isAnnual ? '₹2,830.82' : '₹352.82',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.primary)),
                  ]),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _processing
                ? const Center(child: CircularProgressIndicator())
                : PrimaryButton(text: 'PAY NOW', onPressed: _pay),
            const SizedBox(height: 12),
            const Center(
              child: Text('Secure payment • 7-day refund policy',
                  style: AppTextStyles.bodySmall, textAlign: TextAlign.center),
            ),
          ],
        ),
      ),
    );
  }
}
