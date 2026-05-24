import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:uuid/uuid.dart';
import '../models/user_model.dart';
import 'hive_service.dart';

class AuthService {
  static const String _loggedInKey = 'logged_in_user_id';
  static const _uuid = Uuid();

  // ── Hash a password so we never store it in plain text ────────────────────
  static String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    return sha256.convert(bytes).toString();
  }

  // ── Register a new user ───────────────────────────────────────────────────
  static Future<String?> register({
    required String fullName,
    required String email,
    required String phone,
    required String password,
  }) async {
    final box = HiveService.userBox;

    // Check if email already used
    final existing = box.values.where(
      (u) => u.email.toLowerCase() == email.toLowerCase(),
    );
    if (existing.isNotEmpty) {
      return 'An account with this email already exists.';
    }

    final user = UserModel(
      id: _uuid.v4(),
      fullName: fullName,
      email: email,
      phone: phone,
      passwordHash: _hashPassword(password),
      createdAt: DateTime.now(),
    );

    await box.put(user.id, user);
    // Auto-log in after registration
    await HiveService.settingsBox.put(_loggedInKey, user.id);
    return null; // null means success
  }

  // ── Log in ────────────────────────────────────────────────────────────────
  static Future<String?> login({
    required String email,
    required String password,
  }) async {
    final box = HiveService.userBox;
    final matching = box.values.where(
      (u) => u.email.toLowerCase() == email.toLowerCase(),
    );

    if (matching.isEmpty) {
      return 'No account found with this email.';
    }

    final user = matching.first;
    if (user.passwordHash != _hashPassword(password)) {
      return 'Incorrect password.';
    }

    await HiveService.settingsBox.put(_loggedInKey, user.id);
    return null; // success
  }

  // ── Log out ───────────────────────────────────────────────────────────────
  static Future<void> logout() async {
    await HiveService.settingsBox.delete(_loggedInKey);
  }

  // ── Check if someone is currently logged in ───────────────────────────────
  static bool get isLoggedIn {
    return HiveService.settingsBox.get(_loggedInKey) != null;
  }

  // ── Get the currently logged-in user ─────────────────────────────────────
  static UserModel? get currentUser {
    final id = HiveService.settingsBox.get(_loggedInKey);
    if (id == null) return null;
    return HiveService.userBox.get(id);
  }

  // ── Update profile ────────────────────────────────────────────────────────
  static Future<void> updateProfile({
    String? fullName,
    String? phone,
    String? company,
    String? licenseNumber,
    String? role,
    String? location,
  }) async {
    final user = currentUser;
    if (user == null) return;
    if (fullName != null) user.fullName = fullName;
    if (phone != null) user.phone = phone;
    if (company != null) user.company = company;
    if (licenseNumber != null) user.licenseNumber = licenseNumber;
    if (role != null) user.role = role;
    if (location != null) user.location = location;
    await user.save();
  }

  // ── Simple OTP: generate a 6-digit code and store it locally ──────────────
  static String generateOtp() {
    final otp = (100000 + DateTime.now().millisecondsSinceEpoch % 900000)
        .toString()
        .substring(0, 6);
    HiveService.settingsBox.put('pending_otp', otp);
    return otp;
  }

  static bool verifyOtp(String entered) {
    final stored = HiveService.settingsBox.get('pending_otp');
    if (stored == null) return false;
    if (stored == entered) {
      HiveService.settingsBox.delete('pending_otp');
      return true;
    }
    return false;
  }
}
