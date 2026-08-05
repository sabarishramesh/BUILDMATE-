import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../routes/app_routes.dart';
import '../../widgets/common_widgets.dart';

class UpgradeScreen extends StatelessWidget {
  const UpgradeScreen({super.key});

  static const _features = [
    [Icons.all_inclusive, 'Unlimited Projects', 'Free plan limited to 5 projects'],
    [Icons.bar_chart, 'Advanced Analytics', 'Detailed charts and trend reports'],
    [Icons.picture_as_pdf, 'PDF Export', 'Branded PDF reports with your logo'],
    [Icons.people_outline, 'Team Access', 'Share projects with your team'],
    [Icons.cloud_sync, 'Backup & Restore', 'Cloud backup coming soon'],
    [Icons.support_agent, 'Priority Support', 'Dedicated support channel'],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppBarWidget(title: 'Upgrade to Pro'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: const [
                  Icon(Icons.workspace_premium, color: Colors.amber, size: 48),
                  SizedBox(height: 12),
                  Text('BuildMate Pro', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
                  SizedBox(height: 4),
                  Text('The complete toolkit for construction professionals.',
                      style: TextStyle(color: Colors.white70, fontSize: 13), textAlign: TextAlign.center),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const SectionTitle('PRO FEATURES'),
            const SizedBox(height: 8),
            ..._features.map((f) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: AppCard(
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.iconBgBlue,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(f[0] as IconData, color: AppColors.primary, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(f[1] as String,
                                  style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
                              Text(f[2] as String, style: AppTextStyles.bodySmall),
                            ],
                          ),
                        ),
                        const Icon(Icons.check_circle, color: AppColors.accentGreen, size: 18),
                      ],
                    ),
                  ),
                )),
            const SizedBox(height: 20),
            const SectionTitle('PRICING'),
            const SizedBox(height: 8),
            AppCard(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Monthly', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
                          const Text('Billed every month', style: AppTextStyles.bodySmall),
                        ],
                      ),
                      const Text('₹299 / mo', style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.primary)),
                    ],
                  ),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [
                            Text('Annual', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.iconBgGreen,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Text('SAVE 33%',
                                  style: TextStyle(color: AppColors.accentGreen, fontSize: 10, fontWeight: FontWeight.w700)),
                            ),
                          ]),
                          const Text('Billed once a year', style: AppTextStyles.bodySmall),
                        ],
                      ),
                      const Text('₹2,399 / yr', style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.primary)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              text: 'UPGRADE NOW',
              onPressed: () => Navigator.pushNamed(context, AppRoutes.paymentCheckout),
            ),
          ],
        ),
      ),
    );
  }
}
