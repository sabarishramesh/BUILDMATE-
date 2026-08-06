import 'package:intl/intl.dart';

class AppFormatter {
  static final _inFmt = NumberFormat('#,##,##0', 'en_IN');
  static final _dec1Fmt = NumberFormat('#,##,##0.0', 'en_IN');
  static final _dec2Fmt = NumberFormat('#,##,##0.00', 'en_IN');

  /// Round costs (INR) to the nearest ₹100 and format with Indian commas.
  /// Example: 1423294 -> ₹14,23,300
  static String formatCost(num cost) {
    final rounded = (cost / 100.0).round() * 100;
    return '₹${_inFmt.format(rounded)}';
  }

  /// Round costs (INR) to the nearest ₹100 without currency symbol.
  /// Example: 1423294 -> 14,23,300
  static String formatCostRaw(num cost) {
    final rounded = (cost / 100.0).round() * 100;
    return _inFmt.format(rounded);
  }

  /// Cement bags: round UP (ceil) to whole bags.
  /// Example: 1462.3 -> 1,463 bags
  static String formatCement(num bags) {
    return '${_inFmt.format(bags.ceil())} bags';
  }

  /// Bricks: round UP (ceil) to whole number.
  /// Example: 41869.2 -> 41,870 nos
  static String formatBricks(num count, {String unit = 'nos'}) {
    return '${_inFmt.format(count.ceil())} $unit';
  }

  /// Steel (MT): round to 2 decimal places.
  /// Example: 8.76 MT
  static String formatSteel(num mt) {
    return '${_dec2Fmt.format(mt)} MT';
  }

  /// Volume (Concrete, Sand, Aggregate m³): round to 1 decimal place.
  /// Example: 113.0 m³
  static String formatVolume(num m3, {String unit = 'm³'}) {
    return '${_dec1Fmt.format(m3)} $unit';
  }

  /// Area (sq.ft): formatted with commas.
  static String formatArea(num sqft) {
    return '${_inFmt.format(sqft.round())} sq.ft';
  }
}
