import 'package:uuid/uuid.dart';
import '../models/material_rate_model.dart';
import '../constants/engineering_constants.dart';
import 'hive_service.dart';

class MaterialRatesService {
  static const _uuid = Uuid();

  /// Seeds the database with default rates on first launch.
  static Future<void> seedDefaultRates() async {
    final box = HiveService.ratesBox;
    if (box.isNotEmpty) return; // already seeded

    final defaults = [
      _make('Cement (OPC 53)',    'Structural', MaterialRates.cementPerBag,       'bag'),
      _make('TMT Steel Fe500',    'Structural', MaterialRates.steelPerMT,          'MT'),
      _make('River Sand',         'Structural', MaterialRates.sandPerCubicM,       'm³'),
      _make('Coarse Aggregate',   'Structural', MaterialRates.aggregatePerCubicM,  'm³'),
      _make('First Class Bricks', 'Masonry',    MaterialRates.brickPerUnit,        'no.'),
      _make('Ceramic Tiles 2×2',  'Finishing',  MaterialRates.tilesPerSqft,        'sq.ft'),
      _make('18mm BWR Plywood',   'Wood',       MaterialRates.plywoodPerSqft,      'sq.ft'),
      _make('Paint (3 Coats)',    'Finishing',  MaterialRates.paintPerSqft,        'sq.ft'),
      _make('Plaster',            'Finishing',  MaterialRates.plasterPerSqft,      'sq.ft'),
    ];

    for (final r in defaults) {
      await box.put(r.id, r);
    }
  }

  static MaterialRateModel _make(
      String name, String category, double rate, String unit) {
    return MaterialRateModel(
      id: _uuid.v4(),
      materialName: name,
      category: category,
      rate: rate,
      unit: unit,
      isDefault: true,
      updatedAt: DateTime.now(),
    );
  }

  static List<MaterialRateModel> getAllRates() {
    return HiveService.ratesBox.values.toList()
      ..sort((a, b) => a.category.compareTo(b.category));
  }

  static Future<void> addRate(MaterialRateModel rate) async {
    await HiveService.ratesBox.put(rate.id, rate);
  }

  static Future<void> updateRate(MaterialRateModel rate) async {
    rate.updatedAt = DateTime.now();
    await rate.save();
  }

  static Future<void> deleteRate(String id) async {
    await HiveService.ratesBox.delete(id);
  }
}
