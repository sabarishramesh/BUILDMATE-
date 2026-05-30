import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../services/auth_service.dart';
import '../../widgets/common_widgets.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _companyCtrl;
  late final TextEditingController _licenseCtrl;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final u = AuthService.currentUser;
    _nameCtrl = TextEditingController(text: u?.fullName ?? '');
    _emailCtrl = TextEditingController(text: u?.email ?? '');
    _phoneCtrl = TextEditingController(text: u?.phone ?? '');
    _companyCtrl = TextEditingController(text: u?.company ?? '');
    _licenseCtrl = TextEditingController(text: u?.licenseNumber ?? '');
  }

  @override
  void dispose() {
    _nameCtrl.dispose(); _emailCtrl.dispose(); _phoneCtrl.dispose();
    _companyCtrl.dispose(); _licenseCtrl.dispose();
    super.dispose();
  }

  void _save() async {
    setState(() => _saving = true);
    await Future.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;
    setState(() => _saving = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppBarWidget(title: 'My Profile'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Container(
                    width: 80, height: 80,
                    decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                    child: const Icon(Icons.person, color: Colors.white, size: 44),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () {},
                    child: const Text('Change Photo', style: TextStyle(color: AppColors.primary)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            AppTextField(label: 'Full Name', hint: 'Your name', controller: _nameCtrl),
            const SizedBox(height: 12),
            AppTextField(label: 'Email', hint: 'you@example.com', controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 12),
            AppTextField(label: 'Phone', hint: '+91 XXXXX XXXXX', controller: _phoneCtrl,
                keyboardType: TextInputType.phone),
            const SizedBox(height: 12),
            AppTextField(label: 'Company / Firm', hint: 'Optional', controller: _companyCtrl),
            const SizedBox(height: 12),
            AppTextField(label: 'License Number', hint: 'Optional', controller: _licenseCtrl),
            const SizedBox(height: 24),
            _saving
                ? const Center(child: CircularProgressIndicator())
                : PrimaryButton(text: 'SAVE CHANGES', onPressed: _save),
          ],
        ),
      ),
    );
  }
}
