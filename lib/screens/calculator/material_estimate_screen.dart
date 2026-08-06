import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../constants/engineering_constants.dart';
import '../../routes/app_routes.dart';
import '../../services/hive_service.dart';
import '../../widgets/common_widgets.dart';

class MaterialEstimateScreen extends StatefulWidget {
  final String projectId;
  const MaterialEstimateScreen({super.key, required this.projectId});

  @override
  State<MaterialEstimateScreen> createState() => _MaterialEstimateScreenState();
}

class _MaterialEstimateScreenState extends State<MaterialEstimateScreen>
    with SingleTickerProviderStateMixin {
  int? _selectedIndex;
  late AnimationController _animCtrl;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..forward();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = HiveService.projectBox.get(widget.projectId);
    if (p == null) return const Scaffold(body: Center(child: Text('Project not found')));
    final fmt = NumberFormat('#,##,##0', 'en_IN');

    final cementCost = p.cementBags * MaterialRates.cementPerBag;
    final steelCost = p.steelMT * MaterialRates.steelPerMT;
    final sandCost = p.sandM3 * MaterialRates.sandPerCubicM;
    final aggCost = p.aggregateM3 * MaterialRates.aggregatePerCubicM;
    final brickCost = p.brickCount * MaterialRates.brickPerUnit;
    final totalMatCost = cementCost + steelCost + sandCost + aggCost + brickCost;

    final items = [
      _MatItem('Cement', 'OPC 53 Grade', '${fmt.format(p.cementBags.toInt())} bags',
          cementCost, AppColors.primary, Icons.inventory_2_outlined),
      _MatItem('Steel/TMT', 'Fe 500D', '${p.steelMT.toStringAsFixed(2)} MT',
          steelCost, AppColors.error, Icons.linear_scale),
      _MatItem('River Sand', 'Fine Aggregate', '${p.sandM3.toStringAsFixed(2)} m³',
          sandCost, const Color(0xFFD4A017), Icons.water_drop_outlined),
      _MatItem('Coarse Aggregate', '20mm Crushed Stone', '${p.aggregateM3.toStringAsFixed(2)} m³',
          aggCost, AppColors.textMedium, Icons.circle_outlined),
      _MatItem('Bricks', 'First Class Red Bricks', '${fmt.format(p.brickCount)} nos',
          brickCost, const Color(0xFF8B4513), Icons.grid_view_outlined),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBarWidget(
        title: 'Material Estimate',
        actions: [
          IconButton(
            icon: const Icon(Icons.download_outlined, color: AppColors.textDark),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.shareExport,
                arguments: widget.projectId),
          ),
        ],
      ),
      body: Column(
        children: [
          // Project header
          Container(
            color: AppColors.white,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.iconBgGreen,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text('ACTIVE',
                                style: TextStyle(
                                    color: AppColors.accentGreen,
                                    fontSize: 10, fontWeight: FontWeight.w700)),
                          ),
                          const SizedBox(width: 8),
                          const CostConfidenceBadge(),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(p.name,
                          style: AppTextStyles.heading2.copyWith(fontSize: 20)),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text('TOTAL AREA', style: AppTextStyles.label),
                    Text('${p.builtUpAreaSqft.toInt()} sq.ft',
                        style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
                    Text('G+${p.numberOfFloors - 1} Levels',
                        style: AppTextStyles.bodySmall),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Animated Interactive Donut Chart
                AppCard(
                  child: Column(
                    children: [
                      const SectionTitle('COST DISTRIBUTION'),
                      const SizedBox(height: 8),
                      AnimatedBuilder(
                        animation: _animCtrl,
                        builder: (context, child) {
                          return SizedBox(
                            height: 160,
                            width: 160,
                            child: CustomPaint(
                              painter: _DonutChartPainter(
                                items: items,
                                totalCost: totalMatCost,
                                progress: _animCtrl.value,
                                selectedIndex: _selectedIndex,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      // Legend
                      Wrap(
                        spacing: 12,
                        runSpacing: 8,
                        alignment: WrapAlignment.center,
                        children: List.generate(items.length, (i) {
                          final item = items[i];
                          final pct = totalMatCost > 0
                              ? (item.cost / totalMatCost * 100).toStringAsFixed(1)
                              : '0';
                          final isSelected = _selectedIndex == i;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedIndex = isSelected ? null : i;
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? item.color.withValues(alpha: 0.15)
                                    : AppColors.background,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: isSelected ? item.color : AppColors.border,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: item.color,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    '${item.name} $pct%',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                      color: isSelected ? item.color : AppColors.textDark,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                const SectionTitle('STRUCTURAL MATERIALS'),
                ...List.generate(items.length, (i) {
                  final m = items[i];
                  final isSelected = _selectedIndex == i;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedIndex = isSelected ? null : i;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isSelected ? m.color : Colors.transparent,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: isSelected
                                  ? m.color.withValues(alpha: 0.15)
                                  : Colors.black.withValues(alpha: 0.04),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Container(
                              width: 12, height: 12,
                              decoration: BoxDecoration(color: m.color, shape: BoxShape.circle),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(m.name, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
                                  Text(m.grade, style: AppTextStyles.bodySmall),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(m.qty, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700)),
                                Text('₹${fmt.format(m.cost.toInt())}',
                                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMedium)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 8),
                const SectionTitle('FINISHING MATERIALS'),
                ...[
                  ['Tiles/Flooring', '${p.builtUpAreaSqft.toInt()} sq.ft estimated'],
                  ['Plaster', '${(p.builtUpAreaSqft * 2).toInt()} sq.ft total wall'],
                  ['Paint', '${(p.builtUpAreaSqft * 0.35).toInt()} Liters (3 Coats)'],
                  ['Wood', 'Teak – 450 cu.ft'],
                ].map((item) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: AppCard(
                        child: Row(
                          children: [
                            Checkbox(
                              value: true,
                              activeColor: AppColors.primary,
                              onChanged: (_) {},
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item[0], style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
                                  Text(item[1], style: AppTextStyles.bodySmall),
                                ],
                              ),
                            ),
                            const Icon(Icons.chevron_right, color: AppColors.textLight),
                          ],
                        ),
                      ),
                    )),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        color: AppColors.white,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('ESTIMATED TOTAL', style: AppTextStyles.label),
                Text('₹${fmt.format(p.totalEstimatedCost.toInt())}',
                    style: AppTextStyles.heading3.copyWith(color: AppColors.primary)),
              ],
            ),
            const SizedBox(height: 12),
            PrimaryButton(
              text: 'Generate Report  →',
              onPressed: () => Navigator.pushNamed(context, AppRoutes.generateReport),
            ),
          ],
        ),
      ),
    );
  }
}

class _MatItem {
  final String name, grade, qty;
  final double cost;
  final Color color;
  final IconData icon;
  const _MatItem(this.name, this.grade, this.qty, this.cost, this.color, this.icon);
}

class _DonutChartPainter extends CustomPainter {
  final List<_MatItem> items;
  final double totalCost;
  final double progress;
  final int? selectedIndex;

  _DonutChartPainter({
    required this.items,
    required this.totalCost,
    required this.progress,
    required this.selectedIndex,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (totalCost <= 0) return;
    final center = Offset(size.width / 2, size.height / 2);
    final outerRadius = math.min(size.width, size.height) / 2 - 4;
    final strokeWidth = 24.0;

    double startAngle = -math.pi / 2;

    for (int i = 0; i < items.length; i++) {
      final item = items[i];
      final sweepAngle = (item.cost / totalCost) * 2 * math.pi * progress;
      final isSelected = selectedIndex == i;

      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = isSelected ? strokeWidth + 6 : strokeWidth
        ..strokeCap = StrokeCap.round
        ..color = item.color;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: outerRadius - strokeWidth / 2),
        startAngle,
        sweepAngle,
        false,
        paint,
      );
      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(_DonutChartPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.selectedIndex != selectedIndex;
}
