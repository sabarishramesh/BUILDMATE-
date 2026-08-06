import 'package:intl/intl.dart';

class AppFormatter {
  static final _inFmt = NumberFormat('#,##,##0', 'en_IN');
  static final _dec1Fmt = NumberFormat('#,##,##0.0', 'en_IN');
  static final _dec2Fmt = NumberFormat('#,##,##0.00', 'en_IN');

  static bool _isValid(num? val) {
    if (val == null) return false;
    if (val.isNaN || val.isInfinite) return false;
    return true;
  }

  /// Round costs (INR) to the nearest ₹100 and format with Indian commas.
  /// Example: 1423294 -> ₹14,23,300
  static String formatCost(num? cost) {
    if (!_isValid(cost)) return '₹0';
    final rounded = (cost! / 100.0).round() * 100;
    return '₹${_inFmt.format(rounded)}';
  }

  /// Round costs (INR) to the nearest ₹100 without currency symbol.
  /// Example: 1423294 -> 14,23,300
  static String formatCostRaw(num? cost) {
    if (!_isValid(cost)) return '0';
    final rounded = (cost! / 100.0).round() * 100;
    return _inFmt.format(rounded);
  }

  /// Cement bags: round UP (ceil) to whole bags.
  /// Example: 1462.3 -> 1,463 bags
  static String formatCement(num? bags) {
    if (!_isValid(bags)) return '0 bags';
    final val = bags! <= 0 ? 0 : bags.ceil();
    return '${_inFmt.format(val)} bags';
  }

  /// Bricks: round UP (ceil) to whole number.
  /// Example: 41869.2 -> 41,870 nos
  static String formatBricks(num? count, {String unit = 'nos'}) {
    if (!_isValid(count)) return unit.isNotEmpty ? '0 $unit' : '0';
    final val = count! <= 0 ? 0 : count.ceil();
    return unit.isNotEmpty ? '${_inFmt.format(val)} $unit' : _inFmt.format(val);
  }

  /// Steel (MT): round to 2 decimal places.
  /// Example: 8.76 MT
  static String formatSteel(num? mt) {
    if (!_isValid(mt)) return '0.00 MT';
    final val = mt! < 0 ? 0.0 : mt;
    return '${_dec2Fmt.format(val)} MT';
  }

  /// Volume (Concrete, Sand, Aggregate m³): round to 1 decimal place.
  /// Example: 113.0 m³
  static String formatVolume(num? m3, {String unit = 'm³'}) {
    if (!_isValid(m3)) return unit.isNotEmpty ? '0.0 $unit' : '0.0';
    final val = m3! < 0 ? 0.0 : m3;
    return unit.isNotEmpty ? '${_dec1Fmt.format(val)} $unit' : _dec1Fmt.format(val);
  }

  /// Area (sq.ft): formatted with commas.
  static String formatArea(num? sqft) {
    if (!_isValid(sqft)) return '0 sq.ft';
    final val = sqft! < 0 ? 0 : sqft.round();
    return '${_inFmt.format(val)} sq.ft';
  }
}
