import 'package:flutter/material.dart';
import '../../widgets/app_bottom_nav.dart';
import '../home/dashboard_screen.dart';
import '../calculator/calculator_home_screen.dart';
import '../projects/project_list_screen.dart';
import '../reports/reports_tab_screen.dart';
import '../settings/app_settings_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _tab = 0;

  final _screens = const [
    DashboardScreen(),
    CalculatorHomeScreen(),
    ProjectListScreen(),
    ReportsTabScreen(),
    AppSettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _tab,
        children: _screens,
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: _tab,
        onTap: (i) => setState(() => _tab = i),
      ),
    );
  }
}
