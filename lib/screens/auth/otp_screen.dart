import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../routes/app_routes.dart';
import '../../services/auth_service.dart';
import '../../widgets/common_widgets.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _controllers = List.generate(6, (_) => TextEditingController());
  final _focusNodes  = List.generate(6, (_) => FocusNode());
  int _seconds = 45;
  Timer? _timer;
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _startTimer();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNodes[0].requestFocus();
      // Show the OTP to the user (since this is a local offline app)
      final otp = AuthService.generateOtp();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Your verification code: $otp'),
          duration: const Duration(seconds: 10),
          backgroundColor: AppColors.primary,
        ),
      );
    });
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _seconds = 45);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_seconds == 0) {
        t.cancel();
      } else {
        setState(() => _seconds--);
      }
    });
  }

  String get _enteredOtp =>
      _controllers.map((c) => c.text).join();

  void _verify() {
    if (_enteredOtp.length < 6) return;
    setState(() { _loading = true; _error = null; });
    final ok = AuthService.verifyOtp(_enteredOtp);
    setState(() => _loading = false);
    if (ok) {
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } else {
      setState(() => _error = 'Incorrect code. Please try again.');
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _controllers) c.dispose();
    for (final f in _focusNodes) f.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map?;
    final phone = args?['phone'] as String? ?? '';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              const SizedBox(height: 32),
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: const Color(0xFFD4EDDA),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.verified_user_outlined,
                    color: Color(0xFF2E7D4F), size: 36),
              ),
              const SizedBox(height: 24),
              Text('Verify Your Number', style: AppTextStyles.heading2),
              const SizedBox(height: 8),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: AppTextStyles.subtitle,
                  children: [
                    const TextSpan(text: 'Enter the 6-digit code sent to '),
                    TextSpan(
                      text: phone.isNotEmpty ? phone : '+91 98XXX XXXXX',
                      style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: AppColors.textDark),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              if (_error != null) ...[
                Container(
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

              // 6 OTP boxes
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, (i) => _OtpBox(
                  controller: _controllers[i],
                  focusNode: _focusNodes[i],
                  onChanged: (v) {
                    if (v.length == 1 && i < 5) {
                      _focusNodes[i + 1].requestFocus();
                    } else if (v.isEmpty && i > 0) {
                      _focusNodes[i - 1].requestFocus();
                    }
                    if (_enteredOtp.length == 6) _verify();
                  },
                )),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.timer_outlined,
                      size: 16, color: AppColors.textLight),
                  const SizedBox(width: 4),
                  Text(
                    _seconds > 0
                        ? 'Resend OTP in 00:${_seconds.toString().padLeft(2, '0')}'
                        : 'You can resend the code now',
                    style: AppTextStyles.subtitle,
                  ),
                ],
              ),
              const SizedBox(height: 200),
              PrimaryButton(
                text: 'Verify',
                onPressed: _verify,
                isLoading: _loading,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Didn't receive the code? ",
                      style: TextStyle(color: AppColors.textMedium)),
                  GestureDetector(
                    onTap: _seconds == 0 ? _startTimer : null,
                    child: Text(
                      'Resend Now',
                      style: TextStyle(
                        color: _seconds == 0
                            ? AppColors.primary
                            : AppColors.textLight,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OtpBox extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;

  const _OtpBox({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 48,
      height: 56,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        onChanged: onChanged,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        style: const TextStyle(
            fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.textDark),
        decoration: InputDecoration(
          counterText: '',
          filled: true,
          fillColor: AppColors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:
                const BorderSide(color: AppColors.primary, width: 2),
          ),
        ),
      ),
    );
  }
}
