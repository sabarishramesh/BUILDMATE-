import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../widgets/common_widgets.dart';

class ShareExportScreen extends StatefulWidget {
  final String? projectId;
  const ShareExportScreen({super.key, this.projectId});

  @override
  State<ShareExportScreen> createState() => _ShareExportScreenState();
}

class _ShareExportScreenState extends State<ShareExportScreen> {
  bool _exporting = false;
  String? _doneMsg;

  void _export(String type) async {
    setState(() { _exporting = true; _doneMsg = null; });
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    setState(() {
      _exporting = false;
      _doneMsg = '$type export ready.';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppBarWidget(title: 'Share & Export'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Share & Export', style: AppTextStyles.heading2),
            Text('Export your report in multiple formats.', style: AppTextStyles.subtitle),
            const SizedBox(height: 20),
            if (_doneMsg != null)
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.iconBgGreen,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.accentGreen),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, color: AppColors.accentGreen, size: 18),
                    const SizedBox(width: 8),
                    Text(_doneMsg!, style: const TextStyle(color: AppColors.accentGreen, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            const SectionTitle('EXPORT FORMAT'),
            const SizedBox(height: 8),
            _ExportTile(
              icon: Icons.picture_as_pdf,
              iconColor: Colors.red,
              iconBg: const Color(0xFFFFEBEE),
              title: 'Export as PDF',
              subtitle: 'Full report with branding and layout',
              onTap: _exporting ? null : () => _export('PDF'),
            ),
            const SizedBox(height: 8),
            _ExportTile(
              icon: Icons.table_chart_outlined,
              iconColor: AppColors.accentGreen,
              iconBg: AppColors.iconBgGreen,
              title: 'Export as CSV',
              subtitle: 'Spreadsheet-friendly format',
              onTap: _exporting ? null : () => _export('CSV'),
            ),
            const SizedBox(height: 20),
            const SectionTitle('SHARE VIA'),
            const SizedBox(height: 8),
            _ExportTile(
              icon: Icons.chat_bubble_outline,
              iconColor: const Color(0xFF25D366),
              iconBg: const Color(0xFFE8F5E9),
              title: 'Share on WhatsApp',
              subtitle: 'Send PDF directly via WhatsApp',
              onTap: _exporting ? null : () => _export('WhatsApp share'),
            ),
            const SizedBox(height: 8),
            _ExportTile(
              icon: Icons.share_outlined,
              iconColor: AppColors.info,
              iconBg: AppColors.iconBgBlue,
              title: 'Share via System',
              subtitle: 'Email, Drive, Messages and more',
              onTap: _exporting ? null : () => _export('System share'),
            ),
            if (_exporting)
              const Padding(
                padding: EdgeInsets.only(top: 24),
                child: Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
    );
  }
}

class _ExportTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor, iconBg;
  final String title, subtitle;
  final VoidCallback? onTap;

  const _ExportTile({
    required this.icon, required this.iconColor, required this.iconBg,
    required this.title, required this.subtitle, required this.onTap,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: AppCard(
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(10)),
                child: Icon(icon, color: iconColor, size: 22),
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
              Icon(Icons.chevron_right, color: onTap == null ? AppColors.border : AppColors.textLight),
            ],
          ),
        ),
      );
}
