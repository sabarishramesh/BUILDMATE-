import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../routes/app_routes.dart';
import '../../services/auth_service.dart';
import '../../services/hive_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900));
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeIn);
    _ctrl.forward();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    final seenOnboarding =
        HiveService.settingsBox.get('seen_onboarding', defaultValue: false);
    if (!seenOnboarding) {
      Navigator.pushReplacementNamed(context, AppRoutes.onboarding);
    } else if (AuthService.isLoggedIn) {
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Stack(
        children: [
          // Grid background pattern
          CustomPaint(
            size: MediaQuery.of(context).size,
            painter: _GridPainter(),
          ),
          FadeTransition(
            opacity: _fade,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // App icon
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.domain,
                      color: AppColors.primary,
                      size: 52,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Nexus Build',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'PROFESSIONAL CONSTRUCTION ESTIMATOR',
                    style: TextStyle(
                      color: AppColors.white.withOpacity(0.7),
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Bottom label
          Positioned(
            bottom: 32,
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: _fade,
              child: Center(
                child: Text(
                  'WORKS 100% OFFLINE · INSTANT RESULTS',
                  style: TextStyle(
                    color: AppColors.white.withOpacity(0.5),
                    fontSize: 10,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..strokeWidth = 0.5;
    const step = 40.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_) => false;
}
