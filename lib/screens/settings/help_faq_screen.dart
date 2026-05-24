import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../widgets/common_widgets.dart';

class HelpFaqScreen extends StatefulWidget {
  const HelpFaqScreen({super.key});

  @override
  State<HelpFaqScreen> createState() => _HelpFaqScreenState();
}

class _HelpFaqScreenState extends State<HelpFaqScreen> {
  int? _expanded;

  static const _faqs = [
    ['Is my data safe offline?',
      'Yes. All data is stored locally on your device using an encrypted database. Nothing is sent to any server.'],
    ['How is the cost estimate calculated?',
      'The app uses your built-up area, number of floors, slab/wall thickness and current material rates to compute volumes, then applies phase percentages (Structural 40%, Finishing 25%, etc.).'],
    ['Can I change material rates?',
      'Yes. Go to Materials → Material Rates to view and update current prices, or add custom supplier-specific rates.'],
    ['How do I export a report?',
      'Go to Reports → Generate Report, select your project and tap Generate. You can then preview and share as PDF or CSV.'],
    ['What does "dry-to-wet factor" mean?',
      'Concrete shrinks as it cures. The dry-to-wet factor (1.54) accounts for the bulking of dry materials vs. the final wet concrete volume.'],
    ['How do I delete a project?',
      'Open the project → tap the three-dot menu → Archive or Delete. Archived projects can be restored later.'],
    ['Why is the OTP shown in a pop-up?',
      'Nexus Build is 100% offline. Since there is no internet or SMS server, the OTP is generated locally and shown on screen. Write it down and enter it in the box.'],
    ['How do I update material prices?',
      'Go to Settings → Material Rates → tap any item to edit, or tap the + button to add a new rate.'],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppBarWidget(title: 'Help & FAQ'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Help & FAQ', style: AppTextStyles.heading2),
            Text('Answers to common questions about Nexus Build.', style: AppTextStyles.subtitle),
            const SizedBox(height: 20),
            ..._faqs.asMap().entries.map((e) {
              final open = _expanded == e.key;
              return GestureDetector(
                onTap: () => setState(() => _expanded = open ? null : e.key),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: open ? AppColors.primary : AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(e.value[0],
                                style: AppTextStyles.body.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: open ? AppColors.primary : AppColors.textDark)),
                          ),
                          Icon(open ? Icons.expand_less : Icons.expand_more,
                              color: AppColors.textLight),
                        ],
                      ),
                      if (open) ...[
                        const SizedBox(height: 8),
                        Text(e.value[1], style: AppTextStyles.body),
                      ],
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 16),
            AppCard(
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: AppColors.iconBgBlue, borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.mail_outline, color: AppColors.primary, size: 22),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Still need help?', style: AppTextStyles.body),
                        Text('Contact support at help@nexusbuild.app', style: AppTextStyles.bodySmall),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
