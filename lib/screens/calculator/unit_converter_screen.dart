import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../widgets/common_widgets.dart';

class UnitConverterScreen extends StatefulWidget {
  const UnitConverterScreen({super.key});

  @override
  State<UnitConverterScreen> createState() => _UnitConverterScreenState();
}

class _UnitConverterScreenState extends State<UnitConverterScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabs;
  final _fromCtrl = TextEditingController(text: '2400');
  int _fromIdx = 0, _toIdx = 1;

  final _categories = {
    'Area':     {'sq.ft': 1.0,     'sq.m': 0.0929,   'sq.in': 144.0,   'acres': 0.0000229},
    'Volume':   {'m³': 1.0,       'cu.ft': 35.3147,  'litres': 1000.0, 'cu.in': 61023.7},
    'Length':   {'m': 1.0,        'ft': 3.28084,     'cm': 100.0,      'in': 39.3701},
    'Weight':   {'MT': 1.0,       'kg': 1000.0,      'tons': 0.984207, 'lbs': 2204.62},
    'Pressure': {'MPa': 1.0,      'N/mm²': 1.0,      'psi': 145.038,   'bar': 10.0},
  };

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: _categories.length, vsync: this);
  }

  @override
  void dispose() { _tabs.dispose(); _fromCtrl.dispose(); super.dispose(); }

  List<String> get _units => _categories[_categories.keys.toList()[_tabs.index]]!.keys.toList();

  double get _result {
    final units = _categories[_categories.keys.toList()[_tabs.index]]!;
    final val = double.tryParse(_fromCtrl.text) ?? 0;
    final fromUnit = _units[_fromIdx];
    final toUnit   = _units[_toIdx];
    final fromFactor = units[fromUnit]!;
    final toFactor   = units[toUnit]!;
    return val / fromFactor * toFactor;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppBarWidget(title: 'Unit Converter'),
      body: Column(
        children: [
          Container(
            color: AppColors.white,
            child: TabBar(
              controller: _tabs,
              isScrollable: true,
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.textMedium,
              indicatorColor: AppColors.primary,
              onTap: (_) => setState(() { _fromIdx = 0; _toIdx = 1; }),
              tabs: _categories.keys.map((k) => Tab(text: k)).toList(),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('FROM', style: AppTextStyles.label),
                        Row(
                          children: [
                            DropdownButton<int>(
                              value: _fromIdx,
                              underline: const SizedBox(),
                              items: _units.asMap().entries
                                  .map((e) => DropdownMenuItem(value: e.key, child: Text(e.value, style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.primary))))
                                  .toList(),
                              onChanged: (v) => setState(() => _fromIdx = v!),
                            ),
                            const Spacer(),
                            Expanded(
                              child: TextField(
                                controller: _fromCtrl,
                                textAlign: TextAlign.right,
                                keyboardType: TextInputType.number,
                                onChanged: (_) => setState(() {}),
                                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: AppColors.textDark),
                                decoration: const InputDecoration(border: InputBorder.none),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Swap button
                  Center(
                    child: GestureDetector(
                      onTap: () => setState(() {
                        final tmp = _fromIdx;
                        _fromIdx = _toIdx;
                        _toIdx = tmp;
                      }),
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.swap_vert, color: Colors.white),
                      ),
                    ),
                  ),
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('TO', style: AppTextStyles.label),
                        Row(
                          children: [
                            DropdownButton<int>(
                              value: _toIdx,
                              underline: const SizedBox(),
                              items: _units.asMap().entries
                                  .map((e) => DropdownMenuItem(value: e.key, child: Text(e.value, style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.primary))))
                                  .toList(),
                              onChanged: (v) => setState(() => _toIdx = v!),
                            ),
                            const Spacer(),
                            Text(
                              _result.toStringAsFixed(4),
                              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: AppColors.accentGreen),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const SectionTitle('COMMON CONVERSIONS'),
                  ...[
                    ['1 sq.ft', '0.0929 m²'],
                    ['1 m³', '35.31 cu.ft'],
                    ['1 MT', '1000 kg'],
                    ['1 bar', '14.50 psi'],
                  ].map((c) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: AppCard(
                          child: Row(
                            children: [
                              Text(c[0], style: AppTextStyles.body),
                              const SizedBox(width: 12),
                              const Icon(Icons.arrow_forward, size: 14, color: AppColors.textLight),
                              const SizedBox(width: 12),
                              Text(c[1], style: AppTextStyles.body.copyWith(color: AppColors.textMedium)),
                            ],
                          ),
                        ),
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
