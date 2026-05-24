import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../routes/app_routes.dart';
import '../../services/auth_service.dart';
import '../../widgets/common_widgets.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _form = GlobalKey<FormState>();
  final _nameCtrl  = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passCtrl  = TextEditingController();
  final _confCtrl  = TextEditingController();
  bool _obscure1 = true, _obscure2 = true;
  bool _loading = false;
  String? _error;

  Future<void> _register() async {
    if (!_form.currentState!.validate()) return;
    setState(() { _loading = true; _error = null; });
    final err = await AuthService.register(
      fullName: _nameCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      phone: _phoneCtrl.text.trim(),
      password: _passCtrl.text,
    );
    if (!mounted) return;
    setState(() => _loading = false);
    if (err != null) {
      setState(() => _error = err);
    } else {
      final otp = AuthService.generateOtp();
      Navigator.pushNamed(context, AppRoutes.otp,
          arguments: {'otp': otp, 'phone': _phoneCtrl.text.trim()});
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose(); _emailCtrl.dispose(); _phoneCtrl.dispose();
    _passCtrl.dispose(); _confCtrl.dispose();
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(height: 8),
                Text('Create Account', style: AppTextStyles.heading1),
                const SizedBox(height: 4),
                Text('Join thousands of engineers and contractors.',
                    style: AppTextStyles.subtitle),
                const SizedBox(height: 28),
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
                  label: 'Full Name',
                  hint: 'John Doe',
                  controller: _nameCtrl,
                  prefixIcon: const Icon(Icons.person_outline,
                      color: AppColors.textLight, size: 20),
                  validator: (v) => v == null || v.isEmpty ? 'Enter your name' : null,
                ),
                const SizedBox(height: 16),
                AppTextField(
                  label: 'Email Address',
                  hint: 'email@nexusbuild.com',
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(Icons.email_outlined,
                      color: AppColors.textLight, size: 20),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Enter your email';
                    if (!v.contains('@')) return 'Enter a valid email';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                AppTextField(
                  label: 'Phone Number',
                  hint: '+1 (555) 000-0000',
                  controller: _phoneCtrl,
                  keyboardType: TextInputType.phone,
                  prefixIcon: const Icon(Icons.phone_outlined,
                      color: AppColors.textLight, size: 20),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Enter your phone number' : null,
                ),
                const SizedBox(height: 16),
                AppTextField(
                  label: 'Password',
                  hint: '••••••••',
                  controller: _passCtrl,
                  obscureText: _obscure1,
                  prefixIcon: const Icon(Icons.lock_outline,
                      color: AppColors.textLight, size: 20),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscure1 ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                      color: AppColors.textLight, size: 20,
                    ),
                    onPressed: () => setState(() => _obscure1 = !_obscure1),
                  ),
                  validator: (v) {
                    if (v == null || v.length < 6)
                      return 'Password must be at least 6 characters';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                AppTextField(
                  label: 'Confirm Password',
                  hint: '••••••••',
                  controller: _confCtrl,
                  obscureText: _obscure2,
                  prefixIcon: const Icon(Icons.lock_outline,
                      color: AppColors.textLight, size: 20),
                  validator: (v) {
                    if (v != _passCtrl.text) return 'Passwords do not match';
                    return null;
                  },
                ),
                const SizedBox(height: 28),
                PrimaryButton(
                    text: 'Register', onPressed: _register, isLoading: _loading),
                const SizedBox(height: 20),
                _divider('OR'),
                const SizedBox(height: 16),
                _SocialBtn(icon: Icons.g_mobiledata, label: 'Continue with Google'),
                const SizedBox(height: 12),
                _SocialBtn(icon: Icons.apple, label: 'Continue with Apple'),
                const SizedBox(height: 28),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already have an account? ',
                        style: TextStyle(color: AppColors.textMedium)),
                    GestureDetector(
                      onTap: () => Navigator.pushReplacementNamed(
                          context, AppRoutes.login),
                      child: const Text('Sign In',
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

  Widget _divider(String t) => Row(children: [
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(t,
              style: const TextStyle(color: AppColors.textLight, fontSize: 12)),
        ),
        const Expanded(child: Divider()),
      ]);
}

class _SocialBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  const _SocialBtn({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: OutlinedButton.icon(
        onPressed: () {},
        icon: Icon(icon, size: 22),
        label: Text(label,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textDark,
          side: const BorderSide(color: AppColors.accentGreen),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}
