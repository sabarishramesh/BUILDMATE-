import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'services/hive_service.dart';
import 'services/material_rates_service.dart';
import 'services/notification_service.dart';
import 'constants/app_colors.dart';
import 'routes/app_routes.dart';

import 'screens/splash/splash_screen.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/auth/forgot_password_screen.dart';
import 'screens/auth/otp_screen.dart';
import 'screens/home/main_shell.dart';
import 'screens/projects/new_project_screen.dart';
import 'screens/projects/project_detail_screen.dart';
import 'screens/projects/edit_project_screen.dart';
import 'screens/projects/project_archive_screen.dart';
import 'screens/projects/project_comparison_screen.dart';
import 'screens/calculator/structural_details_screen.dart';
import 'screens/calculator/slab_calculation_screen.dart';
import 'screens/calculator/wall_calculation_screen.dart';
import 'screens/calculator/foundation_details_screen.dart';
import 'screens/calculator/concrete_summary_screen.dart';
import 'screens/calculator/material_estimate_screen.dart';
import 'screens/calculator/steel_reinforcement_screen.dart';
import 'screens/calculator/concrete_mix_screen.dart';
import 'screens/calculator/unit_converter_screen.dart';
import 'screens/calculator/steel_weight_calculator_screen.dart';
import 'screens/calculator/brick_count_calculator_screen.dart';
import 'screens/materials/materials_catalog_screen.dart';
import 'screens/materials/material_detail_screen.dart';
import 'screens/materials/wood_carpentry_screen.dart';
import 'screens/materials/material_rates_screen.dart';
import 'screens/materials/add_custom_rate_screen.dart';
import 'screens/materials/regional_pricing_screen.dart';
import 'screens/reports/generate_report_screen.dart';
import 'screens/reports/report_preview_screen.dart';
import 'screens/reports/share_export_screen.dart';
import 'screens/reports/project_analytics_screen.dart';
import 'screens/reports/cost_history_screen.dart';
import 'screens/settings/app_settings_screen.dart';
import 'screens/settings/user_profile_screen.dart';
import 'screens/settings/offline_storage_screen.dart';
import 'screens/settings/units_measurements_screen.dart';
import 'screens/settings/construction_glossary_screen.dart';
import 'screens/settings/help_faq_screen.dart';
import 'screens/settings/upgrade_screen.dart';
import 'screens/settings/payment_checkout_screen.dart';
import 'screens/settings/notifications_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await HiveService.init();
  await MaterialRatesService.seedDefaultRates();
  await NotificationService.init();
  runApp(const BuildMateApp());
}

class BuildMateApp extends StatelessWidget {
  const BuildMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BuildMate',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        scaffoldBackgroundColor: AppColors.background,
        useMaterial3: true,
      ),
      initialRoute: AppRoutes.splash,
      routes: {
        AppRoutes.splash:            (_) => const SplashScreen(),
        AppRoutes.onboarding:        (_) => const OnboardingScreen(),
        AppRoutes.login:             (_) => const LoginScreen(),
        AppRoutes.register:          (_) => const RegisterScreen(),
        AppRoutes.forgotPassword:    (_) => const ForgotPasswordScreen(),
        AppRoutes.otp:               (_) => const OtpScreen(),
        AppRoutes.home:              (_) => const MainShell(),
        AppRoutes.newProject:        (_) => const NewProjectScreen(),
        AppRoutes.projectArchive:    (_) => const ProjectArchiveScreen(),
        AppRoutes.projectComparison: (_) => const ProjectComparisonScreen(),
        AppRoutes.structuralDetails: (_) => const StructuralDetailsScreen(),
        AppRoutes.concreteMix:       (_) => const ConcreteMixScreen(),
        AppRoutes.unitConverter:     (_) => const UnitConverterScreen(),
        AppRoutes.steelWeightCalculator: (_) => const SteelWeightCalculatorScreen(),
        AppRoutes.brickCountCalculator: (_) => const BrickCountCalculatorScreen(),
        AppRoutes.materialsCatalog:  (_) => const MaterialsCatalogScreen(),
        AppRoutes.woodCarpentry:     (_) => const WoodCarpentryScreen(),
        AppRoutes.materialRates:     (_) => const MaterialRatesScreen(),
        AppRoutes.addCustomRate:     (_) => const AddCustomRateScreen(),
        AppRoutes.regionalPricing:   (_) => const RegionalPricingScreen(),
        AppRoutes.generateReport:    (_) => const GenerateReportScreen(),
        AppRoutes.analytics:         (_) => const ProjectAnalyticsScreen(),
        AppRoutes.costHistory:       (_) => const CostHistoryScreen(),
        AppRoutes.settings:          (_) => const AppSettingsScreen(),
        AppRoutes.userProfile:       (_) => const UserProfileScreen(),
        AppRoutes.offlineStorage:    (_) => const OfflineStorageScreen(),
        AppRoutes.unitsMeasurements: (_) => const UnitsMeasurementsScreen(),
        AppRoutes.glossary:          (_) => const ConstructionGlossaryScreen(),
        AppRoutes.helpFaq:           (_) => const HelpFaqScreen(),
        AppRoutes.upgrade:           (_) => const UpgradeScreen(),
        AppRoutes.paymentCheckout:   (_) => const PaymentCheckoutScreen(),
        AppRoutes.notifications:     (_) => const NotificationsScreen(),
      },
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case AppRoutes.projectDetail:
            return MaterialPageRoute(
              builder: (_) => ProjectDetailScreen(projectId: settings.arguments as String),
            );
          case AppRoutes.editProject:
            return MaterialPageRoute(
              builder: (_) => EditProjectScreen(projectId: settings.arguments as String),
            );
          case AppRoutes.slabCalculation:
            return MaterialPageRoute(
              builder: (_) => SlabCalculationScreen(projectId: settings.arguments as String),
            );
          case AppRoutes.wallCalculation:
            return MaterialPageRoute(
              builder: (_) => WallCalculationScreen(projectId: settings.arguments as String),
            );
          case AppRoutes.foundationDetails:
            return MaterialPageRoute(
              builder: (_) => FoundationDetailsScreen(projectId: settings.arguments as String),
            );
          case AppRoutes.concreteSummary:
            return MaterialPageRoute(
              builder: (_) => ConcreteSummaryScreen(projectId: settings.arguments as String),
            );
          case AppRoutes.materialEstimate:
            return MaterialPageRoute(
              builder: (_) => MaterialEstimateScreen(projectId: settings.arguments as String),
            );
          case AppRoutes.steelReinforcement:
            return MaterialPageRoute(
              builder: (_) => SteelReinforcementScreen(projectId: settings.arguments as String),
            );
          case AppRoutes.materialDetail:
            return MaterialPageRoute(
              builder: (_) => MaterialDetailScreen(materialName: settings.arguments as String),
            );
          case AppRoutes.reportPreview:
            return MaterialPageRoute(
              builder: (_) => ReportPreviewScreen(projectId: settings.arguments as String?),
            );
          case AppRoutes.shareExport:
            return MaterialPageRoute(
              builder: (_) => ShareExportScreen(projectId: settings.arguments as String?),
            );
        }
        return null;
      },
    );
  }
}
