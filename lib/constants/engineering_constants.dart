// ============================================================
//  ENGINEERING CONSTANTS & COST RATES
//  Edit the numbers in this file to change how the calculator
//  works. Everything is labelled so it is easy to update.
// ============================================================

class EngineeringConstants {

  // ──────────────────────────────────────────────────────────
  //  UNIT CONVERSION
  // ──────────────────────────────────────────────────────────
  /// 1 square foot converted to square metres
  static const double sqftToSqm = 0.0929;

  // ──────────────────────────────────────────────────────────
  //  CONCRETE MIX RATIOS  (Cement : Sand : Aggregate by volume)
  // ──────────────────────────────────────────────────────────
  static const Map<String, List<double>> mixRatios = {
    'M15': [1, 2, 4],   // weakest – plain concrete
    'M20': [1, 1.5, 3], // most common for slabs / beams
    'M25': [1, 1, 2],   // stronger structural work
    'M30': [1, 0.75, 1.5], // high-strength columns
  };

  /// Water-cement ratio (litres of water per kg of cement)
  static const double waterCementRatio = 0.5;

  /// Density of cement in kg per bag
  static const double cementBagKg = 50.0;

  /// Dry-to-wet concrete volume conversion factor
  /// (dry ingredients expand ~54% when mixed)
  static const double dryToWetFactor = 1.54;

  /// Wastage factor added on top of calculated quantities (10%)
  static const double wastageFactor = 1.10;

  // ──────────────────────────────────────────────────────────
  //  WALL DEDUCTION FACTOR
  //  Doors and windows typically take up ~15% of gross wall area
  // ──────────────────────────────────────────────────────────
  static const double wallOpeningDeductionFactor = 0.15;

  // ──────────────────────────────────────────────────────────
  //  BRICK WORK
  // ──────────────────────────────────────────────────────────
  /// Standard brick size in metres (L × W × H)
  static const double brickLength = 0.19;
  static const double brickWidth  = 0.09;
  static const double brickHeight = 0.09;
  /// Mortar joint thickness in metres
  static const double mortarJoint = 0.01;
  /// Number of bricks per cubic metre of brickwork
  static const double bricksPerCubicMetre = 500.0;

  // ──────────────────────────────────────────────────────────
  //  STEEL / TMT REINFORCEMENT
  //  Steel is estimated as a % of total concrete volume.
  //  Typical range: 1% to 2% for residential RCC.
  // ──────────────────────────────────────────────────────────
  static const double defaultSteelPercentage = 1.2; // percent
  static const double minSteelPercentage      = 0.8;
  static const double maxSteelPercentage      = 2.0;
  /// Weight of steel in kg per cubic metre of concrete
  /// (calculated as steelPercent/100 × density of steel 7850 kg/m³)
  static const double steelDensityKgPerM3 = 7850.0;

  // ──────────────────────────────────────────────────────────
  //  FOUNDATION DEFAULTS
  // ──────────────────────────────────────────────────────────
  static const double defaultFoundationDepth  = 1.5;  // metres
  static const double defaultFootingLength    = 2.0;  // metres
  static const double defaultFootingBreadth   = 2.0;  // metres
  static const double defaultNumberOfColumns  = 12.0;
  /// Extra excavation added around footing (20% of footing depth)
  static const double excavationFactor        = 1.20;

  // ──────────────────────────────────────────────────────────
  //  PHASE-WISE COST BREAKDOWN (% of total structural cost)
  //  These percentages are applied to the grand total material cost
  //  to produce a phase-wise construction cost estimate.
  // ──────────────────────────────────────────────────────────
  static const double structuralPhasePercent  = 0.40; // 40%
  static const double finishingPhasePercent   = 0.25; // 25%
  static const double plumbingPhasePercent    = 0.12; // 12%
  static const double electricalPhasePercent  = 0.13; // 13%
  static const double carpentryPhasePercent   = 0.10; // 10%

  // ──────────────────────────────────────────────────────────
  //  LABOUR COST MULTIPLIER
  //  Labour is estimated at X times the material cost.
  //  Set to 0 if you want materials-only estimates.
  // ──────────────────────────────────────────────────────────
  static const double labourCostMultiplier = 0.60; // 60% of material cost
}

// ============================================================
//  MATERIAL RATES  (all prices in Indian Rupees ₹)
//  Edit these numbers to match your local market prices.
// ============================================================
class MaterialRates {
  // Structural materials
  static const double cementPerBag        = 380.0;   // ₹ per 50 kg bag
  static const double steelPerMT          = 68000.0; // ₹ per Metric Tonne
  static const double sandPerCubicM       = 1200.0;  // ₹ per m³
  static const double aggregatePerCubicM  = 900.0;   // ₹ per m³
  static const double brickPerUnit        = 8.5;     // ₹ per brick

  // Finishing materials
  static const double tilesPerSqft        = 55.0;    // ₹ per sq.ft
  static const double plywoodPerSqft      = 85.0;    // ₹ per sq.ft (18mm BWR)
  static const double paintPerSqft        = 18.0;    // ₹ per sq.ft (3 coats)
  static const double plasterPerSqft      = 22.0;    // ₹ per sq.ft

  // Labour rates per phase (₹ per sq.ft of built-up area)
  static const double structuralLabourPerSqft  = 180.0;
  static const double finishingLabourPerSqft   = 120.0;
  static const double plumbingLabourPerSqft    = 55.0;
  static const double electricalLabourPerSqft  = 60.0;
  static const double carpentryLabourPerSqft   = 45.0;
}
