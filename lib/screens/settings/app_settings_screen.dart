import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../routes/app_routes.dart';
import '../../services/auth_service.dart';
import '../../services/notification_service.dart';
import '../../widgets/common_widgets.dart';

class AppSettingsScreen extends StatefulWidget {
  const AppSettingsScreen({super.key});

  @override
  State<AppSettingsScreen> createState() => _AppSettingsScreenState();
}

class _AppSettingsScreenState extends State<AppSettingsScreen> {
  late bool _notificationsEnabled;

  @override
  void initState() {
    super.initState();
    _notificationsEnabled = NotificationService.notificationsEnabled;
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthService.currentUser;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppBarWidget(title: 'Settings'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile header
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, AppRoutes.userProfile),
              child: AppCard(
                child: Row(
                  children: [
                    Container(
                      width: 52, height: 52,
                      decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                      child: const Icon(Icons.person, color: Colors.white, size: 28),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(user?.fullName ?? 'Guest User',
                              style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700)),
                          Text(user?.email ?? '', style: AppTextStyles.bodySmall),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: AppColors.textLight),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text('APP PREFERENCES', style: AppTextStyles.label),
            const SizedBox(height: 8),
            _Tile(Icons.straighten, AppColors.iconBgBlue, AppColors.primary,
                'Units & Measurements', () => Navigator.pushNamed(context, AppRoutes.unitsMeasurements)),
            _ToggleTile(
              Icons.notifications_outlined,
              AppColors.iconBgOrange,
              AppColors.warning,
              'Notifications',
              _notificationsEnabled,
              (val) async {
                await NotificationService.setNotificationsEnabled(val);
                setState(() => _notificationsEnabled = val);
              },
            ),
            const SizedBox(height: 20),
            const Text('DATA', style: AppTextStyles.label),
            const SizedBox(height: 8),
            _Tile(Icons.storage_outlined, AppColors.iconBgGreen, AppColors.accentGreen,
                'Offline Storage', () => Navigator.pushNamed(context, AppRoutes.offlineStorage)),
            const SizedBox(height: 20),
            const Text('RESOURCES', style: AppTextStyles.label),
            const SizedBox(height: 8),
            _Tile(Icons.menu_book_outlined, AppColors.iconBgBlue, AppColors.info,
                'Construction Glossary', () => Navigator.pushNamed(context, AppRoutes.glossary)),
            _Tile(Icons.help_outline, AppColors.iconBgOrange, AppColors.warning,
                'Help & FAQ', () => Navigator.pushNamed(context, AppRoutes.helpFaq)),
            const SizedBox(height: 20),
            const Text('ACCOUNT', style: AppTextStyles.label),
            const SizedBox(height: 8),
            _Tile(Icons.logout, const Color(0xFFFFEBEE), Colors.red, 'Log Out', () async {
              await AuthService.logout();
              if (context.mounted) Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (_) => false);
            }),
            const SizedBox(height: 12),
            Center(
              child: Text('BuildMate v1.0.0', style: AppTextStyles.bodySmall),
            ),
          ],
        ),
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  final IconData icon;
  final Color bg, fg;
  final String title;
  final VoidCallback onTap;
  const _Tile(this.icon, this.bg, this.fg, this.title, this.onTap);

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)),
                child: Icon(icon, color: fg, size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(child: Text(title, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w500))),
              const Icon(Icons.chevron_right, color: AppColors.textLight, size: 18),
            ],
          ),
        ),
      );
}

class _ToggleTile extends StatelessWidget {
  final IconData icon;
  final Color bg, fg;
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleTile(this.icon, this.bg, this.fg, this.title, this.value, this.onChanged);

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)),
              child: Icon(icon, color: fg, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(title, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w500))),
            Switch(
              value: value,
              onChanged: onChanged,
              activeColor: AppColors.primary,
            ),
          ],
        ),
      );
}
