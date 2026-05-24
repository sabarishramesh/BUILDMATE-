import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../routes/app_routes.dart';
import '../../services/auth_service.dart';
import '../../widgets/common_widgets.dart';

class AppSettingsScreen extends StatelessWidget {
  const AppSettingsScreen({super.key});

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
            _Tile(Icons.notifications_outlined, AppColors.iconBgOrange, AppColors.warning,
                'Notifications', () => Navigator.pushNamed(context, AppRoutes.notifications)),
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
            _Tile(Icons.workspace_premium_outlined, AppColors.iconBgBlue, AppColors.primary,
                'Upgrade to Pro', () => Navigator.pushNamed(context, AppRoutes.upgrade)),
            const SizedBox(height: 20),
            const Text('ACCOUNT', style: AppTextStyles.label),
            const SizedBox(height: 8),
            _Tile(Icons.logout, const Color(0xFFFFEBEE), Colors.red, 'Log Out', () async {
              await AuthService.logout();
              if (context.mounted) Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (_) => false);
            }),
            const SizedBox(height: 12),
            Center(
              child: Text('Nexus Build v1.0.0', style: AppTextStyles.bodySmall),
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
