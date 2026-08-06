import 'package:flutter_test/flutter_test.dart';
import 'package:nexus_build/utils/app_formatter.dart';

void main() {
  group('AppFormatter Null & Edge Case Safety Tests', () {
    test('formatCost handles null, NaN, infinity, and valid numbers cleanly', () {
      expect(AppFormatter.formatCost(null), '₹0');
      expect(AppFormatter.formatCost(double.nan), '₹0');
      expect(AppFormatter.formatCost(double.infinity), '₹0');
      expect(AppFormatter.formatCost(0), '₹0');
      expect(AppFormatter.formatCost(1423294), '₹14,23,300');
    });

    test('formatCostRaw handles null, NaN, and valid numbers', () {
      expect(AppFormatter.formatCostRaw(null), '0');
      expect(AppFormatter.formatCostRaw(double.nan), '0');
      expect(AppFormatter.formatCostRaw(1423294), '14,23,300');
    });

    test('formatCement rounds UP to whole bags', () {
      expect(AppFormatter.formatCement(null), '0 bags');
      expect(AppFormatter.formatCement(1462.3), '1,463 bags');
      expect(AppFormatter.formatCement(0), '0 bags');
    });

    test('formatBricks rounds UP to whole numbers', () {
      expect(AppFormatter.formatBricks(null), '0 nos');
      expect(AppFormatter.formatBricks(41869.2), '41,870 nos');
      expect(AppFormatter.formatBricks(41869.2, unit: ''), '41,870');
    });

    test('formatSteel rounds to 2 decimal places', () {
      expect(AppFormatter.formatSteel(null), '0.00 MT');
      expect(AppFormatter.formatSteel(8.7642), '8.76 MT');
    });

    test('formatVolume rounds to 1 decimal place', () {
      expect(AppFormatter.formatVolume(null), '0.0 m³');
      expect(AppFormatter.formatVolume(112.98), '113.0 m³');
      expect(AppFormatter.formatVolume(112.98, unit: ''), '113.0');
    });

    test('formatArea handles null and valid numbers', () {
      expect(AppFormatter.formatArea(null), '0 sq.ft');
      expect(AppFormatter.formatArea(2400.7), '2,401 sq.ft');
    });
  });
}
