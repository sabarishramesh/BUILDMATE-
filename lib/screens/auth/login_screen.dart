import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../routes/app_routes.dart';
import '../../services/auth_service.dart';
import '../../widgets/common_widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _form = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;
  bool _loading = false;
  String? _error;

  Future<void> _signIn() async {
    if (!_form.currentState!.validate()) return;
    setState(() { _loading = true; _error = null; });
    final err = await AuthService.login(
      email: _emailCtrl.text.trim(),
      password: _passCtrl.text,
    );
    if (!mounted) return;
    setState(() => _loading = false);
    if (err != null) {
      setState(() => _error = err);
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    }
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Form(
            key: _form,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 24),
                // Logo
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.domain, color: Colors.white, size: 36),
                ),
                const SizedBox(height: 8),
                Text('BUILDPRO',
                    style: AppTextStyles.label.copyWith(
                        color: AppColors.primary, letterSpacing: 2)),
                const SizedBox(height: 20),
                Text('Welcome Back', style: AppTextStyles.heading2),
                const SizedBox(height: 4),
                Text('Sign in to access your projects.',
                    style: AppTextStyles.subtitle),
                const SizedBox(height: 32),

                if (_error != null) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.error.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(_error!,
                        style: const TextStyle(color: AppColors.error)),
                  ),
                  const SizedBox(height: 16),
                ],

                AppTextField(
                  label: 'Email Address',
                  hint: 'e.g. j.doe@nexusbuild.com',
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(Icons.email_outlined,
                      color: AppColors.textLight, size: 20),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Enter your email' : null,
                ),
                const SizedBox(height: 16),
                AppTextField(
                  label: 'Password',
                  hint: '••••••••',
                  controller: _passCtrl,
                  obscureText: _obscure,
                  prefixIcon: const Icon(Icons.lock_outline,
                      color: AppColors.textLight, size: 20),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                      color: AppColors.textLight,
                      size: 20,
                    ),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  ),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Enter your password' : null,
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, AppRoutes.forgotPassword),
                    child: const Text('FORGOT PASSWORD?',
                        style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 12,
                            fontWeight: FontWeight.w600)),
                  ),
                ),
                const SizedBox(height: 8),
                PrimaryButton(
                    text: 'SIGN IN', onPressed: _signIn, isLoading: _loading),
                const SizedBox(height: 24),
                _divider('OR CONTINUE WITH'),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: _SocialBtn(label: 'GOOGLE', icon: Icons.g_mobiledata)),
                    const SizedBox(width: 12),
                    Expanded(child: _SocialBtn(label: 'APPLE', icon: Icons.apple)),
                  ],
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account? ",
                        style: TextStyle(color: AppColors.textMedium)),
                    GestureDetector(
                      onTap: () =>
                          Navigator.pushReplacementNamed(context, AppRoutes.register),
                      child: const Text('Register',
                          style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _divider(String text) {
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(text,
              style: const TextStyle(
                  color: AppColors.textLight, fontSize: 12)),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }
}

class _SocialBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  const _SocialBtn({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () {},
      icon: Icon(icon, size: 20),
      label: Text(label,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.textDark,
        side: const BorderSide(color: AppColors.border),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
    );
  }
}
