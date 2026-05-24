import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../routes/app_routes.dart';
import '../../widgets/common_widgets.dart';

class MaterialsCatalogScreen extends StatelessWidget {
  const MaterialsCatalogScreen({super.key});

  static const _categories = [
    _Cat('Structural',      Icons.domain,             AppColors.iconBgBlue,   AppColors.primary,       '12 items'),
    _Cat('Masonry',         Icons.grid_view_outlined,  AppColors.iconBgOrange, AppColors.warning,       '8 items'),
    _Cat('Finishing',       Icons.format_paint,        AppColors.iconBgGreen,  AppColors.accentGreen,   '15 items'),
    _Cat('Plumbing',        Icons.plumbing,            AppColors.iconBgBlue,   AppColors.info,          '10 items'),
    _Cat('Electrical',      Icons.bolt,                AppColors.iconBgOrange, AppColors.warning,       '9 items'),
    _Cat('Wood & Carpentry',Icons.carpenter,           AppColors.iconBgBrown,  Color(0xFF6D4C41),       '11 items'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppBarWidget(title: 'Materials Catalog'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Materials', style: AppTextStyles.heading2),
            const SizedBox(height: 12),
            TextField(
              decoration: InputDecoration(
                hintText: 'Search catalog...',
                prefixIcon: const Icon(Icons.search, color: AppColors.textLight, size: 20),
                filled: true,
                fillColor: AppColors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 16),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.3,
              children: _categories.map((c) => GestureDetector(
                    onTap: () {
                      if (c.name == 'Wood & Carpentry') {
                        Navigator.pushNamed(context, AppRoutes.woodCarpentry);
                      } else {
                        Navigator.pushNamed(context, AppRoutes.materialDetail,
                            arguments: c.name);
                      }
                    },
                    child: AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(color: c.iconBg, borderRadius: BorderRadius.circular(8)),
                            child: Icon(c.icon, color: c.iconColor, size: 24),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(c.name, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
                              Text(c.count, style: AppTextStyles.bodySmall),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )).toList(),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('RECENTLY VIEWED', style: AppTextStyles.label),
                TextButton(onPressed: () {}, child: const Text('View All')),
              ],
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _RecentChip('Steel Beam H-20'),
                  const SizedBox(width: 8),
                  _RecentChip('Portland Cement'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Cat {
  final String name, count;
  final IconData icon;
  final Color iconBg, iconColor;
  const _Cat(this.name, this.icon, this.iconBg, this.iconColor, this.count);
}

class _RecentChip extends StatelessWidget {
  final String text;
  const _RecentChip(this.text);
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            const Icon(Icons.architecture, size: 14, color: AppColors.textLight),
            const SizedBox(width: 6),
            Text(text, style: AppTextStyles.bodySmall),
          ],
        ),
      );
}
