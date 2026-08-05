// All screen route names live here.
// To navigate to any screen in the app, use these string constants.
class AppRoutes {
  static const String splash           = '/';
  static const String onboarding       = '/onboarding';
  static const String login            = '/login';
  static const String register         = '/register';
  static const String forgotPassword   = '/forgot-password';
  static const String otp              = '/otp';
  static const String home             = '/home';

  // Projects
  static const String projectList      = '/projects';
  static const String newProject       = '/projects/new';
  static const String projectDetail    = '/projects/detail';
  static const String editProject      = '/projects/edit';
  static const String projectArchive   = '/projects/archive';
  static const String projectComparison = '/projects/compare';

  // Calculator
  static const String calculatorHome   = '/calculator';
  static const String structuralDetails = '/calculator/structural';
  static const String slabCalculation  = '/calculator/slab';
  static const String wallCalculation  = '/calculator/wall';
  static const String foundationDetails = '/calculator/foundation';
  static const String concreteSummary  = '/calculator/concrete-summary';
  static const String materialEstimate = '/calculator/material-estimate';
  static const String steelReinforcement = '/calculator/steel';
  static const String concreteMix      = '/calculator/concrete-mix';
  static const String unitConverter    = '/calculator/unit-converter';
  static const String steelWeightCalculator = '/calculator/steel-weight';
  static const String brickCountCalculator = '/calculator/brick-count';

  // Materials
  static const String materialsCatalog = '/materials';
  static const String materialDetail   = '/materials/detail';
  static const String woodCarpentry    = '/materials/wood';
  static const String materialRates    = '/materials/rates';
  static const String addCustomRate    = '/materials/rates/add';
  static const String regionalPricing  = '/materials/rates/regional';

  // Reports
  static const String generateReport  = '/reports/generate';
  static const String reportPreview   = '/reports/preview';
  static const String shareExport     = '/reports/share';
  static const String analytics       = '/reports/analytics';
  static const String costHistory     = '/reports/cost-history';

  // Settings
  static const String settings        = '/settings';
  static const String userProfile     = '/settings/profile';
  static const String offlineStorage  = '/settings/storage';
  static const String unitsMeasurements = '/settings/units';
  static const String glossary        = '/settings/glossary';
  static const String helpFaq         = '/settings/help';
  static const String upgrade         = '/settings/upgrade';
  static const String paymentCheckout = '/settings/upgrade/checkout';
  static const String notifications   = '/settings/notifications';
}
