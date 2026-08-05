import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../routes/app_routes.dart';
import '../../widgets/common_widgets.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailCtrl = TextEditingController();
  bool _sent = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                onPressed: () => Navigator.pop(context),
              ),
              const SizedBox(height: 40),
              Center(
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: AppColors.iconBgBlue,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.lock_reset,
                      color: AppColors.primary, size: 36),
                ),
              ),
              const SizedBox(height: 24),
              Center(
                  child: Text('Reset Password', style: AppTextStyles.heading2)),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  'Enter your registered email address and we will send a reset link.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.subtitle,
                ),
              ),
              const SizedBox(height: 32),
              if (_sent)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.iconBgGreen,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.check_circle,
                          color: AppColors.accentGreen, size: 20),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'If this email is registered, a reset link has been sent.',
                          style: TextStyle(
                              color: AppColors.accentGreen, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                )
              else ...[
                AppTextField(
                  label: 'Email Address',
                  hint: 'engineer@buildmate.com',
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(Icons.email_outlined,
                      color: AppColors.textLight, size: 20),
                ),
                const SizedBox(height: 24),
                PrimaryButton(
                  text: 'Send Reset Link',
                  onPressed: () => setState(() => _sent = true),
                ),
              ],
              const SizedBox(height: 20),
              Center(
                child: TextButton(
                  onPressed: () =>
                      Navigator.pushReplacementNamed(context, AppRoutes.login),
                  child: const Text('Back to Login',
                      style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(height: 60),
              Center(
                child: Text('BuildMate',
                    style: TextStyle(
                        color: AppColors.textLight.withOpacity(0.4),
                        fontSize: 18,
                        fontWeight: FontWeight.w300)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
