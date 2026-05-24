import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../routes/app_routes.dart';
import '../../services/hive_service.dart';
import '../../widgets/common_widgets.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _page = PageController();
  int _current = 0;

  final _slides = const [
    _Slide(
      icon: Icons.straighten,
      iconBg: AppColors.iconBgBlue,
      iconColor: AppColors.primary,
      title: 'Enter Your Project Details',
      body: 'Input floor area, number of floors, slab thickness and wall dimensions to begin your estimate.',
    ),
    _Slide(
      icon: Icons.calculate_outlined,
      iconBg: Color(0xFFD4EDDA),
      iconColor: Color(0xFF2E7D4F),
      title: 'Instant Material Calculations',
      body: 'Concrete, cement, steel, sand, aggregate, bricks — all quantities calculated in seconds with precision engineering formulas.',
    ),
    _Slide(
      icon: Icons.bar_chart,
      iconBg: Color(0xFFFFF3CD),
      iconColor: Color(0xFF856404),
      title: 'Generate Professional Reports',
      body: 'Export detailed PDF estimates, share with clients, and track all your projects in one place — even without internet.',
    ),
  ];

  void _next() {
    if (_current < _slides.length - 1) {
      _page.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else {
      _finish();
    }
  }

  void _finish() {
    HiveService.settingsBox.put('seen_onboarding', true);
    Navigator.pushReplacementNamed(context, AppRoutes.register);
  }

  void _skip() {
    HiveService.settingsBox.put('seen_onboarding', true);
    Navigator.pushReplacementNamed(context, AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: _skip,
                child: Text(
                  'Skip',
                  style: TextStyle(color: AppColors.textMedium, fontSize: 15),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _page,
                onPageChanged: (i) => setState(() => _current = i),
                itemCount: _slides.length,
                itemBuilder: (_, i) => _SlideWidget(slide: _slides[i]),
              ),
            ),
            // Dots indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_slides.length, (i) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: i == _current ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: i == _current
                        ? AppColors.primary
                        : AppColors.border,
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: PrimaryButton(
                text: _current == _slides.length - 1 ? 'Get Started' : 'Next',
                onPressed: _next,
              ),
            ),
            if (_current == _slides.length - 1) ...[
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: OutlineButton(
                  text: 'Sign In',
                  onPressed: _skip,
                ),
              ),
            ],
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _Slide {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String body;
  const _Slide({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.body,
  });
}

class _SlideWidget extends StatelessWidget {
  final _Slide slide;
  const _SlideWidget({required this.slide});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              color: slide.iconBg,
              borderRadius: BorderRadius.circular(28),
            ),
            child: Icon(slide.icon, size: 72, color: slide.iconColor),
          ),
          const SizedBox(height: 40),
          Text(
            slide.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            slide.body,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              color: AppColors.textMedium,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
