import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user_model.dart';
import 'hive_service.dart';

class AuthService {
  static const String _loggedInKey = 'logged_in_user_id';
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ── Hash a password so we never store it in plain text locally ────────────
  static String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    return sha256.convert(bytes).toString();
  }

  // ── Log in with Google Sign-In via Firebase ───────────────────────────────
  static Future<UserCredential?> signInWithGoogle() async {
    final UserCredential? userCredential;
    if (kIsWeb) {
      GoogleAuthProvider googleProvider = GoogleAuthProvider();
      userCredential = await _firebaseAuth.signInWithPopup(googleProvider);
    } else {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return null;
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      userCredential = await _firebaseAuth.signInWithCredential(credential);
    }

    if (userCredential?.user != null) {
      final firebaseUser = userCredential!.user!;
      final uid = firebaseUser.uid;
      final docRef = _firestore.collection('users').doc(uid);
      final doc = await docRef.get();

      if (!doc.exists) {
        await docRef.set({
          'fullName': firebaseUser.displayName ?? '',
          'email': firebaseUser.email ?? '',
          'phone': firebaseUser.phoneNumber ?? '',
          'company': '',
          'licenseNumber': '',
          'role': 'Civil Engineer',
          'location': '',
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      final data = doc.data();
      final user = UserModel(
        id: uid,
        fullName: firebaseUser.displayName ?? data?['fullName'] ?? '',
        email: firebaseUser.email ?? data?['email'] ?? '',
        phone: data?['phone'] ?? '',
        passwordHash: '',
        company: data?['company'] ?? '',
        licenseNumber: data?['licenseNumber'] ?? '',
        role: data?['role'] ?? 'Civil Engineer',
        location: data?['location'] ?? '',
        createdAt: DateTime.now(),
      );

      await HiveService.userBox.put(uid, user);
      await HiveService.settingsBox.put(_loggedInKey, uid);
    }

    return userCredential;
  }

  // ── Register a new user with Firebase ─────────────────────────────────────
  static Future<String?> register({
    required String fullName,
    required String email,
    String phone = '',
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final uid = credential.user!.uid;

      await _firestore.collection('users').doc(uid).set({
        'fullName': fullName,
        'email': email.trim(),
        'phone': phone,
        'company': '',
        'licenseNumber': '',
        'role': 'Civil Engineer',
        'location': '',
        'createdAt': FieldValue.serverTimestamp(),
      });

      final user = UserModel(
        id: uid,
        fullName: fullName,
        email: email.trim(),
        phone: phone,
        passwordHash: _hashPassword(password),
        createdAt: DateTime.now(),
      );
      await HiveService.userBox.put(uid, user);
      await HiveService.settingsBox.put(_loggedInKey, uid);
      return null; // null means success
    } on FirebaseAuthException catch (e) {
      return _friendlyAuthError(e);
    } catch (_) {
      return 'Something went wrong. Please check your internet connection and try again.';
    }
  }

  // ── Log in with Firebase ────────────────────────────────────────────────────
  static Future<String?> login({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final uid = credential.user!.uid;

      // Pull the latest profile from Firestore and mirror it locally so the
      // rest of the app (dashboard, profile, settings) keeps working offline.
      final doc = await _firestore.collection('users').doc(uid).get();
      final data = doc.data();

      final user = UserModel(
        id: uid,
        fullName: data?['fullName'] ?? '',
        email: email.trim(),
        phone: data?['phone'] ?? '',
        passwordHash: _hashPassword(password),
        company: data?['company'] ?? '',
        licenseNumber: data?['licenseNumber'] ?? '',
        role: data?['role'] ?? 'Civil Engineer',
        location: data?['location'] ?? '',
        createdAt: DateTime.now(),
      );
      await HiveService.userBox.put(uid, user);
      await HiveService.settingsBox.put(_loggedInKey, uid);
      return null; // success
    } on FirebaseAuthException catch (e) {
      return _friendlyAuthError(e);
    } catch (_) {
      return 'Something went wrong. Please check your internet connection and try again.';
    }
  }

  // ── Turn Firebase's error codes into messages a user can understand ───────
  static String _friendlyAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'popup-closed-by-user':
      case 'cancelled-popup-request':
        return 'Sign-in cancelled.';
      case 'popup-blocked':
        return 'Popup was blocked by your browser. Please allow popups for this site and try again.';
      case 'unauthorized-domain':
        return 'This domain is not authorized for Google Sign-In in Firebase Console.';
      case 'email-already-in-use':
        return 'An account with this email already exists.';
      case 'invalid-email':
        return 'Enter a valid email address.';
      case 'weak-password':
        return 'Password must be at least 6 characters.';
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'invalid-credential':
      case 'invalid-login-credentials':
        return 'Incorrect email or password.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many attempts. Please wait a moment and try again.';
      case 'network-request-failed':
        return 'No internet connection. Please check your network and try again.';
      default:
        return e.message ?? 'Authentication failed. Please try again.';
    }
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
    if (!HiveService.isSettingsBoxOpen || !HiveService.isUserBoxOpen) return null;
    final id = HiveService.settingsBox.get(_loggedInKey);
    if (id == null) return null;
    return HiveService.userBox.get(id);
  }

  // ── Update profile ────────────────────────────────────────────────────────
  static Future<void> updateProfile({
    String? fullName,
    String? email,
    String? phone,
    String? company,
    String? licenseNumber,
    String? role,
    String? location,
  }) async {
    final user = currentUser;
    if (user == null) return;
    if (fullName != null) user.fullName = fullName;
    if (email != null) user.email = email;
    if (phone != null) user.phone = phone;
    if (company != null) user.company = company;
    if (licenseNumber != null) user.licenseNumber = licenseNumber;
    if (role != null) user.role = role;
    if (location != null) user.location = location;
    await user.save();

    final Map<String, dynamic> updates = {};
    if (fullName != null) updates['fullName'] = fullName;
    if (email != null) updates['email'] = email;
    if (phone != null) updates['phone'] = phone;
    if (company != null) updates['company'] = company;
    if (licenseNumber != null) updates['licenseNumber'] = licenseNumber;
    if (role != null) updates['role'] = role;
    if (location != null) updates['location'] = location;
    if (updates.isNotEmpty) {
      try {
        await _firestore.collection('users').doc(user.id).update(updates);
      } catch (_) {}
    }
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
