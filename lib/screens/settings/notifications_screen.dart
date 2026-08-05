import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../widgets/common_widgets.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool _priceAlerts = true;
  bool _projectReminders = false;
  bool _reportReady = true;
  bool _weeklyDigest = false;
  bool _appUpdates = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppBarWidget(title: 'Notifications'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Notifications', style: AppTextStyles.heading2),
            Text('Manage what alerts you receive from the app.', style: AppTextStyles.subtitle),
            const SizedBox(height: 20),
            const Text('MATERIAL ALERTS', style: AppTextStyles.label),
            const SizedBox(height: 8),
            AppCard(
              child: Column(
                children: [
                  _NRow(
                    Icons.trending_up,
                    AppColors.iconBgOrange,
                    AppColors.warning,
                    'Price Alerts',
                    'Notify when material rates change significantly',
                    _priceAlerts,
                    (v) => setState(() => _priceAlerts = v),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text('PROJECTS', style: AppTextStyles.label),
            const SizedBox(height: 8),
            AppCard(
              child: Column(
                children: [
                  _NRow(
                    Icons.calendar_today_outlined,
                    AppColors.iconBgBlue,
                    AppColors.primary,
                    'Project Reminders',
                    'Remind me about upcoming project milestones',
                    _projectReminders,
                    (v) => setState(() => _projectReminders = v),
                  ),
                  const Divider(height: 1),
                  _NRow(
                    Icons.description_outlined,
                    AppColors.iconBgGreen,
                    AppColors.accentGreen,
                    'Report Ready',
                    'Notify when a report has been generated',
                    _reportReady,
                    (v) => setState(() => _reportReady = v),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text('GENERAL', style: AppTextStyles.label),
            const SizedBox(height: 8),
            AppCard(
              child: Column(
                children: [
                  _NRow(
                    Icons.mail_outline,
                    AppColors.iconBgBlue,
                    AppColors.info,
                    'Weekly Digest',
                    'A summary of your project activity each week',
                    _weeklyDigest,
                    (v) => setState(() => _weeklyDigest = v),
                  ),
                  const Divider(height: 1),
                  _NRow(
                    Icons.system_update_outlined,
                    AppColors.iconBgGreen,
                    AppColors.accentGreen,
                    'App Updates',
                    'Notify when a new version is available',
                    _appUpdates,
                    (v) => setState(() => _appUpdates = v),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.border),
              ),
              child: const Text(
                'ⓘ  Notifications are local only. Since BuildMate is fully offline, no push notifications are sent from a server.',
                style: TextStyle(fontSize: 12, color: AppColors.textMedium),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NRow extends StatelessWidget {
  final IconData icon;
  final Color iconBg, iconColor;
  final String title, subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _NRow(this.icon, this.iconBg, this.iconColor, this.title, this.subtitle, this.value, this.onChanged);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(8)),
              child: Icon(icon, color: iconColor, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
                  Text(subtitle, style: AppTextStyles.bodySmall),
                ],
              ),
            ),
            Switch(value: value, onChanged: onChanged, activeColor: AppColors.primary),
          ],
        ),
      );
}
